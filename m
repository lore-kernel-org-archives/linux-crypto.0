From: Eric =?ISO-8859-1?B?QuluYXJk?= <eric@eukrea.com>
Subject: Re: [PATCH 2/5] ARM: AT91SAM9G45: same platform data structure for
 all crypto peripherals
Date: Wed, 7 Nov 2012 16:50:26 +0100
Message-ID: <20121107165026.4e64422f@eb-e6520>
References: <1352219544-30416-1-git-send-email-nicolas@eukrea.com>
 <20121107152615.GD4576@game.jcrosoft.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: herbert@gondor.apana.org.au, nicolas.ferre@atmel.com,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
 Nicolas Royer <nicolas@eukrea.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20121107152615.GD4576@game.jcrosoft.org>
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

Hi Jean-Christophe,

Le Wed, 7 Nov 2012 16:26:15 +0100,
Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> a =E9crit :
> > @@ -1931,9 +1931,9 @@ static struct platform_device at91sam9g45_aes_dev=
ice =3D {
> >  static void __init at91_add_device_aes(void)
> >  {
> >  	struct at_dma_slave	*atslave;
> > -	struct aes_dma_data	*alt_atslave;
> > +	struct crypto_dma_data	*alt_atslave;
> >  =

> > -	alt_atslave =3D kzalloc(sizeof(struct aes_dma_data), GFP_KERNEL);
> > +	alt_atslave =3D kzalloc(sizeof(struct crypto_dma_data), GFP_KERNEL);
> we do not check the result of kzalloc ouch
> =

> and why we allocate it?
> =

for both remarks : that's the way it's done in at91_add_device_mci since
75305d768d296a07fd02df9af3e5de326df1c72e
A v2 will follow (and also a fix for at91_add_device_mci).

Eric
