Return-Path: <SRS0=LFd7=4X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5717BC3F2D2
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 01:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C4FF20726
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 01:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCFBvw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Mar 2020 20:51:52 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:46144 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbgCFBvw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Mar 2020 20:51:52 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jA29V-0005ta-FA; Fri, 06 Mar 2020 12:51:50 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Mar 2020 12:51:49 +1100
Date:   Fri, 6 Mar 2020 12:51:49 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH v2] crypto: caam/qi2 - fix chacha20 data size error
Message-ID: <20200306015149.GK30653@gondor.apana.org.au>
References: <20200228065123.13216-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200228065123.13216-1-horia.geanta@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 28, 2020 at 08:51:23AM +0200, Horia Geantă wrote:
> HW generates a Data Size error for chacha20 requests that are not
> a multiple of 64B, since algorithm state (AS) does not have
> the FINAL bit set.
> 
> Since updating req->iv (for chaining) is not required,
> modify skcipher descriptors to set the FINAL bit for chacha20.
> 
> [Note that for skcipher decryption we know that ctx1_iv_off is 0,
> which allows for an optimization by not checking algorithm type,
> since append_dec_op1() sets FINAL bit for all algorithms except AES.]
> 
> Also drop the descriptor operations that save the IV.
> However, in order to keep code logic simple, things like
> S/G tables generation etc. are not touched.
> 
> Cc: <stable@vger.kernel.org> # v5.3+
> Fixes: 334d37c9e263 ("crypto: caam - update IV using HW support")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/caamalg_desc.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
