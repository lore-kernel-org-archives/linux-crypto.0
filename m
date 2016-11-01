From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] char: hw_random: atmel-rng: disable TRNG during
 suspend
Date: Tue, 1 Nov 2016 08:44:59 +0800
Message-ID: <20161101004458.GE7375@gondor.apana.org.au>
References: <1477641646-30796-1-git-send-email-wenyou.yang@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        Wenyou Yang <wenyou.yang@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39404 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S948308AbcKAApF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Oct 2016 20:45:05 -0400
Content-Disposition: inline
In-Reply-To: <1477641646-30796-1-git-send-email-wenyou.yang@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 28, 2016 at 04:00:46PM +0800, Wenyou Yang wrote:
> To fix the over consumption on the VDDCore due to the TRNG enabled,
> disable the TRNG during suspend, not only disable the user interface
> clock (which is controlled by PMC). Because the user interface clock
> is independent from any clock that may be used in the entropy source
> logic circuitry.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
