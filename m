Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCF4C00140
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 20:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239833AbiGZUQP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 16:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiGZUQO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 16:16:14 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B210B22285
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 13:16:08 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id f24-20020a1cc918000000b003a30178c022so11309wmb.3
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 13:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DuJgcpOe4gNmfay0rE1ntfTCfqk8yba7b4vVaG5kYnc=;
        b=YxKDpWHRk6i9u9cRxAikGdBPS4rkM9EbufsX8Ylp6WSmSPwuqqtGWDM9eeSIhFkCGD
         gZljTXMw/uhyOhT9/s+mikKLL7IDb0fyWlI9zx4oxS8Fp03qy/fLa1SmxiqDxKz5bJtr
         +RVo5Z2J8YdY3UtXL3UJUpYDUiHW6Rg1yXeAQCf/rf4Xrt+k2Iwv5Nqlo8BBQAc8XBqO
         r7QghM0I1v9A1smL/3w4VLl3PtoVg8uRedlxsCx+h6+LiAtPpdG6g37hxoUZ0Qq/bk39
         0YDy8v/z4ifI/dUHAfcDbWzDOJ9CvBGAmn1t9obfdycYt++P7CHI7QN/T6V4Z8PPWiKG
         l0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DuJgcpOe4gNmfay0rE1ntfTCfqk8yba7b4vVaG5kYnc=;
        b=Pek99I2DLEh+HwQz+i8BG9k+XXLdcjzuqvZHq9ZpVMgymZn3zgn/M/QNEYmvQ58oqh
         plnx48oZRXp4AMqtcZFEuOrOpZKFRglijcsHdcymCaJwUrP4OiFUrCxOqzpdHA6O00LP
         gN4eAdzBO9Inqu8f4joPW+UjEm2fNl1UiWFGfURRUfaxa+b3gjeTXgyr4z8JPrTfNTtb
         aaZbDXebgnSMKV/LN1YgU7fQ5aSwmVUJRLMRFmDh18VWjn1FpE8JTGWez0PovBl4QEr3
         0yOtHaNVpNZ2a4X3aj+7s3UewPq/63jobjrX+xN12sOQKjmIwNDWWy14R+fgyRaUMWKZ
         9seg==
X-Gm-Message-State: AJIora/A6UbGSlRuiQvQCOqyRvarmoDePfAr8rlDHdu4PVFg4KNHsu1S
        98db3265rDnUIWhZzLyGZGkgbA==
X-Google-Smtp-Source: AGRyM1vzUa5yqumKM6Ypk+SxZVxOPaosaOguI6fpqdcL1kfowdhYXfBgLSYDA2HymhTOc42t065Xsw==
X-Received: by 2002:a05:600c:17d5:b0:3a3:576:21ba with SMTP id y21-20020a05600c17d500b003a3057621bamr562364wmo.176.1658866567153;
        Tue, 26 Jul 2022 13:16:07 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b003a320e6f011sm28073wms.1.2022.07.26.13.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 13:16:06 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 0/6] net/crypto: Introduce crypto_pool
Date:   Tue, 26 Jul 2022 21:15:54 +0100
Message-Id: <20220726201600.1715505-1-dima@arista.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto_pool - an API for allocating per-CPU array of crypto requests
on slow-path (in sleep'able context) and to use them on a fast-path,
which is RX/TX for net/ users (or in any other bh-disabled users).
The design is based on the current implementations of md5sig_pool.

Previously, I've suggested to add such API on TCP-AO patch submission [1], 
where Herbert kindly suggested to help with introducing new crypto API.

New API will allow:
- to reuse per-CPU ahash_request(s) for different users
- to allocate only one per-CPU scratch buffer rather than a new one for
  each user
- to have a common API for net/ users that need ahash on RX/TX fast path

In this version I've wired up TCP-MD5 and IPv6-SR-HMAC as users.
Potentially, xfrm_ipcomp and xfrm_ah can be converted as well.
The initial reason for patches would be to have TCP-AO as a user, which
would let it share per-CPU crypto_request for any supported hashing
algorithm.

While at it, I've also made TCP-MD5 static key dynamically switchable.
This means that after TCP-MD5 was used and the last key got destroyed,
the static branch is disabled and any potential penalty for checking
tcp_md5sig_info is gone, and the system's tcp performance should be as
if it never had TCP-MD5 key defined.

[1]: http://lkml.kernel.org/r/20211106034334.GA18577@gondor.apana.org.au

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Francesco Ruggeri <fruggeri@arista.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leonard Crestez <cdleonard@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Salam Noureddine <noureddine@arista.com>
Cc: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Dmitry Safonov (6):
  crypto: Introduce crypto_pool
  crypto_pool: Add crypto_pool_reserve_scratch()
  net/tcp: Separate tcp_md5sig_info allocation into
    tcp_md5sig_info_add()
  net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction
  net/tcp: Use crypto_pool for TCP-MD5
  net/ipv6: sr: Switch to using crypto_pool

 crypto/Kconfig           |  12 ++
 crypto/Makefile          |   1 +
 crypto/crypto_pool.c     | 316 +++++++++++++++++++++++++++++++++++++++
 include/crypto/pool.h    |  33 ++++
 include/net/seg6_hmac.h  |   7 -
 include/net/tcp.h        |  32 ++--
 net/ipv4/Kconfig         |   2 +-
 net/ipv4/tcp.c           | 102 ++++---------
 net/ipv4/tcp_ipv4.c      | 153 ++++++++++++-------
 net/ipv4/tcp_minisocks.c |  23 ++-
 net/ipv4/tcp_output.c    |   4 +-
 net/ipv6/Kconfig         |   2 +-
 net/ipv6/seg6.c          |   3 -
 net/ipv6/seg6_hmac.c     | 204 ++++++++++---------------
 net/ipv6/tcp_ipv6.c      |  63 ++++----
 15 files changed, 634 insertions(+), 323 deletions(-)
 create mode 100644 crypto/crypto_pool.c
 create mode 100644 include/crypto/pool.h


base-commit: 058affafc65a74cf54499fb578b66ad0b18f939b
-- 
2.36.1

