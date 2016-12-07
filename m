From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/mcryptd: Check mcryptd algorithm compatibility
Date: Wed, 7 Dec 2016 20:09:41 +0800
Message-ID: <20161207120941.GF20680@gondor.apana.org.au>
References: <6825659d1f6a96d4ab2327aa0dcf357f6252e915.1480967128.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, megha.dey@linux.intel.com,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Milan Broz <mbroz@redhat.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6825659d1f6a96d4ab2327aa0dcf357f6252e915.1480967128.git.tim.c.chen@linux.intel.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 05, 2016 at 11:46:31AM -0800, Tim Chen wrote:
> Algorithms not compatible with mcryptd could be spawned by mcryptd
> with a direct crypto_alloc_tfm invocation using a "mcryptd(alg)" name
> construct.  This causes mcryptd to crash the kernel if an arbitrary
> "alg" is incompatible and not intended to be used with mcryptd.  It is
> an issue if AF_ALG tries to spawn mcryptd(alg) to expose it externally.
> But such algorithms must be used internally and not be exposed.
> 
> We added a check to enforce that only internal algorithms are allowed
> with mcryptd at the time mcryptd is spawning an algorithm.
> 
> Link: http://marc.info/?l=linux-crypto-vger&m=148063683310477&w=2
> Cc: stable@vger.kernel.org
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
