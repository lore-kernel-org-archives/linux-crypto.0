From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: document the quality field
Date: Fri, 5 Oct 2018 10:27:16 +0800
Message-ID: <20181005022716.ljqj3kkgu3osntia@gondor.apana.org.au>
References: <20180925162924.378725-1-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        matthias.bgg@gmail.com, Liam.Merwick@oracle.com,
        Jim.Quigley@oracle.com, linux-crypto@vger.kernel.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>, dgilbert@redhat.com
To: "Michael S. Tsirkin" <mst@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180925162924.378725-1-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 25, 2018 at 12:35:18PM -0400, Michael S. Tsirkin wrote:
> quality field is currently documented as being 'per mill'.  In fact the
> math involved is:
> 
>                 add_hwgenerator_randomness((void *)rng_fillbuf, rc,
>                                            rc * current_quality * 8 >> 10);
> 
> thus the actual definition is "bits of entropy per 1024 bits of input".
> 
> The current documentation seems to have confused multiple people
> in the past, let's fix the documentation to match code.
> 
> An alternative is to change core to match driver expectations, replacing
> 	rc * current_quality * 8 >> 10
> with
> 	rc * current_quality / 1000
> but that has performance costs, so probably isn't a good option.
> 
> Fixes: 0f734e6e768 ("hwrng: add per-device entropy derating")
> Reported-by: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> 
>  drivers/char/hw_random/core.c | 4 ++--
>  include/linux/hw_random.h     | 3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
