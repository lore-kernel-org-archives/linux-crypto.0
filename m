From: Behan Webster <behanw@converseincode.com>
Subject: [PATCH V2 2/2] Remove VLAIS usage from crypto/testmgr.c
Date: Wed, 31 Oct 2012 07:20:34 -0400
Message-ID: <1351682434-6642-2-git-send-email-behanw@converseincode.com>
References: <1351682434-6642-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
	pageexec@freemail.hu, Behan Webster <behanw@converseincode.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351682434-6642-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
[Use shash_desc_ctx() to calculate address of ctx]
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 crypto/testmgr.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 941d75c..8738ff4 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1578,16 +1578,17 @@ static int alg_test_crc32c(const struct alg_tes=
t_desc *desc,
 	}
=20
 	do {
-		struct {
-			struct shash_desc shash;
-			char ctx[crypto_shash_descsize(tfm)];
-		} sdesc;
+		char sdesc[sizeof(struct shash_desc)
+			+ crypto_shash_descsize(tfm)
+			+ CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
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
1.7.9.5
