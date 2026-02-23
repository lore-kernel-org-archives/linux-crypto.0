Received: from mail-m10214.netease.com (mail-m10214.netease.com [154.81.10.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E07223DE7;
	Tue, 24 Feb 2026 00:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=154.81.10.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771894520; cv=none; b=lSCQecTmajtUKC8ePqvfQUCacBHgECY9MVSi252sU8wzifC9SEgMqziDEE2gbyZ6ceX3Imouhj2I3HiMwozhXyPsjDvy2q4R8ilv97pFh+aIciZzHdW02bYnStKf4IbYBSevy38JWAtFdurDiJshIQpjhzGYzH6ID+aB2MW3G14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771894520; c=relaxed/simple;
	bh=8WzlflZ34qKm3b5d02I3sYaBSLAexfVSpezxBgpifBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=c0me3mUuzlErpDXy0OjNiQ1ARrRpDPcM8ljMnHq7TW5ldvrMk4TGSRu4qVidElfH9do17Nzo2F7qYgdDEMD3aTYAqZptIFwl0FhX7SvtNXnMvNE2EReo9BYnaKcpQ8v/poxBVT/2YOkjgp0hmz0WlPS1JcI/7qvjYgrMQE0iPmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=SvPqBqoI; arc=none smtp.client-ip=154.81.10.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="SvPqBqoI"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 34b40457d;
	Mon, 23 Feb 2026 23:51:57 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Philipp Stanner <phasta@kernel.org>,
	linux-pci@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH 17/37] crypto: safexcel: Replace pci_alloc_irq_vectors() with pcim_alloc_irq_vectors()
Date: Mon, 23 Feb 2026 23:51:50 +0800
Message-Id: <1771861910-88163-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1771860581-82092-1-git-send-email-shawn.lin@rock-chips.com>
References: <1771860581-82092-1-git-send-email-shawn.lin@rock-chips.com>
X-HM-Tid: 0a9c8b333de609cckunma0e2a033987a79
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGhhLHVZPQxpPQx8fSE1OTkJWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=SvPqBqoIKCJ5Fh92JioddDZ6IPavGqxBmDIFVU+H4SVb8h3jIygbncHCUNN+jHNY2HuDiOVrgLqCiHbJHtd2tZqc0gwWpbfOghrHWEvHje838d753QD/mEj/+M3CZm/0xWNo7Ufzs348lD8nQbTUgtykafQR8PQRoqqFh9Q3iv0=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=Jv8sx4V8Kx94pQbsGOseu8/K3SdNRp4HhMI/8Hu2kN8=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

pcim_enable_device() no longer automatically manages IRQ vectors via devres.
Drivers must now manually call pci_free_irq_vectors() for cleanup. Alternatively,
pcim_alloc_irq_vectors() should be used.

To: Antoine Tenart <atenart@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net
Cc: linux-crypto@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Philipp Stanner <phasta@kernel.org>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/crypto/inside-secure/safexcel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index c3b2b22..4e4991e 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1596,10 +1596,10 @@ static int safexcel_probe_generic(void *pdev,
 		 */
 		struct pci_dev *pci_pdev = pdev;
 
-		ret = pci_alloc_irq_vectors(pci_pdev,
-					    priv->config.rings + 1,
-					    priv->config.rings + 1,
-					    PCI_IRQ_MSI | PCI_IRQ_MSIX);
+		ret = pcim_alloc_irq_vectors(pci_pdev,
+					     priv->config.rings + 1,
+					     priv->config.rings + 1,
+					     PCI_IRQ_MSI | PCI_IRQ_MSIX);
 		if (ret < 0) {
 			dev_err(dev, "Failed to allocate PCI MSI interrupts\n");
 			return ret;
-- 
2.7.4

