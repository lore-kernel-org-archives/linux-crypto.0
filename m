Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9EB1A3178;
	Sat, 15 Feb 2025 23:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739662628; cv=none; b=fh0OMr7sQVP9EiIoQNYB7v8PHleyLE4Rry85/YqCVTvUuefaW+5aZtOkWLw7Ekf1Y+CuivKVgbZITHASvN5GijGffD9VCFUdLd8NgblJcrFljte1reyyJCILeQPN3eX4Jsx4FwcG5X1k874MrtLcS9C1jFqeUsWBuIfxdkpfXhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739662628; c=relaxed/simple;
	bh=hgFI0iMzCgRJd9XfbMQxCzSdhAP3/ciUkg1x01gr5/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t3CD8ocU0HcbT2JER6ZgW9szTsFqKOFh9SlcmCXJqJGBxSv3SC3s6cuifJ7jnJmeQagy2X/zaPJYUi6MygWhPTK90A2yK0TKk89RYAeNxPjL9CxnFsoh2sd+tt5sToQBLD0Cna5jy/FA6wL6xiveimStYhlGJeKeVhLMLjrUPFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b5GgjY5+; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b5GgjY5+"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4396740abe9so11831345e9.1;
        Sat, 15 Feb 2025 15:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739662624; x=1740267424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vLveuntNUHWnqmHByGPtzBXVxOK5dyWigDdHtXrYawU=;
        b=b5GgjY5+0f2AF3wfbatCVExBv9pSEp4F8DPCK8sWa41s4aOJYgxrtaNvFT8rCgHG3m
         SSqoRJo3o+PDTNtsMSU44RUPDhaeqEUhbe8fLOBWULm3PtdyqUdbNBFJr5Cfzy5TQhYN
         +a9IJABzXbUPh+7hG+CAihw4QKeIXu348iqDYeHPNu+0zNGeuZb0LFUhzvgDXc/NAHeM
         rxATSK6XjozfAKMQ5QQHGHypbZz5pMR/J6Ly9Ve1VFFOuMqlmk90e+iAvasQ5WMuLwxa
         qwWVCPJO3RmQ3ZAOLwS65qW4caKm9Z9h3pLyQxEfriDbiBW5kAJXvwBD5V+zngc72E57
         0Wsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739662624; x=1740267424;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vLveuntNUHWnqmHByGPtzBXVxOK5dyWigDdHtXrYawU=;
        b=YVVwN/xRMmxWz54O52xHR/LY+vR2x4pimJvfQKuamf94o+38ZlFZOaZHK92BIORyKj
         0wfZ885JSON2BwM+bV9W6E0UmAKDOzrtxpQNJtQWnu8X2zz5Z1LyQyMXQebjz68rIzIz
         DKmJ4YFQbP0w3Hf9otD/Rey3Ffd06uwO9uwOh/CoRWdZgXvXnIQg9GGWNlkUwH24IGxY
         /Sr1HokLm/FwE0+co1LpcBczgPLCCw2f2U1u1U0KADGfmQVKHCLeivAd1N4lrqo1F5MO
         jRkns8KWaRXLMV9cEAM2YXF6a5HQRjSARQ3hO9xo4vszcOEXYuSLwmDJTr9U7yqxTE3H
         nwuA==
X-Forwarded-Encrypted: i=1; AJvYcCVQCkkds2PsEiqrHGJdwFOyRQfBaRVifRITFXtTD9MWdkH5EkFlGP4PzCabMQd1bIloaIGUQCp4NtSKhyo=@vger.kernel.org, AJvYcCVZ1+xZ9J8ec+CsC9F8CrUv7I80d0yjviw+zq4+309GNCdlk8a4q//XXVoGpeJjWZ0ccnFwPFu1seqhJNSu@vger.kernel.org
X-Gm-Message-State: AOJu0YzTFI0MRGNP1a9hPr4FgA7Gz6+a4ecUhaMS5Aj8vRyn7UB99Apd
	6EOzPwkluWnvbiE77ZDlG9rt9uSjsip4kaFiBZOtPcGR8CjvFW5M
