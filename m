Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F421D2BF3DB
	for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 07:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759131839; cv=none; b=qs6kZk2kWPg9gUDGN6yqcahDeS0atnozWtAPyphYfhcJuKRqUBIYMVzde1gtBgbvQeclrldw8sKkXNRVtgE5oUpqDpTmvPKz5OTjB+Y7lvFGwoUUIj6ThC1hgj49Ov0jadeVzVUJzXkNni+ETkfBnP47hcNTcmYOVQ6GAmuPfA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759131839; c=relaxed/simple;
	bh=VXI1szOjiKjEL8zYBGVQtWD6/5ILKOW18W82tAcfKjA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O2WbKg0IPuTPVxrBcBvMqvRRM7RRJKv4+6LwCYO9rYQ9rCtQNEwQBVEoTKr1MKOCElCrqWVlzDLL2hhGlBnnxgoTe7xr00ZCybO0C6qxC1dMMecIaEb344JJnvjcYEFM+vei3FGSy4FgsB2c2pZU/ctGMw0bM9MbPh3YJj/s3wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=SOzTMCuF; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="SOzTMCuF"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-279e2554c8fso44271015ad.2
        for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 00:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1759131836; x=1759736636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zkzwN7LTL6uCgBrStY6yDcslORDO/lWty4C23MUHWAI=;
        b=SOzTMCuFxKjZRIgr6MqrE9n03uWTDOmWiEUiSUQ97Uae1YoaJLyeVxMg2vU9SXBOq0
         +aedJHA5WdaDNsbL+/qnItG6YS1kf/uAB34zLIUxPRu3aRPfisButG8QFt0vqVGr4e1H
         i+JWRqP7UhUR4SROAlfmqe/rFqL8lfx1nDC64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759131836; x=1759736636;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zkzwN7LTL6uCgBrStY6yDcslORDO/lWty4C23MUHWAI=;
        b=e1T746doAS29w6iAzK+zWnJOsWoWZiuO36j8S3OkG5tiWMNGEXWrQ+rxEIhB0nL2aw
         6qf7oay/ttZVZUTCJNYl1kOts4bgTwynL4AVT8AUwsmSdulBANenPpBes01UJQtgMM7k
         jV92JNIv5S65NPjQIMehM6Z9OlyyD5Pk2Q7GCyr6GiftEQ7B9ay+34ASLMwjkR+CayN2
         Xv/l0kv6EOQD5sMlZQ2/dGZKbVOAVj8rHL33/JJMhTV364mINW2+3Mh2rLFzybJp8wHf
         3ONOF6Xw1YZkex1s6JQWO5zLUFl+hdJVasa7zeIlJ59qoROmr2otLjvdQEr5U6hQbPlA
         seJw==
X-Gm-Message-State: AOJu0YzhqvGgScK5LZXfW/YEci7gBKkKkNup7OJj6W3+EOWmGYkqeo94
	LgkQ5sw9GlYwUYv1Cwtrwq9GFYO9Kru6wHuLe4W/Ys6fDrc7T4cWiH7oKGIgGYk2uqtMFVx1Lau
	gf0EQBPk=
X-Gm-Gg: ASbGncsloaAxAB0w5cqS8W3U2REf1qxJi4/dymbW7Xlb4M69WSTHBLs8rj1EL8iS5hq
	UlBhs3tQTK5OojIwXNWZ/BXZjY08UXD7moAM0T0SCP1z8nv/jHOe/orwAAKFbSuOCygRDHRaPl7
	5kdjxR+iE7tLvj+i7mSJbF0U3czmwJdw8dMCu2e+oo2Fscb1alOHViSpQqcfb5Rvb2qCADLWeMb
	elOvEh2uanxRD1RX6QHVdeK3QuUXPrsp5CtWhgC4uzXApf0UsXjBfVu1tlx0TGVXU/+TRb6ui9u
	DP9eu4MfZE7m3eBJu8nAzEmwbJ5GOUq/yvKJNS+oxfJWjY4lnO4c/eckiV9pMJ6Ugqoeqx1v1yO
	5+uJnFI4tB+Khj+vtAw9eyGqh9J3X1NajyYimx5UU/PNqS4M87JsUcdkO
X-Google-Smtp-Source: AGHT+IH5ltnVhI8p9SWMfpRx11EhtJiGOK7ftW/7FfXvSgTjSgVPvPELvNXl5zpk2IS2lmwtKYpJEQ==
X-Received: by 2002:a17:902:e5c7:b0:24b:1589:5054 with SMTP id d9443c01a7336-27ed4a29670mr159434275ad.23.1759131836048;
        Mon, 29 Sep 2025 00:43:56 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed69bc273sm121341105ad.124.2025.09.29.00.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 00:43:55 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk+dt@kernel.org,
	conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v6 0/4] Add SPAcc Crypto Driver
Date: Mon, 29 Sep 2025 13:13:30 +0530
Message-Id: <20250929074334.118413-1-pavitrakumarm@vayavyalabs.com>
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

Pavitrakumar Managutte (4):
  dt-bindings: crypto: Document support for SPAcc
  Add SPAcc ahash support
  Add SPAcc AUTODETECT Support
  Add SPAcc Kconfig and Makefile

changelog:
  v1->v2 changes:
    - Added local_bh_disable() and local_bh_enable() for the below calls.
      a. for ciphers skcipher_request_complete()
      b. for aead aead_request_complete()
      c. for hash ahash_request_complete()
    - dt-bindings updates
      a. removed snps,vspacc-priority and made it into config option
      b. renamed snps,spacc-wdtimer to snps,spacc-internal-counter
      c. Added description to all properties
    - Updated corresponding dt-binding changes to code 

  v2->v3 changes:
    - cra_init and cra_exit replaced with init_tfm and exit_tfm for hashes.
    - removed mutex_lock/unlock for spacc_skcipher_fallback call
    - dt-bindings updates
     a. updated SOC related information
     b. renamed compatible string as per SOC
   - Updated corresponding dt-binding changes to code 

  v3->v4 changes:
   - removed snps,vspacc-id from the dt-bindings 
   - removed mutex_lock from ciphers
   - replaced magic numbers with macros
   - removed sw_fb variable from struct mode_tab and associated code from the
     hashes
   - polling code is replaced by wait_event_interruptible

  v4->v5 changes:
   - Updated to register with the crypto-engine
   - Used semaphore to manage SPAcc device hardware context pool
   - This patchset supports Hashes only 
   - Dropping the support for Ciphers and AEADs in this patchset 
   - Added Reviewed-by tag on the Device tree patch since it was reviewed on 
     v4 patch by Krzysztof Kozlowski and Rob Herring (Arm)

  v5->v6 changes:
   - Removed CRYPTO_DEV_SPACC_CIPHER and CRYPTO_DEV_SPACC_AEAD Kconfig options,
     since the cipher and aead support is not part of this patchset
   - Dropped spacc_skcipher.o and spacc_aead.o from Makefile to fix build errors
     reported by kerenel test robot
   - Added Reported-by and Closes tags as suggested

 .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   80 +
 drivers/crypto/dwc-spacc/Makefile             |    8 +
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  980 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2394 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  830 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  283 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  233 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  328 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  613 +++++
 14 files changed, 6289 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile
 create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c


base-commit: 166c83f7789ed02dc1f25bc7bed4a1beb25343aa
-- 
2.25.1

