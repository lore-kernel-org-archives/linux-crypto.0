From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 2/5 v2] ARM: AT91SAM9G45: same platform data structure
 for all crypto peripherals
Date: Wed, 7 Nov 2012 18:12:17 +0100
Message-ID: <20121107171217.GH4576@game.jcrosoft.org>
References: <20121107152615.GD4576@game.jcrosoft.org>
 <1352305675-21961-1-git-send-email-nicolas@eukrea.com>
 <20121107164523.GG4576@game.jcrosoft.org>
 <20121107175946.01f9dc78@eb-e6520>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: herbert@gondor.apana.org.au, nicolas.ferre@atmel.com,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
 Nicolas Royer <nicolas@eukrea.com>
To: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20121107175946.01f9dc78@eb-e6520>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.infradead.org
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 17:59 Wed 07 Nov     , Eric B=E9nard wrote:
> Hi Jean-Christophe,
> =

> Le Wed, 7 Nov 2012 17:45:23 +0100,
> Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> a =E9crit :
> > > @@ -1900,7 +1900,7 @@ static void __init at91_add_device_tdes(void) {}
> > >   * -----------------------------------------------------------------=
--- */
> > >  =

> > >  #if defined(CONFIG_CRYPTO_DEV_ATMEL_AES) || defined(CONFIG_CRYPTO_DE=
V_ATMEL_AES_MODULE)
> > > -static struct aes_platform_data aes_data;
> > > +static struct crypto_platform_data aes_data;
> > >  static u64 aes_dmamask =3D DMA_BIT_MASK(32);
> > >  =

> > >  static struct resource aes_resources[] =3D {
> > > @@ -1931,9 +1931,11 @@ static struct platform_device at91sam9g45_aes_=
device =3D {
> > >  static void __init at91_add_device_aes(void)
> > >  {
> > >  	struct at_dma_slave	*atslave;
> > > -	struct aes_dma_data	*alt_atslave;
> > > +	struct crypto_dma_data	*alt_atslave;
> > >  =

> > > -	alt_atslave =3D kzalloc(sizeof(struct aes_dma_data), GFP_KERNEL);
> > > +	alt_atslave =3D kzalloc(sizeof(struct crypto_dma_data), GFP_KERNEL);
> > I still not understand why we need to allocate it
> > =

> > just declare it as static
> > =

> last time we had some data static and you asked to alloc them (and
> didn't bother to answer why you required that :
> http://lkml.indiana.edu/hypermail/linux/kernel/1207.0/02779.html ), now
> you ask to declare static something which is allocated (and
> that's already done this way for the mci) : may you please explain why
> so that we get it the right way for next time ?

in the driver yes we write multi instance and generic code but in the platf=
rom I do not see why

Best Regards,
J.
