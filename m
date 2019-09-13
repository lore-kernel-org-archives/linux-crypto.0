Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A387FC49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 712D72084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="skCPXZeR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfIMKNb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 06:13:31 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:38087 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729368AbfIMKNb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 06:13:31 -0400
Received: by mail-ed1-f54.google.com with SMTP id a23so24333008edv.5
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 03:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=55BmFIodvRNRoyuoyI6oe7g1hihYR8c82aDoSu4TfWo=;
        b=skCPXZeR3qs9wVmHErrgTgGMLpmxg+1vTk7uEJQppWbK/htvcpJEafjIjz0oV0O1kL
         jPaVZgjIdRiRulcpuIFDoRkXwRdQ7NK2FoNRII9GX2soWcAsDDwhQGVvG/1BF77NmdSd
         8Vmz3xRsqgzXTdxo3JZt8iIjJitvChRcOffma48GLjpXDFfn+v5aXFemd6Bm3k11V6qr
         mmW2IqCefabTH58HWcfmKKkJB++yA6QID9HI8/NJ2Jbu5SJHjS+ZS3HCpu4oSmI9ek+o
         Bxwx+EZyOP0noQNP99dH3NQVnlvtOMKjWd5jeHn9ALM6IYlFewvt0XN3MbLU3r8GYmYA
         VwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=55BmFIodvRNRoyuoyI6oe7g1hihYR8c82aDoSu4TfWo=;
        b=dadxMHDy12eEa+vNEKk7uqn9RtWxo6cYIuj33yZSE/+HPAp3jjTWegezWbZqn8ig+b
         UwxVPDkENcC93UmIImQV5yCt1H5wZZ0Sv+42KIGLhRKXNVm0cASnXtTu1vBvJhnSktUA
         dKKBPTIFzgkBGCSOQ/7yWV+TPLC5B9GBYUoDdPylnAQypDWUpWcg+G9bb/gG97hT1oaF
         rRlh3FeRQF182/eVvwR2tQCLQvVV9tiHtIyYt59PBR9SEHe/1dtWuHrtCpY29xgOhxil
         +ZDSgdpVlSFJ/NuB+UaujjzGrXI+80vvqNeg7MMoibCKLZ639azlSsVba5SHM/+oUspy
         hB4Q==
X-Gm-Message-State: APjAAAV0J4IEQY2XRgbZoKclsu07Xb+XuiA3p7ruKPJzEwcwCTP0Srvb
        YLtfhPeikCqdKh+r55CngIUA3yui
X-Google-Smtp-Source: APXvYqxVxOuESpzcsF+LrkMA7OKh56z/HbrVDPQsw/CY/nJFi1/I8yiVaEzgsJz9SiMBB6EHaI28Pw==
X-Received: by 2002:a50:cfc7:: with SMTP id i7mr37753421edk.89.1568369610013;
        Fri, 13 Sep 2019 03:13:30 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z65sm5314382ede.86.2019.09.13.03.13.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 03:13:29 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 0/7] crypto: inside-secure - Add support for SM4 ciphers
Date:   Fri, 13 Sep 2019 11:10:35 +0200
Message-Id: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extend driver support with ecb(sm4), cbc(sm4), ofb(sm4), cfb(sm4) and
rfc3686(ctr(sm4)) skcipher algorithms.
Also add ofb(sm4), cfb(sm4) and rfc3686(ctr(sm4)) testvectors to testmgr.
The patchset has been tested with the eip197c_iewxkbc configuration
on the Xilinx VCU118 development board, including the crypto extra tests.

Note that this patchset applies on top of the earlier submitted
"Add support for (HMAC) SM3" series.

changes since v1:
- rebased on top of v2 of "Added support for the CHACHA20 skcipher",
  fixing an issue that caused SM4 to no longer function

Pascal van Leeuwen (7):
  crypto: inside-secure - Add support for the ecb(sm4) skcipher
  crypto: inside-secure - Add support for the cbc(sm4) skcipher
  crypto: inside-secure - Add support for the ofb(sm4) skcipher
  crypto: testmgr - Added testvectors for the ofb(sm4) & cfb(sm4)
    skciphers
  crypto: inside-secure - Add support for the cfb(sm4) skcipher
  crypto: inside-secure - Add support for the rfc3685(ctr(sm4)) skcipher
  crypto: testmgr - Added testvectors for the rfc3686(ctr(sm4)) skcipher

 crypto/testmgr.c                               |  18 ++
 crypto/testmgr.h                               | 127 +++++++++++++
 drivers/crypto/inside-secure/safexcel.c        |   5 +
 drivers/crypto/inside-secure/safexcel.h        |   6 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 253 +++++++++++++++++++++++++
 5 files changed, 409 insertions(+)

-- 
1.8.3.1

