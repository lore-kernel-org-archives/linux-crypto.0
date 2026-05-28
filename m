Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E2F3AEF46
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959388; cv=none; b=jl+OWNthn+b4610s32bevJRlrpSkvUfROWRUWV4uweelyWu9QS0bt1hnYhFsSQaUKP6X0oi3nAnxeSzgdKOOGB7g5Jp85tEZrpmvubIpZ129LPUQjvmbvIeCjS2uTmeVn6RD1HF1UmHA5d16URCcgKI37tg2dSh7Muj2flgQ9U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959388; c=relaxed/simple;
	bh=BTSBwgLt5hMWdGb57lM5d4Vc1JnP+up3s67JkokV3F4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=r0HGO8/W4CA9YNy6L79sXspbUz80OEv+UVAe5lUiDOglL8+P4hqIz9PQXOA2qVvrnXPfbY1gugPzS5fzhmMUkJQFAf+ccMle48HV9jqHSMM9AuLt1eDTPeZGAhAmpFZYVg9R4GbI7GPD7z6wJ1JV9Gp4V4DRXt83zB88iBrligQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=fh+HrzOy; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="fh+HrzOy"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id B03674E42D77
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:44 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 85E5560495;
	Thu, 28 May 2026 09:09:44 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AF69010888CB8;
	Thu, 28 May 2026 11:09:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959383; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=9Vbekx4ZRxkiaYwmI5aO6ELGv1+EJRijyqHbfJpFx3U=;
	b=fh+HrzOyon5YlxK+EKFBKzKtAbGEFOqCd4N4kXvBUuz4amWnu11XkisaqyvcI8CLxDGpan
	gPJE75lHBbvab2p0tra4j04D6oq7djAvuFOtF639w6GVWFeX7oLIGM0L/jv1pDHLLTZfD2
	sqLeCOC69fywScQ0QtKqwvhTyp3KgSfRUcgMFZxNpiA9GaTFRKptxVAyjyADN84ELoMT9y
	CbNkYyaN9JAeknpLp/wJioszl9GeRVtqKwYOdRJsxumApXzizd/S5SQphPYE/wsn2TPZOE
	WLIXOBE2gLDmSXI07c0NmA7tSjgFHl8vMGZ/tCCMQXRElLWrjobmyAEsZqrJAA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:32 +0200
Subject: [PATCH 19/29] crypto: talitos - Introduce struct talitos_ops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-19-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=2103;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=BTSBwgLt5hMWdGb57lM5d4Vc1JnP+up3s67JkokV3F4=;
 b=O9qNjN9+omr/lmCsYQ7U8UTfXePPWWSYAeSsm7unGn5iE6G/a7c3Z/7MBZgVi2n+zT03t+t8s
 KKRZaB+Hgm9D/1pIb8bJTwLP6MNld2DfvzURWaVianvYUlIad1WCko+
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Add struct talitos_ops containing function pointers for IRQ probing,
tasklet initialization, device and channel reset, device configuration,
descriptor DMA mapping, request header retrieval and error handling.

Add an ops pointer to struct talitos_private. The ops pointer will be
initialized at probe time based on the detected hardware and used to
dispatch SEC1/SEC2-specific behaviour.


Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index 904fdc9dec80..46de1bf1ef27 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -14,6 +14,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/hw_random.h>
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
 #include <linux/scatterlist.h>
 #include <linux/types.h>
 
@@ -139,6 +140,25 @@ struct talitos_channel {
 	int tail;
 };
 
+struct talitos_ops {
+	int (*probe_irq)(struct platform_device *ofdev);
+	void (*init_task)(struct device *dev);
+	int (*reset_device)(struct device *dev);
+	int (*reset_channel)(struct device *dev, int ch);
+	void (*configure_device)(struct device *dev);
+
+	void (*dma_map_request)(struct device *dev,
+			       struct talitos_request *request,
+			       struct talitos_desc *desc);
+	void (*dma_unmap_request)(struct device *dev,
+				  struct talitos_request *request);
+	__be32 (*get_request_hdr)(struct device *dev,
+				  struct talitos_request *request);
+	__be32 (*search_desc_hdr_in_request)(struct talitos_request *request,
+					     dma_addr_t cpdr);
+	int (*handle_error)(struct device *dev, u32 isr, u32 isr_lo);
+};
+
 struct talitos_private {
 	struct device *dev;
 	struct platform_device *ofdev;
@@ -162,6 +182,8 @@ struct talitos_private {
 	unsigned int exec_units;
 	unsigned int desc_types;
 
+	const struct talitos_ops *ops;
+
 	/* SEC Compatibility info */
 	unsigned long features;
 

-- 
2.54.0

