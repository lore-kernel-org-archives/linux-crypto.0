Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D3B1C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 15:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35FC621721
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560353599;
	bh=vnCFqlIysBlBrEjyKyc8fWyjqHp8jOqecr01gQB6WHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=aW3XydDOzSCc6xUf7hr+osyvOU2YZexPp7OMsPkEWqCppi1i7EZgECSJ4V7b5yaHp
	 2HdIax9lHZr5VPV9STezRPDuWQRoXvIGFgL54VduJQjgETvbh38EtP2xfq2+dOFf0Q
	 /Uo9KeLNPWytOKp3D2JQ4v1k2DUSN8dGR1bMpwEU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408943AbfFLPdS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 11:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405706AbfFLPdS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 11:33:18 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E607E215EA;
        Wed, 12 Jun 2019 15:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560353598;
        bh=vnCFqlIysBlBrEjyKyc8fWyjqHp8jOqecr01gQB6WHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ujTEPwJvcqxC/Pf8kL1XVhT8CstMMVeQAYJFuiTgItn/UkzJ1JHlxoHAFu5I8J7ab
         SyjQ3wq8JeYRU8lBv1LFfGhkub7txTCZT1RtVwK73MgO7CNhB2w8HW6cHkynvtWksc
         rhw3yD2KddohJjMbRIFvQ+AgGYsXInnEutZptMLs=
Date:   Wed, 12 Jun 2019 08:33:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3 5/7] crypto: arc4 - remove cipher implementation
Message-ID: <20190612153316.GA680@sol.localdomain>
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
 <20190611134750.2974-6-ard.biesheuvel@linaro.org>
 <20190611173938.GA66728@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611173938.GA66728@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 11, 2019 at 10:39:39AM -0700, Eric Biggers wrote:
> > -
> >  static struct skcipher_alg arc4_skcipher = {
> 
> Similarly this could be renamed from arc4_skcipher to arc4_alg, now that the
> skcipher algorithm doesn't need to be distinguished from the cipher algorithm.
> 
> >  	.base.cra_name		=	"ecb(arc4)",
> 
> Given the confusion this name causes, can you leave a comment?  Like:
> 
>         /*
>          * For legacy reasons, this is named "ecb(arc4)", not "arc4".
>          * Nevertheless it's actually a stream cipher, not a block cipher.
>          */
> 	 .base.cra_name          =       "ecb(arc4)",
> 
> 
> Also, due to removing the cipher algorithm, we need the following testmgr change
> so that the comparison self-tests consider the generic implementation of this
> algorithm to be itself rather than "ecb(arc4-generic)":
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 658a7eeebab28..5d3eb8577605f 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -4125,6 +4125,7 @@ static const struct alg_test_desc alg_test_descs[] = {
>  		}
>  	}, {
>  		.alg = "ecb(arc4)",
> +		.generic_driver = "ecb(arc4)-generic",
>  		.test = alg_test_skcipher,
>  		.suite = {
>  			.cipher = __VECS(arc4_tv_template)
> 
> - Eric

Hi Ard, did you see these comments?  They weren't addressed in v4.  We need at
least the testmgr change, otherwise there's a warning when booting with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y:

[    0.542610] alg: skcipher: skipping comparison tests for ecb(arc4)-generic because ecb(arc4-generic) is unavailable

- Eric
