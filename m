From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v0] Crypto: Talitos: re-initialize async_tx descriptors
Date: Tue, 15 Dec 2009 11:23:40 -0700
Message-ID: <4B27D42C.8070309@intel.com>
References: <1260797602-7476-1-git-send-email-Vishnu@freescale.com> <e9c3a7c20912142329j6603402ah2963d075419efa1c@mail.gmail.com> <76952DF81420A349876E087D089DF034562C75@zin33exm21.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	Tabi Timur-B04825 <B04825@freescale.com>,
	Li Yang-R58472 <r58472@freescale.com>,
	Ira Snyder <iws@ovro.caltech.edu>
To: Suresh Vishnu-B05022 <B05022@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25022 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760781AbZLOSXn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Dec 2009 13:23:43 -0500
In-Reply-To: <76952DF81420A349876E087D089DF034562C75@zin33exm21.fsl.freescale.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Suresh Vishnu-B05022 wrote:
>  > On Mon, Dec 14, 2009 at 6:33 AM, Vishnu Suresh <Vishnu@freescale.com> 
> wrote:
>  > > The async_tx descriptors contains dangling pointers.
>  > > Hence, re-initialize them to NULL before use.
>  > >
>  > > Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
>  > > ---
>  > > o. Rebased to linux-next as of 20091214
>  > >
>  > >  drivers/crypto/talitos.c |    3 +++
>  > >  1 files changed, 3 insertions(+), 0 deletions(-)
>  > >
>  > > diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
>  > > index 87f06be..9e261c6 100644
>  > > --- a/drivers/crypto/talitos.c
>  > > +++ b/drivers/crypto/talitos.c
>  > > @@ -952,6 +952,9 @@ static struct dma_async_tx_descriptor * 
> talitos_prep_dma_xor(
>  > >                return NULL;
>  > >        }
>  > >        dma_async_tx_descriptor_init(&new->async_tx, &xor_chan->common);
>  > > +       new->async_tx.parent = NULL;
>  > > +       new->async_tx.next = NULL;
>  > > +
>  > >
>  > >        desc = &new->hwdesc;
>  > >        /* Set destination: Last pointer pair */
> 
>  > These two values are owned by the async_tx api, drivers are not
>  > supposed to touch them.
> I have sent this patch and the similar one for fsldma seperately,
> so that if the changes are needed and can be done in 
> dma_async_tx_descriptor_init(),
> these patches can be ignored. 
>  > Both iop_adma and the new ppx4xx driver
>  > (which use the async_tx channel switching capability) get away without
>  > touching these fields which makes me suspect there is a
>  > misunderstanding/bug somewhere else in the talitos implementation.
> 
> This bug does not occur on all the platforms. The occurrance is random.
> This occurs when a channel switch between two different devices are 
> present.
> This same initialization is required in case of fsldma as well. 
> In case of fsldma/talitosXOR, there are two DMA channels (on same 
> device) and single XOR channel (on another device).
> 
> When used without fsldma, this driver works fine.
> Does iop_adma and ppx4xx work in similar enviroment?

Yes, iop_adma when running on iop3xx hardware has one xor channel and 
two memcpy channels.

The bug may very well be in the fsldma driver, but the workarounds are 
just band aids.  I would be more comfortable with dropping the three 
workaround patches and simply adding "depends on !FSL_DMA" to the 
CRYPTO_DEV_TALITOS option until the true fix can be developed.

--
Dan

