Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9781AC4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C34520830
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbfJDPmP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:42:15 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42500 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389131AbfJDPmN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 11:42:13 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iGPhq-0001GL-PW; Sat, 05 Oct 2019 01:41:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2019 01:41:18 +1000
Date:   Sat, 5 Oct 2019 01:41:18 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Srikanth Jampala <jsrikanth@marvell.com>,
        "mallesham.jatharakonda@oneconvergence.com" 
        <mallesham.jatharakonda@oneconvergence.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: cavium/nitrox - check assoclen and authsize for
 gcm(aes) cipher
Message-ID: <20191004154118.GM5148@gondor.apana.org.au>
References: <20190916064140.24387-1-rnagadheeraj@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916064140.24387-1-rnagadheeraj@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 16, 2019 at 06:42:06AM +0000, Nagadheeraj Rottela wrote:
> Check if device supports assoclen to solve hung task timeout error when
> extra tests are enabled. Return -EINVAL if assoclen is not supported.
> Check authsize to return -EINVAL if authentication tag size is invalid.
> Change blocksize to 1 to match with generic implementation.
> 
> Signed-off-by: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
> Reported-by: Mallesham Jatharakonda <mallesham.jatharakonda@oneconvergence.com>
> Suggested-by: Mallesham Jatharakonda <mallesham.jatharakonda@oneconvergence.com>
> Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_aead.c | 39 +++++++++++++++++++++++++++---
>  1 file changed, 36 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
