Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2BFFC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 23:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbiBJX2f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 18:28:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345655AbiBJX2f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 18:28:35 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F207116D
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:28:35 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z15-20020a25bb0f000000b00613388c7d99so15316445ybg.8
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=X4pGovICiPQ0U+Wm+4Mu3dfpVMwLlQ+3KkIwYwKv2HY=;
        b=JwD33JaCAdwyGy0A45Vk6WDnFItu+aqp8GMTky89wFARQDZXlfOVNqaT9dWXtuQT0W
         oIIYuvVAGp5n3+826axpuJSMg9Ywdo+SGL8/b7YiTHwrZMcSnXamKw9lqcbjMmVCT0Kd
         Tv36pXuj+yUVH6Xe7DoITIf74d4kX+Vh3eWP3jpNPZwuveodR/20y9cieYqS+Wu2g48a
         zCocD7ZuDG7AG2MunqE34VUGiJGG3cFJG2x8PAeVt4JDg7ZBDuo1ChClCnvjMVxSk057
         8QP4ueC/UG2ztofFRdQKXWJcpMXr1MAwtMm+ZV1+lNV60BD6xSedODK4Y+qaZHGQvpf5
         fqCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=X4pGovICiPQ0U+Wm+4Mu3dfpVMwLlQ+3KkIwYwKv2HY=;
        b=3bappqV9v02c3s6cdrnOoLTbfS3Kbe9yNoELCPDwOa6TD9+cJigHcQqDbCpY5GTnA7
         N7r5NArSyXYywUsYNKS6q6UmYJWI5KmWUIPQ8pWfZQcnoMMwFwfKWulh9e2CHETdmNiQ
         lTAjKadsK5yTQYsKITaaC/YjIBCgAfAC0c1RA3u0NzakWs1VzpwmSw6Agvfq+ghwiU8/
         NvhPGO4eQDSlS2/2GXjh2mFwfzqDvAcPtac2vP2Zt68pOCa82Q9NS1ZQoKHcRXS30hNH
         8yjoWw/XHbT+C+l/xkUVWp3YiuZkOvyuBAbMmHTaLaLlM0WEtZoF4lJhwopfqBNPvyOs
         c+rw==
X-Gm-Message-State: AOAM530JeNM/6CiSwx3Af2shU567TJ2BM0nN6LvGsXmNJ3qRf0EoQKRw
        VD5VnI+Q0Se5GvOkjTZd8GMYde9YkT/xn8oR4tCcIfvpEIzjQzEPMvkb0abs13VlJz8F+gP+g52
        Z6HWSnC2uoulPXW7v2I8vomM6JLAxMKDHUALETomNUuzlw4RRAqMdir93SQcDRg0UdIQ=
X-Google-Smtp-Source: ABdhPJxwZ4Y6YJ+RiwWywKVKfsWcJiykReiGnNG6XrsemntyXE/P+wYILD44hJRaJ3u7EJU7Kuy7AT51Ww==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:30d4:: with SMTP id w203mr9052733ybw.511.1644535714443;
 Thu, 10 Feb 2022 15:28:34 -0800 (PST)
Date:   Thu, 10 Feb 2022 23:28:05 +0000
Message-Id: <20220210232812.798387-1-nhuck@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [RFC PATCH v2 0/7] crypto: HCTR2 support
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

HCTR2 is a length-preserving encryption mode that is efficient on
processors with instructions to accelerate AES and carryless
multiplication, e.g. x86 processors with AES-NI and CLMUL, and ARM
processors with the ARMv8 Crypto Extensions.

HCTR2 is specified in https://ia.cr/2021/1441 "Length-preserving
encryption with HCTR2" which shows that if AES is secure and HCTR2 is
instantiated with AES, then HCTR2 is secure.  Reference code and test
vectors are at https://github.com/google/hctr2.

As a length-preserving encryption mode, HCTR2 is suitable for applications
such as storage encryption where ciphertext expansion is not possible, and
thus authenticated encryption cannot be used.  Currently, such
applications usually use XTS, or in some cases Adiantum.  XTS has the
disadvantage that it is a narrow-block mode: a bitflip will only change 16
bytes in the resulting ciphertext or plaintext.  This reveals more
information to an attacker than necessary.

