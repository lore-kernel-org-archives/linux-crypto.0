Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795840865;
	b=YGNeTEuQjUx14L7EI6RDpV++b9CB5qgI7/YCOEuA48OD57lRVpE+puzQCLMXxwM6A2tg
	 jNO6TE7kKJyhmJ1aK76917cOCJXxDZN6pq6tUNUw4SXY5dt7oB9f/35l8C45MUNosXlij
	 V/dkycscNKdyeQjtjBNXTkptygdq10916cg4FVFhnmhx4og9YGhwA6aeQ5nVshv+lgQzz
	 ln808aQr+1n8IJTLDx+3O4FnQbzJz+irUhitNnCu8pP7zqrM6aR7IojDNXLD8NcW9hzVV
	 fvda834fK6GKyf8vC1Z5KxMyeRqdRvCjlhwpgp7YpJbK5Xk5uYuGL7MxEVTvgn0AW/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795840865;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6t9fJk8rDsnFKfYoqA35qg4bwmIPA6klJozyTgQquS0=;
	b=4/f97STJxlKw+xSc4VEuipKLk4bP6EnSOGL3rJ7GgM86S4lguVueU97a/h6YsnzkS6GG
	 rmjHly6qylNcjByNemZ2bBcPeIUDWFozSc/sFnG7O4UWDIN9EL0syc0GqefMQDSQ1i4aN
	 JBo5It05q4kynzEHYh+ESq66yzazwBf9hFvI+x8rlWon/Ymg7oYPlVzQu6gHGAW6fA9BH
	 PDoS330Tfni9oDHX3cBmivSqjpoboE+WWwswR99F9TjV9vQgc+1G7XTpWKeSmoR9gctpp
	 AWnKwDC/VH7gx9321GwC/mrp3C0BdsIfjLjHNeoyDg5aatK9B4rwbpea5Gzd6RSXzoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DyB1+Za6;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70F4606A323
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 04:41:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C70F4606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DyB1+Za6
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2f041f88577so47331665ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 20:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795840864; x=1796445664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6t9fJk8rDsnFKfYoqA35qg4bwmIPA6klJozyTgQquS0=;
        b=DyB1+Za6LDlVE8b9T+YIkdtwMuuoR+2/gonBfCrPhKe+rQ6VTrobq1bRH0jmMnzqcx
         Rs/Ec4lwolFnCNRTHu3Jy5aXrtp5cY6lnlBZ+VRc0DMty815qTirlQ+8cqt5P1trKZxB
         WdhDaNwiy6uWcw4RAoYLgePn6U4kijKXEDazBDYhuBkGbpGfEyTba/0w1JatCHT2/APw
         UhLYhmHj6f2ayIIs9/9f/sbNdd2VJgl0dC5WGrZBa9HvH5Cq+RKraZxEh7uz20IRfx85
         g9n/csAs91cWbJEdZfMVZ6Of71zssVlCu1xVftsgMqkUIA71+aTQTAU0yHilzQa/bVBg
         xRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795840864; x=1796445664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6t9fJk8rDsnFKfYoqA35qg4bwmIPA6klJozyTgQquS0=;
        b=NivZoxLl4b+V/WEp6MN0Yv2edaJ60sChzOgDwJO3AouuR5wQREz94d4GAlzi6zeR3m
         p/8kyZR+2DfN7AXRJncM4+QLFjN2uxWDEg0VPM0LR44GtQBTUFlmGt5K5qryGoFZm+1E
         BxH4jx2rmP4oCM3iQlNYRc9Gm+eHZkgpzr3Vvj3fGfhNvKgdxcjrR7BceROyexBBZeeM
         WotUsN8yqRvSkIHBv0rBO1Gk70+Jw3YeqLwKxs39KHyCuv9g8IBJxDU+2ETDdXaCsPjz
         F5ZGX2oa7AYqicNTIQj8wKsV5orxpBw2bYuoQn9fG41SDCAuYSgwATzMoo9qi183BhPr
         8JCA==
X-Gm-Message-State: APuU4Z+W2qaMTDsEQyysEyYadrkgNQ/i52Tr0DbJlJVwrZZwqQkCm/3x
	23OCGAxj6Wfb89SjBiiEcgcSzViqVxawEZqGfFO3EWtwvsalTgHT+ueAPTwuiQ==
