Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B050320C021
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 12:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082515; cv=none; b=V2x1GaHhZTUPAaWzWb0HwwZDjJxL77UWIjA953kZd7Ys61naAbP63G8YxOJ0WrTDhx7aWmo58q967GKhBFdPNwwXlp/dMt69ujEgzofvfbJGnz8QQiilkKONieD26omc+reE13w15FcWQMjcWn1wW9hp0ls9MtnjqDJuy3QvFus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082515; c=relaxed/simple;
	bh=oVo6QvjNlOPmijXz1zHLQkfiuuBuqfV474IJ4VAK4xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9PlqJD1GmMqny6+1E1Jbr8zH3A0cn3qzkN+xUajptCZYimbwAvYtABVoSaJKPpRAf1aeP8SzxVtXIxwH990ybM4fOX/ZFaddshnmKleU3KiKL6RvtCJhS7wN13kTx1qXx9bU7Lj85hP5gaJX0iitfvixBtL7rMN9tCvpt+Mcoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DL0o26JC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DL0o26JC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729082512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CkbzS05iowN1f0M3rgo936jPG3Sqbtimq2cAJDorb0Y=;
	b=DL0o26JCSFFYUmhMrlq+6WKgCoJDJJywC2b+kFF5uChOo9hoRTQRg9q+PG09JwnvAKJGGI
	AucZiDJZ/GUGO4LEnk8ICHCRbyaobq4Qj1POfuYselY08S/1dhG8cc++8nE/ZXxkBGofCs
	VMXPqfnQw4MSkHgasclr/SACK+CXnEE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-hUeDzxVTPAKZMOw5qk2jZQ-1; Wed, 16 Oct 2024 08:41:51 -0400
X-MC-Unique: hUeDzxVTPAKZMOw5qk2jZQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d4cf04be1so3123855f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 05:41:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729082510; x=1729687310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CkbzS05iowN1f0M3rgo936jPG3Sqbtimq2cAJDorb0Y=;
        b=isAVmXG9zqMPnm0hsINa7VZu48oJuoGAGu7pjkX39OTaaPacq68z/TLu252hsRgTsd
         79lKnrzGy2b7dqZG5Y5R0EB0m2KxCm4jQibCHSnkwnPj2oTO26M//+IQlzANNUXMVNAU
         44nw4ef02bgz9hSoSQaBAmzpswtuCTU69Txlri3/eNICASuTR0saYW3x0wKEIZmZrnCA
         CG84w+VPJrzdVKZIgs2gFeya4UVwIzJLZKGFqgKLivYlEWpaeki3j/NC2pbmAhJ2si8O
         wvqZdYRJ3cqq9+bQFYK6rfn9AIUi7Qk9uFpaeo9uY6cbZUn+ruvhOO9iBJoFxcH9oo8a
         jlUQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9smWqPrysqqqj3hgVkHUR89CXZp0hjvZJzqdiDyHQ1LNNfQdWiZbw6vZwJvwjp25IAbGPAg44PtL1IQ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbUJvetZHR/HCoJ4hfvQxEdak6wAvHzNgrJ/x16Hmag+fVtiKC
	wdlUzNNph61345rr6nWtCVKapizqra1ZTAPeEKrocZBoBf2EvwFyu8Y8KHDxJj/QmbYPS0YsFbz
	49NZPEA7YyogwG9UtyqX42f2cWOkD3+G3wkE6Q4CE0p1GcOZRB8mKdmIbMpdjhw==
X-Received: by 2002:a05:6000:1101:b0:37c:c4d3:b9ba with SMTP id ffacd0b85a97d-37d5519998amr12212277f8f.12.1729082510434;
        Wed, 16 Oct 2024 05:41:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFK1gqBE/jl0UfBUACkKIQmrpKFH7ZX+GOEOp/3UeRC+ZbEAEi2K3NnzF3HBuuhY4BbNlHnw==
X-Received: by 2002:a05:6000:1101:b0:37c:c4d3:b9ba with SMTP id ffacd0b85a97d-37d5519998amr12212213f8f.12.1729082509847;
        Wed, 16 Oct 2024 05:41:49 -0700 (PDT)
Received: from eisenberg.muc.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d7fa8ffd6sm4246879f8f.50.2024.10.16.05.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 05:41:49 -0700 (PDT)
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
Subject: [PATCH v4 04/10] crypto: marvell - replace deprecated PCI functions
Date: Wed, 16 Oct 2024 14:41:26 +0200
Message-ID: <20241016124136.41540-5-pstanner@redhat.com>
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
2.47.0

