From: behanw@converseincode.com
Subject: [PATCH v3 08/12] crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
Date: Mon, 15 Sep 2014 00:30:30 -0700
Message-ID: <1410766234-1634-9-git-send-email-behanw@converseincode.com>
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
	Behan Webster <behanw@converseincode.com>,
	pageexec@freemail.hu, gmazyland@gmail.com
To: agk@redhat.com, clm@fb.com, davem@davemloft.net,
	dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au,
	jbacik@fb.com, snitzer@redhat.com, tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55694 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbaIOHbr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Sep 2014 03:31:47 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so5635848pdj.36
        for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2014 00:31:47 -0700 (PDT)
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
Cc: gmazyland@gmail.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/md/dm-crypt.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index cd15e08..fc93b93 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -526,29 +526,26 @@ static int crypt_iv_lmk_one(struct crypt_config *=
cc, u8 *iv,
 			    u8 *data)
 {
 	struct iv_lmk_private *lmk =3D &cc->iv_gen_private.lmk;
-	struct {
-		struct shash_desc desc;
-		char ctx[crypto_shash_descsize(lmk->hash_tfm)];
-	} sdesc;
+	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
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
@@ -557,12 +554,12 @@ static int crypt_iv_lmk_one(struct crypt_config *=
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
@@ -679,10 +676,7 @@ static int crypt_iv_tcw_whitening(struct crypt_con=
fig *cc,
 	struct iv_tcw_private *tcw =3D &cc->iv_gen_private.tcw;
 	u64 sector =3D cpu_to_le64((u64)dmreq->iv_sector);
 	u8 buf[TCW_WHITENING_SIZE];
-	struct {
-		struct shash_desc desc;
-		char ctx[crypto_shash_descsize(tcw->crc32_tfm)];
-	} sdesc;
+	SHASH_DESC_ON_STACK(desc, tcw->crc32_tfm);
 	int i, r;
=20
 	/* xor whitening with sector number */
@@ -691,16 +685,16 @@ static int crypt_iv_tcw_whitening(struct crypt_co=
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
