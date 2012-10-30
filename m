From: Behan Webster <behanw@converseincode.com>
Subject: [PATCH 1/2] Remove VLAIS usage from crypto/hmac.c
Date: Tue, 30 Oct 2012 14:37:28 -0400
Message-ID: <1351622249-18084-2-git-send-email-behanw@converseincode.com>
References: <1351622249-18084-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
	pageexec@freemail.hu, Behan Webster <behanw@converseincode.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:50484 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205Ab2J3ShQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Oct 2012 14:37:16 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so408619iag.19
        for <linux-crypto@vger.kernel.org>; Tue, 30 Oct 2012 11:37:15 -0700 (PDT)
In-Reply-To: <1351622249-18084-1-git-send-email-behanw@converseincode.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>

The use of variable length arrays in structs (VLAIS) in the Linux Kerne=
l code
precludes the use of compilers which don't implement VLAIS (for instanc=
e the
Clang compiler). This patch instead allocates the appropriate amount of=
 memory
using an char array.

Patch from series at
http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/14=
2707.html
by PaX Team.

Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
Cc: pageexec@freemail.hu
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 crypto/hmac.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 8d9544c..1061255 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -52,20 +52,19 @@ static int hmac_setkey(struct crypto_shash *parent,
 	struct hmac_ctx *ctx =3D align_ptr(opad + ss,
 					 crypto_tfm_ctx_alignment());
 	struct crypto_shash *hash =3D ctx->hash;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(hash)];
-	} desc;
+	char desc[sizeof(struct shash_desc) + crypto_shash_descsize(hash)
+		+ CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash =3D (struct shash_desc *)desc;
 	unsigned int i;
=20
-	desc.shash.tfm =3D hash;
-	desc.shash.flags =3D crypto_shash_get_flags(parent) &
-			    CRYPTO_TFM_REQ_MAY_SLEEP;
+	shash->tfm =3D hash;
+	shash->flags =3D crypto_shash_get_flags(parent)
+		& CRYPTO_TFM_REQ_MAY_SLEEP;
=20
 	if (keylen > bs) {
 		int err;
=20
-		err =3D crypto_shash_digest(&desc.shash, inkey, keylen, ipad);
+		err =3D crypto_shash_digest(shash, inkey, keylen, ipad);
 		if (err)
 			return err;
=20
@@ -81,12 +80,12 @@ static int hmac_setkey(struct crypto_shash *parent,
 		opad[i] ^=3D 0x5c;
 	}
=20
-	return crypto_shash_init(&desc.shash) ?:
-	       crypto_shash_update(&desc.shash, ipad, bs) ?:
-	       crypto_shash_export(&desc.shash, ipad) ?:
-	       crypto_shash_init(&desc.shash) ?:
-	       crypto_shash_update(&desc.shash, opad, bs) ?:
-	       crypto_shash_export(&desc.shash, opad);
+	return crypto_shash_init(shash) ?:
+	       crypto_shash_update(shash, ipad, bs) ?:
+	       crypto_shash_export(shash, ipad) ?:
+	       crypto_shash_init(shash) ?:
+	       crypto_shash_update(shash, opad, bs) ?:
+	       crypto_shash_export(shash, opad);
 }
=20
 static int hmac_export(struct shash_desc *pdesc, void *out)
--=20
1.7.9.5
