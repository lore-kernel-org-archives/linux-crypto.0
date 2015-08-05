From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/4] ASN.1: Handle 'ANY OPTIONAL' in grammar
Date: Wed, 05 Aug 2015 14:18:42 +0100
Message-ID: <20150805131842.8933.6659.stgit@warthog.procyon.org.uk>
References: <20150805131810.8933.59566.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: keyrings@linux-nfs.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150805131810.8933.59566.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

An ANY object in an ASN.1 grammar that is marked OPTIONAL should be skipped
if there is no more data to be had.

This can be tested by editing X.509 certificates or PKCS#7 messages to
remove the NULL from subobjects that look like the following:

	SEQUENCE {
	  OBJECT(2a864886f70d01010b);
	  NULL();
	}

This is an algorithm identifier plus an optional parameter.

The modified DER can be passed to one of:

	keyctl padd asymmetric "" @s </tmp/modified.x509
	keyctl padd pkcs7_test foo @s </tmp/modified.pkcs7

It should work okay with the patch and produce EBADMSG without.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Marcel Holtmann <marcel@holtmann.org>
Reviewed-by: David Woodhouse <David.Woodhouse@intel.com>
---

 include/linux/asn1_ber_bytecode.h |   17 +++++++++++------
 lib/asn1_decoder.c                |    8 ++++++++
 scripts/asn1_compiler.c           |    3 ++-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/linux/asn1_ber_bytecode.h b/include/linux/asn1_ber_bytecode.h
