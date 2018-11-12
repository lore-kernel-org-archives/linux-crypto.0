Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from lhrrgout.huawei.com ([185.176.76.210]:32741 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbeKLUYE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 15:24:04 -0500
From: Roberto Sassu <roberto.sassu@huawei.com>
To: <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>
Subject: [RFC][PATCH 07/12] KEYS: Provide PGP key description autogeneration
Date: Mon, 12 Nov 2018 11:24:18 +0100
Message-ID: <20181112102423.30415-8-roberto.sassu@huawei.com>
In-Reply-To: <20181112102423.30415-1-roberto.sassu@huawei.com>
References: <20181112102423.30415-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: David Howells <dhowells@redhat.com>

Provide a facility to autogenerate the name of PGP keys from the contents
of the payload.  If add_key() is given a blank description, a description
is constructed from the last user ID packet in the payload data plus the
last 8 hex digits of the key ID.  For instance:

	keyctl padd asymmetric "" @s </tmp/key.pub

might create a key with a constructed description that can be seen in
/proc/keys:

2f674b96 I--Q---     1 perm 39390000     0     0 crypto    \
			Sample kernel key 31f0ae93: PGP.RSA 31f0ae93 []

Changelog

v0:
- fix style issues (Roberto Sassu)

Signed-off-by: David Howells <dhowells@redhat.com>
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/pgp_public_key.c | 46 ++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pgp_public_key.c b/crypto/asymmetric_keys/pgp_public_key.c
index a5ce146a1250..371a3e721f69 100644
--- a/crypto/asymmetric_keys/pgp_public_key.c
+++ b/crypto/asymmetric_keys/pgp_public_key.c
@@ -35,6 +35,9 @@ struct pgp_key_data_parse_context {
 	struct public_key *pub;
 	unsigned char *raw_fingerprint;
 	char *fingerprint;
+	const char *user_id;
+	size_t user_id_len;
+	size_t fingerprint_len;
 };
 
 /*
@@ -155,6 +158,7 @@ static int pgp_generate_fingerprint(struct pgp_key_data_parse_context *ctx,
 	if (ret < 0)
 		goto cleanup_raw_fingerprint;
 
+	ctx->fingerprint_len = digest_size * 2;
 	fingerprint = kmalloc(digest_size * 2 + 1, GFP_KERNEL);
 	if (!fingerprint)
 		goto cleanup_raw_fingerprint;
@@ -199,6 +203,13 @@ static int pgp_process_public_key(struct pgp_parse_context *context,
 
 	kenter(",%u,%u,,%zu", type, headerlen, datalen);
 
+	if (type == PGP_PKT_USER_ID) {
+		ctx->user_id = data;
+		ctx->user_id_len = datalen;
+		kleave(" = 0 [user ID]");
+		return 0;
+	}
+
 	if (ctx->fingerprint) {
 		kleave(" = -ENOKEY [already]");
 		return -EBADMSG;
@@ -291,13 +302,46 @@ static int pgp_key_parse(struct key_preparsed_payload *prep)
 	kenter("");
 
 	memset(&ctx, 0, sizeof(ctx));
-	ctx.pgp.types_of_interest = (1 << PGP_PKT_PUBLIC_KEY);
+	ctx.pgp.types_of_interest = (1 << PGP_PKT_PUBLIC_KEY) |
+				    (1 << PGP_PKT_USER_ID);
 	ctx.pgp.process_packet = pgp_process_public_key;
 
 	ret = pgp_parse_packets(prep->data, prep->datalen, &ctx.pgp);
 	if (ret < 0)
 		goto error;
 
+	if (ctx.user_id && ctx.user_id_len > 0) {
+		/* Propose a description for the key
+		 * (user ID without the comment)
+		 */
+		size_t ulen = ctx.user_id_len, flen = ctx.fingerprint_len;
+		const char *p;
+
+		p = memchr(ctx.user_id, '(', ulen);
+		if (p) {
+			/* Remove the comment */
+			do {
+				p--;
+			} while (*p == ' ' && p > ctx.user_id);
+			if (*p != ' ')
+				p++;
+			ulen = p - ctx.user_id;
+		}
+
+		if (ulen > 255 - 9)
+			ulen = 255 - 9;
+		prep->description = kmalloc(ulen + 1 + 8 + 1, GFP_KERNEL);
+		ret = -ENOMEM;
+		if (!prep->description)
+			goto error;
+		memcpy(prep->description, ctx.user_id, ulen);
+		prep->description[ulen] = ' ';
+		memcpy(prep->description + ulen + 1,
+		       ctx.fingerprint + flen - 8, 8);
+		prep->description[ulen + 9] = 0;
+		pr_debug("desc '%s'\n", prep->description);
+	}
+
 	/* We're pinning the module by being linked against it */
 	__module_get(public_key_subtype.owner);
 	prep->payload.data[asym_subtype] = &public_key_subtype;
-- 
2.17.1
