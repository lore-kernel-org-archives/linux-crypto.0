Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586BE156F4A
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2024 08:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722844945; cv=none; b=pLw6PWT8EDWFi4g4G7W1Nuh2bNmO7m7lOMe2ucoRXemalockNq6VipNsC/hXNjt68Ey24b4EoXwUa9Gybc4hc60PGmsXVfR0DsLDRuTYJrVVfmI2Y1UEvLmoSR4tzPtIR9TXK7dguZ9ss2ZENxuvAf9lCoe9yer+96r072Uv4Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722844945; c=relaxed/simple;
	bh=7JtiDzH4j1fn6e/l1CbreMTpZlhxa3kkuVFDYh4FXvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjTHWE0Wgv0C2uiZKV49G58My4VgmjFf/mBIb0IytFkN3/OPqoYVG387P3Ty42hjqi/MS+LHm2vULlZwDVah0XSOc2DzKyQOjTdkjfv29WYf4w1fS4l4RJpTwau9YecaLOi8EfkmglsYJ/KKOC+sfjJwx9HZGK62eOdWqgkhiMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cPFM5mTU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cPFM5mTU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722844942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0WfVVRPiytk6PFyUBJOpMrU1ppuGmgzu2AH1RznbocA=;
	b=cPFM5mTUYh4Rg/0b2WuVBruhiaVw1B+a9T7M7qsUKzFYwktKNm4wgelznogy8/GkTwqzKo
	bUD6J7mdT5iZUoE0XGoRCQhd2Nhd8obg8HJbZDwn0R2dISaG0YHZW4YIh1HC6Ul+/mAZVX
	z54hhz5TQCY+93XJ1HeFdafIRYchfYw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-0iDALpomPBe39XV6AAaI7Q-1; Mon, 05 Aug 2024 04:02:18 -0400
X-MC-Unique: 0iDALpomPBe39XV6AAaI7Q-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a7aa36a777eso95723166b.3
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2024 01:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722844937; x=1723449737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0WfVVRPiytk6PFyUBJOpMrU1ppuGmgzu2AH1RznbocA=;
        b=rXL/MxJZ/Vs8VHn3fKGhL/wihf2RkiqbH5FvkKFDzZItZQfWDpG0gvSEyL61hEim4Q
         /Oh1rWt4tATMyXEaijExyO5+h5ZiLwexDrDmBrirlZv/OHBdXKYtlDALMVvzgpp202FB
         VpaNlKiCWIWwz0l3EzUwp55qyUVrV94q9Ws4LDXiGbhvVTDoa5ygXsT8tFGOGKC2z9Vj
         jQRtc0cRX35xnTZ7r/J8vwd84HLzVbnTfsYhxyT3xauZQIufY+Gfx0qJ0kbeKcCr+Q4x
         9UbNVKqtx7ugsDd9P1ypLd6KlPJqBD9oaQtotWKmEI+e1F7nQ0eeGgoG+EmcaCbHvFEJ
         6nyw==
X-Forwarded-Encrypted: i=1; AJvYcCX5iiSpDe6uKjAaw1JoPe3C0srFju49C0JE35t+Ji7GT1v8LrM3AQnXcoRZ9SWcOmPv8V+qK6jELHJuqr0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO2wlt2lTVeKbhwYUTYIEDrOm5Hn0aPYBUUNaJly9KQm3BJiWB
	Q/eSnd4HzKAgFOiWu8EEa0c/lFWyKbFTEhKZEnJN7bp686rNW5XzLAW7w/lQscAEGAoLnyeH+lS
	m67kSv66gDhDK216NPfYTwttXH5lYEX9m7n11mg7uDwJ9bwItdffVa6TK3VxoNQ==
X-Received: by 2002:a17:906:794b:b0:a7a:87b3:722f with SMTP id a640c23a62f3a-a7dc4e50c8fmr559109666b.3.1722844937207;
        Mon, 05 Aug 2024 01:02:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG76bxvYb5Yaoc3VRVGn0E6yzVD6z6UB6d1yYJXJ3VBKVznVuoeO63AJt78w0QvkxaZORLkrA==
X-Received: by 2002:a17:906:794b:b0:a7a:87b3:722f with SMTP id a640c23a62f3a-a7dc4e50c8fmr559107866b.3.1722844936734;
        Mon, 05 Aug 2024 01:02:16 -0700 (PDT)
Received: from eisenberg.fritz.box (200116b82df07e000a5f4891a3b0b190.dip.versatel-1u1.de. [2001:16b8:2df0:7e00:a5f:4891:a3b0:b190])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7de8d0868bsm277958966b.143.2024.08.05.01.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 01:02:16 -0700 (PDT)
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
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Jie Wang <jie.wang@intel.com>,
	Adam Guerin <adam.guerin@intel.com>,
	Shashank Gupta <shashank.gupta@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Nithin Dabilpuram <ndabilpuram@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Yedidya Benshimol <yedidya.ben.shimol@intel.com>,
	Breno Leitao <leitao@debian.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	John Ogness <john.ogness@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>
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
Subject: [PATCH v2 07/10] ntb: idt: Replace deprecated PCI functions
Date: Mon,  5 Aug 2024 10:01:34 +0200
Message-ID: <20240805080150.9739-9-pstanner@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240805080150.9739-2-pstanner@redhat.com>
References: <20240805080150.9739-2-pstanner@redhat.com>
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
pcim_request_all_regions()

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
2.45.2

