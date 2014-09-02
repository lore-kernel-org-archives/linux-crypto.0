From: behanw@converseincode.com
Subject: [PATCH RFC 1/6] crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
Date: Tue,  2 Sep 2014 15:32:28 -0700
Message-ID: <1409697153-7006-2-git-send-email-behanw@converseincode.com>
References: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, james.l.morris@oracle.com,
	john.johansen@canonical.com, linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
	neilb@suse.de, serge@hallyn.com, torvalds@linux-foundation.org,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
	Behan Webster <behanw@converseincode.com>, pageexec@freemail.hu
To: agk@redhat.com, clm@fb.com, davem@davemloft.net,
	dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au,
	jbacik@fb.com, snitzer@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
 drivers/md/dm-crypt.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index cd15e08..4d940d3 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -526,29 +526,28 @@ static int crypt_iv_lmk_one(struct crypt_config *=
cc, u8 *iv,
 			    u8 *data)
 {
 	struct iv_lmk_private *lmk =3D &cc->iv_gen_private.lmk;
-	struct {
-		struct shash_desc desc;
-		char ctx[crypto_shash_descsize(lmk->hash_tfm)];
-	} sdesc;
+	char sdesc[sizeof(struct shash_desc)
+		+ crypto_shash_descsize(lmk->hash_tfm)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *desc =3D (struct shash_desc *)sdesc;
 	struct md5_state md5state;
 	__le32 buf[4];
 	int i, r;
=20
-	sdesc.desc.tfm =3D lmk->hash_tfm;
-	sdesc.desc.flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc->tfm =3D lmk->hash_tfm;
+	desc->flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	r =3D crypto_shash_init(&sdesc.desc);
+	r =3D crypto_shash_init(desc);
 	if (r)
 		return r;
=20
 	if (lmk->seed) {
-		r =3D crypto_shash_update(&sdesc.desc, lmk->seed, LMK_SEED_SIZE);
+		r =3D crypto_shash_update(desc, lmk->seed, LMK_SEED_SIZE);
 		if (r)
 			return r;
 	}
=20
 	/* Sector is always 512B, block size 16, add data of blocks 1-31 */
-	r =3D crypto_shash_update(&sdesc.desc, data + 16, 16 * 31);
+	r =3D crypto_shash_update(desc, data + 16, 16 * 31);
 	if (r)
 		return r;
=20
@@ -557,12 +556,12 @@ static int crypt_iv_lmk_one(struct crypt_config *=
cc, u8 *iv,
 	buf[1] =3D cpu_to_le32((((u64)dmreq->iv_sector >> 32) & 0x00FFFFFF) |=
 0x80000000);
 	buf[2] =3D cpu_to_le32(4024);
 	buf[3] =3D 0;
-	r =3D crypto_shash_update(&sdesc.desc, (u8 *)buf, sizeof(buf));
+	r =3D crypto_shash_update(desc, (u8 *)buf, sizeof(buf));
 	if (r)
 		return r;
=20
 	/* No MD5 padding here */
-	r =3D crypto_shash_export(&sdesc.desc, &md5state);
+	r =3D crypto_shash_export(desc, &md5state);
 	if (r)
 		return r;
=20
@@ -679,10 +678,9 @@ static int crypt_iv_tcw_whitening(struct crypt_con=
fig *cc,
 	struct iv_tcw_private *tcw =3D &cc->iv_gen_private.tcw;
 	u64 sector =3D cpu_to_le64((u64)dmreq->iv_sector);
 	u8 buf[TCW_WHITENING_SIZE];
-	struct {
-		struct shash_desc desc;
-		char ctx[crypto_shash_descsize(tcw->crc32_tfm)];
-	} sdesc;
+	char sdesc[sizeof(struct shash_desc)
+		+ crypto_shash_descsize(tcw->crc32_tfm)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *desc =3D (struct shash_desc *)sdesc;
 	int i, r;
=20
 	/* xor whitening with sector number */
@@ -691,16 +689,16 @@ static int crypt_iv_tcw_whitening(struct crypt_co=
nfig *cc,
 	crypto_xor(&buf[8], (u8 *)&sector, 8);
=20
 	/* calculate crc32 for every 32bit part and xor it */
-	sdesc.desc.tfm =3D tcw->crc32_tfm;
-	sdesc.desc.flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc->tfm =3D tcw->crc32_tfm;
+	desc->flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
 	for (i =3D 0; i < 4; i++) {
-		r =3D crypto_shash_init(&sdesc.desc);
+		r =3D crypto_shash_init(desc);
 		if (r)
 			goto out;
-		r =3D crypto_shash_update(&sdesc.desc, &buf[i * 4], 4);
+		r =3D crypto_shash_update(desc, &buf[i * 4], 4);
 		if (r)
 			goto out;
-		r =3D crypto_shash_final(&sdesc.desc, &buf[i * 4]);
+		r =3D crypto_shash_final(desc, &buf[i * 4]);
 		if (r)
 			goto out;
 	}
--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
