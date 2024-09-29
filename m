Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C3DAD24;
	Sun, 29 Sep 2024 13:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727616121; cv=none; b=TR+7OmiNZlsLKh4HUceKREqG6CPIjpzNPA+eRww0CvlyWHJy6QyKALa0Rzv3gZw2Bla/ttiNOBXgBs2dlurBocWr0bh1VTC9qYogQRaxdk83PX7tQi4M131Cebhsi9HkxlBDri7qSMidxQsQGf3/h4BIiG5fbsKZ3CJW7rEw2DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727616121; c=relaxed/simple;
	bh=WYnuVxqd5hSPhIFrTOAnB7iby9Oq77UsN/+a6q5jE3A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XggQ3nq2orJlkVVLMwBJr4hyN3bDEeUZHxSpWH6KF5IWQQNofs/shRL0UHT1sEPW+wk6Iv2VjX76hzuAFWlsM4VHQgd6wxrtTxN3j2vo4HSvCF7IOiLWW75GgHkXRPaU5qOkr3+bEpTDGHD/5x4W8k6WmyRS+suHcbk6GtXISKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=loCtGb3W; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="loCtGb3W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=OhfsAlvF10vePpQdEHFo+AXyae0n1XmhLg+/AjvLFKk=; b=loCtGb3Wzw7vom0Z
	KXvELTEOIj6u/SNswcddnB7loY2XoVHahkJ7meUTBvkj8ZpmrebVTre7yHGHXQ0tO//47IOx0y0g0
	vlnW2dIh3Qcr8WUwZEAcBk8faOClKgdnLMx8kB6cKTG3CHWYE+fBZyPJ7aIE4uzEcCDiWuJh47v4H
	WluKqe6dQ/i066Hxn3uNFNXggBaJZPz1269uAVNN6nDfyAmUoQD3R/tWzgOCpOq8hRPc6qmjsStZx
	nOIJeUcHLyTImD9iQpHvB1m0pslgPaPQ72HAaT3Xk2nqP96/5wzuErPswyfF0LXkDakAoHyr5LtCX
	LneBH9NcI6nr3DPQcQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1suts0-007opV-34;
	Sun, 29 Sep 2024 13:21:52 +0000
From: linux@treblig.org
To: dan.j.williams@intel.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] async_xor: Remove unused 'async_xor_val'
Date: Sun, 29 Sep 2024 14:21:48 +0100
Message-ID: <20240929132148.44792-1-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

async_xor_val has been unused since commit
a7c224a820c3 ("md/raid5: convert to new xor compution interface")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 crypto/async_tx/async_xor.c | 26 --------------------------
 include/linux/async_tx.h    |  5 -----
 2 files changed, 31 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 1a3855284091..2c499654a36c 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -389,32 +389,6 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 }
 EXPORT_SYMBOL_GPL(async_xor_val_offs);
 
-/**
- * async_xor_val - attempt a xor parity check with a dma engine.
- * @dest: destination page used if the xor is performed synchronously
- * @src_list: array of source pages
- * @offset: offset in pages to start transaction
- * @src_cnt: number of source pages
- * @len: length in bytes
- * @result: 0 if sum == 0 else non-zero
- * @submit: submission / completion modifiers
- *
- * honored flags: ASYNC_TX_ACK
- *
- * src_list note: if the dest is also a source it must be at index zero.
- * The contents of this array will be overwritten if a scribble region
- * is not specified.
- */
-struct dma_async_tx_descriptor *
-async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
-	      int src_cnt, size_t len, enum sum_check_flags *result,
-	      struct async_submit_ctl *submit)
-{
-	return async_xor_val_offs(dest, offset, src_list, NULL, src_cnt,
-			len, result, submit);
-}
-EXPORT_SYMBOL_GPL(async_xor_val);
-
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("asynchronous xor/xor-zero-sum api");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 5cc73d7e5b52..1ca9f9e05f4f 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -167,11 +167,6 @@ async_xor_offs(struct page *dest, unsigned int offset,
 		struct page **src_list, unsigned int *src_offset,
 		int src_cnt, size_t len, struct async_submit_ctl *submit);
 
-struct dma_async_tx_descriptor *
-async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
-	      int src_cnt, size_t len, enum sum_check_flags *result,
-	      struct async_submit_ctl *submit);
-
 struct dma_async_tx_descriptor *
 async_xor_val_offs(struct page *dest, unsigned int offset,
 		struct page **src_list, unsigned int *src_offset,
-- 
2.46.2

