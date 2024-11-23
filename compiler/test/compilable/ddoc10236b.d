// PERMUTE_ARGS:
// REQUIRED_ARGS: -D -Dd${RESULTS_DIR}/compilable -wi -o-

/*
TEST_OUTPUT:
---
compilable/ddoc10236b.d(52): Warning: Ddoc: parameter count mismatch, expected 1, got 0
void foo_count_mismatch(int x)(int y)	// Warning: Ddoc: parameter count mismatch
     ^
compilable/ddoc10236b.d(52):        Note that the format is `param = description`
compilable/ddoc10236b.d(64): Warning: Ddoc: function declaration has no parameter 'y'
void foo_no_param_y(int x)(int z)		// Warning: Ddoc: function declaration has no parameter 'y'
     ^
compilable/ddoc10236b.d(76): Warning: Ddoc: function declaration has no parameter 'y'
void foo_count_mismatch_no_param_y(int x)()
     ^
compilable/ddoc10236b.d(76): Warning: Ddoc: parameter count mismatch, expected 0, got 1
void foo_count_mismatch_no_param_y(int x)()
     ^
---
*/

/***********************************
 * foo_good does this.
 * Params:
 *	x =	is for this
 *		and not for that
 *	y =	is for that
 */

void foo_good(int x)(int y)
{
}

/***********************************
 * foo_good2 does this.
 * Params:
 *	y =	is for that
 */

void foo_good2(int x)(int y)
{
}

/***********************************
 * foo_count_mismatch does this.
 * Params:
 *	x =	is for this
 *		and not for that
 */

void foo_count_mismatch(int x)(int y)	// Warning: Ddoc: parameter count mismatch
{
}

/***********************************
 * foo_no_param_y does this.
 * Params:
 *	x =	is for this
 *		and not for that
 *	y =	is for that
 */

void foo_no_param_y(int x)(int z)		// Warning: Ddoc: function declaration has no parameter 'y'
{
}

/***********************************
 * foo_count_mismatch_no_param_y does this.
 * Params:
 *	x =	is for this
 *		and not for that
 *	y =	is for that
 */

void foo_count_mismatch_no_param_y(int x)()
{
}
