Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D8DC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Oct 2022 10:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiJNKIA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Oct 2022 06:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiJNKHy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Oct 2022 06:07:54 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8F715381B
        for <linux-crypto@vger.kernel.org>; Fri, 14 Oct 2022 03:07:52 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bu30so6796153wrb.8
        for <linux-crypto@vger.kernel.org>; Fri, 14 Oct 2022 03:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kPSC14H4qvXkT9TYkAZgmifJI9m19ef7qgoJ4OsHyyg=;
        b=vnlPWAmwmg0Zu0PEMDLBoa6dhUKeqWzyoHwUBGMfJ7nVwamcozMkMIhqh6E/zs7Y31
         bPNQRhSvMPKWcsBOvMJKluiIsuLnfxFpqHpTXCZAONw2Ppgoq9JpNDaBcoXk9hmT63dH
         sKKlPQlXA4+rChv4Xrri3HQgo+D86h/YVo40Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kPSC14H4qvXkT9TYkAZgmifJI9m19ef7qgoJ4OsHyyg=;
        b=NTdkYHdyPjfzRNrDv5GWczxxoD7GJBh4fTLx1seplMWpOL7Br12wllttXTxhug+cRK
         8XF5nwsKnbRBhwBPuslgxKm/CTNY2PtoN+WYRObjuD+mH9Zdxd09pS4jSyZgc1a+4BCf
         onNyIaedSCDS8CkpsrqmWYchM1hEsrWN9xlAR5AzgXtmY16uRD7QAg+3Tmc0xooYjBhs
         J1W/DVJ8rWb5hwvYmp01ZY+s2ZSglxxr/j+K+/GjO5m0Sncb9YHuoW7uIw0V6gmHKYVq
         4ZaWiwZN/SQIuCQvSoPl5nUtDtLLsnYHB0ArYaFPqSWXtzvpF0fgaDNlpRJJwg5J7Kks
         SRwQ==
X-Gm-Message-State: ACrzQf37A3Z5VOdcYXy4zaGT0kutnH5mqWNW0j0FZfBePdoLmX5o/G/x
        AMQgT6abmwOhQ6N9DROTblGbbw==
X-Google-Smtp-Source: AMsMyM63n0BME1wzakGcd9fpHxmmjPaT7s3n01NO4QiDx0MC/YSVqw0PfekfOqiRcGaQE7RhMCABWg==
X-Received: by 2002:adf:9dd0:0:b0:22c:d6cc:b387 with SMTP id q16-20020adf9dd0000000b0022cd6ccb387mr2922910wre.353.1665742071061;
        Fri, 14 Oct 2022 03:07:51 -0700 (PDT)
Received: from localhost.localdomain ([2a02:c7c:5308:6600:49a0:d6bf:5c1a:f3da])
        by smtp.gmail.com with ESMTPSA id c15-20020a5d414f000000b002285f73f11dsm1931008wrq.81.2022.10.14.03.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 03:07:50 -0700 (PDT)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel-team@cloudflare.com, lei he <helei.sig11@bytedance.com>,
        Ignat Korchagin <ignat@cloudflare.com>
Subject: [PATCH v2 0/4] crypto, keys: add ECDSA signature support to key retention service
Date:   Fri, 14 Oct 2022 11:07:33 +0100
Message-Id: <20221014100737.94742-1-ignat@cloudflare.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Changes from v1:
  * fixed code format

Kernel Key Retention Service[1] is a useful building block to build secure
production key management systems. One of its interesting features is
support for asymmetric keys: we can allow a process to use a certain key
(decrypt or sign data) without actually allowing the process to read the
cryptographic key material. By doing so we protect our code from certain
type of attacks, where a process memory memory leak actually leaks a
potentially highly sensitive cryptographic material.

But unfortunately only RSA algorithm was supported until now, because
in-kernel ECDSA implementation supported signature verifications only.

This patchset implements in-kernel ECDSA signature generation and adds
support for ECDSA signing in the key retention service. The key retention
service support was taken out of a previous unmerged patchset from Lei He[2]

[1]: https://www.kernel.org/doc/html/latest/security/keys/core.html
[2]: https://patchwork.kernel.org/project/linux-crypto/list/?series=653034&state=*

Ignat Korchagin (2):
  crypto: add ECDSA signature generation support
  crypto: add ECDSA test vectors from RFC 6979

lei he (2):
  crypto: pkcs8 parser support ECDSA private keys
  crypto: remove unused field in pkcs8_parse_context

 crypto/Kconfig                        |   3 +-
 crypto/Makefile                       |   4 +-
 crypto/asymmetric_keys/pkcs8.asn1     |   2 +-
 crypto/asymmetric_keys/pkcs8_parser.c |  46 +++-
 crypto/ecc.c                          |   9 +-
 crypto/ecdsa.c                        | 373 +++++++++++++++++++++++++-
 crypto/ecprivkey.asn1                 |   6 +
 crypto/testmgr.c                      |  18 ++
 crypto/testmgr.h                      | 333 +++++++++++++++++++++++
 include/crypto/internal/ecc.h         |  10 +
 10 files changed, 787 insertions(+), 17 deletions(-)
 create mode 100644 crypto/ecprivkey.asn1

-- 
2.30.2

