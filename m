Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E69E180A7B
	for <linux-crypto@vger.kernel.org>; Thu,  2 May 2024 21:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714683647; cv=none; b=WLJ+IcMRy/pUC0rjSsyANhKULaFwA9zLKn4rHRfeZ7ZleTXLyuwPrxl+NS4AChq1d39hl8Nmy5fOA8iwD3msnpNN8eMUV/cpsutyk3/3ObSFo6nLoP4Acme3C0B4mlHAuTN6Nh2gyPX9Y3ikXynpkZ2qkyD4JIukCznouKpw8Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714683647; c=relaxed/simple;
	bh=+d6b3FksZbPOKBQGGcwOVwEGil3QNF+ROjxdUMA1suE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuwwB4mQyB5xRcjk8g/yvrZud2kTZLE0gQDlkLntjIlmI38ZlH4ZBbgfSyTT0g38+wnA2K98ebwBPCBVpGI7ATlQEUYC2hfttC1F11kbXh/v+KMDzB6m7Ha8Td/72AQVe3Z4bhOqV5XFAg8oy16VrKehzGZT7RoSUPupLVJ8jjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=K9Fsn+cK; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="K9Fsn+cK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=from:to:cc:subject:date:message-id
	:in-reply-to:references:mime-version:content-transfer-encoding;
	 s=k1; bh=tOPs0nDGGn0HUpYZAQR6tc6UVzlGp/hbe2nkl7eQS7M=; b=K9Fsn+
	cK4+E9DvepSe92HRLSBXVO693S/2nkQF/M3RxGKSLvpMsfMkpG03UtLMpW4lSHhc
	FvR82+rUw9G74jX0WO3I+9+XAWLOW0olqM0LljTsMIGH0nj1wb4sez8xdhrHt5g6
	OcLt/KJWRMVMbbOj35Hz0CXZr4vysQWbDH6Q9/ynXjmUcZTzqNEzC2qRmOP8ERbt
	S7uJYtjc3Zg0R809MYA7U5FMGH08xd61R1LGGQsUpCjzLMPXYWoRpq+iKfPiE4Ve
	5gzmgwxRUU8uyVn6ADCbnBUlX86bVvapr3IImHofXKwZuLKc5lSQW0j45Vc4Xnyu
	cyRAl0HUJB5cDw+Q==
Received: (qmail 3365871 invoked from network); 2 May 2024 23:00:41 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 2 May 2024 23:00:41 +0200
X-UD-Smtp-Session: l3s3148p1@He1V5X4XdIpehhrT
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-crypto@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Moritz Fischer <mdf@kernel.org>,
	Wu Hao <hao.wu@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Tom Rix <trix@redhat.com>,
	Michal Simek <michal.simek@amd.com>,
	linux-fpga@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] fpga: zynq-fpga: use 'time_left' variable with wait_for_completion_timeout()
Date: Thu,  2 May 2024 23:00:37 +0200
Message-ID: <20240502210038.11480-3-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240502210038.11480-1-wsa+renesas@sang-engineering.com>
References: <20240502210038.11480-1-wsa+renesas@sang-engineering.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a confusing pattern in the kernel to use a variable named 'timeout' to
store the result of wait_for_completion_timeout() causing patterns like:

	timeout = wait_for_completion_timeout(...)
	if (!timeout) return -ETIMEDOUT;

with all kinds of permutations. Use 'time_left' as a variable to make the code
self explaining.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/fpga/zynq-fpga.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/fpga/zynq-fpga.c b/drivers/fpga/zynq-fpga.c
index 0ac93183d201..4db3d80e10b0 100644
--- a/drivers/fpga/zynq-fpga.c
+++ b/drivers/fpga/zynq-fpga.c
@@ -387,7 +387,7 @@ static int zynq_fpga_ops_write(struct fpga_manager *mgr, struct sg_table *sgt)
 	const char *why;
 	int err;
 	u32 intr_status;
-	unsigned long timeout;
+	unsigned long time_left;
 	unsigned long flags;
 	struct scatterlist *sg;
 	int i;
@@ -427,8 +427,8 @@ static int zynq_fpga_ops_write(struct fpga_manager *mgr, struct sg_table *sgt)
 	zynq_step_dma(priv);
 	spin_unlock_irqrestore(&priv->dma_lock, flags);
 
-	timeout = wait_for_completion_timeout(&priv->dma_done,
-					      msecs_to_jiffies(DMA_TIMEOUT_MS));
+	time_left = wait_for_completion_timeout(&priv->dma_done,
+						msecs_to_jiffies(DMA_TIMEOUT_MS));
 
 	spin_lock_irqsave(&priv->dma_lock, flags);
 	zynq_fpga_set_irq(priv, 0);
@@ -452,7 +452,7 @@ static int zynq_fpga_ops_write(struct fpga_manager *mgr, struct sg_table *sgt)
 
 	if (priv->cur_sg ||
 	    !((intr_status & IXR_D_P_DONE_MASK) == IXR_D_P_DONE_MASK)) {
-		if (timeout == 0)
+		if (time_left == 0)
 			why = "DMA timed out";
 		else
 			why = "DMA did not complete";
-- 
2.43.0

