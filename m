Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CB323312D
	for <linux-crypto@vger.kernel.org>; Fri, 26 Sep 2025 14:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758896367; cv=none; b=VKiNH/SjFCkqdEolbXKWnN4weMIp+81iwdA+mK7AcjdBu6cKWi1cBge5NWQTEJB3KIQ0k7CZLQg5/BBBZN6kdMCtg03dkWZ6CIUHkDH2SbrGEJDvxpHmEJcUKZMpR9Kc080fF7sdrB4Ma4R0KmPeXxbvVZH1k6qYRq9FU1A8vJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758896367; c=relaxed/simple;
	bh=qvArYMpECQWNjBPgOxirpmiiPvoUDMcIKMOCAFvgia0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TrKLwGEPnbIHXe7avBv9fiyD+2CR9UuGu02U6WZLvVu4TrgKcHACx4xMDbPmjC1ZqjTH1DfO1jQ21XAfLf/50rd89v7d8d5td/SKs/5OvrQt5UmVdSGV8XxLH75Wixw6cXjWXIGKnsNkEgc6PhF8cf9xB3MfhgtwU+3eVxxg8N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=HCmIdGLg; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="HCmIdGLg"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-780fc3b181aso1425425b3a.2
        for <linux-crypto@vger.kernel.org>; Fri, 26 Sep 2025 07:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1758896363; x=1759501163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a15yEDQ1T2kumn6gYn6T3lQRGJS4ns0sEIC2Qbr0Jig=;
        b=HCmIdGLg0oVNGQ3tCXmQt72rHBTNTPQoEZRpuyAE8QPxquF6wwOQw4PQ1F3FSyhkYS
         YUsKByiZvNJYwOET+DDE89MoACNPvBlFR7Z9wpDmHkBwNBA6HTHmWgAC/SzmRp5ASTSh
         dhypQ3iNyCmOqi6zIGNM7h5yNG893pslkcI0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758896363; x=1759501163;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a15yEDQ1T2kumn6gYn6T3lQRGJS4ns0sEIC2Qbr0Jig=;
        b=bfpPhAKGIiUqxdtOOMmIhEXT50flUYfgQY2Rk3CvtjDVUzZU8BFXkUjPDPHSCMUa20
         OsikgftCrXm9uIdcDHz8sv7HiUcrsmftXzmPFJcWULt2e9Pz5pp7x9NZ3r///T4W9Hyq
         Pvuh72qkEazNfD6/mFQDwJ9+sWIAJBo93gdQarx/h7m2L56XeB2bEEQknn6fw+MfIbW2
         PKTYGBrf+sxByJPkQJ0yKS1PsKaSyfSK5wqk3vTUD/HEcivv7XuJ7DREcNmx6KJxcAFK
         WJ5E1dVgRUYMSGSN5KsXhCzKWaf45HJ2lGOknqSVB6P7wh69JMEhI1velcyoa/tqYqaX
         0a3w==
X-Gm-Message-State: AOJu0YxOWS9A/EQObhkFABPP1iAE6I/qUYj8qvJKpGc7DjgaGu1RAqxL
	F/7lbIG2z6yKEogP0j5EW/Fm8NPoNZ/HFHr5ckZ9sfgWoLljaQVNY8xQTWbBMo9qSrInOeyaEnF
	S1y+K
X-Gm-Gg: ASbGnctOoFOfsVBxgXMR+AbzslgFH1asVHCAFOGYekO9fOXWparbhQks69GyzFURhPH
	jPYN1+dBkeBC/ffboLubdcZea+In4MseUJ6fTSI702kkITOU0ek068h/aU9PoIIMu5c4poNnbyW
	966oRZgzs+K8nAMlhivhkjqZ55prYc5XGI9Lt7S7+4JkHcDWSIhTFBFY5rb9BapL5KsmDY7t6aM
	D+daRYm+viQzAZFwya0XtkH7swGHPVWsT/jg3t3cAGgGfpue22znrQdYW78uK02NURKp/XcZX9s
	pFPlxjy60hcRM6ETIfJR0QMSN5abZA7hKJ6K6X568kf9VBNTpXUH8DEUCX/eFXTLj5XxP7xZ592
	WFVtMoiOruz5Cb29soxbhX/PE9V+J/lAgQX5wTxnQsr7kOA==
X-Google-Smtp-Source: AGHT+IFZ16FT1p5gokWgr6LpHsUm5GTcBBHq5fPgHU1wdmqAqjrcfBJ/8H4l2VH5+fHKS9me61FR7w==
X-Received: by 2002:a05:6a00:139e:b0:781:2271:50ed with SMTP id d2e1a72fcca58-7812271540fmr530653b3a.5.1758896363226;
        Fri, 26 Sep 2025 07:19:23 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7810238ca1esm4624845b3a.11.2025.09.26.07.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 07:19:22 -0700 (PDT)
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
Subject: [PATCH v5 0/4] Add SPAcc Crypto Driver
Date: Fri, 26 Sep 2025 19:49:00 +0530
Message-Id: <20250926141904.38919-1-pavitrakumarm@vayavyalabs.com>
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

 .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |  114 +
 drivers/crypto/dwc-spacc/Makefile             |   16 +
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  980 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2394 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  830 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  301 +++
 drivers/crypto/dwc-spacc/spacc_device.h       |  233 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  328 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  613 +++++
 14 files changed, 6349 insertions(+)
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


base-commit: b73f28d2f847c24ca5d858a79fd37055036b0a67
-- 
2.25.1

