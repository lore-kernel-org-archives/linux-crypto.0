From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccm - preserve the IV buffer
Date: Fri, 3 Nov 2017 21:43:07 +0800
Message-ID: <20171103134307.GB8811@gondor.apana.org.au>
References: <20171031144235.22818-1-romain.izard.pro@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Romain Izard <romain.izard.pro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37986 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756312AbdKCNne (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 09:43:34 -0400
Content-Disposition: inline
In-Reply-To: <20171031144235.22818-1-romain.izard.pro@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 31, 2017 at 03:42:35PM +0100, Romain Izard wrote:
> The IV buffer used during CCM operations is used twice, during both the
> hashing step and the ciphering step.
> 
> When using a hardware accelerator that updates the contents of the IV
> buffer at the end of ciphering operations, the value will be modified.
> In the decryption case, the subsequent setup of the hashing algorithm
> will interpret the updated IV instead of the original value, which can
> lead to out-of-bounds writes.
> 
> Reuse the idata buffer, only used in the hashing step, to preserve the
> IV's value during the ciphering step in the decryption case.
> 
> Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
