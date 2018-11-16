Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37582 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727353AbeKPQ1V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 11:27:21 -0500
Date: Fri, 16 Nov 2018 14:16:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Yael Chemla <Yael.Chemla@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: cts: document NIST standard status
Message-ID: <20181116061612.vegrut7op4vpowoe@gondor.apana.org.au>
References: <1541419502-7286-1-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541419502-7286-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 05, 2018 at 12:05:01PM +0000, Gilad Ben-Yossef wrote:
> cts(cbc(aes)) as used in the kernel has been added to NIST
> standard as CBC-CS3. Document it as such.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Suggested-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/Kconfig | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
