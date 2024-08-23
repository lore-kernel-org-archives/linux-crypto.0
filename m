Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050E1190482;
	Fri, 23 Aug 2024 18:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724438365; cv=none; b=XjslTvwvzUUuBCWs52EcGWmjF/z8H84Z9fKy0ZajbV/N+Tr9tGgvxz0hKoqBG5OlFI+dHfdsxO9OeIkQkC8tiVfT4aPttgS9JDcoVze6KtGtxYnnAWpcHI4qw4PoE1mOZFKjkI/Ag2RFBaCuR9/ps3i9g9M3HedYeCwTVmjrHS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724438365; c=relaxed/simple;
	bh=vS0rVEDSQYULdN8EnBPSspx7F1bgHxO4L9Yx3ey7uyw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oulPGcfw3cMoyn4EdhSMBXl0RJGZLtDKrtKvXFwlS/CfuUCPab1zHRSV2RjtB+zMzi/ZvdNYTQ99s0xZSFmqXLcEFdTj+9ZJO8ZSo9zICCLkcfLRJk3iq7lI1HdUr6j8BDWHpU2zSRKMP6uCvmb4qPtBNt77OH3jfAVOTJqC+WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RzyRdbRz; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RzyRdbRz"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-270298a3b6eso1605026fac.3;
        Fri, 23 Aug 2024 11:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724438363; x=1725043163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XNYyXTiUUKGs1jDISX3liwadU3ssMVGkOQ//kMNiZNE=;
        b=RzyRdbRzasM+UDOFIj9+b1enP4/6vz4bgueFj8imNdpNHiV8rKQqysYDLBkb8Nzoai
         QSwVa+dai3cuAmSa89tIHjD+pNw+xxo7Sr3/jc6vQZcmimZ+p2ZlhZJikH1UHWl4wZBh
         VOC0TXxOgyL2H5C8ICai7hQ5E27hWijaZj5nXNwBvHjIEIWN1Zw2uCaPVo4IqNQt2yY8
         F17aG+1OHKVByHCB9JK9fK5G1sd/TTwVRGAtC45OdetwLSmep1735wVjVeq9BGOX1Tr9
         h8MJCeFFa0euFbwWSyB0V1E5Car47IwmYsGuEzOy8WQhf4GGULztQ69xyv6WLiwkadAo
         cXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724438363; x=1725043163;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XNYyXTiUUKGs1jDISX3liwadU3ssMVGkOQ//kMNiZNE=;
        b=bb/4LJ/MxcVcNnyzKxMSiZvHU8x2SybskksdFTnHlxcFG5Mp3hcU32cDUd6G7sFNKd
         4GBifxzCH7kwVQ8MFR+c4/08u9rJfDW16O5bBQRD8kcpZA4iSAi6U3yhplxnZQO73zfb
         HSmOUNkyBumnwAAdIJ/a7xyMT9yzY+vmTamsR/qW2tgcsPuSarwGZ3eFxNOvhrxaONBP
         hNLbSdcqPdGyZFMSlb1mjfCKRjqfeV8b6pJAZO0cn149kIr5x0qKSrUKuD1lLbRsQhBa
         ljtOP8irkrQpZtx2zbhnGUcJ8fE42nYmGzid6iYrtRzkgOE1k3AAivoRuH3TPj3Ly1+T
         hg3g==
X-Forwarded-Encrypted: i=1; AJvYcCVHwyh7ROjzPkpJxE65bzkeYzT+zvLCt0Fzwesib6DtYMpOol7HlqHJeIOBztMmUWdN67azTx2qGHmqTr6T@vger.kernel.org, AJvYcCVWE6PuLj0gZ+yUTtea2vmzTsQpRhT8wGxJokLD/zT1RYXchdxFL7/zRQNOTNgvbsHdX4y9iZgv5DknaD0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt2i0rs6n1lhC5m1swEgE3Ey0Qj7EYXP9shNGJBTKOhUS+H6tp
	fMAZj+jSYIT2CTnAgZ8t/xrRBKhKWTmNG1C6lqDsunxRPQg/Z+WQ
