Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E70CC433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Oct 2021 06:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6359D61A71
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Oct 2021 06:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352081AbhJAGpw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Oct 2021 02:45:52 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55760 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231165AbhJAGpv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Oct 2021 02:45:51 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mWCH7-0006js-1O; Fri, 01 Oct 2021 14:44:05 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mWCH0-0003VN-Sy; Fri, 01 Oct 2021 14:43:58 +0800
Date:   Fri, 1 Oct 2021 14:43:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Matt Mackall <mpm@selenic.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Jerome Brunet <jbrunet@baylibre.com>
Subject: Re: [PATCH v2] hwrng: meson - Improve error handling for core clock
Message-ID: <20211001064358.GA13451@gondor.apana.org.au>
References: <20210920074405.252477-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210920074405.252477-1-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 20, 2021 at 09:44:05AM +0200, Uwe Kleine-König wrote:
> -ENOENT (ie. "there is no clock") is fine to ignore for an optional
> clock, other values are not supposed to be ignored and should be
> escalated to the caller (e.g. -EPROBE_DEFER). Ignore -ENOENT by using
> devm_clk_get_optional().
> 
> While touching this code also add an error message for the fatal errors.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> compared to (implicit) v1
> (https://lore.kernel.org/r/20210914142428.57099-1-u.kleine-koenig@pengutronix.de)
> this used dev_err_probe() as suggested by Martin Blumenstingl.
> 
> v1 got a "Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>", I didn't add
> that because of the above change.
> 
> (Hmm, my setup is broken, the b4 patch signature was done before I added this
> message. I wonder if this will break the signature ...)
> 
> Best regards
> Uwe
> 
>  drivers/char/hw_random/meson-rng.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
