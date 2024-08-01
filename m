Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75091BDA89
	for <linux-crypto@vger.kernel.org>; Thu,  1 Aug 2024 17:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722534405; cv=none; b=f/UzmJLjbFy74ekC9+/qy8L36TwvQejECm7WymvaT4A6CUgeAcNYvB9jvMvPDcNtzscJ99DRyCWonTtnfS+UWeLXlF1X5l2syioiNME0hLeLky+GleZcfiClliDjLJN71xUQnSykLtxGvowI//EzwjNU1LXo3dA7xt7L5JAti/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722534405; c=relaxed/simple;
	bh=0LeaHW5FeDo/J1kHqKb1puWkhgMcN88tyrLkKTALSn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOjld0tPWyrhoOthCFhaMPuOQr5CYc/n4ju1p828tLARXUdltdJntoiacH3vBiBH2aQnd8F2uZYvSXvdWeJTBBAMegUjZbLhlYGhhTIOsxkiy/tvGnjzd1zBOBaZz83q2Mrre08V8MIjKg0mdBEXeHdVP4S/WSUm9NJi66E5CaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a/TxZPQ+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a/TxZPQ+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722534403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qDhVp6QnBZ1g/RzszT8Pq/d9t6N0/RLenYs6FD2bY+k=;
	b=a/TxZPQ+GIPLT3uc3TM3i8vcc1Z2lBzrK4Hn/EcNiSFGLi1L9jbzTXDauI1RaYPdIDqInx
	9K1AcyDbjSBDDrnE+9M4pgDjGxMCT5I8XOCl9WgdG3efFxS/9id4c3dLKxoA/JTACR7XmX
	VpM/RAumNEgUl9DyCTqlrK7yb4wpqcQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-8uzF_wUAPpOsuHlk2k4ipQ-1; Thu, 01 Aug 2024 13:46:41 -0400
X-MC-Unique: 8uzF_wUAPpOsuHlk2k4ipQ-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5b78e856a85so45713a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 01 Aug 2024 10:46:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722534401; x=1723139201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qDhVp6QnBZ1g/RzszT8Pq/d9t6N0/RLenYs6FD2bY+k=;
        b=Mj3DT8wtknfeOjn/+tkBfhaHyTeyIw+qxcJ/+BbY386GXGh+PhLQzzK2PCBq8OliCn
         ohu9QijZdQMCnzd+u4vhzZh0GVFJzcJE/KOt3jG0pFNmSOze/MTJVmkjklcFeGf8wePE
         u4S1c75geOGFuo28EmqG6yKoGlZaktaFr6dkguNsMo+PVK6SZ7KxFRsuZA4WMvsiwUGF
         KCRyrgYYrtlWoFf0MnBzSOHvHoYwvQLnh5IEkUEMYPSAkXVWo7wCD047Aa8oT74WZJos
         8cZsQGiIvL4hHVXZN7yXb+3zuCUv0xLC0KUNwA4IrcibmuO7lGr8QV2YqFsZZ+A3kZ3S
         uWmw==
X-Forwarded-Encrypted: i=1; AJvYcCULOj9CijJEKlyylQKZYZNusDsJVCuXWFFiq6U4LwO7U6bYY84gOXYV0Fw0EsQEYSKad3mXjUftRhLZAnc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn/XYwWhOv+EpsesAglD6qjFyANC9LiUMYaQE5Asv9lhYkteR/
	BV+369rllkTJAciCFVNUmQBJe7AOnqknMMJiOhZ8JY2nnrQBSFndh6cxMnpAidV+nYT2u7vzvSC
	F/vRq61dOr8Qqp46F218LsKt6rfqXMlBVVkgPiepzHEErRT7Tm2D86yCj5zKJgA==
X-Received: by 2002:a17:906:6a0f:b0:a7a:9447:3e88 with SMTP id a640c23a62f3a-a7dc51bdf14mr37331166b.10.1722534400677;
        Thu, 01 Aug 2024 10:46:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgF3Sc4W75RJOJ5PBpT9M4a6sO2Rp0mbMsz9U0e7mL5uSzBLd6vq274D9sQmuuim3NQQHQ+g==
X-Received: by 2002:a17:906:6a0f:b0:a7a:9447:3e88 with SMTP id a640c23a62f3a-a7dc51bdf14mr37328866b.10.1722534400301;
        Thu, 01 Aug 2024 10:46:40 -0700 (PDT)
Received: from eisenberg.fritz.box ([2001:16b8:3d4b:3000:1a1d:18ca:1d82:9859])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9e83848sm5339066b.177.2024.08.01.10.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 10:46:39 -0700 (PDT)
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
Subject: [PATCH 07/10] ntb: idt: Replace deprecated PCI functions
Date: Thu,  1 Aug 2024 19:46:05 +0200
Message-ID: <20240801174608.50592-8-pstanner@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240801174608.50592-1-pstanner@redhat.com>
References: <20240801174608.50592-1-pstanner@redhat.com>
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

