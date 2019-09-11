Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283F3ECDE20
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 08:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFFC821928
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 08:44:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SJ7Vwh95"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfIKIoB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 04:44:01 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:33728 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfIKIoB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 04:44:01 -0400
Received: by mail-ed1-f49.google.com with SMTP id o9so19920847edq.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 01:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cCKe9sc9WhMUME4iOB2bNUe4kdVeUl12Cn8tXnr6OII=;
        b=SJ7Vwh953IN2cXV5HsjXAK6ipxgwyXerxFjVTRyIAKj+lfUh72a6LbtrWu4FUTdLYc
         sbWftTWHG+qFzsp9BsSyGFWEM1OjRpv0Qz5IoE2PYWE8HzXEJ0hBX49Uu1g0hD36ygr5
         Nez2W9RFjwGDjfmHkGe5Us8Jo9X6cRWoO64BlzzhfmIVdBLAFXEXSkOYrr0OBg8WLMV7
         bQLcNlt2PBSirj2xj6XtF633Jk7onQSC5KD647J5FXtEbV5MDQLxTZOOWJ072uaILhL3
         bCnoUrfpImB9y82FS5IfDpRcc7Hp4f89N7q19iuDmPxGM5jz78kjczebt5M9Tu775iXd
         FuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cCKe9sc9WhMUME4iOB2bNUe4kdVeUl12Cn8tXnr6OII=;
        b=O3/jIJ5TPVRhkwOjz0UZeeYJI9iPEMoF0kqbDT0QH1tLFaSt9lZvm3dTdhls99+5kr
         +/2wpHKHIHxps7mmK+J9oBLQLddkuaw/1pVqZO7RLUXxdndmxkYLZyYt5U45OUElrsYK
         jJmbxoldrx1g5qbezlnL1fErMtOv1iUiKoTnzCVBoSZKR8jkMz7FXcqc+s3HzY4gs9CB
         /4l3rku+4a8o7HyQagjGDynhTzWFxDMEZEaO73zb0t8k/IPNBWglsAJi3xeq4+q2hK4G
         DtuFtC/pBL/SoBnjSE2L08NGTh13r1OT00GGmyejK+AdsggL8vE8pwK19ARs5AadF8Gm
         O40Q==
X-Gm-Message-State: APjAAAVzUuF5a60TqwO1DfJXpvhGv0mdgtBEzLXWa8rsErVXNvlywUmE
        B2alNBek7rs8R/JEj1sAuSBN247N
X-Google-Smtp-Source: APXvYqxv16fDNcNG+yCL2Z3WkJi/JIW27Bj3G0tpEAQX9aHqgaJly3r63NdA+sCsjoR36HmeYjgUcw==
X-Received: by 2002:a17:906:660c:: with SMTP id b12mr1467517ejp.102.1568191437982;
        Wed, 11 Sep 2019 01:43:57 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id h38sm207138edh.13.2019.09.11.01.43.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 01:43:57 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/3] crypto: inside-secure - Add support for (HMAC) SM3
Date:   Wed, 11 Sep 2019 09:41:08 +0200
Message-Id: <1568187671-8540-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extend driver support with sm3 and hmac(sm3) ahash support.
Also add GM/T 0042-2015 hmac(sm3) testvectors to the testmgr.
The patchset has been tested with the eip197c_iewxkbc configuration
on the Xilinx VCU118 development board, including the crypto extra tests.

Note that this patchset applies on top of the earlier submitted
"Add support for the Chacha20 kcipher and the Chacha20-Poly..." series.

Pascal van Leeuwen (3):
  crypto: inside-secure - Added support for basic SM3 ahash
  crypto: inside-secure - Added support for HMAC-SM3 ahash
  crypto: testmgr - Added testvectors for the hmac(sm3) ahash

 crypto/testmgr.c                             |   6 ++
 crypto/testmgr.h                             |  56 ++++++++++++
 drivers/crypto/inside-secure/safexcel.c      |   2 +
 drivers/crypto/inside-secure/safexcel.h      |   3 +
 drivers/crypto/inside-secure/safexcel_hash.c | 129 +++++++++++++++++++++++++++
 5 files changed, 196 insertions(+)

-- 
1.8.3.1

