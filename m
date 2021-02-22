Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF50C433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Feb 2021 06:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2E5B64ED6
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Feb 2021 06:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhBVGn4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Feb 2021 01:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhBVGn4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Feb 2021 01:43:56 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20130C061574;
        Sun, 21 Feb 2021 22:43:16 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id j24so3064839pfi.2;
        Sun, 21 Feb 2021 22:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8+hbDvQcQCM/KIbXRfTLR9tvWpT5dA5ahHEuu/uLRYw=;
        b=EaJ+kGRPKi2j7y274OQFqiWVxtFUd+ACJ4KFnkvIddaWX/ITooEBTXe1CKm4A5NIa4
         PrzkH1XrpHZCnPqYgU0uMDWMqQembXgvPen+iJdmxz8gNAd3TD3o6+6XPFOaiuXLQlm/
         1hx+rkBI2gn1Bk5wIC59BgvK2dtkwWihCGIDAtO2z5M9Z8NYZzRUfANx/iFD/rRhzQJv
         5wf2Hk+G3Q/jMcQuxrc3l7FytH7Zk8uJ1t/N674ytcTKRwDbuZYpi/PyX6uCf9sgQSmn
         SilPCuRyj3jsQwgKCnarOyuS5Pvn4eSVkD+WMbhdmcBS4rcd1FyMkwbCiXeKAzQNY6Pm
         nxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8+hbDvQcQCM/KIbXRfTLR9tvWpT5dA5ahHEuu/uLRYw=;
        b=WGdytSzMIdcXcDzN7KZ1kNsdVHV+aE66KMZCuhhpoMZw3fOj2LQhj+vnzAEv5ydOy8
         Fn/2T3bO79lwcLbCJ2MvdEqgC50dG1NxtiWGZv+ejRvi5Y9OIkMcEPlE3qcHdvzAipDg
         Mm+93uBiCGnvVy2zBHBBrVIMqLh3N03SeAKJsGBYjPFlgYo865RrANLJ8eaUmMYa+mWQ
         fSgN0/gezejolUxNoirtLEwELtZ05oguHA3F3AXSnX6OF+/fVOF2VYDEtskDXCfmr94+
         Rm7JfK2aLQmZhskIHyYWYgjK7A/c2+L2gvGxYwcoJXWidcqZhB3D/xky/O0p7kUrEYnX
         6lOQ==
X-Gm-Message-State: AOAM530xgQDsTbjHDorXzeOUEgOwvOC4yrYDhJdByrhW2jWJFQArzPH1
        Yj5lY9ocM5jtfBwi4QNUnwo=
X-Google-Smtp-Source: ABdhPJzVU93RG59/iJNoTjgTsUGZOuCI+x9l21fm0mksD/+D3dHDJ+POYXmQ4xd36Z7gyHjQBsng5A==
X-Received: by 2002:a62:8f0c:0:b029:1ed:8c8d:6910 with SMTP id n12-20020a628f0c0000b02901ed8c8d6910mr6428293pfd.31.1613976195690;
        Sun, 21 Feb 2021 22:43:15 -0800 (PST)
Received: from linux-l9pv.suse ([124.11.22.254])
        by smtp.gmail.com with ESMTPSA id 188sm8688195pfz.119.2021.02.21.22.43.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Feb 2021 22:43:15 -0800 (PST)
From:   "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
X-Google-Original-From: "Lee, Chun-Yi" <jlee@suse.com>
To:     David Howells <dhowells@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Ben Boeckel <me@benboeckel.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Malte Gell <malte.gell@gmx.de>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH v4 0/4] Check codeSigning extended key usage extension
Date:   Mon, 22 Feb 2021 14:42:47 +0800
Message-Id: <20210222064251.13374-1-jlee@suse.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

NIAP PP_OS certification requests that the OS shall validate the
CodeSigning extended key usage extension field for integrity
verifiction of exectable code:

    https://www.niap-ccevs.org/MMO/PP/-442-/
        FIA_X509_EXT.1.1

This patchset adds the logic for parsing the codeSigning EKU extension
field in X.509. And checking the CodeSigning EKU when verifying
signature of kernel module or kexec PE binary in PKCS#7.

v4:
Fixed the wording in patch description.

v3:
- Add codeSigning EKU to x509.genkey key generation config.
- Add openssl command option example for generating CodeSign EKU to
  module-signing.rst document. 

v2:
Changed the help wording in the Kconfig.

Lee, Chun-Yi (4):
  X.509: Add CodeSigning extended key usage parsing
  PKCS#7: Check codeSigning EKU for kernel module and kexec pe
    verification
  modsign: Add codeSigning EKU when generating X.509 key generation
    config
  Documentation/admin-guide/module-signing.rst: add openssl command
    option example for CodeSign EKU

 Documentation/admin-guide/module-signing.rst |  6 +++++
 certs/Makefile                               |  1 +
 certs/system_keyring.c                       |  2 +-
 crypto/asymmetric_keys/Kconfig               |  9 +++++++
 crypto/asymmetric_keys/pkcs7_trust.c         | 37 +++++++++++++++++++++++++---
 crypto/asymmetric_keys/x509_cert_parser.c    | 24 ++++++++++++++++++
 include/crypto/pkcs7.h                       |  3 ++-
 include/crypto/public_key.h                  |  1 +
 include/linux/oid_registry.h                 |  5 ++++
 9 files changed, 83 insertions(+), 5 deletions(-)

-- 
2.16.4

