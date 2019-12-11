Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 340C3C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 16:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01F57214AF
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 16:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DngTiWL+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbfLKQf7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 11:35:59 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:40758 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbfLKQf7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 11:35:59 -0500
Received: by mail-wr1-f41.google.com with SMTP id c14so24732501wrn.7
        for <linux-crypto@vger.kernel.org>; Wed, 11 Dec 2019 08:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZUl06BYxk7D/rljPXJgV9taUy2fMktlYeZWLjsgd0Wg=;
        b=DngTiWL+U05E0/+55Ly4dmthhEF4z/D/Mn2RduDEfmzy/IFc/jVfRhJRvqO8+qgtdN
         b4e8y/AQVPMOMHyOU8VJ23QAHCBkTgkPc5FKp2DSnfpO7RSb7LrpKrarvj6+CpLH2JuY
         951X8Szez5HWVMxeYL1jj2R4rwOVzdxymOaost0dSTLSAhYoPsljWEWsh+jwPn+dqqml
         4Mp1pz+8ym6yqsOC9m2C233Vvyuf8THAWDOwFWvmsR2+xL8AM47q7pGQ9O4zhiqvmz9c
         Ykb3Dz9YhR7POTwzSyyHIc5iplGj3v1JoqEXnD/I3PdeV30VgzTjOUlngEVXzpF+DJOQ
         r0vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZUl06BYxk7D/rljPXJgV9taUy2fMktlYeZWLjsgd0Wg=;
        b=R/UT7aEk8j3q5nkBLwdZPcEzQg5Uij+LOXNg48Y37sRALqKznZxcxzsPBD1B5UYpMi
         csXKfO1jhpbGD6HvWoR6dwyElKiRE+DZABIjbc1zt/rzKSNsqKcGecDAU0k5T+MHesOh
         qcLenSbAy2tDgyhpwMMxnJy+3E/IsjBPwgueorxiF/DpEIsW5LY/dqzahVLAHjqPdRgi
         0CcU/DWQvSCs4reskTNNE6f1Ttq+fJ2th1zXH8Bp0S2DJVulyGbY/4bfBmO2xel0oq4u
         v7Ek1pfeGzMRVq4rL8+MykHJLOIzu8p2O4Bd8b1oPVWSlWcpFupEkfLLRD5at3O+AWTM
         3XWA==
X-Gm-Message-State: APjAAAV851Ck6dtY8LCEIkIFilHt38Yz19HBJf5jTWAoslhFuUwZ1d/O
        KIGpdNFBsEPkKVs1o0mxLUC+KmdCFfA7Kg==
X-Google-Smtp-Source: APXvYqxNyZ/zuEHZPfShJ/GRNePtl8hUkKCPQqVWpe20fdQjSZK4rWkeZDAuL9wF4CUhZ2kITzf2Ig==
X-Received: by 2002:a5d:4a91:: with SMTP id o17mr792383wrq.232.1576082156691;
        Wed, 11 Dec 2019 08:35:56 -0800 (PST)
Received: from localhost.localdomain.com ([31.149.181.161])
        by smtp.gmail.com with ESMTPSA id o19sm2162405wmc.18.2019.12.11.08.35.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Dec 2019 08:35:55 -0800 (PST)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@rambus.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, Pascal van Leeuwen <pvanleeuwen@rambus.com>
Subject: [PATCH 0/3] crypto: inside-secure - Made driver work on EIP97
Date:   Wed, 11 Dec 2019 17:32:34 +0100
Message-Id: <1576081957-5971-1-git-send-email-pvanleeuwen@rambus.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset fixes various errors and hang cases that occurred when
running the crypto self-tests, and in particular the extra tests, on
an EIP97 type engine (e.g. Marvell Armada 3700LP as used on EspressoBin)

Tested on Macchiatobin, EspressoBin (thanks, Antoine Tenart), EIP97HW2.3
and EIP197HW3.2 on the Xilinx VCU118 FPGA development board.

Pascal van Leeuwen (3):
  crypto: inside-secure - Fix Unable to fit even 1 command desc error w/
    EIP97
  crypto: inside-secure - Fix hang case on EIP97 with zero length input
    data
  crypto: inside-secure - Fix hang case on EIP97 with basic DES/3DES ops

 drivers/crypto/inside-secure/safexcel.c        |  12 +-
 drivers/crypto/inside-secure/safexcel.h        |  34 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 552 +++++++++++++++----------
 drivers/crypto/inside-secure/safexcel_hash.c   |  14 +-
 drivers/crypto/inside-secure/safexcel_ring.c   | 130 ++++--
 5 files changed, 473 insertions(+), 269 deletions(-)

--
1.8.3.1
