Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A701E47D1
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 11:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730287698; cv=none; b=nZGBCM/oatQeKPAeoH7MLbqhvqYnsX4rTawxJqjGkqSlb9+P1cvvmaGg0jBbl6ZipcFRsdgzz5gY9hpXo73Rth1+NLu5Mwi1wtNiQ4rHEpKNW3g+HpS+3kREZ7LhNNlPfXHVJ0DC+1/vD+uNNXHZ8httFZwdOK32HqA4NtvnGFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730287698; c=relaxed/simple;
	bh=1nBiOt4E9hWg/0zn3g4OFCyMxJcpq+nbeiFpVMj1Z9M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Aux84zroJhfYkFozqPALP1o7ZvWAG4Rn5bmZF0OTb4HX0Bm5I3fqCQvvJcdNXZ37wkrxGv3fCLU3KhfdpFRHvdb9snhFzd7GAyuLhrhVpvFYkFqvr+PRkQhgECub33V+g/HcGNEe5XcX1P+J+WZmXqVBaE7eUZk8/Yn+TlJl8hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a+Naaeaa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a+Naaeaa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730287695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F5SOWMgY56iXsI2F11A2ajlpJiSFnTM4sKk1Get+9MQ=;
	b=a+NaaeaaKJno8CT/BASz0ZJCQm9fPymncP98pfKd5eyo8DK5AQqZ/PQA8qBbbSQnH1DnRb
	haEKOAXIVjiK+X0VeWTOll+qcBjlkRGVvw8saKHwUvKT22xmWnjnZWpv2766a2ERyITIpB
	H6ErQvjINkCLl8T+Ybz69o5qaeXUnng=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-YiXK0RdGMea0oxF22Bjq8w-1; Wed, 30 Oct 2024 07:28:14 -0400
X-MC-Unique: YiXK0RdGMea0oxF22Bjq8w-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a9a1af73615so459780266b.0
        for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 04:28:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730287693; x=1730892493;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F5SOWMgY56iXsI2F11A2ajlpJiSFnTM4sKk1Get+9MQ=;
        b=DXtQlNg3xOi0PROR8k065m1ykVWtu3ZBSVLXjbFBp2Evdv9EuqcUjTRvFK6VrJu6BB
         dVYnbcYw5NGlvl2n5DtdmOtOMRvO7EvzUCC9ds55UzqJz4GpsC7obXAqiCaXDLRT4biX
         oFC58cCN8xYGFAjIHkB6pZIRdmV8D5Z32+jTJH4+558713WbH9tktHgSHFmbRfDTnyck
         j+7ur6Y+kmhZlVL/fzFwMRSVyLuVG9rrNFKwL0w9qU7mXYNFhObF/UUai+btiiKyAgit
         n2+HmLtJ9J65xhjgOKZ6JM146Zp51PhC4JontP9V+bi66tV85GGqKcQxfgJNKnzOnA50
         eTUg==
X-Forwarded-Encrypted: i=1; AJvYcCUhZJkYL3jJXLd/bmTjDxGuoqSvsSYVAgCReVnGolKnv0Y1k/6sKr5d69ABV7+OnysBfAwaQaCw4hWdFUA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1kPA0ICVdIX1taP6gSEzwnN0O+RUMio5ShMB7TjR/oOxyb4SG
	JuiTORygJkTMQQmQ12zYu9QAqvCFgtJXRRyltK69om/bPqlMpHQN5B3Io2ES9Tnm1Jib3pxd3uP
	f3q2wkNkCkrN3S6aVqu3mKmCzgEWrpjs641e2tBcvpybF3zSA9H1b10kLbKKKAQ==
X-Received: by 2002:a17:907:3ea6:b0:a9a:d52:9e79 with SMTP id a640c23a62f3a-a9de632e87cmr1484261866b.60.1730287692611;
        Wed, 30 Oct 2024 04:28:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnDINiXRUE96BlR23lv9C+OQFBClKdFZUq7ld2UJ9kzdhczUGabkr4/M1e9W23thWxvBAWBg==