X-Google-Smtp-Source: AGHT+IHbkE3ZdZNEe89UyGALRUQdE2iHgZVFlqykGhqfkjXdOnaI2N/Cf8M87lZEgKanxYVaiw3f+w==
X-Received: by 2002:a05:6870:d113:b0:260:f50e:923c with SMTP id 586e51a60fabf-273e63e6ca2mr3485136fac.10.1724438363009;
        Fri, 23 Aug 2024 11:39:23 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7143425201csm3352157b3a.73.2024.08.23.11.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 11:39:22 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: shenyang39@huawei.com,
	wangzhou1@hisilicon.com
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	jserv@ccns.ncku.edu.tw,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH] crypto: hisilicon/zip - Optimize performance by replacing rw_lock with spinlock
Date: Sat, 24 Aug 2024 02:38:56 +0800
Message-Id: <20240823183856.561166-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The req_lock is currently implemented as a rw_lock, but there are no
instances where read_lock() is called. This means that the lock is
effectively only used by writers, making it functionally equivalent to
a simple spinlock.

As stated in Documentation/locking/spinlocks.rst:
"Reader-writer locks require more atomic memory operations than simple
spinlocks. Unless the reader critical section is long, you are better
off just using spinlocks."

Since the rw_lock in this case incurs additional atomic memory
operations without any benefit from reader-writer locking, it is more
efficient to replace it with a spinlock. This patch implements that
replacement to optimize the driver's performance.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
Note: Build test only.

 drivers/crypto/hisilicon/zip/zip_crypto.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 94e2d66b04b6..92d3bd0dfe1b 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -54,7 +54,7 @@ struct hisi_zip_req {
 struct hisi_zip_req_q {
 	struct hisi_zip_req *q;
 	unsigned long *req_bitmap;
-	rwlock_t req_lock;
+	spinlock_t req_lock;
 	u16 size;
 };
 
@@ -116,17 +116,17 @@ static struct hisi_zip_req *hisi_zip_create_req(struct hisi_zip_qp_ctx *qp_ctx,
 	struct hisi_zip_req *req_cache;
 	int req_id;
 
-	write_lock(&req_q->req_lock);
+	spin_lock(&req_q->req_lock);
 
 	req_id = find_first_zero_bit(req_q->req_bitmap, req_q->size);
 	if (req_id >= req_q->size) {
-		write_unlock(&req_q->req_lock);
+		spin_unlock(&req_q->req_lock);
 		dev_dbg(&qp_ctx->qp->qm->pdev->dev, "req cache is full!\n");
 		return ERR_PTR(-EAGAIN);
 	}
 	set_bit(req_id, req_q->req_bitmap);
 
-	write_unlock(&req_q->req_lock);
+	spin_unlock(&req_q->req_lock);
 
 	req_cache = q + req_id;
 	req_cache->req_id = req_id;
@@ -140,9 +140,9 @@ static void hisi_zip_remove_req(struct hisi_zip_qp_ctx *qp_ctx,
 {
 	struct hisi_zip_req_q *req_q = &qp_ctx->req_q;
 
-	write_lock(&req_q->req_lock);
+	spin_lock(&req_q->req_lock);
 	clear_bit(req->req_id, req_q->req_bitmap);
-	write_unlock(&req_q->req_lock);
+	spin_unlock(&req_q->req_lock);
 }
 
 static void hisi_zip_fill_addr(struct hisi_zip_sqe *sqe, struct hisi_zip_req *req)
@@ -456,7 +456,7 @@ static int hisi_zip_create_req_q(struct hisi_zip_ctx *ctx)
 
 			goto err_free_comp_q;
 		}
-		rwlock_init(&req_q->req_lock);
+		spin_lock_init(&req_q->req_lock);
 
 		req_q->q = kcalloc(req_q->size, sizeof(struct hisi_zip_req),
 				   GFP_KERNEL);
-- 
2.34.1

