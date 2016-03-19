From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cleaning and refactoring in rsa.c
Date: Sat, 19 Mar 2016 16:03:28 +0800
Message-ID: <20160319080328.GA26605@gondor.apana.org.au>
References: <1458333591-28297-1-git-send-email-violador.de.segmentos@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	maitesin <violador.de.segmentos@gmail.com>
To: maitesin <oscar.forner.martinez@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458333591-28297-1-git-send-email-violador.de.segmentos@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 18, 2016 at 08:39:51PM +0000, maitesin wrote:
> * Removed several unused initializations of variables.
> * Inlined couple of functions.
> * rsa_check_key_length: changed to use only the switch statement.
> * rsa_setkey: refactored the implementation to be closer to the other
> functions in the file.
> 
> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>

Nack.  I don't think this patch improves the code at all.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
