Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7177C3A5A4
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DBC1238CF
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:43:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OslC7F9x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbfH3Inm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:43:42 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45267 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727747AbfH3Inl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:43:41 -0400
Received: by mail-ed1-f65.google.com with SMTP id x19so7072451eda.12
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 01:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bvNpuuHfca8bNfd+gumtPXm3KV25Fpxl2wx+eefd+v4=;
        b=OslC7F9xCTNDCb0EUJjPOCm/YWgnq44brQd9wiXNnJDKsgW9usFnILZaRbkZNKjLbR
         OcYpGeRu5Zsvj6Ef13giFiyX2hsIVtwHyC58dgjtiLOzpVDddQDl1TsGOl8ty6fRrHV6
         +OPjDubEblXlz42BoiMa3N+4e3urnMynOW8tl3gbpNvGOehz/RTZi75b+Uk4YzkqKLQk
         3RL8Qt8eZzA4UPPpPdDaCUr0zaGUZh5VSxzV9ue/X3v9M0sJBN1emOD0PE+TUqTfC7MQ
         wkvljBylK6/AX2tInrw4M9lJ8qHEcqfQdLeurKKl1L6obnrCl5c3V1ZSh01gv7Vfd/mk
         GOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bvNpuuHfca8bNfd+gumtPXm3KV25Fpxl2wx+eefd+v4=;
        b=Y5SW/JbElu5TLZta1vjitE/UHsOrOhbUOoCVJ2qtSJYb5cKikhhWcSyqNFXYoQrbtG
         0Wc7fTZVD1wMnpnuY6joyfVxnOZ870AlgUhA7wir0K5W6exf+JCGFP2ZPEA71psp5+Xd
         KR1xQd1dxLRT2hsP1kQ9gDBVCby0AcwyU/CEAIBKIB+0gBgH4x9T2x61H1X3W1Fa2wTN
         +zmsem0llFvgnRIsiInkTNblyyJEDGemA4kOzltUviBh538Y40bXrmn6dMzXXI4jBJBt
         OhwVSRGSlAd9npQewq+QPoV5j0ymwGoey4aXV6BTR2z1HZQkwPsQ0+UJ5Vh0bpQaUgUX
         rOhw==
X-Gm-Message-State: APjAAAUFB3zFj/i6doXQzR30sp2Q1nHw94237vMYauLHOAnNMbOXKAu1
        HTXom1OCWNz49TWOOob7N9jgtbRE
X-Google-Smtp-Source: APXvYqx0n04aXatPrxQ/qmzZPIud0miUBRweG+GV5po/jDmWzKWUZe/T1xGSt0l3KzhlRsl8X6jPrg==
X-Received: by 2002:aa7:d8ca:: with SMTP id k10mr14223857eds.249.1567154619815;
        Fri, 30 Aug 2019 01:43:39 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id x11sm705823eju.26.2019.08.30.01.43.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 01:43:39 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/3] crypto: inside-secure - Add AES-XTS cipher support 
Date:   Fri, 30 Aug 2019 09:40:51 +0200
Message-Id: <1567150854-10589-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the AES-XTS algorithm for HW that supports it.

Pascal van Leeuwen (3):
  crypto: inside-secure - Move static cipher alg & mode settings to init
  crypto: inside-secure - Add support for the AES-XTS algorithm
  crypto: inside-secure - Only enable algorithms advertised by the
    hardware

 drivers/crypto/inside-secure/safexcel.c        |  37 ++-
 drivers/crypto/inside-secure/safexcel.h        |  35 +++
 drivers/crypto/inside-secure/safexcel_cipher.c | 401 +++++++++++++++----------
 drivers/crypto/inside-secure/safexcel_hash.c   |  12 +
 4 files changed, 332 insertions(+), 153 deletions(-)

-- 
1.8.3.1

