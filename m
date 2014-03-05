From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: omap-sham: kmap SG pages before appending
Date: Wed, 5 Mar 2014 15:11:09 +0800
Message-ID: <20140305071109.GA22178@gondor.apana.org.au>
References: <1393957854-10961-1-git-send-email-joelf@ti.com>
 <20140305015953.GA20702@gondor.apana.org.au>
 <39412163-4B61-4490-ABC8-5BA633CC6618@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Vutla, Lokesh" <lokeshvutla@ti.com>
To: "Fernandes, Joel" <joelf@ti.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <39412163-4B61-4490-ABC8-5BA633CC6618@ti.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 05, 2014 at 04:18:12AM +0000, Fernandes, Joel wrote:
> 
> 
> > On Mar 4, 2014, at 8:00 PM, "Herbert Xu" <herbert@gondor.apana.org.au> wrote:
> > 
> >> On Tue, Mar 04, 2014 at 12:30:54PM -0600, Joel Fernandes wrote:
> >> HIGHMEM pages may not be mapped so we must kmap them before accessing.
> >> This resolves a random OOPs error that was showing up during OpenSSL SHA tests.
> >> 
> >> Signed-off-by: Joel Fernandes <joelf@ti.com>
> >> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> >> ---
> >> v2 changes:
> >>    - don't check for HIGHMEM, kmap/kunmap do them anyway (Thanks Herbert).
> >> 
> >> drivers/crypto/omap-sham.c |    8 +++++++-
> >> 1 file changed, 7 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> >> index e45aaaf..207eac1 100644
> >> --- a/drivers/crypto/omap-sham.c
> >> +++ b/drivers/crypto/omap-sham.c
> >> @@ -636,11 +636,17 @@ static size_t omap_sham_append_buffer(struct omap_sham_reqctx *ctx,
> >> static size_t omap_sham_append_sg(struct omap_sham_reqctx *ctx)
> >> {
> >>    size_t count;
> >> +    const u8 *vaddr;
> >> 
> >>    while (ctx->sg) {
> >> +        vaddr = kmap(sg_page(ctx->sg));
> > 
> > Are you sure you can safely use kmap here as opposed to kmap_atomic?
> 
> Yes I made sure it is not called in interrupt context and also tested the patch.

What about omap_sham_update => omap_sham_append_sg? As the former
can be called in softirq context what is preventing it from calling
kmap?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
