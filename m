Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9B2C433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 13:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84E0E64F5F
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 13:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhCLNPZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 08:15:25 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54584 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230512AbhCLNOx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 08:14:53 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lKhcM-0006Jj-Rw; Sat, 13 Mar 2021 00:14:16 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Mar 2021 00:14:14 +1100
Date:   Sat, 13 Mar 2021 00:14:14 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     Matt Mackall <mpm@selenic.com>, Rob Herring <robh+dt@kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] hwrng: bcm2835: add reset support
Message-ID: <20210312131414.GK31502@gondor.apana.org.au>
References: <20210305070132.2986-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210305070132.2986-1-noltari@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 05, 2021 at 08:01:29AM +0100, Álvaro Fernández Rojas wrote:
> Some devices may need to perform a reset before using the RNG, such as the
> BCM6368.
> 
> v6: fix dt-bindings documentation, add patch makings clocks mandatory for
>  BCM6368.
> v5: remove reset_control_rearm() and apply on latest herbert/cryptodev-2.6.git.
> v4: fix documentation, add reset_control_rearm().
> v3: make resets required if brcm,bcm6368-rng.
> v2: document reset support.
> 
> Álvaro Fernández Rojas (3):
>   dt-bindings: rng: bcm2835: add clock constraints
>   dt-bindings: rng: bcm2835: document reset support
>   hwrng: bcm2835: add reset support
> 
>  .../devicetree/bindings/rng/brcm,bcm2835.yaml | 21 +++++++++++++++++++
>  drivers/char/hw_random/bcm2835-rng.c          | 10 +++++++++
>  2 files changed, 31 insertions(+)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
