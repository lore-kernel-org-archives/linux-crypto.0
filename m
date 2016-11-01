From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cryptd - Remove unused but set variable 'tfm'
Date: Tue, 1 Nov 2016 08:46:28 +0800
Message-ID: <20161101004628.GH7375@gondor.apana.org.au>
References: <20161031144243.18152-1-tklauser@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Tobias Klauser <tklauser@distanz.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58811 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S948193AbcKAAqe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Oct 2016 20:46:34 -0400
Content-Disposition: inline
In-Reply-To: <20161031144243.18152-1-tklauser@distanz.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 31, 2016 at 03:42:43PM +0100, Tobias Klauser wrote:
> Remove the unused but set variable tfm in cryptd_enqueue_request to fix
> the following warning when building with 'W=1':
> 
> crypto/cryptd.c:125:21: warning: variable 'tfm' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
