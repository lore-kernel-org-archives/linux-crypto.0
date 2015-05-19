From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing
 nonblocking_pool
Date: Tue, 19 May 2015 22:30:22 +0800
Message-ID: <20150519143022.GC32663@gondor.apana.org.au>
References: <1921857.OvxEu6y28S@tachyon.chronox.de>
 <20150519135028.GC20421@thunk.org>
 <20150519141805.GA32663@gondor.apana.org.au>
 <1637466.ZUdUCXWXVs@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1637466.ZUdUCXWXVs@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 19, 2015 at 04:27:54PM +0200, Stephan Mueller wrote:
>
> The current modification with patch 1 to random.c is the smallest change to 
> date. Is that then appropriate?
> 
> Herbert, based on your comment now, would the currently discussed patch with 
> waiting in the work queue in patch 3 appropriate? Or what would you like to 
> see changed?

Sorry but I have lost track as to which patch is which.  Please post
the changes to random.c and we can all take a look.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
