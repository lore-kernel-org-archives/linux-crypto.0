Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D543890F8;
	Mon, 20 Apr 2026 06:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667027; cv=none; b=TPQyAmnVASmxUERbTeel670IfYouw6SC34V6CiUeRze5w0/0EmxY7CZQ4n6pB+MyyK3R3smoWmfJQySfI5j3e1W96buFDGvYqIVOI47DjZ/31E7QWveWt4sMIvOi0KCtz+j4P4Nye1CfnAYCukmpe9mgTDA+0Vnlx6pvUMnZ4qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667027; c=relaxed/simple;
	bh=Ct+Yb/JehA1pkz6jkJer+61StVFhFHW+rSm/55LtL1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnxWhW1ucHx2JgDFvW/tJMyj51pYSSgs9bZdy/SndnbUpaKVJD7s5kKcv21cIz6jmtawlKK4L+rezBULSiq9TMpPBl35eCkV5FdIcYiB27n13pk0ct/DIhSv4ioSNH4xSKCZc+1dF4PMRPoSY+12ilUgsOeTS31+BpkQ/7pIA0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A3GHopUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A3GHopUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56652C19425;
	Mon, 20 Apr 2026 06:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667027;
	bh=Ct+Yb/JehA1pkz6jkJer+61StVFhFHW+rSm/55LtL1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3GHopUZx8uV2DNqrAZU255OxmIdRxLnXq5TRM0H1yiqaDhty70l4IgXJQvNGOg0D
	 ac7WqP8s8EWDqVLvtmGjH7Tmx8hDJaTAjs85mmlJw+LH+zo0JONEzNfHNNYMzUSnJh
	 yJ0T6TvBE6/LNibqEUB1VSQ+yGIF/hdao5EHfvhKHfaetnex+hij8zG1dYgnhawT2U
	 MEZFgv9GlHn8I7BjTGX5BrD//D0JzR7030BFJ2Ol2edDHXE20dL8HP08G9t+s4sgmr
	 cHuKCzDmlMKkC3Ju6BeZYqaXtOhY16QfjDUQI8N38r1z7ZbhuGXA8Ecx9ZgwPQn4Pi
	 pPEB7Wo3FsXRA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 26/38] crypto: drbg - Consolidate "instantiate" logic and remove drbg_state::C
Date: Sun, 19 Apr 2026 23:34:10 -0700
Message-ID: <20260420063422.324906-27-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420063422.324906-1-ebiggers@kernel.org>
References: <20260420063422.324906-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently some of the steps of "Instantiate the DRBG" occur in a
convoluted way in different places in the call stack:

drbg_instantiate()

    => drbg_seed(reseed=0) sets the raw HMAC key drbg_state::C to its
       correct initial value, and it sets the state value
       drbg_state::V to an *incorrect* initial value.

        => drbg_hmac_update(reseed=0) overwrites drbg_state::V with the
           correct initial value, then prepares the hmac_sha512_key
           drbg_state::key from the initial raw HMAC key drbg_state::C.

Later, each time the HMAC key is updated, drbg_hmac_update() also uses
drbg_state::C to temporarily store the new raw key.

Simplify all of this by:

    - Making drbg_instantiate() set the correct initial values of
      drbg_state::V and drbg_state::key.

    - Converting drbg_hmac_update() to generate the raw key in a
      temporary on-stack array instead of drbg_state::C.

    - Removing drbg_state::C.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 439581d7bb83..7e3ab2f811b6 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -134,11 +134,10 @@ enum drbg_seed_state {
 
 struct drbg_state {
 	struct mutex drbg_mutex;	/* lock around DRBG */
 	u8 V[DRBG_STATE_LEN];		/* internal state -- 10.1.2.1 1a */
 	struct hmac_sha512_key key;	/* current key -- 10.1.2.1 1b */
-	u8 C[DRBG_STATE_LEN];		/* current key -- 10.1.2.1 1b */
 	/* Number of RNG requests since last reseed -- 10.1.2.1 1c */
 	size_t reseed_ctr;
 	size_t reseed_threshold;
 	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
 	unsigned long last_seed_time;
@@ -158,21 +157,15 @@ static int drbg_uninstantiate(struct drbg_state *drbg);
 /******************************************************************
  * HMAC DRBG functions
  ******************************************************************/
 
 /* update function of HMAC DRBG as defined in 10.1.2.2 */
-static void drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
-			     int reseed)
+static void drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed)
 {
 	int i = 0;
 	struct hmac_sha512_ctx hmac_ctx;
-
-	if (!reseed) {
-		/* 10.1.2.3 step 2 -- memset(0) of C is implicit with kzalloc */
-		memset(drbg->V, 1, DRBG_STATE_LEN);
-		hmac_sha512_preparekey(&drbg->key, drbg->C, DRBG_STATE_LEN);
-	}
+	u8 new_key[DRBG_STATE_LEN];
 
 	for (i = 2; 0 < i; i--) {
 		/* first round uses 0x0, second 0x1 */
 		unsigned char prefix = DRBG_PREFIX0;
 		if (1 == i)
@@ -186,20 +179,21 @@ static void drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
 
 			list_for_each_entry(input, seed, list)
 				hmac_sha512_update(&hmac_ctx, input->buf,
 						   input->len);
 		}
-		hmac_sha512_final(&hmac_ctx, drbg->C);
-		hmac_sha512_preparekey(&drbg->key, drbg->C, DRBG_STATE_LEN);
+		hmac_sha512_final(&hmac_ctx, new_key);
+		hmac_sha512_preparekey(&drbg->key, new_key, DRBG_STATE_LEN);
 
 		/* 10.1.2.2 step 2 and 5 -- HMAC for V */
 		hmac_sha512(&drbg->key, drbg->V, DRBG_STATE_LEN, drbg->V);
 
 		/* 10.1.2.2 step 3 */
 		if (!seed)
 			break;
 	}
