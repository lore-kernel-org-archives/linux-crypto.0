Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D18EC49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 15:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 606F020CC7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 15:06:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qYGeodGM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390890AbfIMPGQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 11:06:16 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:36716 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390534AbfIMPGQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 11:06:16 -0400
Received: by mail-ed1-f53.google.com with SMTP id f2so20992822edw.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 08:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=l4PYogeEIfK1Wnzm66iOMvWL2Di39/1EQLciiU0aDlc=;
        b=qYGeodGMYMwlF7JWWqv0Jlbaqq4BzMTt8maqlLoZWRb83/0mgde/O15IlnxGeooNi0
         1Kpw3KjCGEKH0k8T6Fj6MSBEuiTAGIxB6x91++ucg0sp5EMy9TSgDS/c4A92u5LvFUW+
         H42RhfNni+c4WOr80pogLAWzNaI4Cgn6jaVxsFmsegk2o9xtaibp920XAKuaKTQ/9lEq
         fpU3rkugRWCke2lBv24PvMvcbXLrRc2Ljd7jBnzXOp6j5UvLZmcEZoEGcBI4Gg1KvA7g
         tK/cCrOexfvmtZP/WLTNKsww9JuX13v5gELIdY+EUjT3VOTRdLpXhVnc8uoH4re/MZpe
         TdOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l4PYogeEIfK1Wnzm66iOMvWL2Di39/1EQLciiU0aDlc=;
        b=hGDSiqqUUd5Vj+UMTurNlTPrf7PtjCjj5rxqib5ITfyQIaZxgvxJd28hJ7ZvZZJaKU
         LrflAZzn/pMS4JjS73PXHNGtfszaMrmGrLQHC0aZQBZ+Sa6ufbIMFYFfsrnlhYDAif2Z
         uoosJCQK93F3D4XGZVDLz2H4GC1kqezd27f5yN1xvWdB9/t22LTGsP0AN70zZDmago0S
         l21RJSUcwuKV3a6efccxTKIjCQPcXzZVkoltJ2OjmvYkqqm+LRIklEOUzh3QQXmZiY28
         +BiytX56TLtdJk6hO2oaz0dEVtXNXf8huRPGsAKuXgQmVtL3djtkgnFCmUmYCSkyR0W1
         THFA==
X-Gm-Message-State: APjAAAXJ7wdgDcLBCiVXyzmfQpsO41Q5wGH+JrlC3VWhOWFDXygYFna3
        9rfsuNmfQ4NAmP0x4A2sZVGPJnDc
X-Google-Smtp-Source: APXvYqztYcsKTc+3P4eNDUYWUEvvAVdc4x3+CEO8qANStJ2puf1CgkIy9VyAxxLk2o1B/s6q7EcAeg==
X-Received: by 2002:aa7:dd91:: with SMTP id g17mr4932660edv.175.1568387174015;
        Fri, 13 Sep 2019 08:06:14 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id ly10sm3206654ejb.59.2019.09.13.08.06.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 08:06:13 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/3] crypto: inside-secure - Added more authenc w/ (3)DES
Date:   Fri, 13 Sep 2019 16:03:23 +0200
Message-Id: <1568383406-8009-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset adds the remaining authencs with DES or 3DES currently
supported with vectors by testmgr.

The patchset has been tested with the eip197c_iewxkbc configuration on the
Xilinx VCU118 development boardi as well as on the Macchiatobin board,
including the testmgr extra tests.

Pascal van Leeuwen (3):
  crypto: inside-secure - Added support for authenc HMAC-SHA1/DES-CBC
  crypto: inside-secure - Added support for authenc HMAC-SHA2/3DES-CBC
  crypto: inside-secure - Added support for authenc HMAC-SHA2/DES-CBC

 drivers/crypto/inside-secure/safexcel.c        |   9 +
 drivers/crypto/inside-secure/safexcel.h        |   9 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 317 +++++++++++++++++++++++++
 3 files changed, 335 insertions(+)

-- 
1.8.3.1

