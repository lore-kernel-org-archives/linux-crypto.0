Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2496114D29C
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 08:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723796613; cv=none; b=hKhVUojRAd9N2ntq6HjEng3YPOPBYZI/PP4fvbw6w8QoZ9fwk184aVW1eexMPyGNuRcN7Xfo9zolPXcYRJ8ib0G8pz5CAqQplLwf9YMZKoDaqjyP3n8JYbRbnPUQv5A279J5BYy9WGVziibgzWxKMUZoPlnSqbJWWITsTkZjKJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723796613; c=relaxed/simple;
	bh=VxK2Q9rTPaJTkxCUDwKgVr4mTt/G6TMMjXLiVOpU1l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISd2k02uJ5GzHtY4tgWQgeiW6tcW8QUUxXiOwOnDsRmJx/qEhfFaQ6FGt/+3/jWAjIax5ErTtLveyHon81qk1StQ96uj2Ltg+XqAw+tLb7apAmxpvoCk/+s0cAQMpc1Oa/jxExqh+yqSrXRRohwqDz3l5Mdi35tqGl7o6n4mfqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JpIEFOKQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JpIEFOKQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723796611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9vavx9d8Z3lY3D2Y8KLNdQxHUg+4fLRoKF7EdDYKitk=;
	b=JpIEFOKQf6zEXk8HIMH1wClF7GzTFziDevI7iA7QgGj8vqjXffY0E86/I9HU4Cpmx9A4+y
	mZJ41SSa+cfJqgYGaK5xIu5DnAgVHBtkyYA9yxxEp2s1jeGhQMm2i+xE8TaYiXf840xPsP
	12IFePRwVWOR3yV4oMSbpaPRULByBAQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-5rCQsnNwN9maPg5KjyNI2g-1; Fri, 16 Aug 2024 04:23:28 -0400
X-MC-Unique: 5rCQsnNwN9maPg5KjyNI2g-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42818ae1a68so2831415e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 01:23:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723796607; x=1724401407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9vavx9d8Z3lY3D2Y8KLNdQxHUg+4fLRoKF7EdDYKitk=;
        b=vl8w2NY5wpwe+yJz33oSXRZykUSPEhQ7dB45bFCxEONLrXNFfFBHafYv6z1iJLBHgg
         qc7INZosNtSQd0+xmuAZH52JvT2p4/YvVbpulSzbm6f7S9I0u17h/LhkD+TaV/rVm4kG
         dux04N3X5HSvL6Sf7BJRfg6ksZtGZlgA85L9efz/Q0r3PHR8QbN3e3P8QRgD0K74z/wT
         3edbbfqfDlv66cRWvDwYMRwed7KmegugSsy8MFbLDAukpoKsskx8P7kPGwNjjBcqHLWy
         tn79g7CzQ06g5lfZAMFOQTjip8FfIy/5Z6yMPcau5kJl1tmMHOXvgegx2tLbR7HvUe+K
         cSXw==
X-Forwarded-Encrypted: i=1; AJvYcCXHm1FutxQqdrYnTdzfYlXGOHchve44RYakFjemdQuAM3i81m7hzOjJ6AEvypqilRqoFh9I00T1YqNAfoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzK41RG8kgYAbqiIPce/4ZdU6AsF4ZARvCsqx/0n7oELDEE/D41
	2p1Xducbt8ThB0+QEA8WpiCDQm0U+XLIuKzjUNj70b8fuWbm9IZJuYCSbUUoCUamAL2Fn65KS59
	zPNncz/eXzjT1JdlLkTPMAPZNQNEg9eVuFvjsuUT/oPUbg9otnBpoG4lr3dL4mw==
X-Received: by 2002:a05:600c:4f52:b0:427:9f6f:9c00 with SMTP id 5b1f17b1804b1-429ed820e35mr7943945e9.6.1723796606700;
        Fri, 16 Aug 2024 01:23:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFH6n0oWvlUqxpyDu61U28p7RR4akODFJTFMNu8jX2SKNBsfpChGB90y3cm5ks0xETivd581Q==
X-Received: by 2002:a05:600c:4f52:b0:427:9f6f:9c00 with SMTP id 5b1f17b1804b1-429ed820e35mr7943515e9.6.1723796606233;
        Fri, 16 Aug 2024 01:23:26 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded367ebsm71461355e9.25.2024.08.16.01.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 01:23:25 -0700 (PDT)
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
Subject: [PATCH v3 06/10] wifi: iwlwifi: replace deprecated PCI functions
Date: Fri, 16 Aug 2024 10:22:58 +0200
Message-ID: <20240816082304.14115-7-pstanner@redhat.com>
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
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 719ddc4b72c5..6b282276e7b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3534,7 +3534,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	struct iwl_trans_pcie *trans_pcie, **priv;
 	struct iwl_trans *trans;
 	int ret, addr_size;
-	void __iomem * const *table;
 	u32 bar0;
 
 	/* reassign our BAR 0 if invalid due to possible runtime PM races */
@@ -3657,22 +3656,15 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	}
 
-	ret = pcim_iomap_regions_request_all(pdev, BIT(0), DRV_NAME);
+	ret = pcim_request_all_regions(pdev, DRV_NAME);
 	if (ret) {
-		dev_err(&pdev->dev, "pcim_iomap_regions_request_all failed\n");
+		dev_err(&pdev->dev, "pcim_request_all_regions failed\n");
 		goto out_no_pci;
 	}
 
-	table = pcim_iomap_table(pdev);
-	if (!table) {
-		dev_err(&pdev->dev, "pcim_iomap_table failed\n");
-		ret = -ENOMEM;
-		goto out_no_pci;
-	}
-
-	trans_pcie->hw_base = table[0];
+	trans_pcie->hw_base = pcim_iomap(pdev, 0, 0);
 	if (!trans_pcie->hw_base) {
-		dev_err(&pdev->dev, "couldn't find IO mem in first BAR\n");
+		dev_err(&pdev->dev, "pcim_iomap failed\n");
 		ret = -ENODEV;
 		goto out_no_pci;
 	}
-- 
2.46.0

