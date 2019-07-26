Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A79C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ABF322ADA
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfGZMfi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:35:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46518 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfGZMfi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:35:38 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hqzR8-0003yI-Sq; Fri, 26 Jul 2019 22:35:03 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hqzQz-0002Bv-KJ; Fri, 26 Jul 2019 22:34:53 +1000
Date:   Fri, 26 Jul 2019 22:34:53 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Anson.Huang@nxp.com
Cc:     mpm@selenic.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, rfontana@redhat.com, allison@lohutok.net,
        kstewart@linuxfoundation.org, tglx@linutronix.de,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Linux-imx@nxp.com
Subject: Re: [PATCH 1/2] char: hw_random: imx-rngc: use
 devm_platform_ioremap_resource() to simplify code
Message-ID: <20190726123453.GA8415@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717090438.31522-1-Anson.Huang@nxp.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Anson.Huang@nxp.com wrote:
> From: Anson Huang <Anson.Huang@nxp.com>
> 
> Use the new helper devm_platform_ioremap_resource() which wraps the
> platform_get_resource() and devm_ioremap_resource() together, to
> simplify the code.
> 
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
> ---
> drivers/char/hw_random/imx-rngc.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
