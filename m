Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="S95c7fFz"
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFA412D
	for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 23:07:14 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1cfb2176150so11002335ad.3
        for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 23:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701068833; x=1701673633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M0gSkc9h7Dt01uGTWB4LCFdNicZR7jg2IspiMbYPhPs=;
        b=S95c7fFzygJQAMDn8ZcnvH3qipYm1ZKRBVKnpuOBu/JQgpJBNdVYW5aIlrEQz48yGP
         8257FP9eiYcYy7WYc32WLYxdR/JYotzsLHtVGfaUeIVu5Ieas3WaLII0dJVvzF1RNL5w
         rdwidD5gBL4pPt0STijhZy4xppAxRLBfigvxSniqRofzMrHPtlhAF4z4pz5ejbCvWMgt
         m6ZBQh1KotOBSQ5Lq5Rm7WU8pVRLmtee8MG8GX+Een2sNq81HTolbYryfYIJTbJSOptE
         8ESlgd1pSdYeLRFNiJnFAl2NT3kmCTBege1fVytoxPR5byDYhsu03j4ZqzSehWbaF6Fi
         rrEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701068833; x=1701673633;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M0gSkc9h7Dt01uGTWB4LCFdNicZR7jg2IspiMbYPhPs=;
        b=uxLUXK9V4/CCKeNmp5slcHYU/XTkbWRrJvvT1nb715MSd81BobgNCWLKPH4xY1t5uO
         hsmkZqRJBPoni8FRLGsSNpxvV8Jlwz5XVHcnz5gQU0xaXOVYTOjhTaKZjHOCD6HsoAqp
         MT869o4i4qbIizNGYjRDqXYJIP7YHaQB48/pJMdipoiTuAB/YW/GODIoprL1OTZsAsZu
         3VGml3whgS5zT5WMc71LLTOBhNyl6qbH/qdgUttsOaf74lHwgFLc2k2+Lh1wZEgnX97D
         R4/3S/o9gx+Ad+pUsCD8RD+KA6CkVOEA6S6K0UFjnazurYCc+fE5zzLFrEcUnB4PeGkz
         /i0Q==
X-Gm-Message-State: AOJu0Yx0rRioFhDwA+PIHjMzT1RAyXdBjGOcPRG00Os4EBTiUYPRlB8c
	LN8aBjLif8Lij/xGtHkS/2lbOw==
X-Google-Smtp-Source: AGHT+IEfe6FjAY/b3i+5RpV4TYqK3Omg/1PqoyhXli/ctCcwdTs4Sv4A93+zLYj5Jd499/7PyEN7uw==
X-Received: by 2002:a17:90b:4a03:b0:280:8544:42fb with SMTP id kk3-20020a17090b4a0300b00280854442fbmr9692227pjb.17.1701068833493;
        Sun, 26 Nov 2023 23:07:13 -0800 (PST)
Received: from localhost.localdomain ([101.10.45.230])
        by smtp.gmail.com with ESMTPSA id jh15-20020a170903328f00b001cfcd3a764esm1340134plb.77.2023.11.26.23.07.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Nov 2023 23:07:12 -0800 (PST)
From: Jerry Shih <jerry.shih@sifive.com>
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	conor.dooley@microchip.com,
	ebiggers@kernel.org,
	ardb@kernel.org
Cc: heiko@sntech.de,
	phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 00/13] RISC-V: provide some accelerated cryptography implementations using vector extensions
Date: Mon, 27 Nov 2023 15:06:50 +0800
Message-Id: <20231127070703.1697-1-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series provides cryptographic implementations using the vector crypto
extensions[1] including:
1. AES cipher
2. AES with CBC/CTR/ECB/XTS block modes
3. ChaCha20 stream cipher
4. GHASH for GCM
5. SHA-224/256 and SHA-384/512 hash
6. SM3 hash
7. SM4 cipher

This patch set is based on Heiko Stuebner's work at:
Link: https://lore.kernel.org/all/20230711153743.1970625-1-heiko@sntech.de/

The implementations reuse the perl-asm scripts from OpenSSL[2] with some
changes adapting for the kernel crypto framework.
The perl-asm scripts generate the opcodes into `.S` files instead of asm
mnemonics. The reason for using opcodes is because that we don't want to
re-implement all crypto functions from OpenSSL. We will try to replace
perl-asm with asm mnemonics in the future. It needs lots of extensions
checking for toolchains. We already have RVV 1.0 in kernel, so we will
replace the RVV opcodes with asm mnemonics at first.

All changes pass the kernel run-time crypto self tests and the extra tests
with vector-crypto-enabled qemu.
Link: https://lists.gnu.org/archive/html/qemu-devel/2023-11/msg00281.html

This series depend on:
1. kernel 6.6-rc7
Link: https://github.com/torvalds/linux/commit/05d3ef8bba77c1b5f98d941d8b2d4aeab8118ef1
2. support kernel-mode vector
Link: https://lore.kernel.org/all/20230721112855.1006-1-andy.chiu@sifive.com/
3. vector crypto extensions detection
Link: https://lore.kernel.org/lkml/20231017131456.2053396-1-cleger@rivosinc.com/
4. fix the error message:
    alg: skcipher: skipping comparison tests for xts-aes-aesni because
    xts(ecb(aes-generic)) is unavailable
Link: https://lore.kernel.org/linux-crypto/20231009023116.266210-1-ebiggers@kernel.org/

Here is a branch on github applying with all dependent patches:
Link: https://github.com/JerryShih/linux/tree/dev/jerrys/vector-crypto-upstream-v2

