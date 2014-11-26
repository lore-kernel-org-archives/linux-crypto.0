From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: include crypto- module prefix in template
Date: Wed, 26 Nov 2014 20:10:24 +0800
Message-ID: <20141126121024.GB16424@gondor.apana.org.au>
References: <20141125003238.GA17207@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141125003238.GA17207@www.outflux.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 24, 2014 at 04:32:38PM -0800, Kees Cook wrote:
> This adds the module loading prefix "crypto-" to the template lookup
> as well.
> 
> For example, attempting to load 'vfat(blowfish)' via AF_ALG now correctly
> includes the "crypto-" prefix at every level, correctly rejecting "vfat":
> 
> 	net-pf-38
> 	algif-hash
> 	crypto-vfat(blowfish)
> 	crypto-vfat(blowfish)-all
> 	crypto-vfat
> 
> Reported-by: Mathias Krause <minipli@googlemail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Mathias Krause <minipli@googlemail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
