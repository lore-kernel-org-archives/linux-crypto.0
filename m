Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBB6225760
	for <linux-crypto@vger.kernel.org>; Tue,  7 Oct 2025 06:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759819843; cv=none; b=P4HlRvhrT8itmt2Tcp09JVQVFzm6/3LWnpQ/bGkp9YGi9ppOpAt88SBwbSVn9P3L989GAi6ebL4EleO6idF7ItMFfQgo2mg19lWr1zFnJRpfEwu96rafywOoWBtNzAsBTEiQUcpdqOyWSuseu7qulKHyTcov4YoZHQ0j8mcelSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759819843; c=relaxed/simple;
	bh=QnTLV3o19IG6q9YeHZebGR923u5V9mmkqGyVmvzfLc8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pYpl8XR2NNBhN2QqUA1Qz+sP6y7EES3hH7bc4c2gehVuz/i88aB+K7Aq2c5MTW389e9XpfAMf4q6ijTJBuzi5KyBH14TsGnW7RQM8KIQOwi6kaRYfpM2k8mUrIG0U3TbIn/QRLnjyDtgBNAZgGe05i+NPLCGzfEjfhNEYAOVqEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=GwDAa8UH; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="GwDAa8UH"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-271067d66fbso58297235ad.3
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 23:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1759819837; x=1760424637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1ue3YLt56/lr86Z7z674epKcb+OTcReM8+sZPVWTsKU=;
        b=GwDAa8UHYRjEi52ycFVQ04djnMFU4iM3bQU46XZVynA8kB1fsZI+V72Zq+STjkjofn
         BMVYvtrQNKpdhm5VumSmUalNa6uQ1jLAm2T2ynYbOOTxwAOXmSZm7qZ972TLN2I6dOSF
         W/MaV4tkmWOEigTefoaI7d7r9wyZ3+FKxKxAM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759819837; x=1760424637;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ue3YLt56/lr86Z7z674epKcb+OTcReM8+sZPVWTsKU=;
        b=S9iGgGi0u9A0fuVmmIjK437b0nECpAVoOu5u5KEeApgF5Xu9XtaOACaOPNKdb+B5PU
         O7qjvBsVBLMMZ3glnBQBYKcypEyw5hVgXjIHGl0wtViu0S5uI4g2sRrmgKZ1+2VbpDfu
         IzJMImB9FG7nx6+3s9FEFYNxpFQS12De/dZKH/iyPYL/vKpUEhgoKiX+BeXjI8omnlmV
         9v+OPsYE0fst54rwZkvfv0DSUHLaNIxHaK8SJb77LW0lxNjZ3NOosPfy4ymz+I7UGl+M
         OQRjcPszDiB1v+WWVlt4z5itZ9/TNqJvCkhIdEKkFQHWwLVP6v0LM9mWvzKxzIlOyZ1H
         jTYw==
X-Gm-Message-State: AOJu0Yy2u+NSaj+TEUdmaZq3HbokXdylGc9seRn6/bTjL4AoXJwsjTmH
	D4OJthJZUxQ88h5vxMDcykgA5B7zSA7e0/jIOt55Pt1OWzdbll9Uvjw+YFaZ8ZDrl1dzlSAvUmC
	h1Ba0KB4=
X-Gm-Gg: ASbGncvDOou8o6Zjc1AgfW/TA1ps8o7dJfN6wbhTo6o9vy9uwWYdmTj7yu2wZEs202I
	2DwzZf64Wpi7xB3quWOZVQGzgvEq3Mx7P/e808eY7K7TLpb113yyf+7gmP0Gndh2fviFc2XaZrx
	OyhrXb4NDsl7x5Kqc5JFBQgA4V6j79AYrw8nRe3eTMaOSY0vsspOFc4+q0vJwgDxLhRtgVrlVtm
	ZoHntM85jb1Ff9xgcPe0Ye866yc5oAZ75Exuh/xYgsi931vkBwmTpWAPKXDd/Tg4+/Us2VQijYL
	XY4kTxLbwYCYjTt0OFfR6GR/kzho0ZoG1yGSuxC7JzoanYQq+iJQnARgqqfrTWdFe89fMG0ay8y
	ZE75sSQyaQBhrpU9bpGAi0bbkswDpOdVtHnSiIl2fv9MXmMsZkNBw/ET/pzs5HowvJ0pV2g==
X-Google-Smtp-Source: AGHT+IGyuOfQcD629SA8YXpzQqVGAaDQkA881473yXUv9GAx21Pra7oLfp+Z5y2AIx6o3w56Q0/m5A==
X-Received: by 2002:a17:903:3bcf:b0:273:1516:3ed2 with SMTP id d9443c01a7336-28e9a6dd480mr172564515ad.50.1759819837084;
        Mon, 06 Oct 2025 23:50:37 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d111905sm153287745ad.24.2025.10.06.23.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 23:50:36 -0700 (PDT)
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
Subject: [PATCH v7 0/4] Add SPAcc Crypto Driver
Date: Tue,  7 Oct 2025 12:20:16 +0530
Message-Id: <20251007065020.495008-1-pavitrakumarm@vayavyalabs.com>
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
     reported by kernel test robot
   - Added Reported-by and Closes tags as suggested

  v6->v7 changes:
   - Fixed build error reported by Kernel test robot
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


base-commit: c0d36727bf39bb16ef0a67ed608e279535ebf0da
-- 
2.25.1

