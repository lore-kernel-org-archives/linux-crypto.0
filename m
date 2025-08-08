Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9E0277CA0
	for <linux-crypto@vger.kernel.org>; Fri,  8 Aug 2025 12:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754656026; cv=none; b=pUvgeYTJzZrhikw1pAI8w8x/TMOlUAFPKoiizxaXvoCktGfVGCkH8mLdidEVEtOQGuRT79/X8NEcurdvF11GXmG5n1BDGrJLWcs8nGGi6e1z3OCUm1+IzhzDABv0lUNinBEO97/8K5lRG8AzNDLq+cOY3as5oBxWaKZnkEIoOqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754656026; c=relaxed/simple;
	bh=OKFjF1Bfnuf8ky87YXofFFua4f1JQFfaJXtPqeH77Fc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JEEwxdb3LTePEy5IyB686hz9icVYioGFcuZCo2iebafQouCG7bGkt0rPFBaljwKPxmvakgXMRWl8cG71s0O5D41CvM0sAmYikPfeAf0tsNMrCarVt3+IGAioVrKPDtXOgtNqXFzKshSrlhcP/w0FTCELM5vP0i2fn5IF13BrLNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=EX1gAw/p; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="EX1gAw/p"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-24003ed822cso11972015ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 08 Aug 2025 05:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1754656023; x=1755260823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PIrQA2x5lCe6wDOB4syEAlQhMjLSjkTfPyXDtA9t/Q4=;
        b=EX1gAw/pFTb3JECWBw7OHbIMoenduDYovtHunGUzfd1XEj47Hr5W1+YZB8E+wyqRH2
         0qTOoV/nwwzJ9EZ+2qBYrpKQr8ToMmPumoZlsUoagjL85/ba39O6w61EBSjPv4gbtWc7
         7mlKlFBZqgO7kpsnenJf8XKNGrFehxsIh/7R8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754656023; x=1755260823;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PIrQA2x5lCe6wDOB4syEAlQhMjLSjkTfPyXDtA9t/Q4=;
        b=uJiXteR5BLvMpl3bjGZKzdSzDg+uCpRpRy+KclvAQB4y6n1bjL62rGr4+ZIFh3LLgY
         HdMuULtb13SYTxfzhvWdlULxbWz1IVNBCDAIie9pInFJjz//wdONjVzqMyGt3vXuN4Tj
         ujW33TFkzLLijocIz5MhjvZr9vjOdTr3dYLYgliQXnFgZvOmxg4yDOc8R+lw7FB7CTM9
         qQJj9Pjs6HKDBSFJplCm0q3KJxFYFzUGRLo6vSa0FAIktv4dGP994LL2Ur/PBA1vG1sW
         EQvQBtvZ6Dhwl6pCLHYSAaNANp5qEk/oAaP7auM+xgREZxK/i9+/r787ol6GMPBfh1Kb
         u3EQ==
X-Gm-Message-State: AOJu0YzasDT5s+YJ2eB5SHO33KQ24O3H9P3LGAjYP++YINkeonLnqoBn
	kFOlkQMQJoHdhKMHByskWdDYITNBS2mY3laqpnt9e/BT0l7ua2TzhaMUXWjf8+22THlH4uhXjwK
	bB/y3
X-Gm-Gg: ASbGnctMVuGw+lAK7nxzmAycs/PSsQP1aUoNoLTJl9Nmw2Igxoe9GlYlkDDAJPJo/bL
	tCCr8HjI4LjIAQRxX/xuwSrTImGXMYUKX5agjsWZRaym08tuo+/tJ9oo/2iKyxA+pG9C7KWQZQP
	kgsWdKp6EcyD8m353F8QrVydEZKTY/bGz0EJYK1RHW2SPJiBJXqfNLzxsVVz0t5ZMovJlQoyi49
	N/suq53EgAzdH5qZL/zHlsYSgqtbG1gGNyTIyXcAiFhbWYxOGVTadtz2gxb2k9v1tu4dHI50l0Q
	ozR814IOk5LvD/VXu9QtcmeW3AbRSJr9ckN0wis91B17Mw7GLv6nSbD1A2QR8XarnlV7FFZ1aOD
	7f0Fh/mhZxTR3Ej8JB+cFbgKgiKZd3yubQRGLfEIUl2vhcDET8s1jHo73
X-Google-Smtp-Source: AGHT+IEPWSAwHTSc8ABL9LCu2I6T6WODoVF4DZm55wdkaEYX0gM2Xc13ez3clxRybEyqcPrMyMs6Rw==
X-Received: by 2002:a17:902:f78e:b0:240:1831:eede with SMTP id d9443c01a7336-242c21e043dmr54100225ad.32.1754656023573;
        Fri, 08 Aug 2025 05:27:03 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e899a8cdsm208296665ad.121.2025.08.08.05.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 05:27:03 -0700 (PDT)
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
Subject: [PATCH v4 0/6] Add SPAcc Crypto Driver
Date: Fri,  8 Aug 2025 17:56:25 +0530
Message-Id: <20250808122631.697421-1-pavitrakumarm@vayavyalabs.com>
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

  v3->v4 changes:
   - removed snps,vspacc-id from the dt-bindings 
   - removed mutex_lock from ciphers
   - replaced magic numbers with macros
   - removed sw_fb variable from struct mode_tab and associated code from the
     hashes
   - polling code is replaced by wait_event_interruptible

 .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |  114 +
 drivers/crypto/dwc-spacc/Makefile             |   16 +
 drivers/crypto/dwc-spacc/spacc_aead.c         | 1297 +++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  968 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2452 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  832 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  275 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  230 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  330 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  611 ++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c     |  752 +++++
 16 files changed, 8417 insertions(+)
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


base-commit: 9d9b193ed73a65ec47cf1fd39925b09da8216461
-- 
2.25.1