HCTR2 is a wide-block mode, so it provides a stronger security property: a
bitflip will change the entire message.  HCTR2 is somewhat similar to
Adiantum, which is also a wide-block mode.  However, HCTR2 is designed to
take advantage of existing crypto instructions, while Adiantum targets
devices without such hardware support.  Adiantum is also designed with
longer messages in mind, while HCTR2 is designed to be efficient even on
short messages.

The first intended use of this mode in the kernel is for the encryption of
filenames, where for efficiency reasons encryption must be fully
deterministic (only one ciphertext for each plaintext) and the existing
CBC solution leaks more information than necessary for filenames with
common prefixes.

HCTR2 uses two passes of an =CE=B5-almost-=E2=88=86-universal hash function=
 called
POLYVAL and one pass of a block cipher mode called XCTR.  POLYVAL is a
polynomial hash designed for efficiency on modern processors and was
originally specified for use in AES-GCM-SIV (RFC 8452).  XCTR mode is a
variant of CTR mode that is more efficient on little-endian machines.

This patchset adds HCTR2 to Linux's crypto API, including generic
implementations of XCTR and POLYVAL, hardware accelerated implementations
of XCTR and POLYVAL for both x86-64 and ARM64, and a templated
implementation of HCTR2.

Nathan Huckleberry (7):
  crypto: xctr - Add XCTR support
  crypto: polyval - Add POLYVAL support
  crypto: hctr2 - Add HCTR2 support
  crypto: x86/aesni-xctr: Add accelerated implementation of XCTR
  crypto: arm64/aes-xctr: Add accelerated implementation of XCTR
  crypto: x86/polyval: Add PCLMULQDQ accelerated implementation of
    POLYVAL
  crypto: arm64/polyval: Add PMULL accelerated implementation of POLYVAL

 arch/arm64/crypto/Kconfig                |   11 +-
 arch/arm64/crypto/Makefile               |    3 +
 arch/arm64/crypto/aes-glue.c             |   72 +-
 arch/arm64/crypto/aes-modes.S            |  130 ++
 arch/arm64/crypto/polyval-ce-core.S      |  405 ++++++
 arch/arm64/crypto/polyval-ce-glue.c      |  365 ++++++
 arch/x86/crypto/Makefile                 |    5 +-
 arch/x86/crypto/aes_xctrby8_avx-x86_64.S |  529 ++++++++
 arch/x86/crypto/aesni-intel_asm.S        |   70 +
 arch/x86/crypto/aesni-intel_glue.c       |   89 ++
 arch/x86/crypto/polyval-clmulni_asm.S    |  414 ++++++
 arch/x86/crypto/polyval-clmulni_glue.c   |  365 ++++++
 crypto/Kconfig                           |   38 +
 crypto/Makefile                          |    3 +
 crypto/hctr2.c                           |  532 ++++++++
 crypto/polyval-generic.c                 |  199 +++
 crypto/tcrypt.c                          |   10 +
 crypto/testmgr.c                         |   20 +
 crypto/testmgr.h                         | 1500 ++++++++++++++++++++++
 crypto/xctr.c                            |  193 +++
 include/crypto/polyval.h                 |   22 +
 21 files changed, 4970 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm64/crypto/polyval-ce-core.S
 create mode 100644 arch/arm64/crypto/polyval-ce-glue.c
 create mode 100644 arch/x86/crypto/aes_xctrby8_avx-x86_64.S
 create mode 100644 arch/x86/crypto/polyval-clmulni_asm.S
 create mode 100644 arch/x86/crypto/polyval-clmulni_glue.c
 create mode 100644 crypto/hctr2.c
 create mode 100644 crypto/polyval-generic.c
 create mode 100644 crypto/xctr.c
 create mode 100644 include/crypto/polyval.h

--=20
2.35.1.265.g69c8d7142f-goog

