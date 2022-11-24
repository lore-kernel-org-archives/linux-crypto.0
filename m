Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB8CC43217
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Nov 2022 14:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiKXOAt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Nov 2022 09:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiKXOAf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Nov 2022 09:00:35 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA5D13F484
        for <linux-crypto@vger.kernel.org>; Thu, 24 Nov 2022 05:58:33 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id a11-20020a05600c2d4b00b003cf6f5fd9f1so1312874wmg.2
        for <linux-crypto@vger.kernel.org>; Thu, 24 Nov 2022 05:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FLYGIY1cjSaO8iMr+6IveYVeTtbbWK2zYM30V3Bwty4=;
        b=fUMAZbkFZkyQCLNk7f66kU61yfocH/0UqmdSp0zdUHTGOZ79YhOTbvqMNBl3qGhN91
         5kjEnU8oWNbqaBNlok68y7eHenJUWKDR0noHJJ85VfBpN0Y+Dt6sVhUpkWei1ZLensFO
         UQJKjDgLInKe1XEXKarXu8sQTV4rmW7n/Yb60=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FLYGIY1cjSaO8iMr+6IveYVeTtbbWK2zYM30V3Bwty4=;
        b=OHqWAVvYdYbrwGESFEtp9stP7HioGY0MNpK/XfQGsA9wL6HfZ3U6GQlmWY935MXeHY
         JAyBQkkb4p8sbK4DAcRygsCi+JxkhPCGz3EAl9PnJkiu+PupaqKB6qgbU22KlODgJZJK
         z3ja5rA7X3C8ZcoCKxYa3jdlZorBGZZ6c7JB/oNyzuQm9Ki2cvcJ9sNz26o9nwXWoB2O
         qr8WAGGP2qtV01T3Sxwe9CSvMY0cARy0EtlvAwmO9DQny2hintYaUagip43vz4fo6hgw
         5Sp5Cn5v5i1xgJiiSX9o5kAGoWtbQPvJUX2O2VmRa6eaqPO0/t9A5vjITNOEXRyw4mCb
         pd6Q==
X-Gm-Message-State: ANoB5pnHuWna6kyPYwa+x92si7C1Th/mXPbp8FSJV+MJSMtr8f4Dtp03
        XPtDa7LSSxwjGwwV+xt6PO3mcQ==
X-Google-Smtp-Source: AA0mqf4/QBhLyxEoDVdGqBp609ooHToWLVOwDE/1LbsJTnLrEg3y4oxHdGyVwSH6CRxaRz0UtmWzIg==
X-Received: by 2002:a05:600c:1d09:b0:3cf:6ab3:4a0b with SMTP id l9-20020a05600c1d0900b003cf6ab34a0bmr26840189wms.91.1669298311983;
        Thu, 24 Nov 2022 05:58:31 -0800 (PST)
Received: from localhost.localdomain ([2a09:bac1:28c0:140::15:1b6])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d660e000000b00241bee11825sm1371440wru.103.2022.11.24.05.58.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 24 Nov 2022 05:58:31 -0800 (PST)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        keyrings@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Ignat Korchagin <ignat@cloudflare.com>
Subject: [RESEND PATCH v2 0/4] crypto, keys: add ECDSA signature support to key retention service
Date:   Thu, 24 Nov 2022 13:58:08 +0000
Message-Id: <20221124135812.26999-1-ignat@cloudflare.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
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

Original posting: https://patchwork.kernel.org/project/keyrings/cover/20221014100737.94742-1-ignat@cloudflare.com/

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
 crypto/ecc.c                          |  19 +-
 crypto/ecdsa.c                        | 373 +++++++++++++++++++++++++-
 crypto/ecprivkey.asn1                 |   6 +
 crypto/testmgr.c                      |  18 ++
 crypto/testmgr.h                      | 333 +++++++++++++++++++++++
 include/crypto/internal/ecc.h         |  10 +
 10 files changed, 792 insertions(+), 22 deletions(-)
 create mode 100644 crypto/ecprivkey.asn1

-- 
2.30.2

