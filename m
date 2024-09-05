Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DF5199FB2
	for <linux-crypto@vger.kernel.org>; Thu,  5 Sep 2024 11:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725535863; cv=none; b=YYcuCXD6Z/xeKbhFR/yi6B7C4yvSCmIyx/R2ktS2oz96Lo0cWeQnpq2m6Xqu2Scpstpb1bibDyl5yM+nc/QURnIoxs2rEZKWWNGrVVBp6CNbcdQb+/4coscObnZp1k/cJQk14vFeJfXTum9yG2SabX4xl/EGxJKjQ0BtjE4w7cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725535863; c=relaxed/simple;
	bh=faqGa18nHyzcWN4TqtqjVr1HBnTbMJRfK9IGzn5T3Rs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aSfreUGBtSblrOJPqsnXMViaXwWGRtSZEbcLiffXphfjRLp7iL9hGDFZ5qhzdQ4pcGRoG7e9zisxAr1AJCNkfxp28FTilb2ZV7VqaPsKJZtJ1nly3aibVtyA+FR6CpImGmDPjgQrZp6uPSjlAtk3amFHwstIB7XfzTF3b82hy1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=XBK1yMgA; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="XBK1yMgA"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2057835395aso6321735ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 04:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725535861; x=1726140661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CYj/NhG5y+9ykbCc5b1VY8g2hYoHIvLS/P/f9X0W6lI=;
        b=XBK1yMgAcITuAUwPExYFBx8WXnRgNP1UhPEMfxY3rrxwpXXh9xph+0R+uPHsvPCF5r
         lfqkugrQgTdTVj46vodlXHZZjg+LH602Gj/eB7y2ddbr3kGvn/y8ZFFlAQwIGtu3e06A
         1HDUVp6rVajuZThgRP77/Ybs049qUzAXU+aVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725535861; x=1726140661;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CYj/NhG5y+9ykbCc5b1VY8g2hYoHIvLS/P/f9X0W6lI=;
        b=FLu1vqQvw99jqcY7j/wxnjFYj1BxRv/GbIkjj60/c/9ls2o2LifndYLX4JILyEBM8w
         fCD4N6ONF0bzFJXbWQmnIGEY0TFeD71U9apHHPqtze0e7/Isp81xYxFuCqAUwDA37P5u
         FT3PLVAukKn8rPBC5vyFYxjkqqzjjmga1kPcHsCl2oVvO7UrQGvUTdP2GopU3gGvJExB
         GzRQVlZp5W/PZ9Q325HMojfgxYHK2rIPivA+gDwyoiRLttH+4TbxaSqp/aGxFuk5EMF7
         oWCSm6TapWKh9mTEMGK/O9y0aMQQob0Frv25/y6UfXc8cWlLXDcNLL3tvPytPfK+DHWs
         29SQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2LFy1YDK77sidAOHV4gMAADNFbMxinDtN9rWdWsv0CzAr/dFpC9g0BJygEyejyce6BOKQEnnoh7TNcAw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwugND6IiC7l8rGgRN/OTT6TdkZ2NEvoxIzF4cVTv/L7koeuw/U
	XdPY2yhWjNYSTboQikoKgblQiFCZeSj/SHBl8Pt9WjF3n+Fl1UxuM8ItYbw1chI=
X-Google-Smtp-Source: AGHT+IE+3uQwHFxvI9S/Dv82RJjTzNL8ZHeOjV1lABcB+yXNURdjwtX5S7619UrcNaNAwBI0l4oVsg==
X-Received: by 2002:a17:902:e80e:b0:205:7f9b:b84d with SMTP id d9443c01a7336-2057f9bbb0cmr169782065ad.22.1725535860898;
        Thu, 05 Sep 2024 04:31:00 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206e6aef432sm704085ad.177.2024.09.05.04.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 04:31:00 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v8 0/6] Add SPAcc Crypto Driver
Date: Thu,  5 Sep 2024 17:00:44 +0530
Message-Id: <20240905113050.237789-1-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the driver for SPAcc(Security Protocol Accelerator), which is a
crypto acceleration IP from Synopsys. The SPAcc supports multiple ciphers,
hashes and AEAD algorithms with various modes. The driver currently supports
below

AEAD:
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
  Add SPAcc AUTODETECT support
  Add SPAcc ahash support
  Add SPAcc AEAD support
  Add SPAcc Kconfig and Makefile
  Add SPAcc compilation in crypto

 drivers/crypto/Kconfig                     |    1 +
 drivers/crypto/Makefile                    |    1 +
 drivers/crypto/dwc-spacc/Kconfig           |   94 +
 drivers/crypto/dwc-spacc/Makefile          |   16 +
 drivers/crypto/dwc-spacc/spacc_aead.c      | 1245 ++++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c     |  916 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c      | 2514 ++++++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h      |  819 +++++++
 drivers/crypto/dwc-spacc/spacc_device.c    |  304 +++
 drivers/crypto/dwc-spacc/spacc_device.h    |  228 ++
 drivers/crypto/dwc-spacc/spacc_hal.c       |  367 +++
 drivers/crypto/dwc-spacc/spacc_hal.h       |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c |  317 +++
 drivers/crypto/dwc-spacc/spacc_manager.c   |  658 +++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c  |  716 ++++++
 15 files changed, 8310 insertions(+)
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


base-commit: b8fc70ab7b5f3afbc4fb0587782633d7fcf1e069
-- 
2.25.1

