Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79513234
	for <linux-crypto@vger.kernel.org>; Wed, 23 Apr 2025 10:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745403334; cv=none; b=LFZCHCISgjLEXX8NaS0dwaYi7Mvl96/KVqF+Yly5xkaWJ3YTQ5etN86MSQ8OFeF4FjxBF7uSiwk21Cf5ZLV2gWHc/qzpuV+he9q/W/0kZjLuPKiCROpUKCDeFYSYIexiYnb00Yw0vdy7n3Pj8SiCsVdUo+MLGKBZiKs57a0JuFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745403334; c=relaxed/simple;
	bh=JjhHXd84vxOcVqH5MHgid4VSL+UFqBPYvmGTFOuJbek=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kbA5iIL2BWbOtQ+Xqj8mR3nTFct/bZPrSWu2ogGFxlvJ453N2dY1cP1ygvzGPedlkT8JRvupZT5XTkcev8vh+/yBS96JS6cEfYWuk0O4LLTS2XVvQ4tdTCRM9m5K4g17FjBPD4cZCb1wkSMSdfeghkpwCPuYBHrTrggAIaPSRCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=o2HiuISs; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="o2HiuISs"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-30572effb26so5612226a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 23 Apr 2025 03:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1745403332; x=1746008132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Maz8FDImtOQb/iZZCgqaREVgXkrX824uXQKthiCjCsY=;
        b=o2HiuISsm5U8uX4AMp2a5fkP3D4nQ1vK0gMcVvFQWYOdeI0eEdFjinXUkZMewc0IlM
         FZhMIuBonWnm6/e0KxwGlPL3P5VgqmuvRor8mjFtz3v30pDEtVBkVWHjGX4Qr4k4nAzE
         +5JEwzGUAnARj3PE3s46lv5bTdc3V2d0aNkE8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745403332; x=1746008132;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Maz8FDImtOQb/iZZCgqaREVgXkrX824uXQKthiCjCsY=;
        b=Teui85EhdE8G+iuoRjbUgmPaXW4L6zF7vLXlnYBB8Hv51n6GnqizJjK7gt0fGAV7NL
         Rp7iicYAkq925ZkDj7tteA7Cm835pVGWa3sOEaV1qAH/MR/NJfJF6GkjtSQh0PqSkOdp
         VVC7le0yByjReuyN7O9hWoBRIs7oyVklpSXK86bVpKWU7P6RmZ/mxLntddQMuO7yr0p5
         VrZXC9fevGuuarTzYP46jAHqqsGXbB1k/8I6PIO4oC7qE2Bj7PRI3DbzP9CGYQWyEEeM
         XQX6CweDV2UZzKBYwBmGPHDyFJd2SH3MkEjMpCAsSF3zems6ZU1o9wwEE/LVpqG/EMUt
         ChVg==
X-Gm-Message-State: AOJu0YxS3TXvCXZ99xYbIy8ychJSA33ukqZOJiTwfx2UeVDNqsFX29E7
	u+R8KhUjBRJA9hAxbTUCUxJ200Ht+4mwUa28Dn0L97iGncK2lOeIULm405j6AZH+M9azeQu5Mxf
	y
X-Gm-Gg: ASbGncsk90A62idqsPMip7Mo9CWcr/bc6OtsOCfRw7js0p4KjI5Uzeqbwb/jxm1sWXg
	ltJfCazGE4aGYpPQs0x+6Bl6G6MH5RQE0l5vPiWM0b1jJ/z3KsJ7oMq4DZ5hI26To+EVwSPGskW
	3x33yyMb7ydF1BfGtAdWNviqjeBWUt8Rq1mBrPrlBO1NhxBTDWXt8EjJrGRJM36j8E2gv+iOyZv
	FtQd6EMNxWNSvEbMIrxVnC/LYD4INoRCkjEJmG9BJ7QwUSopeFdJWaj+C+HUy/uUqw9FFWXBsJP
	dczn5sH+XLVFRZh+5D7z5s/p7D/yQF4YVJT7Nrq6Jc4+FK9sV2UUTNwsh0y04eJ5
X-Google-Smtp-Source: AGHT+IESSbSNjcCTDzlOdLYH5rfkzYY6H/NEnWm7A0o3H8wPMl6nNkuSAVfLJuO1MU1/dIBUolwhew==
X-Received: by 2002:a17:90b:380b:b0:2fe:e9c6:689e with SMTP id 98e67ed59e1d1-3087bb47920mr25214281a91.8.1745403331832;
        Wed, 23 Apr 2025 03:15:31 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309df9ef918sm1205765a91.7.2025.04.23.03.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 03:15:31 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v1 0/6] Add SPAcc Crypto Driver
Date: Wed, 23 Apr 2025 15:45:12 +0530
Message-Id: <20250423101518.1360552-1-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>

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

 .../bindings/crypto/snps,dwc-spacc.yaml       |   70 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   94 +
 drivers/crypto/dwc-spacc/Makefile             |   16 +
 drivers/crypto/dwc-spacc/spacc_aead.c         | 1295 +++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  969 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2441 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  828 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  318 +++
 drivers/crypto/dwc-spacc/spacc_device.h       |  230 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  324 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  610 ++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c     |  776 ++++++
 16 files changed, 8461 insertions(+)
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


base-commit: d23fce15abd480811098c0bca6d4edeb17824279
-- 
2.25.1

