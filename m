Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E363EC76191
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC84022CE8
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 13:47:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I6up5k5j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388077AbfGZNrn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:47:43 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:41646 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388296AbfGZNpw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 09:45:52 -0400
Received: by mail-ed1-f49.google.com with SMTP id p15so53297258eds.8
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jul 2019 06:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fFB59i/KR1NFPnF58ScmWzSYAxJrvQ5w2m22vY6o9Q4=;
        b=I6up5k5jF5TcM2gFSkA0bQyN0zOjnQJlr+eJPrPB7TbqFpjBNTKTNTEej1rNsO2aYE
         RcX8jfWSxPBcAnrNrFFdjicX1LIeqG+xF40mu9KI1beH2R0iE7hMt0Sut2Jk7XGAwOaa
         kKII90mt2wKzUgJV9hs/3v8ipx2i6Nq9h2hBrDMcd7W5UypkjFzIremc17IrzuBJTVAB
         CcR6hv+OdB9kac4b65xNMFdG5nb8JhmgdVKfQsEUu/6VWavNcYGjOjjWWjA0kXctek3H
         kuks9CUZ4T1+N660HvkyByRpbQ/WGM2hGgUj2vIuOhc9Oia21eHqMU58Gh1u3INuJLOx
         ddQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fFB59i/KR1NFPnF58ScmWzSYAxJrvQ5w2m22vY6o9Q4=;
        b=S4yKC/si0aOeudEJYkQdhHndn8sTumKVo376GpY246eJtNNy4PK5V3dAj5WdatgNP/
         bYOdUSO6pX+KU0wpJCZpVjb8j78qmGYqnsQ1SbhRPffuDQrEpO2iE5d4NPP7z5lcxWlb
         sKSJJPwZy2UEM0vdQupqhX2s33gKHYwNm7p5yXO0zL6OL8O6RmHChAd5mE73Jll03IBg
         fB9T//BbfOOdeVQHd2P4oBIYh08Ttc95qZwlk3xxlUnUDByBR62WqEvmgiPChbhaLqvK
         w0rVYniILtmZHye428K3B+J0jDaI3TJ4+a8Nz/33C6MKXaACMkz96Tc6wZyfKj1eCoDX
         e4gA==
X-Gm-Message-State: APjAAAUKXYc/77HZGua29EaXfpwEzpt4WG87pMD3mC2FEuD8IQO+x5Rr
        m5n+pSetcNI/8djQ2DoOXG2H7tH/
X-Google-Smtp-Source: APXvYqzm4XatAl2zC4IFzpMpp+EfOwNiJXm5wmU/kDbx8/mmn8FqKJol8O3NMrQ9jXsnmqT+KaWPFQ==
X-Received: by 2002:a50:922a:: with SMTP id i39mr82185648eda.219.1564148749982;
        Fri, 26 Jul 2019 06:45:49 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id 34sm14061423eds.5.2019.07.26.06.45.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 06:45:49 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope 
Date:   Fri, 26 Jul 2019 14:43:22 +0200
Message-Id: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a first baby step towards making the inside-secure crypto driver
more broadly useful. The current driver only works for Marvell Armada HW
and requires proprietary firmware, only available under NDA from Marvell,
to be installed. This patch set allows the driver to be used with other
hardware and removes the dependence on that proprietary firmware.

changes since v1:
- changed dev_info's into dev_dbg to reduce normal verbosity
- terminate all message strings with \n
- use priv->version field strictly to enumerate device context
- fixed some code & comment style issues
- removed EIP97/197 references from messages
- use #if(IS_ENABLED(CONFIG_PCI)) to remove all PCI related code
- use #if(IS_ENABLED(CONFIG_OF)) to remove all device tree related code
- do not inline the minifw but read it from /lib/firmware instead

Pascal van Leeuwen (3):
  crypto: inside-secure - make driver selectable for non-Marvell
    hardware
  crypto: inside-secure - add support for PCI based FPGA development
    board
  crypto: inside-secure - add support for using the EIP197 without
    vendor firmware

 drivers/crypto/Kconfig                         |  12 +-
 drivers/crypto/inside-secure/safexcel.c        | 748 +++++++++++++++++--------
 drivers/crypto/inside-secure/safexcel.h        |  36 +-
 drivers/crypto/inside-secure/safexcel_cipher.c |  11 -
 drivers/crypto/inside-secure/safexcel_hash.c   |  12 -
 drivers/crypto/inside-secure/safexcel_ring.c   |   3 +-
 6 files changed, 569 insertions(+), 253 deletions(-)

-- 
1.8.3.1

