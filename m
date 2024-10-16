Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720D6212EF9
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 12:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082526; cv=none; b=jCB5E/fp2c5EPIutji12Q5FkiNQG33RKb9igqbg5pZVXbb7fNm8aPk5QGOmguJCTP9+bhdbQ3Sk/tG29muaef1xilFoaNYVBTaYAGEwCL/AL0U9F+votkQqku9psmiLiX4g70te1V1CLty2MIzVzxFRWP7TybFZx/qMgChEEwEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082526; c=relaxed/simple;
	bh=xeBMFrWniQWPsGN4NVOp7U+TERIRvwx/CXaeZ/U1fmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvIya/ufRqKU2hrpsyfBWS28IH/DEPbCkHg/CRm/zDj73p/7ch4s835yH5T4wV59lBkkV0DC2hWMhg8qAAQ8KwiRuQMWkgk1j1YMqi+3nn/XW5JUxKQq9jBKSn7y9w78EevwtbgSkKfS9SSX/dcm0RzCnhzjmuJhW34lJibXZM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BUk1D4Rn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BUk1D4Rn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729082523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZRGVJdsI4KeDAeg9imgjHK9adQHetOZy1n8XhZE2xHU=;
	b=BUk1D4RnRjS9fv23GuX2Ay080o8xN2qH6cg3iawOqBvH9JatUXULtHhFQdqV6g9NgSHnsS
	TwN4dsqIUdSDgYTaP0f7c4sg08CA0YAgKCVtzA56YwK8Ymw9g371J6M7Dgy8nhnpJjiGuk
	B7DqVxqpin1axOTy0Y+FaEhLoj2vmnA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-s09PZWOCOFeU2lmnlhZykA-1; Wed, 16 Oct 2024 08:42:02 -0400
X-MC-Unique: s09PZWOCOFeU2lmnlhZykA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43111c47d0bso35478845e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 05:42:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729082521; x=1729687321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZRGVJdsI4KeDAeg9imgjHK9adQHetOZy1n8XhZE2xHU=;
        b=cp5hymVooTmNPR8H8119Twx1IKU/84/eaakHjztVIwh2ufrO899qeaGRq/mlESzfxA
         0xlCVRuYkDwFUsg5WiFZPctgPUXyMfcx6sSlCMlDWfgS9qXRsTjAfRpcfc+Ocd6p530o
         MiRHCdtDS5t7PN41UC4soIU9umK/LGNK31WvDEOzsWxyGDgye8zFjSWr1Y2DVUZws3Ca
         vTgsdgtuhh1v5mToRW4XaVE9GEFMt+T64qgsnZ1m2RDWCtBrS00G0I9fwxKfrFxguzuq
         8aWan8NQaYY6m3GRUU0e8EhAN5AJe3V3jE/O3261kstZAbt/HDGIZPn5ViJrqYmeWlBB
         WsWw==
X-Forwarded-Encrypted: i=1; AJvYcCWyN6+/hZi1SFS9XP6ysQGNYBQWLeTEc8k3v5Y/zckiCVtsIpTZeMFxgdNRb/vVQgiJj5Zql1lTRlscRS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLl8t9QIUvcSM6NiSGNHxuryEmrutvo+S56nti/qXPaNv8Z0Rq
	xiggFqwNumEG82gZ7IkRW6sSnis6ilhZsYrnOsN/TWG6DPPWEs/nSDk/nNngn+M/DD4VEZzjgwi
	zOCLH9eg6rIMDYiGqVgfegBbV0Q0RResY79TEklmIizkE4dLYke/gv85nnBWKJQ==
X-Received: by 2002:a05:600c:4455:b0:431:5522:e009 with SMTP id 5b1f17b1804b1-4315522e18bmr6220415e9.12.1729082521429;
        Wed, 16 Oct 2024 05:42:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGE3P1Sf2DjAjua7QaSHPu6bkCGVM+tumEiRjRf2AVFHTw3nylGoruyKCB/DirRoG2V4OxriA==
X-Received: by 2002:a05:600c:4455:b0:431:5522:e009 with SMTP id 5b1f17b1804b1-4315522e18bmr6219795e9.12.1729082521006;
        Wed, 16 Oct 2024 05:42:01 -0700 (PDT)
Received: from eisenberg.muc.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d7fa8ffd6sm4246879f8f.50.2024.10.16.05.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 05:42:00 -0700 (PDT)
From: Philipp Stanner <pstanner@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Kalle Valo <kvalo@kernel.org>,
	Serge Semin <fancer.lancer@gmail.com>,
	Jon Mason <jdmason@kudzu.us>,
	Dave Jiang <dave.jiang@intel.com>,
	Allen Hubbe <allenbh@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kevin Cernekee <cernekee@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Mark Brown <broonie@kernel.org>,
	David Lechner <dlechner@baylibre.com>,
	Philipp Stanner <pstanner@redhat.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Jie Wang <jie.wang@intel.com>,
	Tero Kristo <tero.kristo@linux.intel.com>,
	Adam Guerin <adam.guerin@intel.com>,
	Shashank Gupta <shashank.gupta@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Nithin Dabilpuram <ndabilpuram@marvell.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Yedidya Benshimol <yedidya.ben.shimol@intel.com>,
	Breno Leitao <leitao@debian.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ntb@lists.linux.dev,
	linux-pci@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-sound@vger.kernel.org
