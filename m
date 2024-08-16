Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F0E1422D9
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 08:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723796609; cv=none; b=E67riZEE0yZnsVFWVvuaQJUu0pt6+VNpOZ/5VjaU5FVk0pq0zAoDFeT7an1r1LwHRSKTD5dBb/GFWapPV23m8CfbpEiqrEHw/eYPpAg1L7mCUvyFFB8twM4zZWaWWxkmXO0lOVGcshGsx2e8aPEn/RcvBU5J+7XTISfP+m6iFEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723796609; c=relaxed/simple;
	bh=xKAvNOGbgRJHGNVobngUeE6l3k1n1HAKWh4bGb29i8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8J1NzSMpyJ5WmjWcufgCxr9ukQiz7cC5i2Gd63x353FMyQ/iJ8eHv1M2mIIu9y3ceDlvmfolvyRjwdZXkRI2MdvIGTIxu4Xw5Bp6iHUkWlnD5xXuifGDu4JfpCmQxlZdcntwW2lCTCDcWCBj/YXCpcJt9ITZ3wSMUTSq719zUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M995CCwI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M995CCwI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723796606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=idBIL1cNTTGhcAk+zwpuj0GurJvuhXTWsWSbkJ3vUdI=;
	b=M995CCwIAylHRJL16t39VHMy2bdYJm4dedDyPc2LjC/ttDl0PFOSfiONJiwcbQyHoA+f8Q
	x2mCzXtAGZ4w+5q7RArO2uBZjIBt9CehON1kz2MniYzWe4MC+s/P/bCf1guH3OxMAQThLa
	0lljCuBrapQcXb1UbO5VMrn7snft/Vs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-fY8MsrYuPHCupyuNcxK9Iw-1; Fri, 16 Aug 2024 04:23:24 -0400
X-MC-Unique: fY8MsrYuPHCupyuNcxK9Iw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37197ab1330so62228f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 01:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723796603; x=1724401403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=idBIL1cNTTGhcAk+zwpuj0GurJvuhXTWsWSbkJ3vUdI=;
        b=pKl54cJ0hsahd51++vkK7RIYX46g3XDWgF2CT7vacpP5TBvxctZ7Z2oWhFOv/HSKir
         mw3dDel1aTH6ZLWGVCWWIx9Hs6Qs6r/vawOjh0uJjJUBLOy8s6L7WnD0ZoLD+rFW1/Tt
         3ZupN2Ur5o1LVLwkPK7F+qXbVrxkf7DIXZsCmQBCtV0HIxvFYS3uvUitDu7zaG1Etov3
         SKAPQLbMDoaHJ22cxD+YLFFVLHffk9ALdGBXnBsz/TUw+muxQXBgGWNOKNkmxtu5ctIK
         3Av2kvEirJ/9nMpMNr0R7hn1q/YuQDbLvsnPlsMRLRNJ5qns7jDtvS/soxLR8taNhSYq
         m8vA==
X-Forwarded-Encrypted: i=1; AJvYcCVD/XjzBZFVRNqFQyJPIIwCLOwCe+9Z1P3+w8KdmIzHlZbV9imhFCxv0BxZ0ARgphaeZBH/wPoWiS/kARA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdCPysnyypz34D+uUmph9Nebqdaswhi758c2Rs56nej4ilUZcp
	N2mJAwwbb8mYDLSOdMBl8CPV5U4UF0aJR1c9uL9Fn1LA7PUWkYZLVnQcQ+ZM4Rlpvscs2kf/Ubb
	vCAHQ3nfkDCp3KlHLMi4zPdBGZoKPmp8RI5TXemB2e7q899nEiM8JP7oAHgqm+Q==
X-Received: by 2002:a05:600c:3508:b0:427:9f6c:e4bd with SMTP id 5b1f17b1804b1-429ed82dcd1mr7749595e9.6.1723796603329;
        Fri, 16 Aug 2024 01:23:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKlPm1rBtWEoi/GBorTZm6wziB5Vs2DwGl6VWjNmzFzWskWquGITgeWGaOB8d0QhM8LFtHSg==
X-Received: by 2002:a05:600c:3508:b0:427:9f6c:e4bd with SMTP id 5b1f17b1804b1-429ed82dcd1mr7749405e9.6.1723796602861;
        Fri, 16 Aug 2024 01:23:22 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded367ebsm71461355e9.25.2024.08.16.01.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 01:23:22 -0700 (PDT)
