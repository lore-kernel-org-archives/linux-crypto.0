Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37664 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbeKPQbE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 11:31:04 -0500
Date: Fri, 16 Nov 2018 14:19:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2] crypto: ecc - regularize scalar for scalar
 multiplication
Message-ID: <20181116061958.yary7zcu5m3pnolb@gondor.apana.org.au>
References: <20181111174002.30929-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181111174002.30929-1-vt@altlinux.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 11, 2018 at 08:40:02PM +0300, Vitaly Chikunov wrote:
> ecc_point_mult is supposed to be used with a regularized scalar,
> otherwise, it's possible to deduce the position of the top bit of the
> scalar with timing attack. This is important when the scalar is a
> private key.
> 
> ecc_point_mult is already using a regular algorithm (i.e. having an
> operation flow independent of the input scalar) but regularization step
> is not implemented.
> 
> Arrange scalar to always have fixed top bit by adding a multiple of the
> curve order (n).
> 
> References:
> The constant time regularization step is based on micro-ecc by Kenneth
> MacKay and also referenced in the literature (Bernstein, D. J., & Lange,
> T. (2017). Montgomery curves and the Montgomery ladder. (Cryptology
> ePrint Archive; Vol. 2017/293). s.l.: IACR. Chapter 4.6.2.)
> 
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> Cc: kernel-hardening@lists.openwall.com
> ---
> 
> Changes from v1:
> - No code changes, only description updates to be more informative.
> 
>  crypto/ecc.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
