Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD94CCA0ECA
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Sep 2023 04:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbjILECs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Sep 2023 00:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbjILECm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2023 00:02:42 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6661704
        for <linux-crypto@vger.kernel.org>; Mon, 11 Sep 2023 21:02:38 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qfubI-00DAFY-QH; Tue, 12 Sep 2023 12:02:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 12 Sep 2023 12:02:11 +0800
Date:   Tue, 12 Sep 2023 12:02:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] hwrng: stm32 - rework error handling in
 stm32_rng_read()
Message-ID: <ZP/iw6jvHrlBavdK@gondor.apana.org.au>
References: <20230908165120.730867-1-gatien.chevallier@foss.st.com>
 <20230908165120.730867-6-gatien.chevallier@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230908165120.730867-6-gatien.chevallier@foss.st.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 08, 2023 at 06:51:15PM +0200, Gatien Chevallier wrote:
>
> +			if (WARN_ON(sr & RNG_SR_CEIS), "RNG clock too slow - %x\n", sr)

Introducing an unconditional WARN_ON is not acceptable.  If you
really need it, make it WARN_ON_ONCE.  But why does this need
to be a WARN instead of dev_err?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
