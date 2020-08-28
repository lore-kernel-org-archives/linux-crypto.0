Return-Path: <SRS0=6Tes=CG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7152C433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Aug 2020 06:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 997432098B
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Aug 2020 06:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgH1GsN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Aug 2020 02:48:13 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35202 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgH1GsN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Aug 2020 02:48:13 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kBYAv-0003Db-Na; Fri, 28 Aug 2020 16:47:50 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Aug 2020 16:47:49 +1000
Date:   Fri, 28 Aug 2020 16:47:49 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/18] crypto: sun8i-ss: support hash algorithms
Message-ID: <20200828064749.GA26312@gondor.apana.org.au>
References: <1598017415-39059-1-git-send-email-clabbe@baylibre.com>
 <1598017415-39059-4-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598017415-39059-4-git-send-email-clabbe@baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 21, 2020 at 01:43:20PM +0000, Corentin Labbe wrote:
>
> +	err = pm_runtime_get_sync(op->ss->dev);
> +	if (err < 0)
> +		goto error_pm;
> +	return 0;

You need to handle the error case like this:

https://patchwork.kernel.org/patch/11728595/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
