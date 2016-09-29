From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] arm64: add support for SHA256 using NEON instructions
Date: Thu, 29 Sep 2016 15:51:42 -0700
Message-ID: <1475189503-9175-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: appro@openssl.org, victor.chong@linaro.org,
        daniel.thompson@linaro.org, will.deacon@arm.com,
        catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34534 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935356AbcI2Wvt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Sep 2016 18:51:49 -0400
Received: by mail-pf0-f178.google.com with SMTP id u78so7935900pfa.1
        for <linux-crypto@vger.kernel.org>; Thu, 29 Sep 2016 15:51:47 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a port of the ARMv7 implementation in arch/arm/crypto. For a Cortex-A57
(r2p1), the performance numbers are listed below. In summary, 40% - 50% speedup
where it counts, i.e., block sizes over 256 bytes with few updates.

testing speed of async sha256 (sha256-generic)
(   16 byte blocks,   16 bytes x   1 updates): 1379992 ops/s,  22079872 Bps
(   64 byte blocks,   16 bytes x   4 updates): 633455 ops/s,  40541120 Bps
(   64 byte blocks,   64 bytes x   1 updates): 738076 ops/s,  47236864 Bps
(  256 byte blocks,   16 bytes x  16 updates): 234420 ops/s,  60011520 Bps
(  256 byte blocks,   64 bytes x   4 updates): 293008 ops/s,  75010048 Bps
(  256 byte blocks,  256 bytes x   1 updates): 309600 ops/s,  79257600 Bps
( 1024 byte blocks,   16 bytes x  64 updates):  66997 ops/s,  68604928 Bps
( 1024 byte blocks,  256 bytes x   4 updates):  91912 ops/s,  94117888 Bps
( 1024 byte blocks, 1024 bytes x   1 updates):  93992 ops/s,  96247808 Bps
( 2048 byte blocks,   16 bytes x 128 updates):  34385 ops/s,  70420480 Bps
( 2048 byte blocks,  256 bytes x   8 updates):  47570 ops/s,  97423360 Bps
( 2048 byte blocks, 1024 bytes x   2 updates):  48557 ops/s,  99444736 Bps
( 2048 byte blocks, 2048 bytes x   1 updates):  48781 ops/s,  99903488 Bps
( 4096 byte blocks,   16 bytes x 256 updates):  17401 ops/s,  71274496 Bps
( 4096 byte blocks,  256 bytes x  16 updates):  24211 ops/s,  99168256 Bps
( 4096 byte blocks, 1024 bytes x   4 updates):  24720 ops/s, 101253120 Bps
( 4096 byte blocks, 4096 bytes x   1 updates):  24930 ops/s, 102113280 Bps
( 8192 byte blocks,   16 bytes x 512 updates):   8738 ops/s,  71581696 Bps
( 8192 byte blocks,  256 bytes x  32 updates):  12214 ops/s, 100057088 Bps
( 8192 byte blocks, 1024 bytes x   8 updates):  12474 ops/s, 102187008 Bps
( 8192 byte blocks, 4096 bytes x   2 updates):  12558 ops/s, 102875136 Bps
( 8192 byte blocks, 8192 bytes x   1 updates):  12555 ops/s, 102850560 Bps

