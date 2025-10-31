Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC4322A4EE
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 04:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761886100; cv=none; b=k/SFGWcJaYlmUYVphOC9UAudRMrnZMcC5qKImlYa0Eh12pWEJEfne2z1EnsuSvgaZL2nDuQq6C3yH3YSNfixBl4SjyZivGx/uY7cYt/omfawvhm3FMgHdnpkLo71wx81rJ1PGU44wXjDU2TXFfqbU8ETvmgCI7HWpR+aZO+oqj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761886100; c=relaxed/simple;
	bh=zAL4Uew2kRkkegj/cOObPY5ATqhKWlz/Yo1+x7xPdR0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iQHyuT7zCO/R4bGXWjwOsoxB9Du9Ef4eT0KqJuZUaufFIHrCsL79ugj4tTu/kHw2TBer1Su9SGWQLIg/6wOt/sRwwvSGYci0quQQfOxzxN/I5Z+R8E4kTV8K2yv+aHFAGgNcehE5L2dzLUJ1ec20VzgjupUtB4JGj+PKyK5Ykwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=H5x99lwx; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="H5x99lwx"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2952048eb88so6917035ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2025 21:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1761886098; x=1762490898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O+OiTvskOoQU6h9IL752qz8b+0it9yRGV456YrP7vcs=;
        b=H5x99lwxp1wnzzbN6g0HNBEplPKXJb3xXfB+W+URrbCSlVMVb+0/jfCdYNyLleWjux
         jXkchJes8xKGkVHtncDTRMGSTgOEy8wHplerQxg8OV+nepvgdU4Si2AzGfoJZuVuQJzJ
         EiOk6dgkGuDw7GKj3PKCKAtJYy4RW6FGSqd4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761886098; x=1762490898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O+OiTvskOoQU6h9IL752qz8b+0it9yRGV456YrP7vcs=;
        b=aSaLZO/WPJO+UV5bpz18qyvuA+ZNMr47ZyP8+w1ahTnLDWc4PYgNZZM3YLxl8Llt/d
         LeiZkz+oJggjs2EW3RQVbZcTSs4zjcCVunXh7JCwpIb2bN8GESL6SysQt3hKEWppQccL
         ukdkdEDKWYy46utuWMHSq2tzez+doSIRoKhqsSuM5FNhq9iUOlZNku9Ljp4lEkmLj0sn
         3LAD5pT3gaCg3vY7S9byVUP/92N+0lowS4L6jFjCrZLyVNvOGfDh+H1duQNiVhRyCWUp
         O9X18C4IPdPn/hMOzWgPDjG1m/nI1Lo7EKG5SLVA694uQzpDKfMaUC1wXha7eyD5UpsE
         E7+A==
X-Gm-Message-State: AOJu0YyUprO7btpOLPIJlwkt0NbyPF40ZtYufARWJKyJB8k9k9uiShn3
	aD6rwkwL58pTcxc3vnbn+qcYPh/vI0chJEsGMuWkb5GsKCSono4YxGNqKo9hNZsMPLXDcyjeNi3
	GU1tG
X-Gm-Gg: ASbGncvIl8my6EBYEfQBxe+4dQnPZL35bQyRfWd4iWysIyWBQymiFjhhgL99d9HBZrj
	j3LCxlKgki17VIQlRzTo/2clMw7xJKIbWh6hqB8io7y8lernf0wYgV4gF3Ma5oxJJI/J4oxn8VT
	uYrRTYbT9ZMXjQ302dX74+qNbU1H5+4UwfKl1JqW6Hn6J2oIQgaI+3KZsKQW5+b6KpMSyF+D4ww
	31Ja4gmtlj3Cjm2ynk4RuwLMs6IbBYLWMvP+th/GG53EPhX2BrMLBoI8Bhmfc+vKFz9otfmTT4A
	PsbtgswGcSm81Mmpgb78HUvNblo74PfWOohNP/eKBKqPJ49wpsymitMiqS2lqLOgy+OWc67e1QE
	SZRxfFILqJug0zsEIYYKHlDJXD7MOYzI6g9kNscfqadXnimPAu1GGvFh9YwuUaeQp+ys6eZEICe
	TiZ4uHPPtrhSmALictRqW6OuOcaGfqnX0j3P3Dq3VfSvoUqs045tjU/NU=
X-Google-Smtp-Source: AGHT+IFkuWxI7QfXkeD58QkM1mtzUAeKNOhuO+csBjlMU7CEihxjPiSob7XqSz3c0UNu/gwIGI8ltA==
X-Received: by 2002:a17:903:458d:b0:294:9699:74f6 with SMTP id d9443c01a7336-2951a524d52mr32909245ad.43.1761886098289;
        Thu, 30 Oct 2025 21:48:18 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-295269bd2fesm7238875ad.105.2025.10.30.21.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 21:48:17 -0700 (PDT)
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
Subject: [PATCH v8 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Fri, 31 Oct 2025 10:17:59 +0530
Message-Id: <20251031044803.400524-1-pavitrakumarm@vayavyalabs.com>
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
  crypto: spacc - Add SPAcc ahash support
  crypto: spacc - Add SPAcc AUTODETECT Support
  crypto: spacc - Add SPAcc Kconfig and Makefile

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

  v7->v8 changes:
   - Fixed misleading comment: Clarified that only HMAC key pre-processing
     is done in software, while the actual HMAC operation is performed by
     hardware
   - Simplified do_shash() function signature by removing unused parameters
   - Updated all do_shash() call sites to use new simplified signature
   - Fixed commit message formatting by adding "crypto: spacc - <subject>" to 
     all patches
   - used __free() for scope based resource management

 .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   88 +
 drivers/crypto/dwc-spacc/Makefile             |    8 +
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  962 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2393 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  828 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  275 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  233 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  328 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  613 +++++
 14 files changed, 6268 insertions(+)
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


base-commit: 275a9a3f9b6a2158bfb7826074b72d5bdfb2ac35
-- 
2.25.1