X-Gm-Gg: AZFdTZdhG0RBviNmINqfKHgbQllg858FjDS/LEDUwlZn3JO9PIajAmioEeut3D0Ju9F
	kDgAals601661r0W8scH265kh8WNSjeFA0EBt60WOmk4QasAu7Dlyp18laxOQ4l9cKpLLXlx5Hn
	VVmjedxI4iiBz+wMLwLDZ2djqcvLI3GMoBRlPQfe5dtvFrDMCFULoGlQE8x+/f2qhwp44dWHnvm
	Rf8s+fEwxmLHz51kweWMsbxAepe/BCRRj1lbXtsWleOOYvcHli8j2WFnbydjEPv88vugW9/pSUt
	Mz96V8np18qqWyIA2TPEu37GuRfapsu/cKcNdL5ERJZHI1+0NEfZvwf6DjIr5/KxYwcGkQVGzk2
	QhFmJOIqtofTeURdwkGM7CsnjqAn9SUy9T2DHeZR4XuQk4OwaSIJ/YFKKNK3Zr3erHDscr2mYAs
	GFy3F+qJVa6jjL+d0nPwDFKv2p/a74hP0nASyeI4ftVLKo6Zouppsv+rbabZxbJvror8Qn5Tnfc
	U1k8DnX6u9oStyz1nS8NOsZU12TiHSueoT3GIbxw8IBXTP77KBjCzp8dk/OoKYmTIyNe/WRuwAg
	j8iVal6jGgS7LvT4supQSoQJ5EVT4x4Q2ryI7M9ohmdTqbg0IKMXdSguyhLLnwqx+p+cPSTlY6s
	7ksliS2/D/PEOfVdiqZYXolXftjg2bmafHaUejaov8IVFvQVrzwPmxUcxabrk96xsg07gAx627V
	TBKRxz2jsjQiG3/d/DLaoDHEs=
X-Received: by 2002:a17:90b:5287:b0:3ab:9c73:12e with SMTP id 98e67ed59e1d1-3b41c7c22c0mr26750567a91.6.1795840864188;
        Fri, 27 Nov 2026 20:41:04 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm42716729a91.1.2026.11.27.20.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 20:41:03 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Romain Perier <romain.perier@free-electrons.com>,
	stable@vger.kernel.org
Subject: [PATCH 8/8] crypto: cesa - finish long hashes on the non-TDMA path
Date: Fri, 27 Nov 2026 20:40:50 -0800
Message-ID: <20261128044050.722617-9-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261128044050.722617-1-rosenp@gmail.com>
References: <20261128044050.722617-1-rosenp@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On engines without TDMA (Orion), the last request of a hash is finished
in mv_cesa_ahash_std_step() either by the engine, when the total length
fits the descriptor field (0xffff), or with padding built by the driver.
Three things go wrong there:

 - The hand-made padding is only added inside the branch for the
   last/unfragmented operations, which is only taken when the total
   length fits the descriptor field. Hashes of 64 KiB or more are
   therefore never padded.

 - When the padding does not fit behind the data, the code keeps
   len % 64 bytes as the amount to hash and carries 64 - padding length
   bytes into the cache, rather than hashing the whole blocks and
   carrying the partial one over to a step that adds the padding.

 - mv_cesa_ahash_std_process() completes the last request as soon as
   its source data is used up, so a carried-over block and its padding
   would never be hashed anyway.

Enter the finishing code whenever the data of the last request is used
up, convert only last/unfragmented operations to middle/first ones when
padding by hand, carry the partial block over properly, and complete the
last request only once its final operation has been started.

Tested on an Armada 385 (WRT3200ACM) with TDMA disabled in a test build,
against the software implementations, with this and the two previous
patches: before them, single threaded with lengths up to 140000 bytes,
63% of MD5/SHA1/SHA256 digests were wrong and a 4 thread run hung; after
them, none of about 240000 hashes of up to 8192 or 140000 bytes, nor of
26000 operations of mixed cipher and hash load over 4 threads.

Fixes: f63601fd616a ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.h |  3 +++
 drivers/crypto/marvell/cesa/hash.c | 38 ++++++++++++++++++++----------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
