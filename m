Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68881553A6
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 08:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723796617; cv=none; b=fkC/0gzJHCbO1V5DyQDcB6GjuLVybWpRJSn6u0kZujHGTvRCNa+TJ/MuRjcXZdgs1Ztso6ThMl8fq9mBwEPTa9+Pa3PCiLcfcpXhnnCQ9czomd2Y4zW3IzrbQOP+eT5eBRM9Yt20xhxkv/2Ih0RBPh8xQzth1Zt7yrfeGjGIlwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723796617; c=relaxed/simple;
	bh=vRi2Dr8oYOl/Dn3cbKasTreqlBKKIRjGiyZnnXF2ueo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMGLhEAGepxivLDKFDf1RirFDnrMvh+DxswhgwyIp0aGmfDFNzPtMUIZ2cRA4C6ZqFPxz3PrWCD+nvgaq+CkAHJwmvRl/7HTPXQzSFLvxtTI+CpWUpGNDRemb38Ycae7IXW5gws3JO+IlNeAIAPpCZ5N7CcYMc8VQmDm4izIMoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I0ALCTN8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I0ALCTN8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723796614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=18rNye0tQ5OucjTqtNIdO+/X5BNRh9H93PkE7JosHtA=;
	b=I0ALCTN8g3F6GTxMIOOHFib5ayUMaa3K/AuhqLpElykP03VXYQmEiReR9yolVzhEUZSgga
	acLxgTEdIm5AqV30bbFyLCqp1ewTFV/wa4d2fpCtitFSo0oSjJW4OnwLPN1NZfFXArQuBI
	SWyYflQATDGkzXOmj7TCtKHO34Y95Dg=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-ql53BYAjPKSZLtSyL8sIdg-1; Fri, 16 Aug 2024 04:23:33 -0400
X-MC-Unique: ql53BYAjPKSZLtSyL8sIdg-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52efa0a04e8so310970e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 01:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723796611; x=1724401411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=18rNye0tQ5OucjTqtNIdO+/X5BNRh9H93PkE7JosHtA=;
        b=V6z2Eq8Ydzn8Lzwi3H66rZTuHI4Afp3/bYj335lRHrGuuj7T/aXo+ZR9pqJawaTSro
         rDOipvzz9MRbSXxVzypI40lHg6vBNacNUFh4HFuK4veEhM9oeU/sUMn1pmU6fPwBplKT
         1jFtfGtv0CiQQn8DrwaRynb3rd8qFsbp+KCnd2K1hqAkofkkLCtaZep3leNdGO+EzSCc
         Hsow7YVd0lw1V+l9iNC/ZH+Uo3h44HiuUidBDIlJtIVQbiHO0PsQsHX2rs9K4i99zCRr
         2bC0RUAyL9gRcDY2y7xCogne6jwz13szDxSix24GlC0vax/FHqeMYf0Ve+l8dI/EOVuL
         QYfg==
X-Forwarded-Encrypted: i=1; AJvYcCVSn4uJq0wwp3YBCtXN9hWnKBpNnMK0hSlhn8Avrusb7ux8ncJScqXn8kYApSu2jF1o9B/oYobKdq/7af2caLAaEz3WXs/keTOv3tr0
X-Gm-Message-State: AOJu0Yzj8ny4rOmQ5wiTLmW2FU3B1HROfZT5w8A00Qs1VcO57HmHZ8V5
	Trk/7fKL3bwlXoaAocIahmXVhCvNUNIw0vJIy6etDEU8ohR1jp3ZPpjlzdORiDQsmQs9wiuHS6K
	2x+p/uQOZdOp0OQtFl+RCWHp+HtOWd72n3nMVx6FiY6w6sWxQQQYfraoONS948A==
X-Received: by 2002:a2e:bc16:0:b0:2ef:307d:17 with SMTP id 38308e7fff4ca-2f3be6e6debmr8623951fa.1.1723796611385;
        Fri, 16 Aug 2024 01:23:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1IvrWWZfR+lgeOS08d4L6C4BkPOCAMrmkf0L9QOweXgsFSvigKNGw42Y5Pcrt7oEZghU4ww==
X-Received: by 2002:a2e:bc16:0:b0:2ef:307d:17 with SMTP id 38308e7fff4ca-2f3be6e6debmr8623641fa.1.1723796610906;
        Fri, 16 Aug 2024 01:23:30 -0700 (PDT)
Received: from eisenberg.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded367ebsm71461355e9.25.2024.08.16.01.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 01:23:30 -0700 (PDT)
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
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH v3 09/10] ALSA: korg1212: Replace deprecated PCI functions
Date: Fri, 16 Aug 2024 10:23:01 +0200
Message-ID: <20240816082304.14115-10-pstanner@redhat.com>
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
Reviewed-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/korg1212/korg1212.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index 5c2cac201a28..b5428ac34d3b 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -2106,7 +2106,7 @@ static int snd_korg1212_create(struct snd_card *card, struct pci_dev *pci)
         for (i=0; i<kAudioChannels; i++)
                 korg1212->volumePhase[i] = 0;
 
-	err = pcim_iomap_regions_request_all(pci, 1 << 0, "korg1212");
+	err = pcim_request_all_regions(pci, "korg1212");
 	if (err < 0)
 		return err;
 
@@ -2128,7 +2128,9 @@ static int snd_korg1212_create(struct snd_card *card, struct pci_dev *pci)
 		   korg1212->iomem2, iomem2_size,
 		   stateName[korg1212->cardState]);
 
-	korg1212->iobase = pcim_iomap_table(pci)[0];
+	korg1212->iobase = pcim_iomap(pci, 0, 0);
+	if (!korg1212->iobase)
+		return -ENOMEM;
 
 	err = devm_request_irq(&pci->dev, pci->irq, snd_korg1212_interrupt,
                           IRQF_SHARED,
-- 
2.46.0

