Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F7EBC54EBC
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Jan 2023 03:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbjAIDEi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Jan 2023 22:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbjAIDEg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Jan 2023 22:04:36 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F601116E;
        Sun,  8 Jan 2023 19:04:34 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pEiS3-00FR6F-K4; Mon, 09 Jan 2023 11:03:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 09 Jan 2023 11:03:55 +0800
Date:   Mon, 9 Jan 2023 11:03:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     JiaJie Ho <jiajie.ho@starfivetech.com>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor.dooley@microchip.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] hwrng: starfive - Add TRNG driver for StarFive SoC
Message-ID: <Y7uEGxl8xJ1xxkKZ@gondor.apana.org.au>
References: <20221228071103.91797-1-jiajie.ho@starfivetech.com>
 <20221228071103.91797-3-jiajie.ho@starfivetech.com>
 <Y7fePDme5E3yhPhQ@gondor.apana.org.au>
 <7c2cc6e9cdf241318fc73162a5ec221d@EXMBX168.cuchost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c2cc6e9cdf241318fc73162a5ec221d@EXMBX168.cuchost.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 09, 2023 at 02:58:14AM +0000, JiaJie Ho wrote:
>
> My trng device requires sending a generate new number cmd before each read.
> It then only populates the data registers with new random number and raise an interrupt when ready.
> If user choose to not wait, they will always get stale bits. 
> Is it okay to always return error if wait=false ?

What is the length of the wait time? Is there an upper bound?
What is the average wait time?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
