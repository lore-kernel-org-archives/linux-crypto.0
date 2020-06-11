Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0DDC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 08:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A45D207C3
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 08:34:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="WtLg4Gcy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgFKIeH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 04:34:07 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:9800 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgFKIeG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 04:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1591864445;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=weuO0XFY/dx0FwiZnPD9oxzQ7IOVWYOP67G4Q17Dtpg=;
        b=WtLg4GcyOYKd87Kixtck60zs+Q1yOifiNC2EL8WamFmawagYTmiEjYLTGmq8czb0Yd
        OXIcdxcbsl3M+gr/wnHwu/MFM434JxmM9ZhG5Oye2NxNVXtxjHF6zWKWaWmPmKCTSUKO
        fMVkBdu1ORagsWg3aXoeXDj6o1GZj1DEjzVxDbDrENN5cp3CnMA3UXSUfxdrJU4IIXe7
        d3o382Yw1/Y25ruF7cGgJjrzzTAHX8Yp7pBxk9GwXGvN/egD2l0fa2ZN9cRH7U3w0zj4
        kqbgHv5vLaE/QnX7PvKRy7lebedVPVLn07urCaKEvu7iIfevyJa/8YoC+dBt2p3RL5Nf
        fWSw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIfSfDhz3"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.1 DYNA|AUTH)
        with ESMTPSA id 6010b6w5B8Xx05J
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 11 Jun 2020 10:33:59 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: drbg - Fix memleak in drbg_prepare_hrng
Date:   Thu, 11 Jun 2020 10:33:58 +0200
Message-ID: <37905178.8f6zGtLfKx@tauon.chronox.de>
In-Reply-To: <20200611083356.88600-1-zhengbin13@huawei.com>
References: <20200611083356.88600-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 11. Juni 2020, 10:33:56 CEST schrieb Zheng Bin:

Hi Zheng,

Thank you for the note, but I think this is handled, albeit differently. 
Search for patch "[PATCH v3] crypto: DRBG - always try to free Jitter RNG 
instance" that is sent to the list (but not yet applied).

Thanks



> drbg_prepare_hrng
>   drbg->jent = crypto_alloc_rng
>   err = add_random_ready_callback
>   default:
>     drbg->random_ready.func = NULL  -->set NULL, if fail
> 
> drbg_uninstantiate
>   if (drbg->random_ready.func)      -->If NULL, will not free drbg->jent
>     crypto_free_rng(drbg->jent)
> 
> Need to free drbg->jent if add_random_ready_callback return fail.
> 
> Fixes: 97f2650e5040 ("crypto: drbg - always seeded with SP800-90B compliant
> noise source") Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>  crypto/drbg.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 37526eb8c5d5..a643ab7eac7a 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1524,6 +1524,8 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
>  		/* fall through */
> 
>  	default:
> +		crypto_free_rng(drbg->jent);
> +		drbg->jent = NULL;
>  		drbg->random_ready.func = NULL;
>  		return err;
>  	}
> --
> 2.26.0.106.g9fadedd


Ciao
Stephan


