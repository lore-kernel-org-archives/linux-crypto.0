From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/4] ASN.1: Fix actions on CHOICE elements with IMPLICIT tags
Date: Wed, 05 Aug 2015 14:18:21 +0100
Message-ID: <20150805131821.8933.23981.stgit@warthog.procyon.org.uk>
References: <20150805131810.8933.59566.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: keyrings@linux-nfs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbbHENS1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 09:18:27 -0400
In-Reply-To: <20150805131810.8933.59566.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In an ASN.1 description where there is a CHOICE construct that contains
elements with IMPLICIT tags that refer to constructed types, actions to be
taken on those elements should be conditional on the corresponding element
actually being matched.  Currently, however, such actions are performed
unconditionally in the middle of processing the CHOICE.

For example, look at elements 'b' and 'e' here:

	A ::= SEQUENCE {
			CHOICE {
			b [0] IMPLICIT B ({ do_XXXXXXXXXXXX_b }),
			c [1] EXPLICIT C ({ do_XXXXXXXXXXXX_c }),
			d [2] EXPLICIT B ({ do_XXXXXXXXXXXX_d }),
			e [3] IMPLICIT C ({ do_XXXXXXXXXXXX_e }),
			f [4] IMPLICIT INTEGER ({ do_XXXXXXXXXXXX_f })
			}
		} ({ do_XXXXXXXXXXXX_A })

	B ::= SET OF OBJECT IDENTIFIER ({ do_XXXXXXXXXXXX_oid })

	C ::= SET OF INTEGER ({ do_XXXXXXXXXXXX_int })

They each have an action (do_XXXXXXXXXXXX_b and do_XXXXXXXXXXXX_e) that
should only be processed if that element is matched.

The problem is that there's no easy place to hang the action off in the
subclause (type B for element 'b' and type C for element 'e') because
subclause opcode sequences can be shared.

To fix this, introduce a conditional action opcode(ASN1_OP_MAYBE_ACT) that
the decoder only processes if the preceding match was successful.  This can
be seen in an excerpt from the output of the fixed ASN.1 compiler for the
above ASN.1 description:

	[  13] =  ASN1_OP_COND_MATCH_JUMP_OR_SKIP,		// e
	[  14] =  _tagn(CONT, CONS,  3),
	[  15] =  _jump_target(45),		// --> C
	[  16] =  ASN1_OP_MAYBE_ACT,
	[  17] =  _action(ACT_do_XXXXXXXXXXXX_e),

In this, if the op at [13] is matched (ie. element 'e' above) then the
action at [16] will be performed.  However, if the op at [13] doesn't match
or is skipped because it is conditional and some previous op matched, then
the action at [16] will be ignored.

Note that to make this work in the decoder, the ASN1_OP_RETURN op must set
the flag to indicate that a match happened.  This is necessary because the
_jump_target() seen above introduces a subclause (in this case an object of
type 'C') which is likely to alter the flag.  Setting the flag here is okay
because to process a subclause, a match must have happened and caused a
jump.

This cannot be tested with the code as it stands, but rather affects future
code.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Woodhouse <David.Woodhouse@intel.com>
---

 include/linux/asn1_ber_bytecode.h |    3 ++-
 lib/asn1_decoder.c                |   14 +++++++++++++-
 scripts/asn1_compiler.c           |    3 ++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/asn1_ber_bytecode.h b/include/linux/asn1_ber_bytecode.h
index 945d44ae529c..27f35780aecf 100644
--- a/include/linux/asn1_ber_bytecode.h
+++ b/include/linux/asn1_ber_bytecode.h
@@ -61,7 +61,8 @@ enum asn1_opcode {
 	ASN1_OP_COND_FAIL		= 0x1b,
 	ASN1_OP_COMPLETE		= 0x1c,
 	ASN1_OP_ACT			= 0x1d,
-	ASN1_OP_RETURN			= 0x1e,
+	ASN1_OP_MAYBE_ACT		= 0x1e,
+	ASN1_OP_RETURN			= 0x1f,
 
 	/* The following eight have bit 0 -> SET, 1 -> OF, 2 -> ACT */
 	ASN1_OP_END_SEQ			= 0x20,
diff --git a/lib/asn1_decoder.c b/lib/asn1_decoder.c
index 1a000bb050f9..55980d7e1ac0 100644
--- a/lib/asn1_decoder.c
+++ b/lib/asn1_decoder.c
@@ -33,6 +33,7 @@ static const unsigned char asn1_op_lengths[ASN1_OP__NR] = {
 	[ASN1_OP_COND_FAIL]			= 1,
 	[ASN1_OP_COMPLETE]			= 1,
 	[ASN1_OP_ACT]				= 1         + 1,
+	[ASN1_OP_MAYBE_ACT]			= 1         + 1,
 	[ASN1_OP_RETURN]			= 1,
 	[ASN1_OP_END_SEQ]			= 1,
 	[ASN1_OP_END_SEQ_OF]			= 1     + 1,
@@ -177,6 +178,7 @@ int asn1_ber_decoder(const struct asn1_decoder *decoder,
 	unsigned char flags = 0;
 #define FLAG_INDEFINITE_LENGTH	0x01
 #define FLAG_MATCHED		0x02
+#define FLAG_LAST_MATCHED	0x04 /* Last tag matched */
 #define FLAG_CONS		0x20 /* Corresponds to CONS bit in the opcode tag
 				      * - ie. whether or not we are going to parse
 				      *   a compound type.
@@ -211,6 +213,7 @@ next_op:
 		if ((op & ASN1_OP_MATCH__COND &&
 		     flags & FLAG_MATCHED) ||
 		    dp == datalen) {
+			flags &= ~FLAG_LAST_MATCHED;
 			pc += asn1_op_lengths[op];
 			goto next_op;
 		}
@@ -422,8 +425,15 @@ next_op:
 		pc += asn1_op_lengths[op];
 		goto next_op;
 
+	case ASN1_OP_MAYBE_ACT:
+		if (!(flags & FLAG_LAST_MATCHED)) {
+			pc += asn1_op_lengths[op];
+			goto next_op;
+		}
 	case ASN1_OP_ACT:
 		ret = actions[machine[pc + 1]](context, hdr, tag, data + tdp, len);
+		if (ret < 0)
+			return ret;
 		pc += asn1_op_lengths[op];
 		goto next_op;
 
@@ -431,6 +441,7 @@ next_op:
 		if (unlikely(jsp <= 0))
 			goto jump_stack_underflow;
 		pc = jump_stack[--jsp];
+		flags |= FLAG_MATCHED | FLAG_LAST_MATCHED;
 		goto next_op;
 
 	default:
@@ -438,7 +449,8 @@ next_op:
 	}
 
 	/* Shouldn't reach here */
-	pr_err("ASN.1 decoder error: Found reserved opcode (%u)\n", op);
+	pr_err("ASN.1 decoder error: Found reserved opcode (%u) pc=%zu\n",
+	       op, pc);
 	return -EBADMSG;
 
 data_overrun_error:
diff --git a/scripts/asn1_compiler.c b/scripts/asn1_compiler.c
index e87359cd23c0..0515bced929a 100644
--- a/scripts/asn1_compiler.c
+++ b/scripts/asn1_compiler.c
@@ -1468,7 +1468,8 @@ dont_render_tag:
 	case TYPE_REF:
 		render_element(out, e->type->type->element, tag);
 		if (e->action)
-			render_opcode(out, "ASN1_OP_ACT,\n");
+			render_opcode(out, "ASN1_OP_%sACT,\n",
+				      skippable ? "MAYBE_" : "");
 		break;
 
 	case SEQUENCE:
