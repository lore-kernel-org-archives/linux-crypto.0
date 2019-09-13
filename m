Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 047BAC4CEC8
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 19:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB82A2084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 19:04:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZsLodRlP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388638AbfIMTEr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 15:04:47 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41702 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728935AbfIMTEp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 15:04:45 -0400
Received: by mail-ed1-f68.google.com with SMTP id z9so27916258edq.8
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 12:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=99D+Bdz1iAyW31OkwtjCR8anZQFy/QR6OerJdff2IWQ=;
        b=ZsLodRlP/FKcfkjQ8Ydd5kLPygahH96a97bnJ2yVpWHI3dOx6JL169u1J5LHGp099d
         5LdruAJ6fekayYBcoHtu0ni5i2AwGfKHjvYBLiFr9KLhYRcMz+SfFJqLbu/y0RHJtfdd
         vdu1SMao2layU8vFeXKSbFCJo8iXx/+/05nzPknNnTqE6MQGHLxCYjMEDIwamj95hNTf
         pQIYB1BtCc+JtFQBV70IcSpBKHjiXgJHx1FE70JvY33/zQoLVeWbvhN7zfGRCx835AN4
         rh+Pv3iK+/el3brLp1gw7lgFyWbqrKXw6jws0YL/MriWPnVKRldGrsirRygs2qUEN6qG
         6dUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=99D+Bdz1iAyW31OkwtjCR8anZQFy/QR6OerJdff2IWQ=;
        b=nvm1PjGQyVQY/Z7N5ax2ZzsVQJvPoBxYiN8HEgHbSt2UN52MyxNZqZShwkU86h8RDu
         Gg0RuLuyAP3l44BgyVdMkpOJUjXkcM4LIPxUm/d0mW5S3lgJQAmz/GOeirR7XOa8yKNc
         TvBLu9Fb+74P/LQSWRelLTScT58narNu+YCcfgfMjlqPMWRxipkKknTJ4f2mLpanCGDj
         1D7MAbmN8lhd8tcl4HOrpcDh1bNLWm2Y/SHJ2Vvk67prGbNNyaWiAb3Jzl9daQNEVXKz
         OZx6p/qhDENVsF/vNN8J4Qg8Sw4F+wfojmwGssIH8MzJutTeiUMvAkY50AvDcff3YYk1
         cDrQ==
X-Gm-Message-State: APjAAAUb95udRlvy08grGn7Khs6ohGFli0BvmOzuC4bOMkP55LWJBVhX
        NGvkINWN2XuuVqqek78wVGOOnMlL
X-Google-Smtp-Source: APXvYqxausWoPUWISBgEQqA4wpRM/U4QH5p7/vojIMT0EoR3KUNZOGyON/HYS4j2o5CQyioWtvc/rQ==
X-Received: by 2002:a05:6402:516:: with SMTP id m22mr27777088edv.83.1568401483195;
        Fri, 13 Sep 2019 12:04:43 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id ba28sm49099edb.4.2019.09.13.12.04.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 12:04:42 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv3 0/3] crypto: inside-secure: Add support for the Chacha20 skcipher and the Chacha20-Poly1305 AEAD suites
Date:   Fri, 13 Sep 2019 20:01:52 +0200
Message-Id: <1568397715-2535-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extend driver support with chacha20, rfc7539(chacha20,poly1305) and
rfc7539esp(chacha20,poly1305) ciphers.
The patchset has been tested with the eip197c_iesb and eip197c_iewxkbc
configurations on the Xilinx VCU118 development board, including the
crypto extra tests.

Note that this patchset applies on top of the earlier submitted
"Add support for the CBCMAC" series.

changes since v1:
- rebased on top of DES library changes done on cryptodev/master
- fixed crypto/Kconfig so that generic fallback is compiled as well

changes since v2:
- made switch entry SAFEXCEL_AES explit and added empty default, as 
  requested by Antoine Tenart. Also needed to make SM4 patches apply.

Pascal van Leeuwen (3):
  crypto: inside-secure - Added support for the CHACHA20 skcipher
  crypto: inside-secure - Add support for the Chacha20-Poly1305 AEAD
  crypto: Kconfig - Add CRYPTO_CHACHA20POLY1305 to CRYPTO_DEV_SAFEXCEL

 drivers/crypto/Kconfig                         |   3 +-
 drivers/crypto/inside-secure/safexcel.c        |   3 +
 drivers/crypto/inside-secure/safexcel.h        |  11 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 335 ++++++++++++++++++++++++-
 4 files changed, 338 insertions(+), 14 deletions(-)

-- 
1.8.3.1