testing speed of async sha256 (sha256-neon)
(   16 byte blocks,   16 bytes x   1 updates): 1802881 ops/s,  28846096 Bps
(   64 byte blocks,   16 bytes x   4 updates): 744861 ops/s,  47671104 Bps
(   64 byte blocks,   64 bytes x   1 updates): 1015413 ops/s,  64986432 Bps
(  256 byte blocks,   16 bytes x  16 updates): 281055 ops/s,  71950080 Bps
(  256 byte blocks,   64 bytes x   4 updates): 378437 ops/s,  96879872 Bps
(  256 byte blocks,  256 bytes x   1 updates): 453325 ops/s, 116051200 Bps
( 1024 byte blocks,   16 bytes x  64 updates):  79809 ops/s,  81724416 Bps
( 1024 byte blocks,  256 bytes x   4 updates): 131621 ops/s, 134779904 Bps
( 1024 byte blocks, 1024 bytes x   1 updates): 140708 ops/s, 144084992 Bps
( 2048 byte blocks,   16 bytes x 128 updates):  40900 ops/s,  83763200 Bps
( 2048 byte blocks,  256 bytes x   8 updates):  68348 ops/s, 139976704 Bps
( 2048 byte blocks, 1024 bytes x   2 updates):  72051 ops/s, 147560448 Bps
( 2048 byte blocks, 2048 bytes x   1 updates):  73358 ops/s, 150237184 Bps
( 4096 byte blocks,   16 bytes x 256 updates):  20746 ops/s,  84975616 Bps
( 4096 byte blocks,  256 bytes x  16 updates):  34842 ops/s, 142712832 Bps
( 4096 byte blocks, 1024 bytes x   4 updates):  36794 ops/s, 150708224 Bps
( 4096 byte blocks, 4096 bytes x   1 updates):  37422 ops/s, 153280512 Bps
( 8192 byte blocks,   16 bytes x 512 updates):  10428 ops/s,  85426176 Bps
( 8192 byte blocks,  256 bytes x  32 updates):  17600 ops/s, 144179200 Bps
( 8192 byte blocks, 1024 bytes x   8 updates):  18594 ops/s, 152322048 Bps
( 8192 byte blocks, 4096 bytes x   2 updates):  18858 ops/s, 154484736 Bps
( 8192 byte blocks, 8192 bytes x   1 updates):  18880 ops/s, 154664960 Bps

testing speed of async sha256 (sha256-ce)
(   16 byte blocks,   16 bytes x   1 updates): 4107417 ops/s,  65718672 Bps
(   64 byte blocks,   16 bytes x   4 updates): 1418054 ops/s,  90755456 Bps
(   64 byte blocks,   64 bytes x   1 updates): 3323045 ops/s, 212674880 Bps
(  256 byte blocks,   16 bytes x  16 updates): 450084 ops/s, 115221504 Bps
(  256 byte blocks,   64 bytes x   4 updates): 1034376 ops/s, 264800256 Bps
(  256 byte blocks,  256 bytes x   1 updates): 1798744 ops/s, 460478464 Bps
( 1024 byte blocks,   16 bytes x  64 updates): 121411 ops/s, 124324864 Bps
( 1024 byte blocks,  256 bytes x   4 updates): 506086 ops/s, 518232064 Bps
( 1024 byte blocks, 1024 bytes x   1 updates): 634485 ops/s, 649712640 Bps
( 2048 byte blocks,   16 bytes x 128 updates):  61520 ops/s, 125992960 Bps
( 2048 byte blocks,  256 bytes x   8 updates): 266787 ops/s, 546379776 Bps
( 2048 byte blocks, 1024 bytes x   2 updates): 316910 ops/s, 649031680 Bps
( 2048 byte blocks, 2048 bytes x   1 updates): 342777 ops/s, 702007296 Bps
( 4096 byte blocks,   16 bytes x 256 updates):  31003 ops/s, 126988288 Bps
( 4096 byte blocks,  256 bytes x  16 updates): 138097 ops/s, 565645312 Bps
( 4096 byte blocks, 1024 bytes x   4 updates): 164319 ops/s, 673050624 Bps
( 4096 byte blocks, 4096 bytes x   1 updates): 176310 ops/s, 722165760 Bps
( 8192 byte blocks,   16 bytes x 512 updates):  15566 ops/s, 127516672 Bps
( 8192 byte blocks,  256 bytes x  32 updates):  69608 ops/s, 570228736 Bps
( 8192 byte blocks, 1024 bytes x   8 updates):  83682 ops/s, 685522944 Bps
( 8192 byte blocks, 4096 bytes x   2 updates):  88813 ops/s, 727556096 Bps
( 8192 byte blocks, 8192 bytes x   1 updates):  88781 ops/s, 727293952 Bps

Ard Biesheuvel (1):
  crypto: arm64/sha256 - add support for SHA256 using NEON instructions

 arch/arm64/crypto/Kconfig               |   5 +
 arch/arm64/crypto/Makefile              |  11 +
 arch/arm64/crypto/sha256-armv4.pl       | 413 +++++++++
 arch/arm64/crypto/sha256-core.S_shipped | 883 ++++++++++++++++++++
 arch/arm64/crypto/sha256_neon_glue.c    | 103 +++
 5 files changed, 1415 insertions(+)
 create mode 100644 arch/arm64/crypto/sha256-armv4.pl
 create mode 100644 arch/arm64/crypto/sha256-core.S_shipped
 create mode 100644 arch/arm64/crypto/sha256_neon_glue.c

-- 
2.7.4