index 27f35780aecf..ab3a6c002f7b 100644
--- a/include/linux/asn1_ber_bytecode.h
+++ b/include/linux/asn1_ber_bytecode.h
@@ -45,24 +45,27 @@ enum asn1_opcode {
 	ASN1_OP_MATCH_JUMP		= 0x04,
 	ASN1_OP_MATCH_JUMP_OR_SKIP	= 0x05,
 	ASN1_OP_MATCH_ANY		= 0x08,
+	ASN1_OP_MATCH_ANY_OR_SKIP	= 0x09,
 	ASN1_OP_MATCH_ANY_ACT		= 0x0a,
+	ASN1_OP_MATCH_ANY_ACT_OR_SKIP	= 0x0b,
 	/* Everything before here matches unconditionally */
 
 	ASN1_OP_COND_MATCH_OR_SKIP	= 0x11,
 	ASN1_OP_COND_MATCH_ACT_OR_SKIP	= 0x13,
 	ASN1_OP_COND_MATCH_JUMP_OR_SKIP	= 0x15,
 	ASN1_OP_COND_MATCH_ANY		= 0x18,
+	ASN1_OP_COND_MATCH_ANY_OR_SKIP	= 0x19,
 	ASN1_OP_COND_MATCH_ANY_ACT	= 0x1a,
+	ASN1_OP_COND_MATCH_ANY_ACT_OR_SKIP = 0x1b,
 
 	/* Everything before here will want a tag from the data */
-#define ASN1_OP__MATCHES_TAG ASN1_OP_COND_MATCH_ANY_ACT
+#define ASN1_OP__MATCHES_TAG ASN1_OP_COND_MATCH_ANY_ACT_OR_SKIP
 
 	/* These are here to help fill up space */
-	ASN1_OP_COND_FAIL		= 0x1b,
-	ASN1_OP_COMPLETE		= 0x1c,
-	ASN1_OP_ACT			= 0x1d,
-	ASN1_OP_MAYBE_ACT		= 0x1e,
-	ASN1_OP_RETURN			= 0x1f,
+	ASN1_OP_COND_FAIL		= 0x1c,
+	ASN1_OP_COMPLETE		= 0x1d,
+	ASN1_OP_ACT			= 0x1e,
+	ASN1_OP_MAYBE_ACT		= 0x1f,
 
 	/* The following eight have bit 0 -> SET, 1 -> OF, 2 -> ACT */
 	ASN1_OP_END_SEQ			= 0x20,
@@ -77,6 +80,8 @@ enum asn1_opcode {
 #define ASN1_OP_END__OF			  0x02
 #define ASN1_OP_END__ACT		  0x04
 
+	ASN1_OP_RETURN			= 0x28,
+
 	ASN1_OP__NR
 };
 
diff --git a/lib/asn1_decoder.c b/lib/asn1_decoder.c
index 3f74dd3e2910..2b3f46c049d4 100644
--- a/lib/asn1_decoder.c
+++ b/lib/asn1_decoder.c
@@ -24,12 +24,16 @@ static const unsigned char asn1_op_lengths[ASN1_OP__NR] = {
 	[ASN1_OP_MATCH_JUMP]			= 1 + 1 + 1,
 	[ASN1_OP_MATCH_JUMP_OR_SKIP]		= 1 + 1 + 1,
 	[ASN1_OP_MATCH_ANY]			= 1,
+	[ASN1_OP_MATCH_ANY_OR_SKIP]		= 1,
 	[ASN1_OP_MATCH_ANY_ACT]			= 1         + 1,
+	[ASN1_OP_MATCH_ANY_ACT_OR_SKIP]		= 1         + 1,
 	[ASN1_OP_COND_MATCH_OR_SKIP]		= 1 + 1,
 	[ASN1_OP_COND_MATCH_ACT_OR_SKIP]	= 1 + 1     + 1,
 	[ASN1_OP_COND_MATCH_JUMP_OR_SKIP]	= 1 + 1 + 1,
 	[ASN1_OP_COND_MATCH_ANY]		= 1,
+	[ASN1_OP_COND_MATCH_ANY_OR_SKIP]	= 1,
 	[ASN1_OP_COND_MATCH_ANY_ACT]		= 1         + 1,
+	[ASN1_OP_COND_MATCH_ANY_ACT_OR_SKIP]	= 1         + 1,
 	[ASN1_OP_COND_FAIL]			= 1,
 	[ASN1_OP_COMPLETE]			= 1,
 	[ASN1_OP_ACT]				= 1         + 1,
@@ -304,7 +308,9 @@ next_op:
 	/* Decide how to handle the operation */
 	switch (op) {
 	case ASN1_OP_MATCH_ANY_ACT:
+	case ASN1_OP_MATCH_ANY_ACT_OR_SKIP:
 	case ASN1_OP_COND_MATCH_ANY_ACT:
+	case ASN1_OP_COND_MATCH_ANY_ACT_OR_SKIP:
 		ret = actions[machine[pc + 1]](context, hdr, tag, data + dp, len);
 		if (ret < 0)
 			return ret;
@@ -321,8 +327,10 @@ next_op:
 	case ASN1_OP_MATCH:
 	case ASN1_OP_MATCH_OR_SKIP:
 	case ASN1_OP_MATCH_ANY:
+	case ASN1_OP_MATCH_ANY_OR_SKIP:
 	case ASN1_OP_COND_MATCH_OR_SKIP:
 	case ASN1_OP_COND_MATCH_ANY:
+	case ASN1_OP_COND_MATCH_ANY_OR_SKIP:
 	skip_data:
 		if (!(flags & FLAG_CONS)) {
 			if (flags & FLAG_INDEFINITE_LENGTH) {
diff --git a/scripts/asn1_compiler.c b/scripts/asn1_compiler.c
index 0515bced929a..1c75e22b6385 100644
--- a/scripts/asn1_compiler.c
+++ b/scripts/asn1_compiler.c
@@ -1401,7 +1401,8 @@ static void render_element(FILE *out, struct element *e, struct element *tag)
 	act = e->action ? "_ACT" : "";
 	switch (e->compound) {
 	case ANY:
-		render_opcode(out, "ASN1_OP_%sMATCH_ANY%s,", cond, act);
+		render_opcode(out, "ASN1_OP_%sMATCH_ANY%s%s,",
+			      cond, act, skippable ? "_OR_SKIP" : "");
 		if (e->name)
 			render_more(out, "\t\t// %*.*s",
 				    (int)e->name->size, (int)e->name->size,