From: Philipp Stanner <pstanner@redhat.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jie Wang <jie.wang@intel.com>,
	Shashank Gupta <shashank.gupta@intel.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Adam Guerin <adam.guerin@intel.com>,
	Tero Kristo <tero.kristo@linux.intel.com>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	Nithin Dabilpuram <ndabilpuram@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Kalle Valo <kvalo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Yedidya Benshimol <yedidya.ben.shimol@intel.com>,
	Breno Leitao <leitao@debian.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mark Brown <broonie@kernel.org>,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v3 04/10] crypto: marvell - replace deprecated PCI functions
Date: Fri, 16 Aug 2024 10:22:56 +0200
Message-ID: <20240816082304.14115-5-pstanner@redhat.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240816082304.14115-1-pstanner@redhat.com>
References: <20240816082304.14115-1-pstanner@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pcim_iomap_table() and pcim_iomap_regions_request_all() have been
deprecated by the PCI subsystem in commit e354bb84a4c1 ("PCI: Deprecate
pcim_iomap_table(), pcim_iomap_regions_request_all()").

Replace these functions with their successors, pcim_iomap() and
pcim_request_all_regions().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c | 14 +++++++++-----
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c | 13 +++++++++----
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 400e36d9908f..94d0e73e42de 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -739,18 +739,22 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 		dev_err(dev, "Unable to get usable DMA configuration\n");
 		goto clear_drvdata;
 	}
-	/* Map PF's configuration registers */
-	err = pcim_iomap_regions_request_all(pdev, 1 << PCI_PF_REG_BAR_NUM,
-					     OTX2_CPT_DRV_NAME);
+	err = pcim_request_all_regions(pdev, OTX2_CPT_DRV_NAME);
 	if (err) {
-		dev_err(dev, "Couldn't get PCI resources 0x%x\n", err);
+		dev_err(dev, "Couldn't request PCI resources 0x%x\n", err);
 		goto clear_drvdata;
 	}
 	pci_set_master(pdev);
 	pci_set_drvdata(pdev, cptpf);
 	cptpf->pdev = pdev;
 
-	cptpf->reg_base = pcim_iomap_table(pdev)[PCI_PF_REG_BAR_NUM];
+	/* Map PF's configuration registers */
+	cptpf->reg_base = pcim_iomap(pdev, PCI_PF_REG_BAR_NUM, 0);
+	if (!cptpf->reg_base) {
+		err = -ENOMEM;
+		dev_err(dev, "Couldn't ioremap PCI resource 0x%x\n", err);
+		goto clear_drvdata;
+	}
 
 	/* Check if AF driver is up, otherwise defer probe */
 	err = cpt_is_pf_usable(cptpf);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 527d34cc258b..d0b6ee901f62 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -358,9 +358,8 @@ static int otx2_cptvf_probe(struct pci_dev *pdev,
 		dev_err(dev, "Unable to get usable DMA configuration\n");
 		goto clear_drvdata;
 	}
-	/* Map VF's configuration registers */
-	ret = pcim_iomap_regions_request_all(pdev, 1 << PCI_PF_REG_BAR_NUM,
-					     OTX2_CPTVF_DRV_NAME);
+
+	ret = pcim_request_all_regions(pdev, OTX2_CPTVF_DRV_NAME);
 	if (ret) {
 		dev_err(dev, "Couldn't get PCI resources 0x%x\n", ret);
 		goto clear_drvdata;
@@ -369,7 +368,13 @@ static int otx2_cptvf_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, cptvf);
 	cptvf->pdev = pdev;
 
-	cptvf->reg_base = pcim_iomap_table(pdev)[PCI_PF_REG_BAR_NUM];
+	/* Map VF's configuration registers */
+	cptvf->reg_base = pcim_iomap(pdev, PCI_PF_REG_BAR_NUM, 0);
+	if (!cptvf->reg_base) {
+		ret = -ENOMEM;
+		dev_err(dev, "Couldn't ioremap PCI resource 0x%x\n", ret);
+		goto clear_drvdata;
+	}
 
 	otx2_cpt_set_hw_caps(pdev, &cptvf->cap_flag);
 
-- 
2.46.0

