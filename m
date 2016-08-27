From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v3 6/8] hwrng: amd: Replace global variable with private
 struct
Date: Sat, 27 Aug 2016 15:36:15 +0000
Message-ID: <20160827153615.GN10637@io.lakedaemon.net>
References: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
 <1472209896-17197-7-git-send-email-clabbe.montjoie@gmail.com>
 <20160827144331.GK10637@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160827144331.GK10637@io.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Aug 27, 2016 at 02:43:31PM +0000, Jason Cooper wrote:
> Hi Corentin,
> 
> On Fri, Aug 26, 2016 at 01:11:34PM +0200, LABBE Corentin wrote:
> > Instead of having two global variable, it's better to use a
> > private struct. This will permit to remove amd_pdev variable
> > 
> > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> > ---
> >  drivers/char/hw_random/amd-rng.c | 57 ++++++++++++++++++++++++++--------------
> >  1 file changed, 38 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
> > index 383e197..4ef94e9 100644
> > --- a/drivers/char/hw_random/amd-rng.c
> > +++ b/drivers/char/hw_random/amd-rng.c
> > @@ -47,15 +47,18 @@ static const struct pci_device_id pci_tbl[] = {
> >  };
> >  MODULE_DEVICE_TABLE(pci, pci_tbl);
> >  
> > -static struct pci_dev *amd_pdev;
> > +struct amd768_priv {
> > +	struct pci_dev *pcidev;
> > +	u32 pmbase;
> > +};
> >  
> >  static int amd_rng_data_present(struct hwrng *rng, int wait)
> >  {
> > -	u32 pmbase = (u32)rng->priv;
> > +	struct amd768_priv *priv = (struct amd768_priv *)rng->priv;
> 
> Please remove unnecessary casts...

Hmm, I was assuming that, like other places in the tree, that priv was
declared void*.  However, it's unsigned long in hw_random.h.

And, it looks like all users cast it.  Either to a struct, or to a void
__iomem *.

So ignore what I said in my previous email.  You can add my reviewed-by
without change.

It does look like /priv/ s/unsigned long/void */ would be a great
cleanup.

thx,

Jason.
