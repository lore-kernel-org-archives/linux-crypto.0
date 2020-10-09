Return-Path: <SRS0=BuJA=DQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADAEC433E7
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 12:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CABE222B8
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 12:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602245737;
	bh=rTq2L7ADDGmC2aCG76C+N7crz/74z4eDGRcypwoL840=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=wyA5gHgSJ9B7UvuQzC+p0cdjsR0M2oJaBntBs+4O7HCIQKB0bbc17o7RQnd3DiTbr
	 BPCVesTOv5DYPJfkfJeJ8WSdnPGiaGyiOXEk0kqNxhHJm1uUuHeelrr67vYthDOqlD
	 s4k+MHVYMoqUYgeu/cZaI9eUuEZdVNfPoRfMPFk4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388463AbgJIMPg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Oct 2020 08:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388459AbgJIMPg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Oct 2020 08:15:36 -0400
Received: from mail.kernel.org (ip5f5ad5d0.dynamic.kabel-deutschland.de [95.90.213.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2894820709;
        Fri,  9 Oct 2020 12:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602245735;
        bh=rTq2L7ADDGmC2aCG76C+N7crz/74z4eDGRcypwoL840=;
        h=From:To:Cc:Subject:Date:From;
        b=C5sH7wq7QFxHzbOtQD/FfMEkillGm3JuYzND+5IAX/Q1lBbqzqcyznKkoKzUVZv58
         dAmSLBnMDSMdP5FHOHDVG2e6fHy5ZtXV/cIZMchTxnMZJwSewyY55WEqNrtDqwjp1D
         4oZsmDmtIFN5JQqlkiTuoJi3nDN/POOyCsDLOQMA=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kQrJ6-003ksz-HO; Fri, 09 Oct 2020 14:15:32 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Chen-Yu Tsai <wens@csie.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Ripard <mripard@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 0/2] Fix new warnings at linux-next
Date:   Fri,  9 Oct 2020 14:15:29 +0200
Message-Id: <cover.1602245659.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are some file renames at linux-next that are causing some
new documentation warnings. Address them.

Mauro Carvalho Chehab (2):
  MAINTAINERS: fix broken doc refs due to yaml conversion
  crypto: sun8x-ce*: update entries to its documentation

 Documentation/devicetree/bindings/clock/hi6220-clock.txt | 2 +-
 MAINTAINERS                                              | 9 ++++-----
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c        | 2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c        | 2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c        | 2 +-
 .../devicetree/bindings/net/wireless/silabs,wfx.yaml     | 2 +-
 6 files changed, 9 insertions(+), 10 deletions(-)

-- 
2.26.2


