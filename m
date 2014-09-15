From: behanw@converseincode.com
Subject: [PATCH v3 09/12] crypto: LLVMLinux: Remove VLAIS usage from crypto/hmac.c
Date: Mon, 15 Sep 2014 00:30:31 -0700
Message-ID: <1410766234-1634-10-git-send-email-behanw@converseincode.com>
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, bruce.w.allan@intel.com,
	d.kasatkin@samsung.com, james.l.morris@oracle.com,
	john.griffin@intel.com, linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-ima-devel@lists.sourceforge.net,
	linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
	neilb@suse.de, qat-linux@intel.com, serge@hallyn.com,
	thomas.lendacky@amd.com, zohar@linux.vnet.ibm.com,
	torvalds@linux-foundation.org,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
	Behan Webster <behanw@converseincode.com>, pageexec@freemail.hu
To: agk@redhat.com, clm@fb.com, davem@davemloft.net,
	dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au,
	jbacik@fb.com, snitzer@redhat.com, tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36119 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbaIOHbu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Sep 2014 03:31:50 -0400
Received: by mail-pa0-f46.google.com with SMTP id kq14so5769616pab.33
        for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2014 00:31:50 -0700 (PDT)
In-Reply-To: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C9=
9
compliant equivalent. This patch allocates the appropriate amount of me=
mory
using a char array using the SHASH_DESC_ON_STACK macro.

The new code can be compiled with both gcc and clang.

Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Cc: pageexec@freemail.hu
---
 crypto/hmac.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 8d9544c..e392219 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -52,20 +52,17 @@ static int hmac_setkey(struct crypto_shash *parent,
 	struct hmac_ctx *ctx =3D align_ptr(opad + ss,
 					 crypto_tfm_ctx_alignment());
 	struct crypto_shash *hash =3D ctx->hash;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(hash)];
-	} desc;
+	SHASH_DESC_ON_STACK(shash, hash);
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
@@ -81,12 +78,12 @@ static int hmac_setkey(struct crypto_shash *parent,
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
1.9.1
