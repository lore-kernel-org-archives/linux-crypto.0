Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A54C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 21:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EA0564E0B
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 21:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhA2V1Q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbhA2V1G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jan 2021 16:27:06 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B12C061573
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jan 2021 13:26:26 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id j4so5172596qvk.6
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jan 2021 13:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YdcWLiWFcvdkQuVRuzMvT1F73EJns61ztrsLZN0y6sE=;
        b=NXIKStW+wJMRQMmxIqsEqt8y6vZ4bx7QaZPoHKm2q+Mucy5tXUAPMT2pKUFEZVV1Xo
         7SVpBVTLtAaW1bE9YC9SuX73B8aurPklO+nI+quHB5WYS+fD/2qSGrxNA+nx5dmpzT2b
         Uik0WksQyXbBwwXHvvJ+YmJAO50Ju958GmXznSWcHwwQMPpgAwIjLwGSJ5Ssr8aM8MVR
         tE9UB8PRLnbK6lkKq942TbvRlDJfOQ3XnTDPzK+PD88d6362mr+MI3lic6WO0ezAxkgM
         0Yqj39o+aF06OepVebHHPtKX3iFfMbyRBNkgX7AhYFnxwe4LWz/E8QzdNcgYX4qGLdez
         bObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YdcWLiWFcvdkQuVRuzMvT1F73EJns61ztrsLZN0y6sE=;
        b=fXK6RLS9b0qoRe5y5NpHOfXrrrWN7qZHiguslLv8jZR5SGdb+RHaUKeixyf3h19oZI
         OyjOtnZWZMJnam0hF0WrVmCBx/AyNqnam/sNCIGs1Rlb4rhHhSiOqLkupG/hORErSLKT
         NH2JxOig17RjZgx0lRQkKz9osL8TFNO8TS/IQlT21R2yy1GduxzmR63h2fIZpGt+j+rz
         +pcw769jKDpvP0nbCJ/AW/D6BjYK2RYh3Orw5nQpvWXTx/hu9QKe2BQq0vcyFdwXAr/o
         73tn7A0tlcxXBed6Kv28OmukeMpT358CDemt03WI32DI778ufSd3fdoTfdGeV4Kl/BIL
         ngYQ==
X-Gm-Message-State: AOAM530BnFMmrbz1OOtuSkDXqxRRMS1vu5DPUBT4iHlej4KplQ4Jrjsh
        CmQp/23pSs0VM2TnVBKzbfHit04XLwQyvVW+
X-Google-Smtp-Source: ABdhPJzigW+FHqrENWDoAn6r2XncH9ukf6l1jxi7a56SfHG0l5f3b/nLt2dd7hBQ/vinlG2A/o+gZA==
X-Received: by 2002:a05:6214:48f:: with SMTP id ay15mr5652873qvb.58.1611955585176;
        Fri, 29 Jan 2021 13:26:25 -0800 (PST)
Received: from warrior-desktop.domains. ([189.61.66.20])
        by smtp.gmail.com with ESMTPSA id b194sm6763995qkc.102.2021.01.29.13.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:26:24 -0800 (PST)
From:   Saulo Alessandre <saulo.alessandre@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Saulo Alessandre <saulo.alessandre@tse.jus.br>
Subject: [PATCH v2 0/4] ecdsa: this patch implement signature verification
Date:   Fri, 29 Jan 2021 18:25:31 -0300
Message-Id: <20210129212535.2257493-1-saulo.alessandre@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Saulo Alessandre <saulo.alessandre@tse.jus.br>

Why ECDSA on kernel:

I work on Brazilian Supreme Electoral Court [http://www.tse.jus.br], we are
using ECDSA for module and elf32 binaries verification including shared 
libraries on about 450k T-DRE voting machines [5].

This is the first part of our try to contribution, we pretend to share the
elf32 signature mechanism and elf32 kernel verification and start to work
on elf64 verification too.

We have an team of about 12 techs, between cryptologist, developers, 
testers, managers, staff and the coffee machine :). Recently we receive
authorization to share this codes.

Somes advantages from ECDSA are:
. is more secure against current methos of cracking [2];
. gives optimal security with shorter key lenghts [2];

