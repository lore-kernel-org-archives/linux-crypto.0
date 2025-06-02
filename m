Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F5C12CDA5
	for <linux-crypto@vger.kernel.org>; Mon,  2 Jun 2025 05:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748842482; cv=none; b=J/RJ+9/rsB0TWCD7ayNk7WgGMJDSfIelPuY1TOFnmz+KG31MWybeJ6LiVX8eCg42hZvTU6QUGarq0NwfqHEnUUOAQ1wn4Sdf0/w1xBaMDhRHqRR2B3s7qkmyOiMogkOg0Z5zCQmhZ/Q2dr/s372CHy2xO+6mGjcr60Glt4yjKFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748842482; c=relaxed/simple;
	bh=BnSztsTB2eS0uQmoM2RspcYO2f63Ee7poXNlG8WSz6s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e6fwUCxKEaZy5dq+2CyBkwPAiR1337sbUsGFAOUUpjqzYNY2Ben6bgSw9gmJQgtme7TUiiQJCgYG0MDOTlquAqUGuQ2yqlyT35q77cHf0IHFXl8Ndn8AJaRXWTMRxUEjPhPciRccpsllBoJceRXMhVJVTL6c8jTNGkA7BeEUirc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Qk0ZN7FE; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Qk0ZN7FE"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-af51596da56so2694645a12.0
        for <linux-crypto@vger.kernel.org>; Sun, 01 Jun 2025 22:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1748842480; x=1749447280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Of+giPRXoHa61+G+1+f6AExdK/oFgaXp7VMTppRfyjk=;
        b=Qk0ZN7FEJDYbkIaz8exZyXzwHQ4eap6pK8DJd+cintxaFKsNrbuJuHLGzFoy6K7qM5
         GoU9pQrEDFQFCRYe/CD7uk0KlsT2Oq4F1UnQILMGi6O6RjWBqkptje0aHsGvbIXG1MKl
         HNijXqkQJKw01PBQcglJAu8E9Nnws6WQzjc2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748842480; x=1749447280;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Of+giPRXoHa61+G+1+f6AExdK/oFgaXp7VMTppRfyjk=;
        b=aaFYjS8PMHbhTXy+76yrid/PXjtL79EbkTe18QJwEKaEBUdrdkrb/GN8a3OwFs81jK
         AEKG92avEymvcm2gRnn/MiGgyhLQ168GOI+bJdQrxT6ZTAyXQI4dgOIX4B9dI41tnkIn
         ++Lf/w51jByGBk+rpxJxtXmEJPUwzwCV0BS+p+CcvxLBLMyXhFRbPhSHbJF4FjhEk3JA
         d0YlnCHWuDVKfCbZdNUMhk6PDJwwrF89DGu+bLvXlIAzL7bmwt4kH+qYxtHcAVhF1Zp1
         UTO4KO/ZHX1wsUmQMj7J4MmiT47JeZnRjzCzfOojmT2wPklc2XHVfqZDxag8GsSWNwDu
         7nDA==
X-Gm-Message-State: AOJu0Yxm6lMM8hO3T7RbPNQ2wZ4Ob7josVaNgtQ7globiG0vVzPdWI85
	dNS/3UZRA6U7Kj0wVxCrITA1tGsLpWybsNno/A8ian3+BuaNZl9kd4K5Dd6EKBYsarGFRKU6Xju
	r1sFw
X-Gm-Gg: ASbGnctAvBAKdb7UrAAUeGbzYn6caANeQX8igmKWROZwJG5wU8FEDJrJJCKzWnsMwJ1
	ejR6A63aRgR1TzscpCDfw966fVaFCbhF7kTII/JYfKuKtlzXf28cCSztq5laRVc/Hvp68W5PAdJ
	QyOo/VfNIcBqX2Jv0zE+7OD/ZA9wy2v4mQYgUzxO+f2pHWF3T823pvt9vUjmV5oHDLlM+1Xowti
	CZFN52nWKqf2FYA27XNs9avNZVwA0h14StqMErGZY6DLwYCJu2w+l7QzIKTUSVwLLeeQ8KbSWyN
	tPZz1/7k9G6xyq8bQbBvPVg9bOya/r2lRFx+ar19ECJtAfkdgw1Lqi4bQO1oDubK1KDZTA3QEGA
	eW5U=
X-Google-Smtp-Source: AGHT+IEYz2g+lwHZ1E98s1mdsv0Y/q1t6Wkg3SdaSFK3PwIB6dMcQta0OhSUjtdKKXoOzY5aUorewQ==
X-Received: by 2002:a17:90b:48c2:b0:311:9c9a:58c7 with SMTP id 98e67ed59e1d1-3127c6a0481mr11589132a91.7.1748842480443;
        Sun, 01 Jun 2025 22:34:40 -0700 (PDT)
Received: from localhost.localdomain ([117.251.222.160])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3124e30cbe6sm4836986a91.39.2025.06.01.22.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jun 2025 22:34:40 -0700 (PDT)
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
Subject: [PATCH v3 0/6] Add SPAcc Crypto Driver
Date: Mon,  2 Jun 2025 11:02:25 +0530
Message-Id: <20250602053231.403143-1-pavitrakumarm@vayavyalabs.com>
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

  v2->v3 changes:
    - cra_init and cra_exit replaced with init_tfm and exit_tfm for hashes.
    - removed mutex_lock/unlock for spacc_skcipher_fallback call
    - dt-bindings updates
     a. updated SOC related information
     b. renamed compatible string as per SOC.
   - Updated corresponding dt-binding changes to code 

 .../bindings/crypto/snps,dwc-spacc.yaml       |   77 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |  103 +
 drivers/crypto/dwc-spacc/Makefile             |   16 +
 drivers/crypto/dwc-spacc/spacc_aead.c         | 1297 +++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  969 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2464 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  829 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  309 +++
 drivers/crypto/dwc-spacc/spacc_device.h       |  231 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  324 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  610 ++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c     |  763 +++++
 16 files changed, 8482 insertions(+)
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


base-commit: 0a84874c7e7dde5cdddc80a82093120e924a348b
-- 
2.25.1

