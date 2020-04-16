Return-Path: <SRS0=NP+Z=6A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB3BC2BA2B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEAD0214D8
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408477AbgDPGuo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Apr 2020 02:50:44 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:41366 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408458AbgDPGui (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Apr 2020 02:50:38 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jOyM2-0005GG-A0; Thu, 16 Apr 2020 16:50:31 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Apr 2020 16:50:30 +1000
Date:   Thu, 16 Apr 2020 16:50:30 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 0/4] crypto: caam - fix use-after-free KASAN issue
Message-ID: <20200416065029.GA7901@gondor.apana.org.au>
References: <1586213248-4230-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586213248-4230-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 07, 2020 at 01:47:24AM +0300, Iuliana Prodan wrote:
> This series fixes a use-after-free KASAN issue that was introduce
> by CAAM backlogging support[1].
> This is fixed for SKCIPHER, HASH, RSA and AEAD algorithms.
> 
> [1] https://patchwork.kernel.org/cover/11378941/
> 
> ---
> Changes since V1:
> - update commit messages by adding the complete KASAN report;
> - keep resource freeing before request completion callback;
> - added stable tag.
> 
> Iuliana Prodan (4):
>   crypto: caam - fix use-after-free KASAN issue for SKCIPHER algorithms
>   crypto: caam - fix use-after-free KASAN issue for AEAD algorithms
>   crypto: caam - fix use-after-free KASAN issue for HASH algorithms
>   crypto: caam - fix use-after-free KASAN issue for RSA algorithms
> 
>  drivers/crypto/caam/caamalg.c  | 8 ++++++--
>  drivers/crypto/caam/caamhash.c | 8 ++++++--
>  drivers/crypto/caam/caampkc.c  | 8 ++++++--
>  3 files changed, 18 insertions(+), 6 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
