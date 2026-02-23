Received: from mail-m12894.netease.com (mail-m12894.netease.com [103.209.128.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2453EBF10;
	Mon, 23 Feb 2026 22:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.209.128.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771886540; cv=none; b=cVm9dAeUWDQMxMdjoLBEsoe1vpbvtSQbu6ii5ucRDVL+Abh1EXzNTiPpPbpx0kCRbqzQrPQX/CSPbZJYCPl+X4nKBFIlMj5GbDChBj1oPKBms+Rc3yXfjqLgwpWA272k/4QlSJSLUvFBEpSAfKdUo4Emo/w67wNQ6PtnXrNyOBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771886540; c=relaxed/simple;
	bh=dmfaszMEYmcFbIGu5+t9u2mnRjwEyesJMnrckrtQ3Yk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=D9ouXFNOMov1HAAgLGH5nKau3p4h3fxKSYSdln5m1EJVXeC2ilnPzACCqJBLEYn0aEg/4XG3nvLbSuPNYKOqaspI/JSr3p3kUY5ZIE0Fzi/Dn+Wi+Hb+yKyDG25OZk6eBpwwOIMCGG1vhaVyjTTy5z5yzoZOxU87VyLjNTkALBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=fPCmWdO4; arc=none smtp.client-ip=103.209.128.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="fPCmWdO4"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 34b40458c;
	Mon, 23 Feb 2026 23:52:36 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Philipp Stanner <phasta@kernel.org>,
	linux-pci@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH 18/37] crypto: octeontx2: Replace pci_alloc_irq_vectors() with pcim_alloc_irq_vectors()
Date: Mon, 23 Feb 2026 23:52:31 +0800
Message-Id: <1771861951-88488-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1771860581-82092-1-git-send-email-shawn.lin@rock-chips.com>
References: <1771860581-82092-1-git-send-email-shawn.lin@rock-chips.com>
X-HM-Tid: 0a9c8b33d4e109cckunm9ea00323987b2a
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGk5PTVZJQ0pMQxoZHUkYSUhWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=fPCmWdO4i4Ye1WiSbjDtUQm/tOXm4WcOO7R6bjrpZjUVfLjIoIJE2sb0gZ5B11OPZPLuqYDLAuW2J+n4yj3iutiU/XpkAX//6u7zu9Q/uk6xeai+gWMhhjG4nCJB5wwkFqowpKZMWiIwMrysYF6hl0Dfkx7EMMz8ITCopVGPR08=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=0WR8SeGxieLjXEFRKbzi8dpAR6wzWdHho70pdmXl2m4=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

pcim_enable_device() no longer automatically manages IRQ vectors via devres.
Drivers must now manually call pci_free_irq_vectors() for cleanup. Alternatively,
pcim_alloc_irq_vectors() should be used.

To: Srujana Challa <schalla@marvell.com>
To: Bharat Bhushan <bbhushan2@marvell.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net
Cc: linux-crypto@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Philipp Stanner <phasta@kernel.org>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c | 2 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index f54f905..fbcc65c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -774,7 +774,7 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 		goto clear_drvdata;
 	}
 
-	err = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSIX);
+	err = pcim_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSIX);
 	if (err < 0) {
 		dev_err(dev, "Request for %d msix vectors failed\n",
 			RVU_PF_INT_VEC_CNT);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index c1c44a7b..3f4d791 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -42,8 +42,8 @@ static int cptvf_register_interrupts(struct otx2_cptvf_dev *cptvf)
 		return -EINVAL;
 
 	/* Enable MSI-X */
-	ret = pci_alloc_irq_vectors(cptvf->pdev, num_vec, num_vec,
-				    PCI_IRQ_MSIX);
+	ret = pcim_alloc_irq_vectors(cptvf->pdev, num_vec, num_vec,
+				     PCI_IRQ_MSIX);
 	if (ret < 0) {
 		dev_err(&cptvf->pdev->dev,
 			"Request for %d msix vectors failed\n", num_vec);
-- 
2.7.4

