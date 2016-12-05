From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto/mcryptd: Check mcryptd algorithm compatability
Date: Mon, 05 Dec 2016 11:03:20 -0800
Message-ID: <1480964600.3064.67.camel@linux.intel.com>
References: <deb5f529a0ff9b454fcc62b849ac3aff96c3e684.1480724043.git.tim.c.chen@linux.intel.com>
         <20161205123403.GB10635@gondor.apana.org.au>
         <1480956650.3064.65.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, megha.dey@linux.intel.com,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Milan Broz <mbroz@redhat.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1480956650.3064.65.camel@linux.intel.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2016-12-05 at 08:50 -0800, Tim Chen wrote:
> On Mon, 2016-12-05 at 20:34 +0800, Herbert Xu wrote:
> > 
> > On Fri, Dec 02, 2016 at 04:15:21PM -0800, Tim Chen wrote:
> > > 
> > > 
> > > Algorithms not compatible with mcryptd could be spawned by mcryptd
> > > with a direct crypto_alloc_tfm invocation using a "mcryptd(alg)"
> > > name construct.  This causes mcryptd to crash the kernel if
> > > "alg" is incompatible and not intended to be used with mcryptd.
> > > 
> > > A flag CRYPTO_ALG_MCRYPT is being added to mcryptd compatible
> > > algorithms' cra_flags. The compatability is checked when mcryptd spawn
> > > off an algorithm.
> > > 
> > > Link: http://marc.info/?l=linux-crypto-vger&m=148063683310477&w=2
> > > Cc: stable@vger.kernel.org
> > > Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> > > Tested-by: Megha Dey <megha.dey@linux.intel.com>
> > > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > Tim, I think we should instead make mcryptd refuse to generate
> > a non-internal algorithm.  This way the user would not be able
> > to access it at all since they can only request for non-internal
> > algorithms.
> > 
> > Basically you want to check at the start of mcryptd_create_hash
> > that the INTERNAL bit is set on both the type and mask as returned
> > by crypto_get_attr_type.
> I have thought about that.  However, not all internal algorithms
> are compatible with mcryptd. We can still have trouble if some
> random internal algorithm is paired with mcryptd.

You're right.  The mcryptd(alg) should be an internal algorithm itself.
So checking on the INTERNAL flag should be sufficient.

I'll generate another patch that uses the INTERNAL flag for checking.

Tim
