Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DA6CDB474
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 18:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbjJVSWY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 14:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJVSWX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 14:22:23 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54928EE
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 11:22:20 -0700 (PDT)
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 41E223F21F
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 18:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1697998938;
        bh=Tl2mFhMN0hrea9vAgi8pl3E5fM4js6s2Rqa0QUC5Vas=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=E3rMSKunPMjgcW0KmeIjCQoCkx+6M6r4xBeJQkZcN52eT1i/OPUTv/3oWgCekdeih
         G4tbTaTQ7mXb2VOItlDsF0D+PSjKsCYkxy6dP5/98fhuKSafaIAExoHxyM7DHWTjN6
         o7M0AGy72QQRgCxvSuZlsbYVmIbm2bWrs5CQHER7tWr+Qo7v5xIscgiDEb/hSMsuzt
         D7TKi7z8BRrMmaYd2Jn1nNveV9UJv1mCayuLO7c/M8SmFfdvjeE82xkOArq/GHC0bO
         I6hvysLUuVowMvHZOObYmB8/pij+g3lWjUoA++0DnUmVzP7EekSoQ/0iCT7MlsCwLY
         NXdLYOxeYXfww==
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2c53c85e482so21166501fa.1
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 11:22:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697998936; x=1698603736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tl2mFhMN0hrea9vAgi8pl3E5fM4js6s2Rqa0QUC5Vas=;
        b=SKGYY27g3qWd4RO5MVLu/v+lyTMOaioSWjFdE89PHwKcYl+v0GOjUAFQgIAo/ipzet
         2fmSzVJHrGpMVJYT+05BICPEefg0gk3wxUaDJSxq9i4bkRzDCLxDJKHDV7Z3s8Q1ACll
         LenRSe+rTsVSENz99AkjMHMICzcWovCqtyaBF3tzkuvRtrATd13GliW7bIBTWZP4DDpN
         F53yT4+ZkG1OXSvsRhqH7rfSiHOe/T3POe7cEWkrQ7S7EmkpNtnntpvP0xn9PQeBcnMI
         gZuepcr7Drr5P0HY3vdoLQxCr+5QCSXm0Z6p95/os492gyaxTRraq31vpMIzmZXpSwFp
         jaXQ==
X-Gm-Message-State: AOJu0YwFVIbv2x9ckuFBkFaNL5BLcSjojBSh9frCmZYMtkuEHp3bu0c9
        HiqceBJHYA/CqT5kCJOc3im6RImsCRNiP8EteWApGELqUbT6w0KsJK0S9QhuKqKl5J1eiezAc5z
        68AVFG1UtF/mSy+UTTodZ4u2kFD6GZQnTCxwOh09WNvF1yheNTA==
X-Received: by 2002:a05:651c:14c:b0:2c5:9a5:a1c2 with SMTP id c12-20020a05651c014c00b002c509a5a1c2mr5064566ljd.30.1697998936188;
        Sun, 22 Oct 2023 11:22:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHt+uxWT0Ko/rmy6kgwXvchSpLX67lOoo9KNw9wv4C/8E19DoFZxpm9xbReSkzB+eQRWBZDJQ==
X-Received: by 2002:a05:651c:14c:b0:2c5:9a5:a1c2 with SMTP id c12-20020a05651c014c00b002c509a5a1c2mr5064560ljd.30.1697998935791;
        Sun, 22 Oct 2023 11:22:15 -0700 (PDT)
Received: from localhost ([2001:67c:1560:8007::aac:c15c])
        by smtp.gmail.com with ESMTPSA id g3-20020a5d6983000000b00326b8a0e817sm6140877wru.84.2023.10.22.11.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Oct 2023 11:22:15 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] crypto: pkcs7 x509 add FIPS 202 SHA-3 support
Date:   Sun, 22 Oct 2023 19:22:02 +0100
Message-Id: <20231022182208.188714-1-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Recent patches to cryptodev removed support for insecure, broken or
weak x509/pkcs7 signing hashes MD4, MD5, SHA1, SHA-224. This opens
room to add SHA-3 family of hashes, which are not yet broken.

Add support for FIPS 202 SHA-3 in x509 RSA & ECC certs, pkcs7
signatures, hash info structs. And adjust documentation.

This enables using SHA-3 family of hashes for kernel module signing.

For SHA3+ECC signing openssl with this patch [0] is needed, currently
in openssl development tip. SHA3+RSA signing is supported by stable
openssl.

kmod needs a patch to recognise SHA3 hash names [1], submitted
separately.

This patch series is on top of tip of cryptodev git repository commit
a2786e8bdd ("crypto: qcom-rng - Add missing dependency on hw_random")

[0] https://github.com/openssl/openssl/pull/22147/files
[1] https://lore.kernel.org/all/20231022180928.180437-1-dimitri.ledkov@canonical.com/

Dimitri John Ledkov (6):
  x509: Add OIDs for FIPS 202 SHA-3 hash and signatures
  crypto: FIPS 202 SHA-3 register in hash info for IMA
  crypto: rsa-pkcs1pad - Add FIPS 202 SHA-3 support
  crypto: x509 pkcs7 - allow FIPS 202 SHA-3 signatures
  crypto: enable automatic module signing with FIPS 202 SHA-3
  Documentation/module-signing.txt: bring up to date

 Documentation/admin-guide/module-signing.rst | 17 ++++++++-----
 certs/Kconfig                                |  2 +-
 crypto/asymmetric_keys/mscode_parser.c       |  9 +++++++
 crypto/asymmetric_keys/pkcs7_parser.c        | 12 ++++++++++
 crypto/asymmetric_keys/public_key.c          |  5 +++-
 crypto/asymmetric_keys/x509_cert_parser.c    | 24 +++++++++++++++++++
 crypto/hash_info.c                           |  6 +++++
 crypto/rsa-pkcs1pad.c                        | 25 +++++++++++++++++++-
 crypto/testmgr.c                             | 12 ++++++++++
 include/crypto/hash_info.h                   |  1 +
 include/linux/oid_registry.h                 | 11 +++++++++
 include/uapi/linux/hash_info.h               |  3 +++
 kernel/module/Kconfig                        | 15 ++++++++++++
 13 files changed, 133 insertions(+), 9 deletions(-)

-- 
2.34.1

