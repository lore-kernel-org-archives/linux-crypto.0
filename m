Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D1D14D290
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2024 08:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722844933; cv=none; b=k6sCu708GD1cr0Q1hB3+QQDVqbDkbpUIXYY4WcM91/N5JvKYlFcl/IJGQISMzmvPCc383u2ra81YPGUc32EcCA3Zkj4uelt94PE5kZBSoxLqyFcmG/ua8S0Poge1R+AES81MonvPx0d4WsOkh5xnAFvqekfyBhDAQTjSkxe26kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722844933; c=relaxed/simple;
	bh=zFYt4YA/nxrpBwmvCREd85ce7Gyci93GVdK3Ep0M2pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBJ8CuQpYdHyisWpfWFM5UQEKGTeOh5SgmQFiVpDiRcLj7NrF/RXIsIADd03mEDyaTwsTag/9aHYdFiIuxGZkJfPAdD9ledPo1j/q9Wz+gzusjpg+1XYDydkSaZYAFiRo9j/Sl60DT9AX9rFSgqJpM/Bs82BJyhGiVCraNJBv0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bEgTZ285; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bEgTZ285"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722844930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=18fF+PB7j6Y1mDUBH32CYamjOEignK7RbqTPKzQv2/I=;
	b=bEgTZ285B2m3nrSYwgg8AlNP7l2KHr6ILDI6y3gRdC64aMkfKXoIw984HoXUIIQPTsGfK1
	FjMzRhWWzqpqmbJvsqrnZWVoKMgeiIU/1Eybvi/q6tiR7NazRhbbmUDOo4PB71/cq6IDno
	mXfZmC8PCbuZlYGo7BbMXSiZEBNj9ec=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-otUZ96GJNte63vX4smIaJA-1; Mon, 05 Aug 2024 04:02:08 -0400
X-MC-Unique: otUZ96GJNte63vX4smIaJA-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5b78e856a85so608129a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2024 01:02:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722844927; x=1723449727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=18fF+PB7j6Y1mDUBH32CYamjOEignK7RbqTPKzQv2/I=;
        b=KcV1+3aI118N3TxFj1J6jlwAb54zLQpuRa+g9zYfq0lqVFYCgDSGgp2xuCe95M2y53
         nsFuKcV/I0AD4oXFisfi7AGq8iQruI/Ljrfvm4wesD3RByFd4RMAFPCQlVDCGoBP/3to
         Av2hZ4z6+t7LocrW8m+EYUCFUJkWkzhC/6tJSz/SXvuyR0ZHOADuyVFtoPLXMVTQdC5C
         0YqX9+tdFGfaaqnHtUWhtRBqBpEBkQLbLrRS2YBNF59vWtzW2AQl2sBEDjMTKKR09mnv
         Kw8gAe4GyuhNGhul9FD6zKRP7Ecdp5dS4+KHxsaMqzgwDRdJ3HQ7fdY2mmU7yvL94RMd
         5AIw==
X-Forwarded-Encrypted: i=1; AJvYcCU3s5iVtmmDzW7AQpnORWPoVKyhZXe50tpXfQNYAwJdd7ZvcsdiGO1tEDP02wZchkmp6zke0s/flFW8H4s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxhOTYMwIjcnG7ur3TqmGq1GAXVvGZ5pMAtp8UdbiZoW/93M+g
	INlS/hIIy3CaofiXP8PSzMwsSGOJyGm4zR5z0mnZb5wigaGpW3EuoZzLDIuk/r21TNF4zYIyo8E
	0oj9Y0dL0RGHjgdPPNJRauJ1f+4XUnO+syQLBxblXfi1mixlKKDUWdY2IDcBJDg==
X-Received: by 2002:a17:907:3da7:b0:a7d:a4d2:a2a7 with SMTP id a640c23a62f3a-a7dc4e50c01mr456319366b.3.1722844927330;
        Mon, 05 Aug 2024 01:02:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkXCT45DdZBHWQzoU0ORUWv+2ODBb2GUKjo+7GIEAxb39igJSvCRB2n7e9CZjTjRwueB8GGw==
X-Received: by 2002:a17:907:3da7:b0:a7d:a4d2:a2a7 with SMTP id a640c23a62f3a-a7dc4e50c01mr456317566b.3.1722844926788;
        Mon, 05 Aug 2024 01:02:06 -0700 (PDT)
Received: from eisenberg.fritz.box (200116b82df07e000a5f4891a3b0b190.dip.versatel-1u1.de. [2001:16b8:2df0:7e00:a5f:4891:a3b0:b190])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7de8d0868bsm277958966b.143.2024.08.05.01.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 01:02:06 -0700 (PDT)
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
Subject: [PATCH v2 02/10] ata: ahci: Replace deprecated PCI functions
Date: Mon,  5 Aug 2024 10:01:29 +0200
Message-ID: <20240805080150.9739-4-pstanner@redhat.com>
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

pcim_iomap_regions_request_all() and pcim_iomap_table() have been
deprecated by the PCI subsystem in commit e354bb84a4c1 ("PCI: Deprecate
pcim_iomap_table(), pcim_iomap_regions_request_all()").

Replace these functions with their successors, pcim_iomap() and
pcim_request_all_regions()

Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Acked-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/acard-ahci.c | 6 ++++--
 drivers/ata/ahci.c       | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index 547f56341705..3999305b5356 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -370,7 +370,7 @@ static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id
 	/* AHCI controllers often implement SFF compatible interface.
 	 * Grab all PCI BARs just in case.
 	 */
-	rc = pcim_iomap_regions_request_all(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
+	rc = pcim_request_all_regions(pdev, DRV_NAME);
 	if (rc == -EBUSY)
 		pcim_pin_device(pdev);
 	if (rc)
@@ -386,7 +386,9 @@ static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id
 	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI))
 		pci_enable_msi(pdev);
 
-	hpriv->mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+	hpriv->mmio = pcim_iomap(pdev, AHCI_PCI_BAR, 0);
+	if (!hpriv->mmio)
+		return -ENOMEM;
 
 	/* save initial config */
 	ahci_save_initial_config(&pdev->dev, hpriv);
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a05c17249448..905af6b68d80 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1869,7 +1869,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* AHCI controllers often implement SFF compatible interface.
 	 * Grab all PCI BARs just in case.
 	 */
-	rc = pcim_iomap_regions_request_all(pdev, 1 << ahci_pci_bar, DRV_NAME);
+	rc = pcim_request_all_regions(pdev, DRV_NAME);
 	if (rc == -EBUSY)
 		pcim_pin_device(pdev);
 	if (rc)
@@ -1893,7 +1893,9 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ahci_sb600_enable_64bit(pdev))
 		hpriv->flags &= ~AHCI_HFLAG_32BIT_ONLY;
 
-	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
+	hpriv->mmio = pcim_iomap(pdev, ahci_pci_bar, 0);
+	if (!hpriv->mmio)
+		return -ENOMEM;
 
 	/* detect remapped nvme devices */
 	ahci_remap_check(pdev, ahci_pci_bar, hpriv);
-- 
2.45.2

