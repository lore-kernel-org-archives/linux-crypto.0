Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954D4C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jan 2022 02:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1582361AbiAYCTy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415335AbiAYBpI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jan 2022 20:45:08 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD930C0A8876
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jan 2022 17:45:07 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i10-20020a25540a000000b0061391789216so37717095ybb.2
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jan 2022 17:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=oe74CoShjtAShwA7kMPhYzttzX+wC9lwSs6Wtzn+UiI=;
        b=CiJVitmQbgwpYEz1XHuuG/u51SF4CuxUGZieetjHHWTpKdSdH/LCREqBt63HAdQVir
         m8BFHx/7skf/xezHoDdHQkvdEMJjWHjAuMx6pTwTZOTYrgXDWti700EDLJ2GU3wIU9VI
         VulVlvTS2xh2W/BuF/0UCLnXCRTfXLXjLXcbpArphSlsiVuyEsX/pUdbUJIJkxBU74es
         hoIWR7OeBqTDbS+ubxLPORaMcMlXYCLzWsiWuSgL8XjySH25/y0zUopyXnOZC/g8odKz
         pp46vvQXnOQGnhsiEQNroMJjKL8XlbkXMMwuqvK9aJ6xUNzB+pY+Y7AhOdrZ8/hqScjg
         rs8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=oe74CoShjtAShwA7kMPhYzttzX+wC9lwSs6Wtzn+UiI=;
        b=wj+t22TgLgbnUWSdP2pMqrZ95czBgxy7gBsuNn3+fr85hUwyU1U2/bCzErI2tleGIf
         sFqmfJfcPcMv4nurRzIvXZFdbKiYd10oyrTQhr2eJptP7hgMNbaCf7AR1/StFw5+pjPE
         T6ooAhbQcqHL3FcZjjADXeUrTKlc5WxQXX1eSaAUmnlcNCphaJoOJsZAIdXKKUxs2OPx
         zMqVlq89mO73H1TCh6vV/mIdj3rai1zsxvI43vO/gglGsIDwQ/aHdONLKGHOl6Cl8JTM
         0J3BC3HhitbibdBbC3oMVj5gDkGlFefMVANTaQJFQ72WlJrNgXQC1Msdppxk0eOFiRkx
         EXhg==
X-Gm-Message-State: AOAM532OJsLEhVYT14UG+1VSoD17+0jbNrdY662sfk5uhu8GYYp+Ae+g
        gXgdB5+SzrunEXtcDzhxOm+NwyYxx6nYZoV/zJUG2Mc2RvcK/u/XzYuxQUGIzbrvLEChwnq8C1p
        wixumgsi4a82a09Xox2vkaiIzvpqnNxWZiOF4j+Sq9iDY/6bYl/rCsPgFJGckJHa3XPs=
X-Google-Smtp-Source: ABdhPJzxQ5VH8+X1dJPluxeqZp5+21h70mE7AqZs/dsSeEhtcWXiqCC8FuQ+YS81y0Q2KhWNhoIZgpApQQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a81:9347:0:b0:2ca:287c:6c59 with SMTP id
 00721157ae682-2ca287c6ea9mr2801297b3.254.1643075106090; Mon, 24 Jan 2022
 17:45:06 -0800 (PST)
Date:   Mon, 24 Jan 2022 19:44:15 -0600
Message-Id: <20220125014422.80552-1-nhuck@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [RFC PATCH 0/7] crypto: HCTR2 support
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
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

HCTR2 is specified in https://ia.cr/2021/1441 =E2=80=9CLength-preserving
encryption with HCTR2=E2=80=9D which shows that if AES is secure and HCTR2 =
is
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

 arch/arm64/crypto/Kconfig                    |   10 +-
 arch/arm64/crypto/Makefile                   |    3 +
 arch/arm64/crypto/aes-glue.c                 |   70 +-
 arch/arm64/crypto/aes-modes.S                |  128 ++
 arch/arm64/crypto/polyval-ce-core.S          |  317 ++++
 arch/arm64/crypto/polyval-ce-glue.c          |  164 ++
 arch/x86/crypto/Makefile                     |    5 +-
 arch/x86/crypto/aes_xctrby8_avx-x86_64.S     |  529 ++++++
 arch/x86/crypto/aesni-intel_asm.S            |   70 +
 arch/x86/crypto/aesni-intel_glue.c           |   88 +
 arch/x86/crypto/polyval-clmulni-intel_asm.S  |  319 ++++
 arch/x86/crypto/polyval-clmulni-intel_glue.c |  165 ++
 crypto/Kconfig                               |   37 +
 crypto/Makefile                              |    3 +
 crypto/hctr2.c                               |  475 +++++
 crypto/polyval-generic.c                     |  183 ++
 crypto/tcrypt.c                              |   10 +
 crypto/testmgr.c                             |   18 +
 crypto/testmgr.h                             | 1617 ++++++++++++++++++
 crypto/xctr.c                                |  202 +++
 include/crypto/polyval.h                     |   22 +
 include/crypto/xctr.h                        |   19 +
 22 files changed, 4449 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm64/crypto/polyval-ce-core.S
 create mode 100644 arch/arm64/crypto/polyval-ce-glue.c
 create mode 100644 arch/x86/crypto/aes_xctrby8_avx-x86_64.S
 create mode 100644 arch/x86/crypto/polyval-clmulni-intel_asm.S
 create mode 100644 arch/x86/crypto/polyval-clmulni-intel_glue.c
 create mode 100644 crypto/hctr2.c
 create mode 100644 crypto/polyval-generic.c
 create mode 100644 crypto/xctr.c
 create mode 100644 include/crypto/polyval.h
 create mode 100644 include/crypto/xctr.h

--=20
2.35.0.rc0.227.g00780c9af4-goog

