From: behanw@converseincode.com
Subject: [PATCH v3 12/12] crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c
Date: Mon, 15 Sep 2014 00:30:34 -0700
Message-ID: <1410766234-1634-13-git-send-email-behanw@converseincode.com>
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
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
 crypto/testmgr.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ac2b631..b959c0c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1714,16 +1714,14 @@ static int alg_test_crc32c(const struct alg_tes=
t_desc *desc,
 	}
=20
 	do {
-		struct {
-			struct shash_desc shash;
-			char ctx[crypto_shash_descsize(tfm)];
-		} sdesc;
+		SHASH_DESC_ON_STACK(shash, tfm);
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

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
