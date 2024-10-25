Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED7420D50F
	for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2024 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729868458; cv=none; b=lqy3HihXQvblrqEgg1DrKGrYOmOYKqlHSMyS5toR7C5BzlcePXIdaYVEJhtMWphPGrPZc5+wTEaTkWZbFSmXgQaKExJcQnTkBdCVFdqCUwpvv2haD2ufR+l6oi171Uni1TStwCEjQ+QOS2osT7G/97BkZ+3TEfsCZ1Oixtz3eOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729868458; c=relaxed/simple;
	bh=KRhL2deOZRHNfuo7/CizyodCPj2p+YqlhuhaNJFSYuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCzsh1owjiFhvAK6jm1f73YVtpC059RspFFXmfS8tnNmi6Fh3CVUh0eYCZkFzHgfvMnzq4C0+Mj/7Y6GBtTz30fTb1ZjqDDfRFHDdUkAKFj/OpEM/zG/yA7j/DBRf9F4p8vFh22+qqkpdiQs1E18btPiAOW7TL2VRYQAtpQFu54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cx7wJd4x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cx7wJd4x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729868453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oH83zA24aoDnwtpuZ+wclLhu+n7qeaaZUv7+D6hfs+0=;
	b=cx7wJd4xp0QnxOyuePxlOsGLNF8VXGGUsQAbcutm3phFtaDtcl93+Nrm65kupyQUnrS8Z8
	T1PqHfygBNfx6EWJi0/cZA2idFXpfzn0d8hUFsmbmS//rAPNFEDYMK2OpshlsRQgVSZ2UB
	RgSLkwmimcpZPymqWbpDd4h5XYhQpIs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-XIFj8YomNaiVmP1-W2LIUA-1; Fri, 25 Oct 2024 11:00:52 -0400
X-MC-Unique: XIFj8YomNaiVmP1-W2LIUA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37d45de8bbfso1474069f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2024 08:00:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729868449; x=1730473249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oH83zA24aoDnwtpuZ+wclLhu+n7qeaaZUv7+D6hfs+0=;
        b=auxVR8Mc8ObJw60tAc6f/7dbrJ/IK7VRPiBDxLf8K+DrfyoewURI8OdoDwlYjFC3vc
         wKUl+SprlUXvW/0PCXIz4UxcPf9Ux8AlFGv0DeEqH+2lBHrKZlzX+KW8squeWcE2e4nw
         sT/qWn0OUp/yJIJNcGP0uxQrOmQwpNFzbfriQmBV8gFw44+2NCniYCx5Fj8itVGDznNb
         Njnzcn9VcEiqUiVqWcOUZAbUPGxnuVSmXMn2OBBGfVVa+WF8HSLR8/1E3sUoK3LO6RrV
         Dp+21jGGCoFmJF8tKsckc/ctb6eel7yxa1rhisdXJM1h0nOYZty6KFfXrZG8ekFvYvtF
         Y2oA==
X-Forwarded-Encrypted: i=1; AJvYcCUWMR9E1/rNnjDmxNpOQb9qXm3nv9sb63zTeQV65ATOs/5I2RH/zFhNugzGtl2XKI5AzIlF6yp8hzhP62g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF4OGgwARPw5CYv7/91BaWj94eWBvOG8+KBDOyk6b/0kxuAYbV
	7Eg6ue5NoqR6rLFo31RHRUbjhmW3oz64e6WE1vGFlw5450fGfrms3h/jpScDgi3ZwMksTyFwp4T
	BMS5dh60cSik7L2bmwW1fdXMjRcwjYPe8Y/ggzwaixMXDslima7xW/xRKK0lh1A==
X-Received: by 2002:a5d:4e08:0:b0:37d:95a7:9e57 with SMTP id ffacd0b85a97d-37efcee8c28mr8039795f8f.2.1729868448846;
        Fri, 25 Oct 2024 08:00:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1JzvMg8cr6yZm3DrYA37QNNdDoszBRAqVfY9P7gwJlqkM8x7H1LKy5SQs7DHzYJeG4eaDSg==
X-Received: by 2002:a5d:4e08:0:b0:37d:95a7:9e57 with SMTP id ffacd0b85a97d-37efcee8c28mr8039706f8f.2.1729868448084;
        Fri, 25 Oct 2024 08:00:48 -0700 (PDT)
Received: from eisenberg.fritz.box (200116b82de5ba00738ac8dadaac7543.dip.versatel-1u1.de. [2001:16b8:2de5:ba00:738a:c8da:daac:7543])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b9216fsm1727189f8f.100.2024.10.25.08.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 08:00:47 -0700 (PDT)
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
Subject: [PATCH 07/10] ntb: idt: Replace deprecated PCI functions
Date: Fri, 25 Oct 2024 16:59:50 +0200
Message-ID: <20241025145959.185373-8-pstanner@redhat.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241025145959.185373-1-pstanner@redhat.com>
References: <20241025145959.185373-1-pstanner@redhat.com>
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
index 6fc9dfe82474..544d8a4d2af5 100644
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
2.47.0

