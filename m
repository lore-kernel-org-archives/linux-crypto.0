From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH][crypto-next] crypto: inside-secure - make function
 safexcel_try_push_requests static
Date: Wed, 3 Jan 2018 09:38:11 +0100
Message-ID: <20180103083811.GA21727@kwain>
References: <20180102143410.13261-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:57350 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751046AbeACIiX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jan 2018 03:38:23 -0500
Content-Disposition: inline
In-Reply-To: <20180102143410.13261-1-colin.king@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Colin,

On Tue, Jan 02, 2018 at 02:34:10PM +0000, Colin King wrote:
>  
>  /* Called with ring's lock taken */
> -int safexcel_try_push_requests(struct safexcel_crypto_priv *priv, int ring,
> -			       int reqs)
> +static int safexcel_try_push_requests(struct safexcel_crypto_priv *priv,
> +				     int ring, int reqs)

Alignment should match open parenthesis, one space is missing. Otherwise,
looks good to me.

Thanks!
Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
