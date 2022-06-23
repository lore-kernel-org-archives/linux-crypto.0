Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4568FC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jun 2022 06:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiFWGKD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jun 2022 02:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiFWGKC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jun 2022 02:10:02 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5783A63C3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2022 23:10:01 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so1579263pjz.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2022 23:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e8tI85riZMOHfa3k8p/ytOZ+RJHDFY9LmShQDBd6b6I=;
        b=SARoOkbEBf5QYfK+kRxLw37L+QQB/x0IGUpe+lXNKkPPiKNupFPO+530fzS1KWdgi6
         TrCm+F6wWiCV0QkfuRhEmM/gmZ+WfjgE06mqgTlCMKSrwMTM9XSXGiqe9Pqi01eGNsob
         RUHT3oXSWiMOJXbP9jYtrMglqweDdrOnyAeQSSSdaAbzmgF1l28jeGhPebgZk9W8GqmH
         4sRga2f8V3IA+2Nrn9j4/kPc8watpE8yNcdGHRYCB8908vRO/7wABbP90AUXYPosfKId
         Yr3p67UFSZjkXVcZdMPlkgQyOhs1bD0EH0AEuk8BuIG9v2dlEPBndM6TfKZ5qnaclGQ1
         R6og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e8tI85riZMOHfa3k8p/ytOZ+RJHDFY9LmShQDBd6b6I=;
        b=MwiWtARZnU1H6fsypMXnSGpfxo+Jat0iDJ6UnxD6PbnTlf5wwF+hA5f9HNgDQpiPpE
         PYp+LTNvLSItBT1FHhZOp3stwS1ZWu5FS2+j0yL2sZv3RNSXoTv0oRqMHWwepeg0qCX2
         2c/CsYb6Exwo7m+T2U3AWFk5N5+sDP8UNJ8X4FI+xQhX/L5tee6sEZCjkL8pC8W5AWJd
         1KkXYiry2YLLd9W53NNn5xj4DMpQr8LBrBdDcXeAVLsmIJsSh5zfGJJ3cQU1UIBwg8zi
         XzoukPdWqfGVNOqunbrU36zEdxhvAWa/C4bPyovHlMTRqWr2L6j8a4y8KWxNgRNXWR5o
         Z3dg==
X-Gm-Message-State: AJIora9zILQmpQkaGKDJ4jWvtSOpMiLE4EIDIcc2wEgPWoJQtHHNtonz
        V7rQK0eDjyb7bQT5or3Ec+BePg==
X-Google-Smtp-Source: AGRyM1tURR2mWC91RwhGJJ7NdxfnCWsglo8eyFMK8qSWXsfbR3txPvvVUsY0tq+OhaZBG3rVIzzzXA==
X-Received: by 2002:a17:902:d2cb:b0:16a:2efb:d03e with SMTP id n11-20020a170902d2cb00b0016a2efbd03emr15555823plc.81.1655964600838;
        Wed, 22 Jun 2022 23:10:00 -0700 (PDT)
Received: from FVFDK26JP3YV.bytedance.net ([139.177.225.234])
        by smtp.gmail.com with ESMTPSA id s3-20020a170903200300b0016a11750b50sm9782080pla.16.2022.06.22.23.09.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jun 2022 23:10:00 -0700 (PDT)
From:   Lei He <helei.sig11@bytedance.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        dhowells@redhat.com
Cc:     mst@redhat.com, kbuild-all@lists.01.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        berrange@redhat.com, pizhenwei@bytedance.com,
        lei he <helei.sig11@bytedance.com>
Subject: [PATCH v2 0/4] virtio-crypto: support ECDSA algorithm
Date:   Thu, 23 Jun 2022 14:09:47 +0800
Message-Id: <20220623060951.77641-1-helei.sig11@bytedance.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: lei he <helei.sig11@bytedance.com>

This patch supports the ECDSA algorithm for virtio-crypto.

V1 -> V2:
- explicitly specified an appropriate base commit.
- fixed the link error reported by kernel test robot <lkp@intl.com>.
- removed irrelevant commits.

V1:
- fixed the problem that the max_signature_size of ECDSA is
incorrectly calculated.
- make pkcs8_private_key_parser can identify ECDSA private keys.
- implement ECDSA algorithm for virtio-crypto device


lei he (4):
  crypto: fix the calculation of max_size for ECDSA
  crypto: pkcs8 parser support ECDSA private keys
  crypto: remove unused field in pkcs8_parse_context
  virtio-crypto: support ECDSA algorithm

 crypto/Kconfig                                |   1 +
 crypto/Makefile                               |   2 +
 crypto/akcipher.c                             |  10 +
 crypto/asymmetric_keys/pkcs8.asn1             |   2 +-
 crypto/asymmetric_keys/pkcs8_parser.c         |  46 +++-
 crypto/ecdsa.c                                |   3 +-
 crypto/ecdsa_helper.c                         |  45 +++
 drivers/crypto/virtio/Kconfig                 |   1 +
 .../virtio/virtio_crypto_akcipher_algs.c      | 259 ++++++++++++++++--
 include/crypto/internal/ecdsa.h               |  15 +
 include/linux/asn1_encoder.h                  |   2 +
 lib/asn1_encoder.c                            |   3 +-
 12 files changed, 361 insertions(+), 28 deletions(-)
 create mode 100644 crypto/ecdsa_helper.c
 create mode 100644 include/crypto/internal/ecdsa.h


base-commit: 018ab4fabddd94f1c96f3b59e180691b9e88d5d8
-- 
2.20.1

