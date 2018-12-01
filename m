Return-Path: <SRS0=BBPV=OK=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:34366 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbeLAT6V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Dec 2018 14:58:21 -0500
Date: Sat, 1 Dec 2018 16:46:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/11] crypto: crypto_user_stat: misc enhancement
Message-ID: <20181201084605.ktwj5nl7vu56c3ub@gondor.apana.org.au>
References: <1543502546-23870-1-git-send-email-clabbe@baylibre.com>
 <20181129181625.GA168705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181129181625.GA168705@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 29, 2018 at 10:16:26AM -0800, Eric Biggers wrote:
>
> Herbert, can you send this series to Linus for v4.20 after reviewing it?
> We don't want to be stuck with a bad UAPI, and the use-after-free needs to be
> fixed anyway too.

Sure I'll push it through crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
