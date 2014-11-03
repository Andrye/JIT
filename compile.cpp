#include <cstdio>

typedef void const * combinator;

extern char * mallocx(unsigned long size);

extern "C" unsigned long leaf_size();
extern "C" unsigned long inner_size();
extern "C" unsigned long prologue_size();
extern "C" unsigned long epilogue_size();

extern "C" unsigned long  compile_leaf(void * mem, unsigned long n);
extern "C" void compile_inner(void * mem);
extern "C" void compile_prologue(void * mem);
extern "C" void compile_epilogue(void * mem, unsigned long n);

int leaf_qnty;
int inner_qnty;
int nodes;
unsigned long it;


unsigned long eval_mem(unsigned const * tree)
{
  int i;
  inner_qnty = leaf_qnty = 0;
  for(nodes=1,i=0;nodes;++i)
    {
      if (tree[i]==0) ++inner_qnty, ++nodes;
      else ++leaf_qnty, --nodes;
    }
  nodes=i;
  return prologue_size() + epilogue_size() + leaf_qnty*leaf_size() + inner_qnty*inner_size();
}

combinator compile(unsigned nargs, unsigned const * tree)
{
  unsigned long size = eval_mem(tree);
  char * mmem = mallocx(size);
  it = 0;
  compile_prologue(mmem);
  it += prologue_size();
  for(int i=nodes-1;i>=0 ;--i)
    {
       if (tree[i])
        {
          compile_leaf(mmem + it, tree[i]);
          it += leaf_size();
        }
      else
        {
          compile_inner(mmem + it);
          it += inner_size();
        }
    }
  compile_epilogue(mmem + it, nargs);
  return (combinator) mmem;
}
