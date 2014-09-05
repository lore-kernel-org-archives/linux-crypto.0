From: behanw@converseincode.com
Subject: [PATCH v2] crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c
Date: Fri,  5 Sep 2014 16:06:47 -0700
Message-ID: <1409958407-9173-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
	Behan Webster <behanw@converseincode.com>, pageexec@freemail.hu
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48140 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaIEXG4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Sep 2014 19:06:56 -0400
Received: by mail-pa0-f44.google.com with SMTP id rd3so22953214pab.17
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2014 16:06:56 -0700 (PDT)
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

struct shash_desc contains a flexible array member member ctx declared =
with
CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
of the array declared after struct shash_desc with long long.

No trailing padding is required because it is not a struct type that ca=
n
be used in an array.

The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long =
long
as would be the case for a struct containing a member with
CRYPTO_MINALIGN_ATTR.

Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Cc: pageexec@freemail.hu
---
 crypto/testmgr.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ac2b631..34f5a32 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1714,16 +1714,16 @@ static int alg_test_crc32c(const struct alg_tes=
t_desc *desc,
 	}
=20
 	do {
-		struct {
-			struct shash_desc shash;
-			char ctx[crypto_shash_descsize(tfm)];
-		} sdesc;
+		char sdesc[sizeof(struct shash_desc) +
+			crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
+		struct shash_desc *shash =3D (struct shash_desc *)sdesc;
+		u32 *ctx =3D (u32 *)shash_desc_ctx(shash);
=20
-		sdesc.shash.tfm =3D tfm;
-		sdesc.shash.flags =3D 0;
+		shash->tfm =3D tfm;
+		shash->flags =3D 0;
=20
-		*(u32 *)sdesc.ctx =3D le32_to_cpu(420553207);
-		err =3D crypto_shash_final(&sdesc.shash, (u8 *)&val);
+		*ctx =3D le32_to_cpu(420553207);
+		err =3D crypto_shash_final(shash, (u8 *)&val);
 		if (err) {
 			printk(KERN_ERR "alg: crc32c: Operation failed for "
 			       "%s: %d\n", driver, err);
--=20
1.9.1
