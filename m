Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEEAC2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 07:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2283E206F4
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 07:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgKFHDj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 02:03:39 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:35104 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgKFHDj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 02:03:39 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kavmY-00088a-8Q; Fri, 06 Nov 2020 18:03:35 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2020 18:03:34 +1100
Date:   Fri, 6 Nov 2020 18:03:34 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Andrei Botila <andrei.botila@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - fix printing on xts fallback allocation
 error path
Message-ID: <20201106070334.GJ11620@gondor.apana.org.au>
References: <20201101200553.25248-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201101200553.25248-1-horia.geanta@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Nov 01, 2020 at 10:05:53PM +0200, Horia Geantă wrote:
> At the time xts fallback tfm allocation fails the device struct
> hasn't been enabled yet in the caam xts tfm's private context.
> 
> Fix this by using the device struct from xts algorithm's private context
> or, when not available, by replacing dev_err with pr_err.
> 
> Fixes: 9d9b14dbe077 ("crypto: caam/jr - add fallback for XTS with more than 8B IV")
> Fixes: 83e8aa912138 ("crypto: caam/qi - add fallback for XTS with more than 8B IV")
> Fixes: 36e2d7cfdcf1 ("crypto: caam/qi2 - add fallback for XTS with more than 8B IV")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/caamalg.c     | 4 ++--
>  drivers/crypto/caam/caamalg_qi.c  | 4 ++--
>  drivers/crypto/caam/caamalg_qi2.c | 3 ++-
>  3 files changed, 6 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
