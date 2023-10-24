Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137EBC25B47
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Oct 2023 21:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbjJXVwk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Oct 2023 17:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234958AbjJXVwk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Oct 2023 17:52:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F01186;
        Tue, 24 Oct 2023 14:52:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825C5C433C7;
        Tue, 24 Oct 2023 21:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698184356;
        bh=yN/fYhaw1M0JxblGR3933Q8z6sbdb3VobEuc7Zid908=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tIZtE1fH7FMP405U1tbvI0YvnMGOj7bogm1B2zmwcnzevr2KfzCTZdYk/9mSi8X9P
         GQ78zqKCegrms6kDCC0QzIlvZg006vp/7zaTZUQyOqoaU2yhE4IxTv6fvbdcxxRGu8
         I/5OQG4bDfn7g/1UGMCU7OVgWlteN5anoHX7u3Q3C8Nw1DrTM+v/xxEr7auCtKzAwh
         hjBOWYwY6rqynssIvY3OLnCc5D+3S1ArMjDu1oseRPWWo5yQt9GtrJNlSrBA5y++26
         +A2s9T5R7CPJmr46k6RFZguxxXGMp4i4Sz6L60JJ0+FqSbsgrO/1kiBIh7hNQOmZT/
         zGvEbfXO5FlHQ==
Date:   Tue, 24 Oct 2023 23:52:31 +0200
From:   Andi Shyti <andi.shyti@kernel.org>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH 16/42] crypto: exynos-rng - Convert to platform remove
 callback returning void
Message-ID: <20231024215231.n2qjfaeormwu24hv@zenone.zhora.eu>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-60-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231020075521.2121571-60-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Uwe,

On Fri, Oct 20, 2023 at 09:55:38AM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> 
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Andi Shyti <andi.shyti@kernel.org>

Andi
