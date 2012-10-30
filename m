From: Behan Webster <behanw@converseincode.com>
Subject: [PATCH 2/2] Remove VLAIS usage from crypto/testmgr.c
Date: Tue, 30 Oct 2012 14:37:29 -0400
Message-ID: <1351622249-18084-3-git-send-email-behanw@converseincode.com>
References: <1351622249-18084-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
	pageexec@freemail.hu, Behan Webster <behanw@converseincode.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46316 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab2J3ShT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Oct 2012 14:37:19 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so881390iea.19
        for <linux-crypto@vger.kernel.org>; Tue, 30 Oct 2012 11:37:18 -0700 (PDT)
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
 crypto/testmgr.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 941d75c..5b7b3a6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1578,16 +1578,19 @@ static int alg_test_crc32c(const struct alg_tes=
t_desc *desc,
 	}
=20
 	do {
-		struct {
-			struct shash_desc shash;
-			char ctx[crypto_shash_descsize(tfm)];
-		} sdesc;
-
-		sdesc.shash.tfm =3D tfm;
-		sdesc.shash.flags =3D 0;
-
-		*(u32 *)sdesc.ctx =3D le32_to_cpu(420553207);
-		err =3D crypto_shash_final(&sdesc.shash, (u8 *)&val);
+		char sdesc[sizeof(struct shash_desc)
+			+ crypto_shash_descsize(tfm)
+			+ CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
+		struct shash_desc *shash =3D (struct shash_desc *)sdesc;
+		u32 *ctx =3D (u32 *)((unsigned long)(sdesc
+			+ sizeof(struct shash_desc) + CRYPTO_MINALIGN - 1)
+			& ~(CRYPTO_MINALIGN - 1));
+
+		shash->tfm =3D tfm;
+		shash->flags =3D 0;
+
+		*ctx =3D le32_to_cpu(420553207);
+		err =3D crypto_shash_final(shash, (u8 *)&val);
 		if (err) {
 			printk(KERN_ERR "alg: crc32c: Operation failed for "
 			       "%s: %d\n", driver, err);
--=20
1.7.9.5
