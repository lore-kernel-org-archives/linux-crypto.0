Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC50179972
	for <linux-crypto@vger.kernel.org>; Thu,  2 May 2024 21:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714683646; cv=none; b=UPzXbTxOTY3V9veepJTi595TuboHnBL9r1JAp9ZkcQczVtCfeNIL8XMPmx7cYEMgftsty7pAAAcsdBBqDhhc516K7eDHMNPF1nT6dc8sUvLXEFvkYw4cgy3ilk48IRp+d9N1WpAQAZZWPlgOJr4K17Rg7OTtXe6A8v858KfLbBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714683646; c=relaxed/simple;
	bh=OB0axKIV+52dkYXP9Tf4JLw3GKj3ZQlRiztet/h+5Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyVw9S30tsz+b5J0e8bSdr+K6e09fUZn7owUcnxboUIdZvDwN3xdj9REvhuys7ryr9zfDcwY8C+wlH7l7M8wVw2MZVDMIFXsvD5BXxlOA4mDiGK/V+y2UAF4PTFU2UdYvRFs7NtEkCOGXYHWxMykb8mZtzU9NAJILbDXixd8Wwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=AHoBLdRg; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="AHoBLdRg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=from:to:cc:subject:date:message-id
	:in-reply-to:references:mime-version:content-transfer-encoding;
	 s=k1; bh=vAMWiez7uDZZTZNLu3icHY1jKUo9NfGEJcQneAUfCvc=; b=AHoBLd
	Rgmg7yijf1cZpxtTmp/J4Wi+06H9prcdpvbDsJbxa6Y6YsnvcObNg5URdS7UsXIJ
	ThYDPtH/918GbzabGRiBSb3gTqXuT/mWnq1VWF9JCu1Yu8vKppXJcGOGRkCuEysb
	Eod0AL0E368hkgHU7eyvI/f+iwdAWJTTNgIfq4Hq/6VXBgUyIR1u7U+eEwBam5oV
	05gaoqhFpSSGj6LXVtNSBqZLVdftbrqAi7OqFziOdpiTQLiscOrmknwAZMh7C+Ep
	iTB+kYXPpi4K9YO4Pt3qdtigblQWsfAuHtjsgCCPWpBuXttEYaBoBAG7k0/OMNl1
	KlNZvTumqSnxxwug==
Received: (qmail 3365832 invoked from network); 2 May 2024 23:00:40 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 2 May 2024 23:00:40 +0200
X-UD-Smtp-Session: l3s3148p1@JpJK5X4XZopehhrT
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-crypto@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Moritz Fischer <mdf@kernel.org>,
	Wu Hao <hao.wu@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Tom Rix <trix@redhat.com>,
	linux-fpga@vger.kernel.org
Subject: [PATCH 1/2] fpga: socfpga: use 'time_left' variable with wait_for_completion_interruptible_timeout()
Date: Thu,  2 May 2024 23:00:36 +0200
Message-ID: <20240502210038.11480-2-wsa+renesas@sang-engineering.com>
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
store the result of wait_for_completion_interruptible_timeout() causing patterns like:

	timeout = wait_for_completion_interruptible_timeout(...)
	if (!timeout) return -ETIMEDOUT;

with all kinds of permutations. Use 'time_left' as a variable to make the code
self explaining.

Fix to the proper variable type 'long' while here.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/fpga/socfpga.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/fpga/socfpga.c b/drivers/fpga/socfpga.c
index 723ea0ad3f09..b08b4bb8f650 100644
--- a/drivers/fpga/socfpga.c
+++ b/drivers/fpga/socfpga.c
@@ -301,16 +301,17 @@ static irqreturn_t socfpga_fpga_isr(int irq, void *dev_id)
 
 static int socfpga_fpga_wait_for_config_done(struct socfpga_fpga_priv *priv)
 {
-	int timeout, ret = 0;
+	int ret = 0;
+	long time_left;
 
 	socfpga_fpga_disable_irqs(priv);
 	init_completion(&priv->status_complete);
 	socfpga_fpga_enable_irqs(priv, SOCFPGA_FPGMGR_MON_CONF_DONE);
 
-	timeout = wait_for_completion_interruptible_timeout(
+	time_left = wait_for_completion_interruptible_timeout(
 						&priv->status_complete,
 						msecs_to_jiffies(10));
-	if (timeout == 0)
+	if (time_left == 0)
 		ret = -ETIMEDOUT;
 
 	socfpga_fpga_disable_irqs(priv);
-- 
2.43.0