X-Gm-Gg: ASbGncuDsHT2BKQHBeLTd0rwQWVLVVtQeHjLhZO8qOKFglSxCis6JOISv5oEo/HRaDR
	OUSVSqcZxJARLLzBdann4DqeEWja7VwhD68VqjV6s254C+8rHo1Pe0CFpIUq5LCp3k4RbsW/Xgq
	2MCQ0nBQ69RpftgPko4H5UW+6MQoqR3bNGxTkB9kbkZ40smKWNlMdS3rtVyOd/mvDxHhRNFpxVd
	ABIBEmtr+fiZY2uENY8VW1eYsb0WZym434tViYWKKL6xpjRcvtXF03m0M0/F25GbSqlBewfcQ2K
	560/aOvsBm5jcXHX6njQmgRo2v8qkAzlSGVUP7t6IwqI/7JcvW95RJ4ctWgkqsfUSv3xBZz0AQ=
	=
X-Google-Smtp-Source: AGHT+IEsSvOhbgno0PT3Z+96j059EF9Pfl35ijQjSXFi96nd9wc75WUONB34vs9mwWZ/ObEyIacYaQ==
X-Received: by 2002:a05:600c:3b25:b0:439:4b8c:1459 with SMTP id 5b1f17b1804b1-4396e6d4d3cmr46296565e9.4.1739662624106;
        Sat, 15 Feb 2025 15:37:04 -0800 (PST)
Received: from localhost.localdomain (host-87-6-198-177.retail.telecomitalia.it. [87.6.198.177])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4395a1aa779sm111973865e9.30.2025.02.15.15.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2025 15:37:03 -0800 (PST)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] crypto: inside-secure: eip93: Correctly handle return of for sg_nents_for_len
Date: Sun, 16 Feb 2025 00:36:18 +0100
Message-ID: <20250215233621.6277-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix smatch warning for sg_nents_for_len return value in Inside Secure
EIP93 driver.

The return value of sg_nents_for_len was assigned to an u32 and the
error was ignored and converted to a positive integer.

Rework the code to correctly handle the error from sg_nents_for_len to
mute smatch warning.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../crypto/inside-secure/eip93/eip93-common.c | 25 ++++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
index 446a047c242d..66153aa2493f 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
@@ -202,7 +202,6 @@ int check_valid_request(struct eip93_cipher_reqctx *rctx)
 {
 	struct scatterlist *src = rctx->sg_src;
 	struct scatterlist *dst = rctx->sg_dst;
-	u32 src_nents, dst_nents;
 	u32 textsize = rctx->textsize;
 	u32 authsize = rctx->authsize;
 	u32 blksize = rctx->blksize;
@@ -210,6 +209,7 @@ int check_valid_request(struct eip93_cipher_reqctx *rctx)
 	u32 totlen_dst = rctx->assoclen + rctx->textsize;
 	u32 copy_len;
 	bool src_align, dst_align;
+	int src_nents, dst_nents;
 	int err = -EINVAL;
 
 	if (!IS_CTR(rctx->flags)) {
@@ -225,19 +225,24 @@ int check_valid_request(struct eip93_cipher_reqctx *rctx)
 	}
 
 	src_nents = sg_nents_for_len(src, totlen_src);
+	if (src_nents < 0)
+		return src_nents;
+
 	dst_nents = sg_nents_for_len(dst, totlen_dst);
+	if (dst_nents < 0)
+		return dst_nents;
 
 	if (src == dst) {
 		src_nents = max(src_nents, dst_nents);
 		dst_nents = src_nents;
-		if (unlikely((totlen_src || totlen_dst) && src_nents <= 0))
+		if (unlikely((totlen_src || totlen_dst) && !src_nents))
 			return err;
 
 	} else {
-		if (unlikely(totlen_src && src_nents <= 0))
+		if (unlikely(totlen_src && !src_nents))
 			return err;
 
-		if (unlikely(totlen_dst && dst_nents <= 0))
+		if (unlikely(totlen_dst && !dst_nents))
 			return err;
 	}
 
@@ -273,8 +278,16 @@ int check_valid_request(struct eip93_cipher_reqctx *rctx)
 			return err;
 	}
 
-	rctx->src_nents = sg_nents_for_len(rctx->sg_src, totlen_src);
-	rctx->dst_nents = sg_nents_for_len(rctx->sg_dst, totlen_dst);
+	src_nents = sg_nents_for_len(rctx->sg_src, totlen_src);
+	if (src_nents < 0)
+		return src_nents;
+
+	dst_nents = sg_nents_for_len(rctx->sg_dst, totlen_dst);
+	if (dst_nents < 0)
+		return dst_nents;
+
+	rctx->src_nents = src_nents;
+	rctx->dst_nents = dst_nents;
 
 	return 0;
 }
-- 
2.47.1

