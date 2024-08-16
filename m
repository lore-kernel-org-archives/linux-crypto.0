Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560A9155385
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 08:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723796617; cv=none; b=bXuaeFje1ghWeIFbZZGOM+wQOGSJMMyrL/0rF4CgjPD1yaiPKRNVECMetqMAnbNUTGbkQacK28GnbopVEfhBjWlVVSCfFnykHu/CqNVGetlXADxQIz9SrAYM3YkKs6wIwLFLFGRP0zoxU2Xaw8Ixu5ZvS7uO21DTOjVdAN2nmNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723796617; c=relaxed/simple;
	bh=eSFUZ1JCsMVzaieqrfZ6sP42002jGDiUhoG3EeqHIyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eD4oCp4WHup7ULxtb2VwtkKgHJInh0WT3euS4uSA2sz6sU874BABDbcFvSbJ/fB22ZdAuaVzRCxbzOx1dRFagH9Fj+8RrP14sMvyfATokCLqcrNYaLBluo6QrZsKy2kVYOP1Z4XaPypbmMh+vCVOD7seDehGrbtZTfzWJH4sw24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aRtnFgwZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aRtnFgwZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723796614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J/TWDUwF4muPiT/wIrowwWqBmpjVYWuLvHzzBlgJVA8=;
	b=aRtnFgwZ8466B0hF9pj26L3yMKwzR5ApgBa7bYGy3ntb/tQllwfy++0pd+o4LK1bPBZHJM
	JoXwtaQvLUz24AqVHCmin9XkEqmMqHrTcKAbRCRnMIxz1gfalDJefY1pCZSmhjZyO0NUGy
	YGFalX6ib9i9XKP2BO/fp4vr8lpIvSQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-dTYTY7u5M42s1wIgYYNICw-1; Fri, 16 Aug 2024 04:23:29 -0400
X-MC-Unique: dTYTY7u5M42s1wIgYYNICw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42808f5d32aso2935035e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 01:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723796608; x=1724401408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J/TWDUwF4muPiT/wIrowwWqBmpjVYWuLvHzzBlgJVA8=;
        b=vLQlgBMGJsk7wg+W1/wC+mo26mYjsYUtJTwDHQyZgTUZJdvdYMBQJbYQXDWnDEG8dB
         WJBt0CZO4mq/x1RDZwWaN+QPttoxQw3Nk3W9plP2nRTKfzYYUSzQbDwr9LGoukY4YUjS
         UMOXTB5DscvRWvHv5lno7ytxecqFSUeBaoq1DOjphgUSMjuOQqQVjEzHVHwKuSbA2FWj
         ZxYUw3XQWVkNt3f35t5G77ONApgNVH8W1u8Av3p5wNuUunVYVqd+UGZXJDSvsUSj6IzO
         nxSUmdJanlcMPyoE+F3WwlDLyzMP/dPqpakO1XgBLxDVKwxlWzlAQ7xoEOJ7TFuZBIP6
         jt/w==
X-Forwarded-Encrypted: i=1; AJvYcCW2GIpMXi6qUFvosuxvIrNxx3zAaQUGB00AmNOTJDNoJZ/D4sraLY3RaOI52rPrByMpkDPZAFkH7aL7/iU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd99dCEDeDwfnmiSkU1819p3SWWvhhUVdnoIjpPbjQ9xA6iBh2
	NV4jWnO/5knLN9UyG58jgU1YQilyPa+v1JkHgq5FVmbIE1Pdl1dG3C8P7eKNfJ82Oymf1oZ0FcX
	T7h7cr4xvtBYgcdGWqJy8RZ9AzXCdJZduKbIRfISG2kwzLvuG/ZhFru3VO49mSA==
X-Received: by 2002:a05:600c:3c89:b0:427:9f71:16bb with SMTP id 5b1f17b1804b1-429ed81ef7dmr7718595e9.6.1723796608221;
        Fri, 16 Aug 2024 01:23:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIAo2an9uYuqB4ahCNPXZI8UwawbGrjuMMGbskgXu9LAjCjingMPPNd3Qcq6DzQwqmUyfoww==
X-Received: by 2002:a05:600c:3c89:b0:427:9f71:16bb with SMTP id 5b1f17b1804b1-429ed81ef7dmr7718215e9.6.1723796607736;
        Fri, 16 Aug 2024 01:23:27 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded367ebsm71461355e9.25.2024.08.16.01.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 01:23:27 -0700 (PDT)
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
	Serge Semin <fancer.lancer@gmail.com>
Subject: [PATCH v3 07/10] ntb: idt: Replace deprecated PCI functions
Date: Fri, 16 Aug 2024 10:22:59 +0200
Message-ID: <20240816082304.14115-8-pstanner@redhat.com>
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
Acked-by: Serge Semin <fancer.lancer@gmail.com>
---
 drivers/ntb/hw/idt/ntb_hw_idt.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/ntb/hw/idt/ntb_hw_idt.c b/drivers/ntb/hw/idt/ntb_hw_idt.c
index 48dfb1a69a77..f1b57d51a814 100644
--- a/drivers/ntb/hw/idt/ntb_hw_idt.c
+++ b/drivers/ntb/hw/idt/ntb_hw_idt.c
@@ -2671,15 +2671,20 @@ static int idt_init_pci(struct idt_ntb_dev *ndev)
 	 */
 	pci_set_master(pdev);
 
-	/* Request all BARs resources and map BAR0 only */
-	ret = pcim_iomap_regions_request_all(pdev, 1, NTB_NAME);
+	/* Request all BARs resources */
+	ret = pcim_request_all_regions(pdev, NTB_NAME);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request resources\n");
 		goto err_clear_master;
 	}
 
-	/* Retrieve virtual address of BAR0 - PCI configuration space */
-	ndev->cfgspc = pcim_iomap_table(pdev)[0];
+	/* ioremap BAR0 - PCI configuration space */
+	ndev->cfgspc = pcim_iomap(pdev, 0, 0);
+	if (!ndev->cfgspc) {
+		dev_err(&pdev->dev, "Failed to ioremap BAR 0\n");
+		ret = -ENOMEM;
+		goto err_clear_master;
+	}
 
 	/* Put the IDT driver data pointer to the PCI-device private pointer */
 	pci_set_drvdata(pdev, ndev);
-- 
2.46.0

