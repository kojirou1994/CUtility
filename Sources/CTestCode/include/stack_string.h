#ifndef stack_string_h
#define stack_string_h

struct stack_string {
  char string[4];
};

struct stack_string null_terminated_stack_string() {
  struct stack_string value = {"abc"};
  return value;
}

struct stack_string nonnull_terminated_stack_string() {
  struct stack_string value = {"abcd"};
  return value;
}

char stack_string_char_at(struct stack_string str, int index) {
  return str.string[index];
}

#define C_MACRO_OPTION_HIGH (1 << 31)

#endif /* stack_string_h */
