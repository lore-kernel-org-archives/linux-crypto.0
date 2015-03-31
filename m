From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 00/20] crypto: restrict usage of helper ciphers
Date: Tue, 31 Mar 2015 21:34:21 +0800
Message-ID: <20150331133421.GA17318@gondor.apana.org.au>
References: <3417827.fluZli1WvQ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3417827.fluZli1WvQ@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 30, 2015 at 09:54:32PM +0200, Stephan Mueller wrote:
> Hi,
> 
> Based on the discussion in the thread [1], a flag is added to the
> kernel crypto API to allow ciphers to be marked as internal.

All applied.  Thanks for fixing this!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
