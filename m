Return-Path: <SRS0=/ZR5=OQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48944 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbeLGFul (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Dec 2018 00:50:41 -0500
Date: Fri, 7 Dec 2018 13:50:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/11] crypto: crypto_user_stat: misc enhancement
Message-ID: <20181207055033.h5cf73if35rluxof@gondor.apana.org.au>
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

On second thought, I'm just going to revert the whole interface
for now and reintroduce it in cryptodev so we can fix it properly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
