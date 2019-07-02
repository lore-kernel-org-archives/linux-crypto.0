Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714F8C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47D5120663
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="maip/Dhf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfGBPmd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:42:33 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:38785 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfGBPmd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 11:42:33 -0400
Received: by mail-ed1-f49.google.com with SMTP id r12so27736271edo.5
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 08:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sgpwK7LUL89kb0p0u0eLb/pGeaYVIDh+zHi9kEjOyRI=;
        b=maip/DhffK+TcsamUks/tttIxa6RTpPMj6AKVwYiKzfI/lwV2DLor1n5XG2uL1w6SS
         ueHU87S3Zf9RDJ964DEmhoy/QR9d8KfwWGZxHhHtRZ8ZBCCFC1GqbpOaw+1caLqlTLgF
         lnDv+SwCVS1dqzByu+0AOs85lbCz0q345MH3rPIEeciwh60LbkDwar3WzrLkNrFCACON
         MkVeoG+y/oolLXfSezX0jy3oPrYAwhWt4Oa+a6ATPGwdhmQXAWe8vaStkGZdeRQx11Ni
         6ptRblORgyvr6F4mUxB1iFKntcwwDncWQqsYbfve4zDeoLoDp7drBIRbO+gnel6Ptz+J
         oa/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sgpwK7LUL89kb0p0u0eLb/pGeaYVIDh+zHi9kEjOyRI=;
        b=WzDMuh4IAwgd52yXBvzvpUQn62LyU9+qCgbmxcCdctT9866uVJUmVswlq4tEtLTv8d
         QstPwQa8HbXgaC7p9fGmPLVyx/BWe64PEnZHz6m4ZBPfCMwC2Ib0pLoTHyl0e7osEAVU
         0Q7OuIlyDz1vMcXUnHgJUxWSCv6FA+Vd1brLFPlJ6+MqhXjZIZtMm3W3IwW2NKUSr47j
         xpeqo/sxKcazj2GEeywwlVLA5DB/VMdBUPkj4ud1N4PM7E7A1QpwNt5H43kUjwrbtYzQ
         8sGxLDjpxZzVFlpX0R/Rqgg1Brc8sOxbjZtTqbuPNLvy6b9LS8dD5ja9VFND5H638oYm
         4AzQ==
X-Gm-Message-State: APjAAAVw52J5baXkQySGJ/+E/tkwG2P7lrSPk1cfDeNc121owJNJpwpN
        zf2xMTXRc1PsDLJCFxl7/VjA/khJ
X-Google-Smtp-Source: APXvYqxNpTiXH9lnD18IaO2Cwggbxm4Ti+poxTMio8B8FlKtrA1yUokqfqQ2i/V0NZ3MY6+rvSdmHQ==
X-Received: by 2002:a17:906:49ce:: with SMTP id w14mr29366113ejv.168.1562082151357;
        Tue, 02 Jul 2019 08:42:31 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id j11sm2341704ejr.69.2019.07.02.08.42.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:42:30 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/9] crypto: inside-secure - fix cryptomgr extratests issues
Date:   Tue,  2 Jul 2019 16:39:49 +0200
Message-Id: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set fixes all remaining issues with the cryptomgr extra tests
when run on a Marvell A7K or A8K device (i.e Macchiatobin), resulting in
a clean boot with the extra tests enabled.

Pascal van Leeuwen (9):
  crypto: inside-secure - keep ivsize for DES ECB modes at 0
  crypto: inside-secure - silently return -EINVAL for input error cases
  crypto: inside-secure - fix incorrect skcipher output IV
  crypto: inside-secure - fix scatter/gather list to descriptor
    conversion
  crypto: inside-secure - fix EINVAL error (buf overflow) for AEAD
    decrypt
  crypto: inside-secure: back out parts of earlier HMAC update
    workaround
  crypto: inside-secure - let HW deal with initial hash digest
  crypto: inside-secure - add support for arbitrary size hash/HMAC
    updates
  crypto: inside-secure - add support for 0 length HMAC messages

 drivers/crypto/inside-secure/safexcel.c        |  25 +-
 drivers/crypto/inside-secure/safexcel.h        |   6 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 265 ++++++++----
 drivers/crypto/inside-secure/safexcel_hash.c   | 553 ++++++++++++++-----------
 4 files changed, 520 insertions(+), 329 deletions(-)

-- 
1.8.3.1

