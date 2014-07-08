From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] DRBG: Rebasing unapplied patches
Date: Tue, 8 Jul 2014 21:21:47 +0800
Message-ID: <20140708132147.GD24110@gondor.apana.org.au>
References: <2266932.bfVPMOTOeI@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: joe@perches.com, dan.carpenter@oracle.com,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	fengguang.wu@intel.com, Randy Dunlap <rdunlap@infradead.org>,
	linux-crypto@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Rafael Aquini <aquini@redhat.com>,
	aris@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2266932.bfVPMOTOeI@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jul 06, 2014 at 02:22:29AM +0200, Stephan Mueller wrote:
> Hi,
> 
> This patchset superseeds the patch sets submitted with [1] and [2]. It
> rebases all non-applied patches to the current Herbert Xu's
> cryptodev-2.6 tree.
> 
> [1] https://lkml.org/lkml/2014/6/28/497
> [2] https://lkml.org/lkml/2014/7/1/332
> 
> Stephan Mueller (6):
>   DRBG: cleanup of preprocessor macros
>   DRBG: Fix format string for debugging statements
>   DRBG: Call CTR DRBG DF function only once
>   DRBG: Select correct DRBG core for stdrng
>   DRBG: Mix a time stamp into DRBG state
>   DRBG: HMAC-SHA1 DRBG has crypto strength of 128 bits

All applied.  Thanks Stephan!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
