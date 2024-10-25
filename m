Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CE620F3E7
	for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2024 15:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729868462; cv=none; b=LMU4LnCAhvm7GamkvCZnywdLBiOlJFiRcVYnnGVk+/lzh324SXviICOdjSn2AunqXttt5CvOxHsPI0TdjN25gcDagHKLo5x/hvK42Ak8JaSsMdQTUltGzeZf7/VvlIw2flymdxNqDt33FwWClo1bK9h37YedbmUk/UvgAXOStwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729868462; c=relaxed/simple;
	bh=x2AO4woPu9H2aNxl2TylFo7TB42POmIv8HM+dl0TTWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7vAsTI/Trfil8qLaf6teXtZSMCKSnci4maH8hr0cofDO6OicWm3t7+dHxlGt4ZNU5djES/cQWklKdB8i87NcPpSQYgisXHmoEf6X0ogFzHas4NbCp57H7O7KS3FRlNh6hFaEi0KThb4MS1UOcLgXonVJAj8LVPsSqVvLS4qxZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OlhdjYta; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OlhdjYta"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729868455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vZ55uYUf11n7K97VlTpkijb2Akz5QQrQmQxQWIeLt9U=;
	b=OlhdjYta2GD7oF5PEVnAb7w6bqWc2yb4RQQq4GwM8lh0axPXcwrlhNo9YFpwnWGM+SDor8
	CZLCrKLRKwAx/tY1yCy8cf1HxssWIoE6XJtdXUuVA4kAxILX9kFt0aQl+5KHqEkxGQN6HA
	c79JqP5DMWUXlPCf1MDu4U89DUN8Ho0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-260-a29Q1X58OtSJ7DPtqaLSRA-1; Fri, 25 Oct 2024 11:00:54 -0400
X-MC-Unique: a29Q1X58OtSJ7DPtqaLSRA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d5116f0a6so1025216f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2024 08:00:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729868453; x=1730473253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZ55uYUf11n7K97VlTpkijb2Akz5QQrQmQxQWIeLt9U=;
        b=aZkhXIeTPM+YAD3dGB1SIUxrhNhMMhmB5/jYpiiWGFMlU+F1dbTq3p/tpxkiXp7yMp
         tgZqbGp8U/zToAxfYnI3Yq0+GPfAEyzBb/Fg5+2cfcDTJeYsbRVH0ilSEbrANQV6YmO+
         ZNhYnu5MKKgF9eq9l3v4rAwFpRVs/04pjmL9sBq8FYDvu+28Y1qaMqNhUwPhm9ZUWfBY
         Kk8PJD1BvOygEDxWQkVYX+hvQFkvofzsYkM90Fg6IsU2vKJIvROlvprm8gm81FU0lcHk
         mwt2txfIciPAtKNjp+5wpTzt9GomMbuqVn9DTD1BOZ70lDx4ai/Q6MUP+LS/96yAv18H
         Ti+w==
X-Forwarded-Encrypted: i=1; AJvYcCVlk85mQNa3wmA4F0u6z95WV/+4fsAU9CpQK6ku9EByvqrwEZMhwGIzDLEHyFxGlqCwQDdaR0IRl+q7dro=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoCttuzWukk6Y6R0TRe1TM6n6O8qiDCJ2d9DWdhf1FQ2q+uE6S
	lcSIYm7SgT8xRrxVto2tyz2N3rjsKxe7KO4LjDjULg+Ozp+YqNhKee9We2vb+CEw5TRRia4yMQE
	eE9Ii6S9J2dwRFyVP61rMEbH+l8853Z7N4vYQofis9hL8QKaHvuXzJ0G0WEztnQ==
X-Received: by 2002:a05:6000:178e:b0:37d:4937:c9eb with SMTP id ffacd0b85a97d-37efcf05ef0mr8444752f8f.21.1729868452834;
        Fri, 25 Oct 2024 08:00:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHuZZsnRNqLrqF9GwOZcr5qbeM2dWtXIkrXTvrx9EisXT4UszvhL4K4oEeTzFUCaGcEshlLw==
X-Received: by 2002:a05:6000:178e:b0:37d:4937:c9eb with SMTP id ffacd0b85a97d-37efcf05ef0mr8444655f8f.21.1729868452087;
        Fri, 25 Oct 2024 08:00:52 -0700 (PDT)
Received: from eisenberg.fritz.box (200116b82de5ba00738ac8dadaac7543.dip.versatel-1u1.de. [2001:16b8:2de5:ba00:738a:c8da:daac:7543])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b9216fsm1727189f8f.100.2024.10.25.08.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 08:00:51 -0700 (PDT)
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
	linux-sound@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 09/10] ALSA: korg1212: Replace deprecated PCI functions
Date: Fri, 25 Oct 2024 16:59:52 +0200
Message-ID: <20241025145959.185373-10-pstanner@redhat.com>
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
Reviewed-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/korg1212/korg1212.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index e62fb1ad6d77..49b71082c485 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -2108,7 +2108,7 @@ static int snd_korg1212_create(struct snd_card *card, struct pci_dev *pci)
         for (i=0; i<kAudioChannels; i++)
                 korg1212->volumePhase[i] = 0;
 
-	err = pcim_iomap_regions_request_all(pci, 1 << 0, "korg1212");
+	err = pcim_request_all_regions(pci, "korg1212");
 	if (err < 0)
 		return err;
 
@@ -2130,7 +2130,9 @@ static int snd_korg1212_create(struct snd_card *card, struct pci_dev *pci)
 		   korg1212->iomem2, iomem2_size,
 		   stateName[korg1212->cardState]);
 
-	korg1212->iobase = pcim_iomap_table(pci)[0];
+	korg1212->iobase = pcim_iomap(pci, 0, 0);
+	if (!korg1212->iobase)
+		return -ENOMEM;
 
 	err = devm_request_irq(&pci->dev, pci->irq, snd_korg1212_interrupt,
                           IRQF_SHARED,
-- 
2.47.0

