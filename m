Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE6A30F95F;
	Sat, 21 Mar 2026 23:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774134497; cv=none; b=o1TxMm7KNwmEyvhtm8ejq1r2bqBDvYPYusbt0ej6wnp/zcP3ww5N5emyXl9sbFTcofg1OO2nciTbZHNxuvMDC+Re0IfDVLlO0JiBIdi4H5q4cLEA5pedupf+Y4GB1Dj7xAXRZFw5VdPOf6/OS5k7N0CjAnA4Ujf5BWxUnJDAmmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774134497; c=relaxed/simple;
	bh=Q0f6pgaoVbnZA7GQkp92XWTyQYC8TSEiu/m2kHPBBKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnbOjrAeWSdjeLc1yZi1fNJKb3uhZTXw7EvBaa4NORLl+rR2nrmqDJwS/5acjIm5VZRo0JYcXXfhW2LwIa55olKiKjgSzZ0foOmNg/ubM0iE8nCoMy1sbVtqJiQuhhIz+WRejaNamFBNiD7h5/DAaO277IDy0XMiHL1zbxWkWxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tdeo71MN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tdeo71MN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A9BC2BCB2;
	Sat, 21 Mar 2026 23:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774134497;
	bh=Q0f6pgaoVbnZA7GQkp92XWTyQYC8TSEiu/m2kHPBBKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tdeo71MNmf2R+QXD7D31ZrIhEPE3mC50/09LggO+6sWIpDoU+h/zUIyKbYgjj/gGp
	 +HvK3n8awNkYFqzak0ckFUSC4E2t2RuwJOH+y3V+anAib5/wSuX91rf5qgReFQIvAI
	 YCK9ifPchHrFmk+QDb+Ws+qxTPxc0AFWVDUWDwTOHlfItsL8wNcIe4i2zw2zPZITCB
	 2KuyDUjze4z2rRm5YpWDQ11ZzhndON0/Q+RhgXD0daq6aGXC+FiYBA6xm1P/Y2mfvs
	 ruS5M8BiSrL4KZGGcGGfC6ZB1IJgamqYZMX0rOLJmypKlx1ZViC7mNjrT1Tta6saHc
	 qKGLUXWh2Wn8A==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] dm-crypt: Make crypt_iv_operations::wipe return void
Date: Sat, 21 Mar 2026 16:06:51 -0700
Message-ID: <20260321230651.89081-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321230651.89081-1-ebiggers@kernel.org>
References: <20260321230651.89081-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since all implementations of crypt_iv_operations::wipe now return 0,
change the return type to void.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-crypt.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 76b0c6bfd45c..885208a82c55 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -108,11 +108,11 @@ struct crypt_config;
 struct crypt_iv_operations {
 	int (*ctr)(struct crypt_config *cc, struct dm_target *ti,
 		   const char *opts);
 	void (*dtr)(struct crypt_config *cc);
 	int (*init)(struct crypt_config *cc);
-	int (*wipe)(struct crypt_config *cc);
+	void (*wipe)(struct crypt_config *cc);
 	int (*generator)(struct crypt_config *cc, u8 *iv,
 			 struct dm_crypt_request *dmreq);
 	int (*post)(struct crypt_config *cc, u8 *iv,
 		    struct dm_crypt_request *dmreq);
 };
@@ -506,18 +506,16 @@ static int crypt_iv_lmk_init(struct crypt_config *cc)
 		       MD5_DIGEST_SIZE);
 
 	return 0;
 }
 
-static int crypt_iv_lmk_wipe(struct crypt_config *cc)
+static void crypt_iv_lmk_wipe(struct crypt_config *cc)
 {
 	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
 
 	if (lmk->seed)
 		memset(lmk->seed, 0, LMK_SEED_SIZE);
-
-	return 0;
 }
 
 static void crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 			     struct dm_crypt_request *dmreq, u8 *data)
 {
@@ -627,18 +625,16 @@ static int crypt_iv_tcw_init(struct crypt_config *cc)
 	       TCW_WHITENING_SIZE);
 
 	return 0;
 }
 
-static int crypt_iv_tcw_wipe(struct crypt_config *cc)
+static void crypt_iv_tcw_wipe(struct crypt_config *cc)
 {
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
 
 	memset(tcw->iv_seed, 0, cc->iv_size);
 	memset(tcw->whitening, 0, TCW_WHITENING_SIZE);
-
-	return 0;
 }
 
 static void crypt_iv_tcw_whitening(struct crypt_config *cc,
 				   struct dm_crypt_request *dmreq, u8 *data)
 {
@@ -1013,16 +1009,15 @@ static int crypt_iv_elephant_init(struct crypt_config *cc)
 	int key_offset = cc->key_size - cc->key_extra_size;
 
 	return aes_prepareenckey(elephant->key, &cc->key[key_offset], cc->key_extra_size);
 }
 
-static int crypt_iv_elephant_wipe(struct crypt_config *cc)
+static void crypt_iv_elephant_wipe(struct crypt_config *cc)
 {
 	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
 
 	memzero_explicit(elephant->key, sizeof(*elephant->key));
-	return 0;
 }
 
 static const struct crypt_iv_operations crypt_iv_plain_ops = {
 	.generator = crypt_iv_plain_gen
 };
@@ -2646,15 +2641,12 @@ static int crypt_wipe_key(struct crypt_config *cc)
 
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 	get_random_bytes(&cc->key, cc->key_size);
 
 	/* Wipe IV private keys */
-	if (cc->iv_gen_ops && cc->iv_gen_ops->wipe) {
-		r = cc->iv_gen_ops->wipe(cc);
-		if (r)
-			return r;
-	}
+	if (cc->iv_gen_ops && cc->iv_gen_ops->wipe)
+		cc->iv_gen_ops->wipe(cc);
 
 	kfree_sensitive(cc->key_string);
 	cc->key_string = NULL;
 	r = crypt_setkey(cc);
 	memset(&cc->key, 0, cc->key_size * sizeof(u8));
-- 
2.53.0

