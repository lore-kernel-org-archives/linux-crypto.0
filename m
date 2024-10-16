Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55B6210198
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 12:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082522; cv=none; b=OYYmHx0gMalh6ZoNXAzFo4/C6bvjoygx0NIo+Tm1Kap48zOd3yb22IIHLKdAH6mz6W3jPqaXny1aVynE7aQC6kf/x+aTZG0g4C57ZwodNaB0eHUmtWgHUg9whGf8CSxXsZlzq7bUZVKOzfNir7mttAo65RbTVPwCjKlZxaeoBmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082522; c=relaxed/simple;
	bh=RRyy0x2PiBX++bfjCGlA/9AZOm7xwGM5wtpW6IKXyVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVLJ6/EN2pQrw32qMLOvmqyOem9V1IfGlYLKbUMRiBfuLBXP1O/0xNtfPkpyEH75a+mcuGoNmpfxtyDNJoYpKj+9a+SLAHZlE6kw9+BE7Ik1KsWzAwo6hL9o+qe2gWv9AzDTd+i9DWiY6CCpW61gJNxLlzN81XTtdiiPKroMj9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cNevUTJU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cNevUTJU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729082520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WxQ5Vib/1yt2THpDXWI2rA9CY+VRhy0DxtAlfuLaLe4=;
	b=cNevUTJUKr8iMqsBFUukQlXA3o/oX6Sk0COTfe51LO54XqsoB0pLirUm9593bngFdS0ZmQ
	INbwfehcCLO/1uCYs9gVJIXqovNbY+HSRyZygZ+aUXHkFBxp/FvOpDPCGvDelWIc4dvzjH
	Ej5+/uIufGwRWHNrXuksKLJPqSjT5OY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-BeST7zcsOg2cxNmu7CrNhg-1; Wed, 16 Oct 2024 08:41:59 -0400
X-MC-Unique: BeST7zcsOg2cxNmu7CrNhg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42ac185e26cso41379695e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 05:41:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729082518; x=1729687318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WxQ5Vib/1yt2THpDXWI2rA9CY+VRhy0DxtAlfuLaLe4=;
        b=lAqo8ZV+QaVBse2Ai5Idn55OWUWzPiqY5/vk5B3WDQge/olT8qE16qjLF2N+Q9bwcT
         RjUiMOLuLR8/e/tJcFlG3zEugtxEwrQt+g0PZkvJ9aSfL2iW/1m/5IUyTXb9H6NndFdf
         nUEw5Dmb26IALXUjxGyPddcMaCD6b8EsdqpY5M0vnGjmmn33gCmImCmqyJsOHBR05SrX
         CWfuQfzcKx+EgrafzwSY3JgQRQ0CQLUG1HAb+kSbs6WEmeRQ4rCLb6jC1co+4QC21l/c
         hdWmGBRovp4SojA7zPAewDiuiqAY99zptGmCgz0+iIT43VUiHV6MRyTOnOyEt6c5tAMy
         9VGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnlc2QoiLVrmNcALN0++BnG3H8MpbJNHoSHsODVGSfQgEmabn/scfUbKpNtQyzkG11TjlGNRjBF4vs36g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeWydR1Vtt7Ant7DEpI99EjCFciLnDf6PHWD6xTOomHFuepWSq
	ZrvMgOPAXRtSZ8kogdAKr12QyuFa4cjAJ2KqejJTOp5aoalxp7kZKIfEQL37o5CL2+Vtxyi818M
	ChFWfhehq4D2xLRL4cNDd/MfHAwTRf8HW0DHsxPbJQ+xeH7c/krC6vQ1lvyUw7Q==
X-Received: by 2002:a05:600c:3b99:b0:426:647b:1bfc with SMTP id 5b1f17b1804b1-4314a3abe93mr36586755e9.30.1729082517797;
        Wed, 16 Oct 2024 05:41:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHw2sV/ClbQfdvwspcTkrZNz/VyaEPQ2ipBhPy5Ayv8A5HEwXPUtYjfukoE6IW5o2vvgmQFRg==
X-Received: by 2002:a05:600c:3b99:b0:426:647b:1bfc with SMTP id 5b1f17b1804b1-4314a3abe93mr36586155e9.30.1729082517278;
        Wed, 16 Oct 2024 05:41:57 -0700 (PDT)
Received: from eisenberg.muc.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d7fa8ffd6sm4246879f8f.50.2024.10.16.05.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 05:41:56 -0700 (PDT)
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
Subject: [PATCH v4 08/10] serial: rp2: Replace deprecated PCI functions
Date: Wed, 16 Oct 2024 14:41:30 +0200
Message-ID: <20241016124136.41540-9-pstanner@redhat.com>
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
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
---
 drivers/tty/serial/rp2.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/rp2.c b/drivers/tty/serial/rp2.c
index 8bab2aedc499..6d99a02dd439 100644
--- a/drivers/tty/serial/rp2.c
+++ b/drivers/tty/serial/rp2.c
@@ -698,7 +698,6 @@ static int rp2_probe(struct pci_dev *pdev,
 	const struct firmware *fw;
 	struct rp2_card *card;
 	struct rp2_uart_port *ports;
-	void __iomem * const *bars;
 	int rc;
 
 	card = devm_kzalloc(&pdev->dev, sizeof(*card), GFP_KERNEL);
@@ -711,13 +710,16 @@ static int rp2_probe(struct pci_dev *pdev,
 	if (rc)
 		return rc;
 
-	rc = pcim_iomap_regions_request_all(pdev, 0x03, DRV_NAME);
+	rc = pcim_request_all_regions(pdev, DRV_NAME);
 	if (rc)
 		return rc;
 
-	bars = pcim_iomap_table(pdev);
-	card->bar0 = bars[0];
-	card->bar1 = bars[1];
+	card->bar0 = pcim_iomap(pdev, 0, 0);
+	if (!card->bar0)
+		return -ENOMEM;
+	card->bar1 = pcim_iomap(pdev, 1, 0);
+	if (!card->bar1)
+		return -ENOMEM;
 	card->pdev = pdev;
 
 	rp2_decode_cap(id, &card->n_ports, &card->smpte);
-- 
2.47.0