Subject: [PATCH v4 10/10] PCI: Remove pcim_iomap_regions_request_all()
Date: Wed, 16 Oct 2024 14:41:32 +0200
Message-ID: <20241016124136.41540-11-pstanner@redhat.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241016124136.41540-1-pstanner@redhat.com>
References: <20241016124136.41540-1-pstanner@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pcim_iomap_regions_request_all() had been deprecated in
commit e354bb84a4c1 ("PCI: Deprecate pcim_iomap_table(),
pcim_iomap_regions_request_all()").

All users of this function have been ported to other interfaces by now.

Remove pcim_iomap_regions_request_all().

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 .../driver-api/driver-model/devres.rst        |  1 -
 drivers/pci/devres.c                          | 56 -------------------
 include/linux/pci.h                           |  2 -
 3 files changed, 59 deletions(-)

diff --git a/Documentation/driver-api/driver-model/devres.rst b/Documentation/driver-api/driver-model/devres.rst
index 5f2ee8d717b1..3a30cf4f6c0d 100644
--- a/Documentation/driver-api/driver-model/devres.rst
+++ b/Documentation/driver-api/driver-model/devres.rst
@@ -394,7 +394,6 @@ PCI
   pcim_enable_device()		: after success, some PCI ops become managed
   pcim_iomap()			: do iomap() on a single BAR
   pcim_iomap_regions()		: do request_region() and iomap() on multiple BARs
-  pcim_iomap_regions_request_all() : do request_region() on all and iomap() on multiple BARs
   pcim_iomap_table()		: array of mapped addresses indexed by BAR
   pcim_iounmap()		: do iounmap() on a single BAR
   pcim_iounmap_regions()	: do iounmap() and release_region() on multiple BARs
diff --git a/drivers/pci/devres.c b/drivers/pci/devres.c
index 2a64da5c91fb..319a477a2135 100644
--- a/drivers/pci/devres.c
+++ b/drivers/pci/devres.c
@@ -959,62 +959,6 @@ int pcim_request_all_regions(struct pci_dev *pdev, const char *name)
 }
 EXPORT_SYMBOL(pcim_request_all_regions);
 
-/**
- * pcim_iomap_regions_request_all - Request all BARs and iomap specified ones
- *			(DEPRECATED)
- * @pdev: PCI device to map IO resources for
- * @mask: Mask of BARs to iomap
- * @name: Name associated with the requests
- *
- * Returns: 0 on success, negative error code on failure.
- *
- * Request all PCI BARs and iomap regions specified by @mask.
- *
- * To release these resources manually, call pcim_release_region() for the
- * regions and pcim_iounmap() for the mappings.
- *
- * This function is DEPRECATED. Don't use it in new code. Instead, use one
- * of the pcim_* region request functions in combination with a pcim_*
- * mapping function.
- */
-int pcim_iomap_regions_request_all(struct pci_dev *pdev, int mask,
-				   const char *name)
-{
-	int bar;
-	int ret;
-	void __iomem **legacy_iomap_table;
-
-	ret = pcim_request_all_regions(pdev, name);
-	if (ret != 0)
-		return ret;
-
-	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
-		if (!mask_contains_bar(mask, bar))
-			continue;
-		if (!pcim_iomap(pdev, bar, 0))
-			goto err;
-	}
-
-	return 0;
-
-err:
-	/*
-	 * If bar is larger than 0, then pcim_iomap() above has most likely
-	 * failed because of -EINVAL. If it is equal 0, most likely the table
-	 * couldn't be created, indicating -ENOMEM.
-	 */
-	ret = bar > 0 ? -EINVAL : -ENOMEM;
-	legacy_iomap_table = (void __iomem **)pcim_iomap_table(pdev);
-
-	while (--bar >= 0)
-		pcim_iounmap(pdev, legacy_iomap_table[bar]);
-
-	pcim_release_all_regions(pdev);
-
-	return ret;
-}
-EXPORT_SYMBOL(pcim_iomap_regions_request_all);
-
 /**
  * pcim_iounmap_regions - Unmap and release PCI BARs
  * @pdev: PCI device to map IO resources for
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3b151c8331e5..b59197635c5c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2301,8 +2301,6 @@ void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
 void __iomem * const *pcim_iomap_table(struct pci_dev *pdev);
 int pcim_request_region(struct pci_dev *pdev, int bar, const char *name);
 int pcim_iomap_regions(struct pci_dev *pdev, int mask, const char *name);
-int pcim_iomap_regions_request_all(struct pci_dev *pdev, int mask,
-				   const char *name);
 void pcim_iounmap_regions(struct pci_dev *pdev, int mask);
 void __iomem *pcim_iomap_range(struct pci_dev *pdev, int bar,
 				unsigned long offset, unsigned long len);
-- 
2.47.0