First, comparing key size RSA vs ECDSA we have:

Table 1: Comparable key sizes table. ref [3]
|----------+-----+--------+
|Security in bits         |
|----------+-----+--------+
|Symmetric | ECC |  RSA   |
|       80 | 163 | 	1.024 |
|      112 | 233 |  2.240 |
|      128 | 283 |  3.072 |
|      192 | 409 |  7.680 |
|      256 | 571 | 15.360 |
|----------+-----+--------+

So, We need a bigger key in RSA to have the same security against ECDSA.
This can be see on [1] too.

Second, comparing speed performance RSA vs ECDSA we have:

Table 2: Signature performance table. ref: [3]
|-------------+------+------+
| Key Length  | Time (s)    |	
|-----+-------+------+------+
| ECC |  RSA  | ECC	 |  RSA |
|-----+-------+------+------+
| 163 | 1024  | 0.15 | 0.01 |
| 233 | 2240  | 0.34 | 0.15 |
| 283 | 3072  | 0.59 | 0.21 |
| 409 | 7680  | 1.18 | 1.53 |
| 571 | 15360 | 3.07 | 9.20 |
|-----+-------+------+------+

Table 3: Signature verification performance table. ref: [3]
|-------------+------+------+
| Key Length  | Time (s)    |	
|-----+-------+------+------+
| ECC |  RSA  | ECC	 |  RSA |
|-----+-------+------+------+
| 163 | 1024  | 0.23 | 0.01 |
| 233 | 2240  | 0.51 | 0.01 |
| 283 | 3072  | 0.86 | 0.01 |
| 409 | 7680  | 1.80 | 0.01 |
| 571 | 15360 | 4.53 | 0.03 |
|-----+-------+------+------+

On tables 2 and 3, we can see that ECDSA is more fast for strong key 
signatures and very slow for verification when comparable to RSA.
Although something is not so fast to check, it pays off in safety. 

References:
[1] - https://www.ecrypt.eu.org/csa/documents/D5.4-FinalAlgKeySizeProt.pdf
[2] - https://sectigostore.com/blog/ecdsa-vs-rsa-everything-you-need-to-know/
[3] - http://nicj.net/files/performance_comparison_of_elliptic_curve_and_rsa_digital_signatures.pdf
[4] - Mathematical-routines-for-the-NIST-prime-elliptic-curves.pdf [google it]
[5] - https://www.researchgate.net/publication/221046512_T-DRE_a_hardware_trusted_computing_base_for_direct_recording_electronic_vote_machines

---
Saulo Alessandre (4):
  ecdsa: add params to ecdsa algo
  ecdsa: prepare akcipher and x509 parser to use incoming ecdsa
  ecdsa: change ecc.c and ecc.h to support ecdsa
  ecdsa: implements ecdsa signature verification

 Documentation/admin-guide/module-signing.rst |  10 +
 crypto/Kconfig                               |  12 +
 crypto/Makefile                              |   7 +
 crypto/asymmetric_keys/pkcs7_parser.c        |   7 +-
 crypto/asymmetric_keys/pkcs7_verify.c        |   5 +-
 crypto/asymmetric_keys/public_key.c          |  30 +-
 crypto/asymmetric_keys/x509_cert_parser.c    |  37 +-
 crypto/ecc.c                                 | 338 +++++++++---
 crypto/ecc.h                                 |  59 ++-
 crypto/ecc_curve_defs.h                      |  82 +++
 crypto/ecdsa.c                               | 509 +++++++++++++++++++
 crypto/ecdsa_params.asn1                     |   1 +
 crypto/ecdsa_signature.asn1                  |   6 +
 crypto/testmgr.c                             |  17 +-
 crypto/testmgr.h                             |  78 +++
 include/crypto/ecdh.h                        |   2 +
 include/linux/oid_registry.h                 |  12 +
 lib/oid_registry.c                           | 100 ++++
 18 files changed, 1201 insertions(+), 111 deletions(-)
 create mode 100644 crypto/ecdsa.c
 create mode 100644 crypto/ecdsa_params.asn1
 create mode 100644 crypto/ecdsa_signature.asn1

-- 
2.25.1

