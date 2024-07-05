Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822A85FBB7
	for <linux-crypto@vger.kernel.org>; Fri,  5 Jul 2024 17:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720199600; cv=none; b=g8E92j4tEHE9do3fiwQeYcsacsn8puI3cxLe+L9J5WWnMsncPjtfTfbDjSaV2pH6KXiLiAuODLDyF1yr86uja5ZzkYS64ruyOmX8xNi8iP5ObYJlMC+nxl8l3OWcHg++oHRxSlrDNxw5x8TO/rdeUPMdbtnP8oqwGd0c1imA5To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720199600; c=relaxed/simple;
	bh=MGqxnzXWY4KZvwiDYQYj4HQsDzTKyQYLIDsAsoUBnhg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TRh8l4Sm5c/2sZobyb69oXqUuLgSwEvA23aGTqSE/hnr/BkalGNkYmjR+hmEDeiL25CujHTAeKaHwbo5/Q/vlVZI7mJAAUxbE4EJDthhKBPp5lUavcDgFegjANYzxxcID9OjQ6HCxQlan9JjJ5T5looYLyp7BDM/s8NXww3VTqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=JSj7gvt9; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="JSj7gvt9"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-70aec66c936so1452250b3a.0
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jul 2024 10:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1720199598; x=1720804398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VxtgifDqP3plNOk1Sgu1r/FftIXYY9tiHgFci5H19sw=;
        b=JSj7gvt9b9wU5LlAEoLOaXCnwfdpcYl+NHenwrGkUAkP0V8G3L3npKpjizV1OvIqJa
         d37nFJvx+U8IOZ8NKyQsmU1py3NN0m2Z/nNN9pB64f8qrw1X9IUTYruwc/wzOcA9JjA7
         IBREwLw3ZhfO86sxunqrtESFSBDUhEPX1ripA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720199598; x=1720804398;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VxtgifDqP3plNOk1Sgu1r/FftIXYY9tiHgFci5H19sw=;
        b=ZLpYIh+RS0NSPu8VDVIq72TrLmD3wD/pAErdq7GgS77fdyN0peZnXMmSv+Izl8Hsd2
         BRUHJeu4iRKhDKKInOLDKx3OQF+97pKBRc8RlHKMX5f7PG50bhrKvK8NpSXzcUh3VD57
         a8plF/Avf50BzKqf9sz629HcAoa0aR0HmPp3kUgeLOj7WCjc5v8AMbd/ECbENmnXpVr2
         Hwy15znYCOyAunYefh8lvpW5QKpwuBibL6dXpU4G7Q52WoO97NMKRSWIUo/TamY74wsX
         GXo9FAZoJzyU4xAX87+uSuOqzq52p3WD638KfhxKAzn5IIdXKP3QDjeWGeVp3W0/EG+E
         mT/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWvq8vVoV4QoOFiTRNdYtTkapcVFikVs+yoaLWoqGOwxmeic9AE17AHgeIW3qh9fB5OR/zmepRI9xVEhpLMOAtxZLqqISQGQIjIrebE
X-Gm-Message-State: AOJu0Yz74Vdw4npioE+4f1MEMwvVhcPzjWSQBdD/mk3+gO1cPZ1ug3G9
	Y2TM7h9fsmj9FaUH4jS5/qhUWHaQbXSX/dVJ/sJXbN+Clfm5KTgB91WVmHr9WgI=
X-Google-Smtp-Source: AGHT+IGjQz8hNTerYhLBdi6JyYNcymAxcZLNBRGdWpck4xyAQApa+h8XJh54CFVe6nDyZFRQglEK/g==
X-Received: by 2002:a05:6a00:1495:b0:706:aa2e:fc4d with SMTP id d2e1a72fcca58-70b009694ffmr5966538b3a.16.1720199597791;
        Fri, 05 Jul 2024 10:13:17 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b030d5d0bsm3174889b3a.14.2024.07.05.10.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jul 2024 10:13:17 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v6 0/6] Add SPAcc Crypto Driver Support
Date: Fri,  5 Jul 2024 22:42:49 +0530
Message-Id: <20240705171255.2618994-1-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the driver for SPAcc(Security Protocol Accelerator), which is a
crypto acceleration IP from Synopsys. The SPAcc supports many cipher,
hash, aead algorithms and various modes.The driver currently supports
below,

aead:
- ccm(sm4)
- ccm(aes)
- gcm(sm4)
- gcm(aes)
- rfc7539(chacha20,poly1305)

cipher:
- cbc(sm4)
- ecb(sm4)
- ctr(sm4)
- xts(sm4)
- cts(cbc(sm4))
- cbc(aes)
- ecb(aes)
- xts(aes)
- cts(cbc(aes))
- ctr(aes)
- chacha20
- ecb(des)
- cbc(des)
- ecb(des3_ede)
- cbc(des3_ede)

hash:
- cmac(aes)
- xcbc(aes)
- cmac(sm4)
- xcbc(sm4) 
- hmac(md5)
- md5
- hmac(sha1)
- sha1
- sha224
- sha256
- sha384
- sha512
- hmac(sha224)
- hmac(sha256)
- hmac(sha384)
- hmac(sha512)
- sha3-224
- sha3-256
- sha3-384
- sha3-512
- hmac(sm3)
- sm3
- michael_mic

Pavitrakumar M (6):
  Add SPAcc Skcipher support
  Enable SPAcc AUTODETECT
  Add SPAcc ahash support
  Add SPAcc aead support
  Add SPAcc Kconfig and Makefile
  Enable Driver compilation in crypto Kconfig and Makefile

 drivers/crypto/Kconfig                     |    1 +
 drivers/crypto/Makefile                    |    1 +
 drivers/crypto/dwc-spacc/Kconfig           |   95 +
 drivers/crypto/dwc-spacc/Makefile          |   16 +
 drivers/crypto/dwc-spacc/spacc_aead.c      | 1260 ++++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c     |  913 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c      | 2512 ++++++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h      |  826 +++++++
 drivers/crypto/dwc-spacc/spacc_device.c    |  340 +++
 drivers/crypto/dwc-spacc/spacc_device.h    |  231 ++
 drivers/crypto/dwc-spacc/spacc_hal.c       |  367 +++
 drivers/crypto/dwc-spacc/spacc_hal.h       |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c |  316 +++
 drivers/crypto/dwc-spacc/spacc_manager.c   |  650 +++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c  |  712 ++++++
 15 files changed, 8354 insertions(+)
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile
 create mode 100755 drivers/crypto/dwc-spacc/spacc_aead.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c


base-commit: 95c0f5c3b8bb7acdc5c4f04bc6a7d3f40d319e9e
-- 
2.25.1