+	memzero_explicit(new_key, sizeof(new_key));
 }
 
 /* generate function of HMAC DRBG as defined in 10.1.2.5 */
 static void drbg_hmac_generate(struct drbg_state *drbg,
 			       unsigned char *buf,
@@ -208,11 +202,11 @@ static void drbg_hmac_generate(struct drbg_state *drbg,
 {
 	int len = 0;
 
 	/* 10.1.2.5 step 2 */
 	if (addtl && !list_empty(addtl))
-		drbg_hmac_update(drbg, addtl, 1);
+		drbg_hmac_update(drbg, addtl);
 
 	while (len < buflen) {
 		unsigned int outlen = 0;
 
 		/* 10.1.2.5 step 4.1 */
@@ -225,19 +219,19 @@ static void drbg_hmac_generate(struct drbg_state *drbg,
 		len += outlen;
 	}
 
 	/* 10.1.2.5 step 6 */
 	if (addtl && !list_empty(addtl))
-		drbg_hmac_update(drbg, addtl, 1);
+		drbg_hmac_update(drbg, addtl);
 	else
-		drbg_hmac_update(drbg, NULL, 1);
+		drbg_hmac_update(drbg, NULL);
 }
 
 static inline void __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
-			       int reseed, enum drbg_seed_state new_seed_state)
+			       enum drbg_seed_state new_seed_state)
 {
-	drbg_hmac_update(drbg, seed, reseed);
+	drbg_hmac_update(drbg, seed);
 
 	drbg->seeded = new_seed_state;
 	drbg->last_seed_time = jiffies;
 	drbg->reseed_ctr = 1;
 
@@ -273,11 +267,11 @@ static void drbg_seed_from_random(struct drbg_state *drbg)
 	drbg_string_fill(&data, entropy, DRBG_SEC_STRENGTH);
 	list_add_tail(&data.list, &seedlist);
 
 	get_random_bytes(entropy, DRBG_SEC_STRENGTH);
 
-	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
+	__drbg_seed(drbg, &seedlist, DRBG_SEED_STATE_FULL);
 
 	memzero_explicit(entropy, DRBG_SEC_STRENGTH);
 }
 
 static bool drbg_nopr_reseed_interval_elapsed(struct drbg_state *drbg)
@@ -402,16 +396,12 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	if (pers && pers->buf && 0 < pers->len) {
 		list_add_tail(&pers->list, &seedlist);
 		pr_devel("DRBG: using personalization string\n");
 	}
 
-	if (!reseed) {
-		memset(drbg->V, 0, DRBG_STATE_LEN);
-		memset(drbg->C, 0, DRBG_STATE_LEN);
-	}
 
-	__drbg_seed(drbg, &seedlist, reseed, new_seed_state);
+	__drbg_seed(drbg, &seedlist, new_seed_state);
 	ret = 0;
 out:
 	memzero_explicit(entropy, sizeof(entropy));
 
 	return ret;
@@ -422,11 +412,10 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 {
 	if (!drbg)
 		return;
 	memzero_explicit(&drbg->key, sizeof(drbg->key));
 	memzero_explicit(drbg->V, sizeof(drbg->V));
-	memzero_explicit(drbg->C, sizeof(drbg->C));
 	drbg->reseed_ctr = 0;
 	drbg->instantiated = false;
 }
 
 /*
@@ -603,10 +592,11 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
  *	error value otherwise
  */
 static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 			    bool pr)
 {
+	static const u8 initial_key[DRBG_STATE_LEN]; /* all zeroes */
 	int ret;
 	bool reseed = true;
 
 	pr_devel("DRBG: Initializing DRBG with prediction resistance %s\n",
 		 str_enabled_disabled(pr));
@@ -625,10 +615,12 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 		drbg->instantiated = true;
 		drbg->pr = pr;
 		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 		drbg->last_seed_time = 0;
 		drbg->reseed_threshold = DRBG_MAX_REQUESTS;
+		memset(drbg->V, 1, DRBG_STATE_LEN);
+		hmac_sha512_preparekey(&drbg->key, initial_key, DRBG_STATE_LEN);
 
 		ret = drbg_prepare_hrng(drbg);
 		if (ret)
 			goto free_everything;
 
-- 
2.53.0

