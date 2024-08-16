Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF2813FD84
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 08:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723796604; cv=none; b=N91/2Vz7ebLxeKvBFJwG98mL5HMqVmtK1lyEiN75s0ESrUF+Cg509ys1VkAJjo7QzHr4/Yvj4yN25H5rKkxHg8olntmr924syPQGX4yYicwIhi3UCsp1UUPjOuvcnXVveE/IWZQwUKnPID+ufo+GKm30aFP9suMWEk0t01Ra1l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723796604; c=relaxed/simple;
	bh=zVpmTTp3nHIzVMoh7ZTo5T9lcWciVJTr4ZCcBW5jOkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZwK1fR8MYVUz4fy2gTxw548FP9Fh54Zyj6eZ2pNbyvMOeF/czshzV8Z3eu2qQcnV+Ar46RyvczCxO3MOpKdTUHzRmIaNzRPs0awzaa3TP4vd7vxCfpuzqXr6NeJQeXLlfL/t2zC+bBrXvrTtKhIs3whSsoBtGi7XgfyANezVl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gslm1Z99; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gslm1Z99"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723796602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QzzbkcE2piNg6xzdXbcpa+EEzchmMoLeUr0sOfHpsDw=;
	b=Gslm1Z99ht0Mo9R3X+VkIn61al+De5R2Jg9dSHOzXIu5xoC94gn4DqeS3Z5eHgLax+wwea
	JFE8i34FcJ+tFCo+5FOkUYpix2ivbKVUkILdZnrRjbGoRb7xlMVMrS4G/OylhJWHP4Bwr3
	U1JoXUSoSdZbFSkevjhW140Z5c8JY34=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-sruLj5rZOr-cmcL4Z2-x_w-1; Fri, 16 Aug 2024 04:23:20 -0400
X-MC-Unique: sruLj5rZOr-cmcL4Z2-x_w-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-532ffe0530fso251138e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 01:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723796599; x=1724401399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QzzbkcE2piNg6xzdXbcpa+EEzchmMoLeUr0sOfHpsDw=;
        b=lbtXcn5HmWcNFsxxUm7MVQ+A3KPd1Y4ADw1GeseXjfktezbDjEMi6fHI+W+3ivEgq2
         dnqbeBAbjEH9HmxEBUXfbBoRgqGMn3v0FDAdGp+4NjOTg1BAajvEh1CAQWNtYPTia8K4
         v2cDuUxKXa5ZPKWaYisRX4FnatOXJB0IgA0R/cqqhbYvcPhc7XYVBDAIUu9Sn4nxqmve
         XHGm8y3clj4aIvXeFXsm3shx0Y7QUd2kxUQyUXZpW2ipDGnH10eDMtb8uO0JuvrSynHp
         x+2KXIp+sDadisPZL7OKIrJ5knL0qZMAfselfWUWmfPxqXifcQPzQpLVmQA4O2gZBMJR
         IWVg==
X-Forwarded-Encrypted: i=1; AJvYcCVzwHpayzDaCdKb8GceYkusAHBEcL+MkCPSf6K1+LQn/aCG0e0TnM63l2NMVMSUBthJRWTiSSYXs2pPdds=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk3I2jXFU9RWsRRS8cg7QFaJumHwi8gJ+c8gvH1qE/+EXdFwZL
	+e42jCD8hxxyTqFk3IfnjTc+CNpu1Q9uIXw3WD5ndQGfdzMDWsywKww+INqBY2C7BcS5SEKRi64
	5Sx7SGGx2PDq/JbJmazfxGaA89anQ7snRQalJXsPtutbGKIfidWFDK9AVRu+asg==
X-Received: by 2002:a2e:a99c:0:b0:2ef:2b1f:180b with SMTP id 38308e7fff4ca-2f3be617274mr8424671fa.8.1723796598807;
        Fri, 16 Aug 2024 01:23:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFF2FO8TTO68hZ1mL0fNAPSpkGVq8q42PLCiERNm/y+Oi4rSP5Phgl2zzK0/6kEjJzXbloZGQ==
X-Received: by 2002:a2e:a99c:0:b0:2ef:2b1f:180b with SMTP id 38308e7fff4ca-2f3be617274mr8424331fa.8.1723796598136;
        Fri, 16 Aug 2024 01:23:18 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded367ebsm71461355e9.25.2024.08.16.01.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 01:23:17 -0700 (PDT)
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
	linux-pci@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v3 01/10] PCI: Make pcim_request_all_regions() a public function
Date: Fri, 16 Aug 2024 10:22:53 +0200
Message-ID: <20240816082304.14115-2-pstanner@redhat.com>
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

In order to remove the deprecated function
pcim_iomap_regions_request_all(), a few drivers need an interface to
request all BARs a PCI-Device offers.

Make pcim_request_all_regions() a public interface.

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/pci/devres.c | 3 ++-
 include/linux/pci.h  | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/devres.c b/drivers/pci/devres.c
index 3780a9f9ec00..0ec2b23e6cac 100644
--- a/drivers/pci/devres.c
+++ b/drivers/pci/devres.c
@@ -932,7 +932,7 @@ static void pcim_release_all_regions(struct pci_dev *pdev)
  * desired, release individual regions with pcim_release_region() or all of
  * them at once with pcim_release_all_regions().
  */
-static int pcim_request_all_regions(struct pci_dev *pdev, const char *name)
+int pcim_request_all_regions(struct pci_dev *pdev, const char *name)
 {
 	int ret;
 	int bar;
@@ -950,6 +950,7 @@ static int pcim_request_all_regions(struct pci_dev *pdev, const char *name)
 
 	return ret;
 }
+EXPORT_SYMBOL(pcim_request_all_regions);
 
 /**
  * pcim_iomap_regions_request_all - Request all BARs and iomap specified ones
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 4cf89a4b4cbc..5b5856ba63e1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2289,6 +2289,7 @@ static inline void pci_fixup_device(enum pci_fixup_pass pass,
 				    struct pci_dev *dev) { }
 #endif
 
+int pcim_request_all_regions(struct pci_dev *pdev, const char *name);
 void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
 void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
 void __iomem * const *pcim_iomap_table(struct pci_dev *pdev);
-- 
2.46.0

