Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9CCC169C4
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 21:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CB6E217D9
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 21:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549920161;
	bh=IyoANoqpk2wK3RkkQMa+VAM4vshcUiRxbNIODqVQ1x0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=bKJBAXiaoYhn5LK9TXAGvf7eYStSi96lWs2pagXp2WiunnsR8WZTRKEABnn89I5Oz
	 pkxNxtjd4eh4EhYx3IdVOhAozflxGDXEPUcfr0Ciai2HncYvS5g3CDnX91g2XbihyY
	 X7ytygM6Ktbsz/0YoewoiM7zLfaY7Dyrbn781/lo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfBKVWk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 16:22:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbfBKVWk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 16:22:40 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD651214DA;
        Mon, 11 Feb 2019 21:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549920160;
        bh=IyoANoqpk2wK3RkkQMa+VAM4vshcUiRxbNIODqVQ1x0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AAwjxNT65dGgnaRnCDmkRIfNm/OySnExhuz9+l6vmrAa+9oHYb0tuqZWeQ9CtlEOo
         CwL8pb8yW1aW4k5Jj+zSB5RjUt7SvJu4p1yztQqEchhCOWO4QsOZH8CPTc3TSvcNHW
         19I5Z7o8vZNH0X0YyU7RGAyNYCl4oZOLULbP0LO0=
Date:   Mon, 11 Feb 2019 13:22:38 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, tglx@linutronix.de,
        Corentin Labbe <clabbe@baylibre.com>
Subject: Re: [PATCH 2/2] crypto: user: remove crypto_cfg_mutex
Message-ID: <20190211212237.GA226227@gmail.com>
References: <20190211110251.17377-1-bigeasy@linutronix.de>
 <20190211110251.17377-2-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211110251.17377-2-bigeasy@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 11, 2019 at 12:02:51PM +0100, Sebastian Andrzej Siewior wrote:
> crypto_cfg_mutex was never used since it got introduced in commit
> 
>   cac5818c25d04 ("crypto: user - Implement a generic crypto statistics")
> 
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  crypto/crypto_user_stat.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
> index 3e9a53233d804..028be6a1ea781 100644
> --- a/crypto/crypto_user_stat.c
> +++ b/crypto/crypto_user_stat.c
> @@ -20,8 +20,6 @@
>  
>  #define null_terminated(x)	(strnlen(x, sizeof(x)) < sizeof(x))
>  
> -static DEFINE_MUTEX(crypto_cfg_mutex);
> -
>  extern struct sock *crypto_nlsk;
>  
>  struct crypto_dump_info {
> -- 
> 2.20.1
> 

Hi Sebastian, this is already removed by a patch queued in cryptodev:
https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=554557ce0001fc0371fb88db53d7dfe2a398c6de

- Eric
