Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929291A0B15;
	Mon, 30 Dec 2024 00:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517766; cv=none; b=dccLli6OUecuJ2L8AgjrFr2O1df9+0p5mRvtamYIFgu/5AJCAEm4wsaEqT+LGinEZXYZ1P+6xnrw/do5MIj5g9qIaM6iSafLWyAfbmMDWx9pVknsMQlT5pAXXeXUlmsFJl4UWmvndA89YncCzPS8QbhW4FEVC3OCl7cv+bNLaZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517766; c=relaxed/simple;
	bh=H979TZHDgKLaUbglwnxL0UQbpoLtqMQtPXY6pBrdkHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1XM3f5rYBTkfR5oKW98i9T6hWb3wWKTIPJFsn1sYJDdpTOsrrX+q6XOVFur8lWLlhuHxSC/CamzgkY3iipL+/mKdqFjAg5Yobbr/Opc5bPmqViUMsLBv8unpZEJ3pJqqMy0uJu+ymgqpShsdF+n5lhLswVqLd1rhbkfnIdbOFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OVv7ieP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OVv7ieP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CCCC4CEDC;
	Mon, 30 Dec 2024 00:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517766;
	bh=H979TZHDgKLaUbglwnxL0UQbpoLtqMQtPXY6pBrdkHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVv7ieP8SjYk/HjaXd0tHHAvWhYyEeizW7IRUKiiA8xqB5Yq63CHK6thVfRetcYdY
	 XrzADxDGMfIio8KG4x38IIh558UFNmRQ95drvi+0u275GXhE/ZJT3YiTenqo2BB9JC
	 LLGpYM7FxTJ/b8vgYPOfCIIKMZZ9IGbVCuWwV9AXSaIEJvlrfQdUEXToZD2+TQ5zA0
	 uU8xcsI/+F8GRsBGYCAjCT5PpF456KOLQn7/0vH8LjIm08dA0oEbZpEzrYSmIcshQ0
	 d3ObtqAq5VVH6+bHquDAr3RJevWu8J+5hWPWQF6dqDblo5zHstQJQrO0TMQZUtiS7v
	 wlKCqJxFSDOQA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-s390@vger.kernel.org
Subject: [PATCH v2 21/29] crypto: s390/aes-gcm - use the new scatterwalk functions
Date: Sun, 29 Dec 2024 16:14:10 -0800
Message-ID: <20241230001418.74739-22-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230001418.74739-1-ebiggers@kernel.org>
References: <20241230001418.74739-1-ebiggers@kernel.org>
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