index 906d55fb6a3a..490d7b46cbfc 100644
--- a/drivers/crypto/marvell/cesa/cesa.h
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -585,9 +585,12 @@ struct mv_cesa_skcipher_req {
 /**
  * struct mv_cesa_ahash_std_req - standard hash request
  * @offset:	current operation offset
+ * @final_issued: the last operation of the last request (finalised by the
+ *		engine, or followed by the hand-made padding) has been started
  */
 struct mv_cesa_ahash_std_req {
 	unsigned int offset;
+	bool final_issued;
 };
 
 /**
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index b51315cd01df..5e867e688ffa 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -174,6 +174,7 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 	struct mv_cesa_engine *engine = creq->base.engine;
 	struct mv_cesa_op_ctx *op;
 	unsigned int new_cache_ptr = 0;
+	bool final;
 	u32 frag_mode;
 	size_t  len;
 	unsigned int digsize;
@@ -221,16 +222,17 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 
 	frag_mode = mv_cesa_get_op_cfg(op) & CESA_SA_DESC_CFG_FRAG_MSK;
 
-	if (creq->last_req && sreq->offset == req->nbytes &&
-	    creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
+	/* All data of the last request is in SRAM: finish the hash. */
+	final = creq->last_req && sreq->offset == req->nbytes;
+
+	if (final && creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
 		if (frag_mode == CESA_SA_DESC_CFG_FIRST_FRAG)
 			frag_mode = CESA_SA_DESC_CFG_NOT_FRAG;
 		else if (frag_mode == CESA_SA_DESC_CFG_MID_FRAG)
 			frag_mode = CESA_SA_DESC_CFG_LAST_FRAG;
 	}
 
-	if (frag_mode == CESA_SA_DESC_CFG_NOT_FRAG ||
-	    frag_mode == CESA_SA_DESC_CFG_LAST_FRAG) {
+	if (final) {
 		if (len &&
 		    creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
 			mv_cesa_set_mac_op_total_len(op, creq->len);
@@ -238,8 +240,13 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 			int trailerlen = mv_cesa_ahash_pad_len(creq) + 8;
 
 			if (len + trailerlen > CESA_SA_SRAM_PAYLOAD_SIZE) {
-				len &= CESA_HASH_BLOCK_SIZE_MSK;
-				new_cache_ptr = 64 - trailerlen;
+				/*
+				 * No room for the padding: hash the whole
+				 * blocks now and carry the partial one over
+				 * to the next step, which adds the padding.
+				 */
+				new_cache_ptr = len & CESA_HASH_BLOCK_SIZE_MSK;
+				len &= ~CESA_HASH_BLOCK_SIZE_MSK;
 				if (engine->pool)
 					memcpy(creq->cache,
 					       engine->sram_pool +
@@ -262,15 +269,20 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 						    CESA_SA_DATA_SRAM_OFFSET,
 						    creq->cache, i);
 				len += i;
+				sreq->final_issued = true;
 			}
 
 			if (frag_mode == CESA_SA_DESC_CFG_LAST_FRAG)
 				frag_mode = CESA_SA_DESC_CFG_MID_FRAG;
-			else
+			else if (frag_mode == CESA_SA_DESC_CFG_NOT_FRAG)
 				frag_mode = CESA_SA_DESC_CFG_FIRST_FRAG;
 		}
 	}
 
+	if (frag_mode == CESA_SA_DESC_CFG_NOT_FRAG ||
+	    frag_mode == CESA_SA_DESC_CFG_LAST_FRAG)
+		sreq->final_issued = true;
+
 	mv_cesa_set_mac_op_frag_len(op, len);
 	mv_cesa_update_op_cfg(op, frag_mode, CESA_SA_DESC_CFG_FRAG_MSK);
 
@@ -299,11 +311,12 @@ static int mv_cesa_ahash_std_process(struct ahash_request *req, u32 status)
 	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
 	unsigned int left;
 
-	if (creq->last_req) {
-		if (sreq->offset < (req->nbytes - creq->cache_ptr))
-			return -EINPROGRESS;
-		return 0;
-	}
+	/*
+	 * The last request may still hold a partial block carried over from
+	 * the previous step, and always needs its final operation.
+	 */
+	if (creq->last_req)
+		return sreq->final_issued ? 0 : -EINPROGRESS;
 
 	/*
 	 * Less than a block left: keep it in the cache for the next request
@@ -331,6 +344,7 @@ static void mv_cesa_ahash_std_prepare(struct ahash_request *req)
 	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
 
 	sreq->offset = 0;
+	sreq->final_issued = false;
 }
 
 static void mv_cesa_ahash_dma_step(struct ahash_request *req)
-- 
2.56.1

