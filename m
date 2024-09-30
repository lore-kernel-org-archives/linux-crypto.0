Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6591677F11
	for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2024 09:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727688669; cv=none; b=VLulV7oReqPRoXXVm0+HN2yfp/TKRks2yK0DTx/pqP7SDXdOTk8I83te6uwqZV0fhJyj7xX1nu9P6Y9hMF/rsaSAMDYqFH9kbzkrYPZ3R2pUTqMCOZhhSi3m8/U0KltDZUftesSlqZBRj3Mg4PQPnF4gqoFMgiG+dMNZR4dCPVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727688669; c=relaxed/simple;
	bh=b+7lxHQBsKKGJPlwL9RmVWkxh5zyYlAIuY5dEo1s3hQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uiWqvFtJu1jT76CQ/a4lo7XoZpMS0eUFowAr1B/E28tpDxS8TLWR5ixKhYTCFsImTk6+DeAxFkW4G9g/TQmUaCCSz7ibtjp+IigPcr122z3k+lnuUgWf/Wh9mEikfMCzEpPnES+Jyju7HjDdX+c3FnOsXxZgO2yDl0UgCGOeqOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=KOHKbJvn; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="KOHKbJvn"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20b0b2528d8so45152045ad.2
        for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2024 02:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1727688666; x=1728293466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HqOQ1mrMtz8k2GPL+OfCCGmtnhkt8cvQfBe12lJsyS0=;
        b=KOHKbJvnAB6apaKBmIVMHyTc/oL3w33p2ToW5QqGsHn2wc7UwvD1SNRW/FKwgeYNdj
         Y/oLr/VUF/BOK5gdda0HdsFfXMdGg8Ql/fOnBM1VTlG311fKXCz9+rQGQm6eCpM4V6He
         9s3X01vBTV6heYLNDWwx5llLr8ZqBCFERwIbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727688666; x=1728293466;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HqOQ1mrMtz8k2GPL+OfCCGmtnhkt8cvQfBe12lJsyS0=;
        b=Abn5+fw6LzjbC2sNIQmbpnEdt7ILLPEnMt7lM5BN7jjbFJkcQx8x/4Qk8tb8XXeAbk
         WdGN15CaRMuEnKe37naID/gsWb7imRNpIXWDvm7ChJT3j4w6Fs0EtGftX5pM0W2fb8I+
         B3orf78m6yQPNTeh5I/g/wb3QGpogF6fDBGF0BYhVMaaxiGuPnRIqZ7N5k1qWjL+rYyG
         icd8cPz2E7TSDxsaeTSjIlnAjMOOg0A1aj67RQ0a1+q9XZBF5P9WmXzjSUMOfmydXcgP
         sJ9NIhBWlIAmQrS2/slC6Ef5aa0OdPdAr6go0/pEEcaNHmjgTlTHnbWZIs8BwsGWDz2g
         HBcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXFLheMEik5J115I+J7/XgRLY0ES3+6VbQDupil3suEgu/6amVqkrmJ6Ub6bOJ7v3D1lgUZuuUKfKRs+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJa26zT3p1gu5boFUab6JMyOwyNxXstsx1N8MbQZZIzCijIpFb
	6neWHkIhclnw8e+hk/LXrvL+Jfkxw2KyU+XvL9uPjJQyMDdYVdwl+obTcUKODms=
X-Google-Smtp-Source: AGHT+IHaOrPdblC812iCb98Fvov70Rm0mCVhy/kfF5wodwqUZqzOtmcKDlEShm8NZwE+euGmVQpPkQ==
X-Received: by 2002:a05:6a20:d704:b0:1d2:e458:4044 with SMTP id adf61e73a8af0-1d4fa6c358dmr17622233637.22.1727688666655;
        Mon, 30 Sep 2024 02:31:06 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b26499743sm6037482b3a.18.2024.09.30.02.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 02:31:06 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	robh@kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v9 0/7] Add SPAcc Crypto Driver
Date: Mon, 30 Sep 2024 15:00:47 +0530
Message-Id: <20240930093054.215809-1-pavitrakumarm@vayavyalabs.com>
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

Pavitrakumar M (7):
  Add SPAcc Skcipher support
  Add SPAcc AUTODETECT Support
  Add SPAcc ahash support
  Add SPAcc AEAD support
  Add SPAcc Kconfig and Makefile
  Add SPAcc compilation in crypto
  dt-bindings: crypto: Document support for SPAcc

changelog:
  v8 -> v9 changes:
    - Driver instance limited to one
    - Removed platfor_get_resource() and replaced with
      devm_platform_get_and_ioremap_resource()
    - vspacc-index renamed to vspacc-id
    - Used Kernel helpers for endian conversions.
    - Added vendor prefix (snps,) for custom properties
    - Added Co-developed tags for all the commits.
    - Removed clock-names from the DT properties.
  Link to v8: https://lore.kernel.org/linux-crypto/CALxtO0kMa0LLUzZOFFuH0bkUW-814=gbFouV3um6KSMHdGT=9A@mail.gmail.com/
              https://lore.kernel.org/all/20240905150910.239832-1-pavitrakumarm@vayavyalabs.com/T/#m793bbbae55d54e51f79578c8f1a8313493920555

  v7 -> v8 changes:
    - Added DT bindings for Documentation
    - Platform driver APIs updated.

 .../bindings/crypto/snps,dwc-spacc.yaml       |   71 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   94 +
 drivers/crypto/dwc-spacc/Makefile             |   16 +
 drivers/crypto/dwc-spacc/spacc_aead.c         | 1245 ++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  916 ++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2514 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  819 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  296 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  228 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  359 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  317 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  658 +++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c     |  720 +++++
 16 files changed, 8369 insertions(+)
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


base-commit: ce212d2afca47acd366a2e74c76fe82c31f785ab
-- 
2.25.1

