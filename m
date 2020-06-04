Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EB0C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 16:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18793207F5
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 16:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591287305;
	bh=T+Ujqj3So5mnSunqooQUIoEERMGQTbg+ImhD7uF3Tg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=SNkdV7Sd1luxkEkechHVmnzB36ijS0vmSsqfBHfgZWuT5HMw44/+ObiZhwb5a1eEF
	 CFvEgpgN6z1RR2BGD0nNNej0OZfZ4P3wVStJ95YjviMeP0iVHS/Jpmi3DoKD0xyGN5
	 ZZbCg4th9AIBxfbRr30BX97B1kdtMyRHMt3nWvaw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgFDQPE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 12:15:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728972AbgFDQPE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 12:15:04 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6BB620738;
        Thu,  4 Jun 2020 16:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591287303;
        bh=T+Ujqj3So5mnSunqooQUIoEERMGQTbg+ImhD7uF3Tg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dzPBNqcBRsQT1H2CPJvGzMO8Lpdy0HNS5Xil/NnTj1VW5Ep5Wf7N7ZIjDLMPMdoW/
         06zNrNT1jHwjKuIjvLQ4YHumz1O6zQVGpFUv3Dv3iap/FErmLci+2pCad8KO9TnovT
         S5HlaAv1f4u5LKVBXppt8Cv9qOHwt2JtYvxq1frA=
Date:   Thu, 4 Jun 2020 09:15:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] crypto: CRYPTO_CTR no longer need CRYPTO_SEQIV
Message-ID: <20200604161502.GA147774@gmail.com>
References: <1587735647-17718-1-git-send-email-clabbe@baylibre.com>
 <1587735647-17718-3-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587735647-17718-3-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 24, 2020 at 01:40:46PM +0000, Corentin Labbe wrote:
> As comment of the v2, Herbert said: "The SEQIV select from CTR is historical
> and no longer necessary."
> 
> So let's get rid of it.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  crypto/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 6d27fc6a7bf5..a5936e967fe2 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -370,7 +370,6 @@ config CRYPTO_CFB
>  config CRYPTO_CTR
>  	tristate "CTR support"
>  	select CRYPTO_SKCIPHER
> -	select CRYPTO_SEQIV
>  	select CRYPTO_MANAGER
>  	help
>  	  CTR: Counter mode

Shouldn't this patch also have added 'select CRYPTO_SEQIV' to INET_ESP and
INET6_ESP?  Or is the intent to make people explicitly select CRYPTO_SEQIV?

- Eric