X-Received: by 2002:a17:907:3ea6:b0:a9a:d52:9e79 with SMTP id a640c23a62f3a-a9de632e87cmr1484255566b.60.1730287692107;
        Wed, 30 Oct 2024 04:28:12 -0700 (PDT)
Received: from eisenberg.fritz.box ([2001:16b8:3db7:f800:98bb:372a:45f9:41e4])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9b30f58991sm557324566b.159.2024.10.30.04.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 04:28:11 -0700 (PDT)
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
	Philipp Stanner <pstanner@redhat.com>,
	Jie Wang <jie.wang@intel.com>,
	Michal Witwicki <michal.witwicki@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Adam Guerin <adam.guerin@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Nithin Dabilpuram <ndabilpuram@marvell.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Breno Leitao <leitao@debian.org>,
	Yedidya Benshimol <yedidya.ben.shimol@intel.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
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
Subject: [PATCH v6 00/10] Remove pcim_iomap_regions_request_all()
Date: Wed, 30 Oct 2024 12:27:33 +0100
Message-ID: <20241030112743.104395-1-pstanner@redhat.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Changes in v6:
  - Add Ilpo's RB to patch #1
  - Rephrase error log messages in patch #6. (Ilpo)

Changes in v5:
  - Add Acked-by's from Alexander and Bharat (the latter sent off-list,
    because of some issue with receiving the previous patch sets).

Changes in v4:
  - Add Acked-by's from Giovanni and Kalle.

Changes in v3:
  - Add missing full stops to commit messages (Andy).

Changes in v2:
  - Fix a bug in patch №4 ("crypto: marvell ...") where an error code
    was not set before printing it. (Me)
  - Apply Damien's Reviewed- / Acked-by to patches 1, 2 and 10. (Damien)
  - Apply Serge's Acked-by to patch №7. (Serge)
  - Apply Jiri's Reviewed-by to patch №8. (Jiri)
  - Apply Takashi Iwai's Reviewed-by to patch №9. (Takashi)


Hi all,

the PCI subsystem is currently working on cleaning up its devres API. To
do so, a few functions will be replaced with better alternatives.

This series removes pcim_iomap_regions_request_all(), which has been
deprecated already, and accordingly replaces the calls to
pcim_iomap_table() (which were only necessary because of
pcim_iomap_regions_request_all() in the first place) with calls to
pcim_iomap().

Would be great if you can take a look whether this behaves as you
intended for your respective component.

Cheers,
Philipp

Philipp Stanner (10):
  PCI: Make pcim_request_all_regions() a public function
  ata: ahci: Replace deprecated PCI functions
  crypto: qat - replace deprecated PCI functions
  crypto: marvell - replace deprecated PCI functions
  intel_th: pci: Replace deprecated PCI functions
  wifi: iwlwifi: replace deprecated PCI functions
  ntb: idt: Replace deprecated PCI functions
  serial: rp2: Replace deprecated PCI functions
  ALSA: korg1212: Replace deprecated PCI functions
  PCI: Remove pcim_iomap_regions_request_all()

 .../driver-api/driver-model/devres.rst        |  1 -
 drivers/ata/acard-ahci.c                      |  6 +-
 drivers/ata/ahci.c                            |  6 +-
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c  | 11 +++-
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   | 11 +++-
 .../marvell/octeontx2/otx2_cptpf_main.c       | 14 +++--
 .../marvell/octeontx2/otx2_cptvf_main.c       | 13 ++--
 drivers/hwtracing/intel_th/pci.c              |  9 ++-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 16 ++---
 drivers/ntb/hw/idt/ntb_hw_idt.c               | 13 ++--
 drivers/pci/devres.c                          | 59 +------------------
 drivers/tty/serial/rp2.c                      | 12 ++--
 include/linux/pci.h                           |  3 +-
 sound/pci/korg1212/korg1212.c                 |  6 +-
 14 files changed, 76 insertions(+), 104 deletions(-)

-- 
2.47.0

