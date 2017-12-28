From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: stm32 - Use standard CONFIG name
Date: Thu, 28 Dec 2017 18:08:17 +1100
Message-ID: <20171228070817.GE9639@gondor.apana.org.au>
References: <1513793972-11173-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, lionel.debieve@st.com,
        fabien.dessenne@st.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:49012 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750981AbdL1HIl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Dec 2017 02:08:41 -0500
Content-Disposition: inline
In-Reply-To: <1513793972-11173-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 06:19:32PM +0000, Corentin Labbe wrote:
> All hardware crypto devices have their CONFIG names using the following
> convention:
> CRYPTO_DEV_name_algo
> 
> This patch apply this conventions on STM32 CONFIG names.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
