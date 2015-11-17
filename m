From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/8] crypto: akcipher: the key parameter must be const u8
 *
Date: Tue, 17 Nov 2015 17:52:02 +0800
Message-ID: <20151117095202.GB7837@gondor.apana.org.au>
References: <1445326444-11019-1-git-send-email-clabbe.montjoie@gmail.com>
 <1445326444-11019-7-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445326444-11019-7-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 20, 2015 at 09:34:02AM +0200, LABBE Corentin wrote:
> All cryptoAPI setkey function set the key parameter as const u8 *.
> This patch make the crypto_akcipher_setkey parameters like others.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

This patch no longer applies.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
