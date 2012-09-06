From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] arm/crypto: Add optimized AES and SHA1 routines
Date: Thu, 6 Sep 2012 13:20:25 -0700
Message-ID: <20120906202024.GB24269@gondor.apana.org.au>
References: <20120807020103.GA21410@mcafee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: David McCullough <david_mccullough@mcafee.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120807020103.GA21410@mcafee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 07, 2012 at 02:01:03AM +0000, David McCullough wrote:
> 
> Add assembler versions of AES and SHA1 for ARM platforms.  This has provided
> up to a 50% improvement in IPsec/TCP throughout for tunnels using AES128/SHA1.
> 
> Platform   CPU SPeed    Endian   Before (bps)   After (bps)   Improvement 
> 
> IXP425      533 MHz      big     11217042        15566294        ~38%
> KS8695      166 MHz     little    3828549         5795373        ~51%
> 
> Signed-off-by: David McCullough <ucdevel@gmail.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
