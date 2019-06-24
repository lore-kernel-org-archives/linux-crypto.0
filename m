Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D0FC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 742872089F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EFUddc5Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFXHia (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:38:30 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36584 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFXHia (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 03:38:30 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so11516756wrs.3
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 00:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mXpydhn3h8+bwzi+XRJ+smOVOxIlaYlB/CCvwP4+MC0=;
        b=EFUddc5ZhmYskuZkgdXO8fVeBRbsHkwxsuCWTy9nTMFiqHeoeKYmQ8UKTeARs/Ufi0
         AGSAGAyxxey9pENHwuPySrCsOagS0TuUhMdPRGkpbum/kNByuTEOIPnGvLn7MylZ8XQY
         zIMjaMmbzwtPwHqZF5VbI6y+sOSVj6g92/Ihem13G6RH/z/RcABIPO+vK1nLUIoWbIXG
         w5WcIGGvh0yfhxM/QY/kHR0ZHNg5R6QLYs0kcR1cLqFb2uc9kKTFc1Q9bvbX8jmNLiID
         YwQg++0PAd0hxvoklpata8ZfVeTv98YqXEOE5brwnTEzTKtVo/7RFSxFKfrOf46mdvep
         xQtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mXpydhn3h8+bwzi+XRJ+smOVOxIlaYlB/CCvwP4+MC0=;
        b=dKVCUC9JwO1afMyZnN/k1BPLd3PxoHihoy9SBDERJgn1JOX9DNdljTe+duSn5qSkeF
         iuONpJarzZY9NzFLiLbnxOOzW5wyWXXBJvGs/rNtXhJWnD9FQglZAUspaNuE7I3ew/oG
         Svm0F2jYLcZJgofGaRKNB5uYnsny3vzNJr/5Q4FhuDWKojEuZItDI3cEmsX9xWy/qlTp
         aLVRB3NriScLnpM9YSbJl+ldflQXVc2u/5RJGfxIywM+W9DtOuzLhkONm+A43UDgRQ0b
         yF5I81q/KK2a4rNXyoeeUcPv0RBRDoVxAAgQvwwARo4UDnV4X2d5mEd8p8eiIHFlF9XL
         waJg==
X-Gm-Message-State: APjAAAXZx2/IbBRE2rCkSR9vjwBJC3UaFnLIwX8SQ3Wh5nmRaAmMGrIb
        iQAGbcf6v9rvWThPEc7mdma+QzHiQ4Sa1w==
X-Google-Smtp-Source: APXvYqyHU+wrAL3tzmfsUcOkdJGCukuctwZR1VG5OIO/Y8RTnTMwtaL77LTKb4zuZzvqFyI6M5WWjQ==
X-Received: by 2002:adf:fbd0:: with SMTP id d16mr23209832wrs.341.1561361908966;
        Mon, 24 Jun 2019 00:38:28 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4866:7cdc:a930:8455])
        by smtp.gmail.com with ESMTPSA id 203sm7419280wmc.30.2019.06.24.00.38.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 00:38:28 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>
Subject: [PATCH 0/6] crypto: aegis128 - add NEON intrinsics version for ARM/arm64
Date:   Mon, 24 Jun 2019 09:38:12 +0200
Message-Id: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that aegis128 has been announced as one of the winners of the CAESAR
competition, it's time to provide some better support for it on arm64 (and
32-bit ARM *)

This time, instead of cloning the generic driver twice and rewriting half
of it in arm64 and ARM assembly, add hooks for an accelerated SIMD path to
the generic driver, and populate it with a C version using NEON intrinsics
that can be built for both ARM and arm64. This results in a speedup of ~11x,
resulting in a performance of 2.2 cycles per byte on Cortex-A53.

Patches #1 .. #3 are some fixes/improvements for the generic code. Patch #4
adds the plumbing for using a SIMD accelerated implementation. Patch #5
adds the ARM and arm64 code, and patch #6 adds a speed test.

Note that aegis128l and aegis256 were not selected, and nor where any of the
morus contestants, and so we should probably consider dropping those drivers
again.

* 32-bit ARM today rarely provides the special AES instruction that the
  implementation in this series relies on, but this may change in the future,
  and the NEON intrinsics code can be compiled for both ISAs.

Cc: Eric Biggers <ebiggers@google.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steve Capper <steve.capper@arm.com>

Ard Biesheuvel (6):
  crypto: aegis128 - use unaliged helper in unaligned decrypt path
  crypto: aegis - drop empty TFM init/exit routines
  crypto: aegis - avoid prerotated AES tables
  crypto: aegis128 - add support for SIMD acceleration
  crypto: aegis128 - provide a SIMD implementation based on NEON
    intrinsics
  crypto: tcrypt - add a speed test for AEGIS128

 crypto/Kconfig               |   5 +
 crypto/Makefile              |  12 ++
 crypto/aegis.h               |  28 ++--
 crypto/aegis128-neon-inner.c | 142 ++++++++++++++++++++
 crypto/aegis128-neon.c       |  43 ++++++
 crypto/aegis128.c            |  55 +++++---
 crypto/aegis128l.c           |  11 --
 crypto/aegis256.c            |  11 --
 crypto/tcrypt.c              |   7 +
 9 files changed, 261 insertions(+), 53 deletions(-)
 create mode 100644 crypto/aegis128-neon-inner.c
 create mode 100644 crypto/aegis128-neon.c

-- 
2.20.1

