Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5669BFA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 15:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 269F5215EA
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 15:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfKHPO3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 10:14:29 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57798 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfKHPO3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 10:14:29 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iT5xu-00075o-VA; Fri, 08 Nov 2019 23:14:22 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iT5xs-00074Y-Qq; Fri, 08 Nov 2019 23:14:20 +0800
Date:   Fri, 8 Nov 2019 23:14:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] enable CAAM's HWRNG as default
Message-ID: <20191108151420.fwmcwza4vm6w3e7w@gondor.apana.org.au>
References: <20191029162916.26579-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029162916.26579-1-andrew.smirnov@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 29, 2019 at 09:29:13AM -0700, Andrey Smirnov wrote:
> Everyone:
> 
> This series is a continuation of original [discussion]. I don't know
> if what's in the series is enough to use CAAMs HWRNG system wide, but
> I am hoping that with enough iterations and feedback it will be.
> 
> Feedback is welcome!
> 
> Thanks,
> Andrey Smirnov
> 
> [discussion] https://patchwork.kernel.org/patch/9850669/
> 
> Andrey Smirnov (3):
>   crypto: caam - RNG4 TRNG errata
>   crypto: caam - enable prediction resistance in HRWNG
>   crypto: caam - set hwrng quality level
> 
>  drivers/crypto/caam/caamrng.c |  4 +++-
>  drivers/crypto/caam/ctrl.c    | 19 +++++++++++++------
>  drivers/crypto/caam/desc.h    |  2 ++
>  drivers/crypto/caam/regs.h    |  7 +++++--
>  4 files changed, 23 insertions(+), 9 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
