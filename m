Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D5D2512EC
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 12:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746449795; cv=none; b=VHBDqqU3RWJ/L2tVN+p65L1juvDAH08wBv0FokswHC83M53e+eAaZkMRYvzG73gz/PLV09c3k90XcfYS8BLpLanNemMrQ8+ju7gpSDZU9yVQzGB/EMPZS84HWTWolXzz9QAZyalFHKPXpBgaSCJP8hw+c4VCDvgxY50HBWk4sBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746449795; c=relaxed/simple;
	bh=cFqBE34txTRBz5u1i0lU3gPtRNXfWw+oybt/9tjZKEM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aj7F1DIRhXunbjnkhKC8L6tiAXYSWCRtt9s5htEwO+Kh7mL9I2Y0N0v4l4cKhQdPorrIALT2LF68plvz9A0Xm2hjJXsxFCw8AkMA05kdBL/APlgnQ8t599Hgp6hb6neCcbeYbswUtElWAWD/591wvXbliN/+Uf3G/34Ap2zdkW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=jjKAhme6; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="jjKAhme6"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-af59c920d32so2845927a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 05 May 2025 05:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1746449793; x=1747054593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bAnzCXe5txb+UjJy80i7lsKQWkz0PMSte3uBrvU5TzU=;
        b=jjKAhme6l35ZvzLjmNoqI4mYM0pJLM+IKWjPWTsfCqiOsi1G4jNYlTVJy9PFQT6wIv
         tvCILprIgnNpG4sdYKQqXAT2+8Yw5VZFCziP2x77P4QwSVM8Qb1NIrZrBwz55Vdp07ya
         qyVIXBzUtRrlGTYjd1cqP8J07Ni2TsLmVd9Z4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746449793; x=1747054593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bAnzCXe5txb+UjJy80i7lsKQWkz0PMSte3uBrvU5TzU=;
        b=mrxamCqZYbqWr92QO5sUQxubwmcyCTx3K7iN4S5cDzuzXzRRcD7rM3ve3umzJ8XJx5
         7+b05P8N5uSzBTKU3KMhpfSk2WP46pnHhgbQSNyxqKYxKv9hxonF9/xeXdPbaN+nBgnb
         WdTeZ8v2UOvL8D7UIP5aCFp1AVXWKMUYqwKwMyMcMoNfGOfZmlW0OaIBwEpNaCmkB+08
         HzmNM+UgB6JEaV7Eauc0b5nCDSbEq0B/acsOzKOuJeEQpc0LlzQ3tBUhX6eh6hN4meCc
         yufFFhaGFwHCU9O+VS9jLt6vHNdCdp/C7pAnvqlC6SQADon3kpSJCp94CsdrhjqUmdaa
         wyng==
X-Gm-Message-State: AOJu0Yx3zIHJeWD3TMZOyZH5IFP52uzconD/W9IAyzSv2Ozj5LnBeK4L
	kcp3gmjq5Sm+O0wOKBcMFl7a/CCPW5BBHSwqiGsrVFCkGC84iXvEKd9cSKGHoy7ROmwNjKVZn1z
	4
X-Gm-Gg: ASbGncuhaHs4wnQBlQWdAssDl7b16tr6qKbN+nw8K/Ma6gBfOKRXKeUZm4M410w8q88
	6nsN20ygXcgPt2ufA2P1E3D3krJxI9/uFb4paS7YjPfjiPnffxHYT14+8PMpBJs+COwl8l3trMb
	gw1e5LugKMyXvnDZFaFfC5KL7WTZMESyib4HXB0XIyeGRTuNUbGFMc9sMFWRjXZjXkdYJktCj5e
	km2Bz/me/aBatiaoochUlYhf2vjXwqM+NeXc2oqKXU1XjG/hhR3BJT9gmYu01x9nJhqYqptOSs6
	Xjq796PUivvgr5jZZGjrOBdQltuTjv9kmZ3vVDgRkV457tkB0SvE1VAU2GI2+bGs
X-Google-Smtp-Source: AGHT+IEyEpdDrrmWogQElo0DR+gWPXLf+SlnENF+4mdj9wocOmAOCP3bfFYGnG50O+Vp/nCEbn5zRA==
X-Received: by 2002:a17:902:d2d2:b0:21f:8453:7484 with SMTP id d9443c01a7336-22e1ea3a9b8mr96685165ad.30.1746449793039;
        Mon, 05 May 2025 05:56:33 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1521fc6fsm53559565ad.145.2025.05.05.05.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 05:56:32 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v2 0/6] Add SPAcc Crypto Driver
Date: Mon,  5 May 2025 18:25:32 +0530
Message-Id: <20250505125538.2991314-1-pavitrakumarm@vayavyalabs.com>
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

Pavitrakumar Managutte (6):
  dt-bindings: crypto: Document support for SPAcc
  Add SPAcc Skcipher support
  Add SPAcc AUTODETECT Support
  Add SPAcc ahash support
  Add SPAcc AEAD support
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

 .../bindings/crypto/snps,dwc-spacc.yaml       |   81 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |  103 +
 drivers/crypto/dwc-spacc/Makefile             |   16 +
 drivers/crypto/dwc-spacc/spacc_aead.c         | 1297 +++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  972 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2464 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  829 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  309 +++
 drivers/crypto/dwc-spacc/spacc_device.h       |  231 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  324 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  610 ++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c     |  779 ++++++
 16 files changed, 8505 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
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


base-commit: 2dfc7cd74a5e062a5405560447517e7aab1c7341
-- 
2.25.1

