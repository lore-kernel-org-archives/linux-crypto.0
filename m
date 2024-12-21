Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2911F238A;
	Sat, 21 Dec 2024 09:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772295; cv=none; b=g9oXL273n0hHcwlUB4kTTtHmSMmfrmwZoTYvNQba1lnTuXXCCRSMlpbwBVDTSs7Gjf02WzxwDnvvENNC1NVQj3+8WqyZpbQsNuM3Knao13ey3eiGb4hTQmbi0kpA3mI7ZKrEbgYoHL1mT9Jso7RQndgNZ+f0VJJxHHC9s0GLs3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772295; c=relaxed/simple;
	bh=H979TZHDgKLaUbglwnxL0UQbpoLtqMQtPXY6pBrdkHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7VhZalaUcsAhBLW/pj1orqEaHzb2Rq5zmfVMhiAPie3Tbqqcj/C4uJsC337dTlaj9GQSkEaXJZkkJt3sTlG/pC6yxuEDujQ4TTTysThkKfBtUKeQLjYFfH5Dq1hWGEGKdz/EMr1zgDDQMlmPNjceQrZIxXYE3o1ncyarGRAbVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KjcPLqiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KjcPLqiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E55C4CED7;
	Sat, 21 Dec 2024 09:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772295;
	bh=H979TZHDgKLaUbglwnxL0UQbpoLtqMQtPXY6pBrdkHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjcPLqiHfTy2/XRWS3CpUuGEGYQBpRM73/IBhcg1xQPXNH8tHsWjzre8sOAbDtZ72
	 z9Bnvt/nYMEpZTxz/6dsekP22L3wpPmKO7tQTLfm3SARRl0UoE8dZyjwhcaSTLLCjD
	 i9+hGXTjCj8AqrMkMzk0RqS3D9B15ciuannRdSTUv7UBsndTL/LoWrN2K4KdNDsCwQ
	 fdvEaMNfwT/eTqIr8pWglKV27o+aSxC3YSC27d8mPTpOluAfgW5j8bKLRleJu+yLf4
	 k1hObXjJH6ON8rtjpC3Jo57Vb28msuxETe18w7pGks/cl6/1llnl3DA5rOh7GTV5bK
	 OFBBs2aYM6KUg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-s390@vger.kernel.org
Subject: [PATCH 21/29] crypto: s390/aes-gcm - use the new scatterwalk functions
Date: Sat, 21 Dec 2024 01:10:48 -0800
Message-ID: <20241221091056.282098-22-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Use scatterwalk_next() which consolidates scatterwalk_clamp() and
scatterwalk_map().  Use scatterwalk_done_src() and
scatterwalk_done_dst() which consolidate scatterwalk_unmap(),
scatterwalk_advance(), and scatterwalk_done().

Besides the new functions being a bit easier to use, this is necessary
because scatterwalk_done() is planned to be removed.

Cc: Harald Freudenberger <freude@linux.ibm.com>
Cc: Holger Dengler <dengler@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This patch is part of a long series touching many files, so I have
limited the Cc list on the full series.  If you want the full series and
did not receive it, please retrieve it from lore.kernel.org.

 arch/s390/crypto/aes_s390.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 9c46b1b630b1..7fd303df05ab 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -785,32 +785,25 @@ static void gcm_walk_start(struct gcm_sg_walk *gw, struct scatterlist *sg,
 	scatterwalk_start(&gw->walk, sg);
 }
 
 static inline unsigned int _gcm_sg_clamp_and_map(struct gcm_sg_walk *gw)
 {
-	struct scatterlist *nextsg;
-
-	gw->walk_bytes = scatterwalk_clamp(&gw->walk, gw->walk_bytes_remain);
-	while (!gw->walk_bytes) {
-		nextsg = sg_next(gw->walk.sg);
-		if (!nextsg)
-			return 0;
-		scatterwalk_start(&gw->walk, nextsg);
-		gw->walk_bytes = scatterwalk_clamp(&gw->walk,
-						   gw->walk_bytes_remain);
-	}
-	gw->walk_ptr = scatterwalk_map(&gw->walk);
+	if (gw->walk_bytes_remain == 0)
+		return 0;
+	gw->walk_ptr = scatterwalk_next(&gw->walk, gw->walk_bytes_remain,
+					&gw->walk_bytes);
 	return gw->walk_bytes;
 }
 
 static inline void _gcm_sg_unmap_and_advance(struct gcm_sg_walk *gw,
-					     unsigned int nbytes)
+					     unsigned int nbytes, bool out)
 {
 	gw->walk_bytes_remain -= nbytes;
-	scatterwalk_unmap(gw->walk_ptr);
-	scatterwalk_advance(&gw->walk, nbytes);
-	scatterwalk_done(&gw->walk, 0, gw->walk_bytes_remain);
+	if (out)
+		scatterwalk_done_dst(&gw->walk, gw->walk_ptr, nbytes);
+	else
+		scatterwalk_done_src(&gw->walk, gw->walk_ptr, nbytes);
 	gw->walk_ptr = NULL;
 }
 
 static int gcm_in_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
 {
@@ -842,11 +835,11 @@ static int gcm_in_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
 
 	while (1) {
 		n = min(gw->walk_bytes, AES_BLOCK_SIZE - gw->buf_bytes);
 		memcpy(gw->buf + gw->buf_bytes, gw->walk_ptr, n);
 		gw->buf_bytes += n;
-		_gcm_sg_unmap_and_advance(gw, n);
+		_gcm_sg_unmap_and_advance(gw, n, false);
 		if (gw->buf_bytes >= minbytesneeded) {
 			gw->ptr = gw->buf;
 			gw->nbytes = gw->buf_bytes;
 			goto out;
 		}
@@ -902,11 +895,11 @@ static int gcm_in_walk_done(struct gcm_sg_walk *gw, unsigned int bytesdone)
 			memmove(gw->buf, gw->buf + bytesdone, n);
 			gw->buf_bytes = n;
 		} else
 			gw->buf_bytes = 0;
 	} else
-		_gcm_sg_unmap_and_advance(gw, bytesdone);
+		_gcm_sg_unmap_and_advance(gw, bytesdone, false);
 
 	return bytesdone;
 }
 
 static int gcm_out_walk_done(struct gcm_sg_walk *gw, unsigned int bytesdone)
@@ -920,14 +913,14 @@ static int gcm_out_walk_done(struct gcm_sg_walk *gw, unsigned int bytesdone)
 		for (i = 0; i < bytesdone; i += n) {
 			if (!_gcm_sg_clamp_and_map(gw))
 				return i;
 			n = min(gw->walk_bytes, bytesdone - i);
 			memcpy(gw->walk_ptr, gw->buf + i, n);
-			_gcm_sg_unmap_and_advance(gw, n);
+			_gcm_sg_unmap_and_advance(gw, n, true);
 		}
 	} else
-		_gcm_sg_unmap_and_advance(gw, bytesdone);
+		_gcm_sg_unmap_and_advance(gw, bytesdone, true);
 
 	return bytesdone;
 }
 
 static int gcm_aes_crypt(struct aead_request *req, unsigned int flags)
-- 
2.47.1