[1]
Link: https://github.com/riscv/riscv-crypto/blob/56ed7952d13eb5bdff92e2b522404668952f416d/doc/vector/riscv-crypto-spec-vector.adoc
[2]
Link: https://github.com/openssl/openssl/pull/21923

Updated patches (on current order): 4, 7, 8, 9, 10, 11, 12, 13
New patch: 6,
Unchanged patch: 1, 2, 3, 5
Deleted patch: -

Changelog v2:
 - Do not turn on the RISC-V accelerated crypto kconfig options by
   default.
 - Assume RISC-V vector extension could support unaligned access in
   kernel.
 - Turn to use simd skcipher interface for AES-CBC/CTR/ECB/XTS and
   Chacha20.
 - Rename crypto file and driver names to make the most important
   extension at first place.

Heiko Stuebner (2):
  RISC-V: add helper function to read the vector VLEN
  RISC-V: hook new crypto subdir into build-system

Jerry Shih (11):
  RISC-V: crypto: add OpenSSL perl module for vector instructions
  RISC-V: crypto: add Zvkned accelerated AES implementation
  crypto: simd - Update `walksize` in simd skcipher
  crypto: scatterwalk - Add scatterwalk_next() to get the next
    scatterlist in scatter_walk
  RISC-V: crypto: add accelerated AES-CBC/CTR/ECB/XTS implementations
  RISC-V: crypto: add Zvkg accelerated GCM GHASH implementation
  RISC-V: crypto: add Zvknha/b accelerated SHA224/256 implementations
  RISC-V: crypto: add Zvknhb accelerated SHA384/512 implementations
  RISC-V: crypto: add Zvksed accelerated SM4 implementation
  RISC-V: crypto: add Zvksh accelerated SM3 implementation
  RISC-V: crypto: add Zvkb accelerated ChaCha20 implementation

 arch/riscv/Kbuild                             |    1 +
 arch/riscv/crypto/Kconfig                     |  110 ++
 arch/riscv/crypto/Makefile                    |   68 +
 .../crypto/aes-riscv64-block-mode-glue.c      |  514 +++++++
 arch/riscv/crypto/aes-riscv64-glue.c          |  151 ++
 arch/riscv/crypto/aes-riscv64-glue.h          |   18 +
 .../crypto/aes-riscv64-zvkned-zvbb-zvkg.pl    |  949 ++++++++++++
 arch/riscv/crypto/aes-riscv64-zvkned-zvkb.pl  |  415 +++++
 arch/riscv/crypto/aes-riscv64-zvkned.pl       | 1339 +++++++++++++++++
 arch/riscv/crypto/chacha-riscv64-glue.c       |  122 ++
 arch/riscv/crypto/chacha-riscv64-zvkb.pl      |  321 ++++
 arch/riscv/crypto/ghash-riscv64-glue.c        |  175 +++
 arch/riscv/crypto/ghash-riscv64-zvkg.pl       |  100 ++
 arch/riscv/crypto/riscv.pm                    |  828 ++++++++++
 arch/riscv/crypto/sha256-riscv64-glue.c       |  145 ++
 .../sha256-riscv64-zvknha_or_zvknhb-zvkb.pl   |  318 ++++
 arch/riscv/crypto/sha512-riscv64-glue.c       |  139 ++
 .../crypto/sha512-riscv64-zvknhb-zvkb.pl      |  266 ++++
 arch/riscv/crypto/sm3-riscv64-glue.c          |  124 ++
 arch/riscv/crypto/sm3-riscv64-zvksh.pl        |  230 +++
 arch/riscv/crypto/sm4-riscv64-glue.c          |  121 ++
 arch/riscv/crypto/sm4-riscv64-zvksed.pl       |  268 ++++
 arch/riscv/include/asm/vector.h               |   11 +
 crypto/Kconfig                                |    3 +
 crypto/cryptd.c                               |    1 +
 crypto/simd.c                                 |    1 +
 include/crypto/scatterwalk.h                  |    9 +-
 27 files changed, 6745 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/crypto/Kconfig
 create mode 100644 arch/riscv/crypto/Makefile
 create mode 100644 arch/riscv/crypto/aes-riscv64-block-mode-glue.c
 create mode 100644 arch/riscv/crypto/aes-riscv64-glue.c
 create mode 100644 arch/riscv/crypto/aes-riscv64-glue.h
 create mode 100644 arch/riscv/crypto/aes-riscv64-zvkned-zvbb-zvkg.pl
 create mode 100644 arch/riscv/crypto/aes-riscv64-zvkned-zvkb.pl
 create mode 100644 arch/riscv/crypto/aes-riscv64-zvkned.pl
 create mode 100644 arch/riscv/crypto/chacha-riscv64-glue.c
 create mode 100644 arch/riscv/crypto/chacha-riscv64-zvkb.pl
 create mode 100644 arch/riscv/crypto/ghash-riscv64-glue.c
 create mode 100644 arch/riscv/crypto/ghash-riscv64-zvkg.pl
 create mode 100644 arch/riscv/crypto/riscv.pm
 create mode 100644 arch/riscv/crypto/sha256-riscv64-glue.c
 create mode 100644 arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.pl
 create mode 100644 arch/riscv/crypto/sha512-riscv64-glue.c
 create mode 100644 arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.pl
 create mode 100644 arch/riscv/crypto/sm3-riscv64-glue.c
 create mode 100644 arch/riscv/crypto/sm3-riscv64-zvksh.pl
 create mode 100644 arch/riscv/crypto/sm4-riscv64-glue.c
 create mode 100644 arch/riscv/crypto/sm4-riscv64-zvksed.pl

--
2.28.0

