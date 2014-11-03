#include <cassert>
#include <cstdio>
#include <cstring>
using namespace std;

extern char * mallocx(unsigned long size);

typedef void const * combinator;
extern combinator compile(unsigned nargs, unsigned const * tree);

template <typename T>
inline void inject(void * code, size_t offset, T value)
{
    *reinterpret_cast<T *>(static_cast<char *>(code) + offset) = value;
}

combinator compile_write(char c)
{
        static const unsigned char CODE[] = {
                0x48,0xB8,0x00,0x00,0x00,0x00,0x00,0x00,
                0x00,0x00,0x40,0xB7,0x00,0xFF,0xD0,0xC3
        };
        void * code = memcpy(mallocx(sizeof(CODE)), CODE, sizeof(CODE));
        inject(code, 2, &putchar);
        inject(code, 12, c);
        return code;
}

typedef void (*evaluator) (combinator[]);

evaluator compile_eval()
{
        static const unsigned char CODE[] = {
                0x31,0xc0,0x48,0x8d,0x48,0xff,0xf2,0x48,
                0xaf,0x48,0x8d,0x77,0xf0,0x48,0xf7,0xd1,
                0x48,0xff,0xc9,0xfd,0x48,0xad,0x50,0x48,
                0xff,0xc9,0x75,0xf8,0xfc,0xc3
        };
        return reinterpret_cast<evaluator>(memcpy(mallocx(sizeof(CODE)), CODE, sizeof(CODE)));
}

const int MAX = 1000;

int main(int argc, char* argv[])
{
        // prepare the combinators
        combinator C[MAX];
        C[0] = nullptr;
        C[1] = compile_write('0');
        C[2] = compile_write('1');
        for (int i=3; ; ++i)
        {
                unsigned nargs;
                assert(scanf("%u", &nargs) == 1);
                if (nargs == 0) break;
                unsigned T[MAX];
                for (int j=0, k=1; k; ++j)
                {
                        assert(scanf("%u", &T[j]) == 1);
                        k += T[j] ? -1 : 1;
                }
                C[i] = compile(nargs, T);
        }
        // read the expression
        combinator E[MAX];
        for (int i=0; ; ++i)
        {
                int index;
                assert(scanf("%d", &index) == 1);
                E[i] = C[index];
                if (!index) break;
        }
        // evaluate!
        compile_eval()(E);
        putchar('\n');
        return 0;
}
