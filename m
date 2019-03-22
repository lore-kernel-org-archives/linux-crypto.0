Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEF6C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35B1020693
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbfCVNEK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:04:10 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:49476 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731430AbfCVNEI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 09:04:08 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h7Jpx-0006Cp-LQ; Fri, 22 Mar 2019 21:03:53 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h7Jpr-0005cx-DO; Fri, 22 Mar 2019 21:03:47 +0800
Date:   Fri, 22 Mar 2019 21:03:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Rouven Czerwinski <r.czerwinski@pengutronix.de>
Cc:     kernel@pengutronix.de, Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: omap - Set default quality
Message-ID: <20190322130347.grgvvuefqgdclcsy@gondor.apana.org.au>
References: <20190311105857.30792-1-r.czerwinski@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311105857.30792-1-r.czerwinski@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 11, 2019 at 11:58:57AM +0100, Rouven Czerwinski wrote:
> Newer combinations of the glibc, kernel and openssh can result in long initial
> startup times on OMAP devices:
> 
> [    6.671425] systemd-rc-once[102]: Creating ED25519 key; this may take some time ...
> [  142.652491] systemd-rc-once[102]: Creating ED25519 key; done.
> 
> due to the blocking getrandom(2) system call:
> 
> [  142.610335] random: crng init done
> 
> Set the quality level for the omap hwrng driver allowing the kernel to use the
> hwrng as an entropy source at boot.
> 
> Signed-off-by: Rouven Czerwinski <r.czerwinski@pengutronix.de>
> ---
>  drivers/char/hw_random/omap-rng.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
