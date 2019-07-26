Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0E9C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CFCC22ADA
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfGZMdt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:33:49 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46458 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfGZMdt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:33:49 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hqzPu-0003tm-2o; Fri, 26 Jul 2019 22:33:46 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hqzPs-0002Ah-WB; Fri, 26 Jul 2019 22:33:44 +1000
Date:   Fri, 26 Jul 2019 22:33:44 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Phani Kiran Hemadri <phemadri@marvell.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, phemadri@marvell.com
Subject: Re: [PATCH] crypto: cavium/nitrox - Add support for loading
 asymmetric crypto firmware
Message-ID: <20190726123344.GA8340@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709152341.20953-1-phemadri@marvell.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Phani Kiran Hemadri <phemadri@marvell.com> wrote:
> This patch adds support to load Asymmetric crypto firmware on
> AE cores of CNN55XX device. Firmware is stored on UCD block 2
> and all available AE cores are tagged to group 0.
> 
> Signed-off-by: Phani Kiran Hemadri <phemadri@marvell.com>
> Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
> ---
> drivers/crypto/cavium/nitrox/nitrox_csr.h     | 124 ++++++++++++++-
> drivers/crypto/cavium/nitrox/nitrox_debugfs.c |   3 +-
> drivers/crypto/cavium/nitrox/nitrox_dev.h     |   4 +-
> drivers/crypto/cavium/nitrox/nitrox_main.c    | 144 ++++++++++++++----
> 4 files changed, 244 insertions(+), 31 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
