Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56383C433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Mar 2021 03:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BA25619AD
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Mar 2021 03:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhCWDz7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Mar 2021 23:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhCWDzw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Mar 2021 23:55:52 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F121C061574;
        Mon, 22 Mar 2021 20:55:52 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id n11so10376870pgm.12;
        Mon, 22 Mar 2021 20:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/CvRWYjORCw8flby47H5HqIvyfw8yrJSz4E5Q321rKY=;
        b=oP3QugZsARHuicP9Bg26t1dfWHywhPXHaALJqOojkEwJ/iujxOVkMqRGhGiXUaOMRG
         OrUj++v6Sd52IkNczr9Kes+cRJTkle//IaYp3lL/EFwyXlEXOyVl19RoHGOO7eXkgoG+
         Znb7BhgoAYEbk7csOp3ixyYN3GSjzbRlVRmu4Q0y/WFmt3EAuZiq7fGbWm5lfbaVWWGc
         cSc5oAtc2K+wM70oemLc/RMcfhYQJ2TFh3WpBYoMcu47VtDGoamiaMuPoSdwnRGfn8JG
         Y/YRgDag+cU8c39F6kPQ58PGzEsyhRq7q3xWUSMmCqtRJhvUK2mF0QFExtS4pf3jI12X
         ytkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/CvRWYjORCw8flby47H5HqIvyfw8yrJSz4E5Q321rKY=;
        b=D+DJ8JikcetvDsOWfghhoF7Qqr0SjJjEl2XKmkNi5cMbjOv+xKhbsIEn5ixOBYmgY/
         QSTtoUo9vHPd21zCLIM0P+9RCHBpu4Q9wiiqVsTekk9NWURaUVQfGADE64Du9A+U/fTC
         p4Z5nQJyRDR23YPqOiU+NjGm5j8Z1svff0f2wO9/j6oeWTHNFdru3ptyUtZM68aDXhlw
         yIRzVO31Wp97dEo3ABK7IoYExyYwv9I/nszMLRZhFJG7JjmtOQYmm9Wn8xVu5Qs8z88B
         meZvb41wjVqJXaHBf1nppRBhS7XDszFN6p6P/YNRZC2GOwjsFYetQVa2ZOTvqCy6Jm81
         TxcQ==
X-Gm-Message-State: AOAM531Ujc0piEexTpHB4egSnIXsPNlLx+UZRv2TfQwNCvS/YxXp1J1V
        fc0Pa0MgeAsTStHb0uwpec0wmrypMWo=
X-Google-Smtp-Source: ABdhPJz7bPliC4trJh9fqTCx5sg8vrB15Qe7V5WYGLwGA1wWFP2t2D6WilPg0O2XUO0P//fSZZl5mw==
X-Received: by 2002:a65:5cc2:: with SMTP id b2mr2272973pgt.280.1616471751866;
        Mon, 22 Mar 2021 20:55:51 -0700 (PDT)
Received: from linux-l9pv.suse ([124.11.22.254])
        by smtp.gmail.com with ESMTPSA id z22sm14415630pfa.41.2021.03.22.20.55.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Mar 2021 20:55:51 -0700 (PDT)
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
Subject: [PATCH v5 0/4] Check codeSigning extended key usage extension
Date:   Tue, 23 Mar 2021 11:55:17 +0800
Message-Id: <20210323035521.5843-1-jlee@suse.com>
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

v5:
Fixed the wording in module-signing.rst.

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

