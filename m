Return-Path: <SRS0=QxuD=77=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10240C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 07:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA8520899
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 07:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgFRH4t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jun 2020 03:56:49 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60432 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728340AbgFRH4t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jun 2020 03:56:49 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jlpPQ-00023D-Nn; Thu, 18 Jun 2020 17:56:29 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 18 Jun 2020 17:56:28 +1000
Date:   Thu, 18 Jun 2020 17:56:28 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Olivier Sobrie <olivier.sobrie@silexinsight.com>
Cc:     Matt Mackall <mpm@selenic.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Waleed Ziad <waleed94ziad@gmail.com>,
        sebastien.rabou@silexinsight.com
Subject: Re: [PATCH v2 0/2] hwrng: add support for Silex Insight BA431
Message-ID: <20200618075628.GB10091@gondor.apana.org.au>
References: <20200601142740.443548-1-olivier.sobrie@silexinsight.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601142740.443548-1-olivier.sobrie@silexinsight.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 01, 2020 at 04:27:38PM +0200, Olivier Sobrie wrote:
> Hello all,
> 
> This set of patches aims at introducing a linux hwrng driver for the
> Silex Insight BA431 IP which is available for various FPGA.
> This hardware is for instance present in Silex Insight Viper OEM boards.
> 
> The first patch documents the device tree bindings.
> The second one contains the BA431 hwrng driver.
> 
> Olivier Sobrie (2):
>   dt-bindings: rng: document Silex Insight BA431 hwrng
>   hwrng: ba431-rng: add support for BA431 hwrng
> 
>  .../bindings/rng/silex-insight,ba431-rng.yaml |  36 +++
>  drivers/char/hw_random/Kconfig                |  12 +
>  drivers/char/hw_random/Makefile               |   1 +
>  drivers/char/hw_random/ba431-rng.c            | 234 ++++++++++++++++++
>  4 files changed, 283 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml
>  create mode 100644 drivers/char/hw_random/ba431-rng.c
> 
> Changes in v2:
>   - Dropped the first patch that has been applied by Rob.
>   - Added Rob's review tag in the first patch.
>   - Fixed copyright header.
>   - Added missing endpoint and "If unsure, say Y" in the Kconfig like it is
>     done for the other rng drivers.
>   - Replaced the udelay() loop by readx_poll_timeout() in the driver.
>   - Added Arnd's ack in the second patch.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
