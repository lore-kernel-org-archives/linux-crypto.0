Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F31FCA9EBD
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5062B21D71
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440598AbfJYPSy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:18:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35694 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439061AbfJYPSy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 11:18:54 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iO1MN-0001dK-0d; Fri, 25 Oct 2019 23:18:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iO1MC-0007iE-KM; Fri, 25 Oct 2019 23:18:28 +0800
Date:   Fri, 25 Oct 2019 23:18:28 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     linux-crypto@vger.kernel.org, dsaxena@plexity.net, mpm@selenic.com,
        romain.perier@free-electrons.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, daniel.thompson@linaro.org,
        ralph.siemsen@linaro.org, milan.stevanovic@se.com,
        ryan.harkin@linaro.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] hwrng: omap - Fix RNG wait loop timeout
Message-ID: <20191025151828.l4gdnuw3ud5gkfw2@gondor.apana.org.au>
References: <1571054565-6991-1-git-send-email-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571054565-6991-1-git-send-email-sumit.garg@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 14, 2019 at 05:32:45PM +0530, Sumit Garg wrote:
> Existing RNG data read timeout is 200us but it doesn't cover EIP76 RNG
> data rate which takes approx. 700us to produce 16 bytes of output data
> as per testing results. So configure the timeout as 1000us to also take
> account of lack of udelay()'s reliability.
> 
> Fixes: 383212425c92 ("hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>  drivers/char/hw_random/omap-rng.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
