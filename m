From: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH v3 1/2] i.MX27: Add clock support for SAHARA2.
Date: Mon, 11 Mar 2013 09:04:22 +0100
Message-ID: <CACKLOr3mLUYSUDuXFrfRg+ujRqBKE-wbudetygH3aQd0K31pxA@mail.gmail.com>
References: <1362137873-8827-1-git-send-email-javier.martin@vista-silicon.com>
	<1362137873-8827-2-git-send-email-javier.martin@vista-silicon.com>
	<20130304075306.GA1906@pengutronix.de>
	<CACKLOr2kuWXMreEFA4wqyYVRNnPwmEoHPM2+V+tN5P_1bQ+iJQ@mail.gmail.com>
	<20130310083401.GB10448@gondor.apana.org.au>
	<20130310230856.GU1906@pengutronix.de>
	<20130311011926.GA14930@gondor.apana.org.au>
	<20130311074206.GY1906@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	davem@davemloft.net, kernel@pengutronix.de, gcembed@gmail.com,
	shawn.guo@linaro.org, arnd@arndb.de, swarren@nvidia.com
To: Sascha Hauer <s.hauer@pengutronix.de>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20130311074206.GY1906@pengutronix.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On 11 March 2013 08:42, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Mon, Mar 11, 2013 at 09:19:26AM +0800, Herbert Xu wrote:
>> On Mon, Mar 11, 2013 at 12:08:56AM +0100, Sascha Hauer wrote:
>> > On Sun, Mar 10, 2013 at 04:34:01PM +0800, Herbert Xu wrote:
>> > > > >
>> > > > > https://patchwork.kernel.org/patch/1817741/
>> > > > >
>> > > > > So the change above becomes unnecessary
>> > > >
>> > > > Very good. Then this patch can be safely dropped.
>> > >
>> > > So should I take this patch or not?
>> >
>> > This clk patch, no. The sahara patch, yes, if it is fine for you.
>>
>> But will the second patch work fine without the first?
>
> It will work once a device is registered. The necessary clocks for it
> will be provided by the devicetree then.

As Sascha stated you can safely drop this first patch:
[PATCH v3 1/2] i.MX27: Add clock support for SAHARA2.

And merge the second one:
[PATCH v3 2/2] crypto: sahara: Add driver for SAHARA2 accelerator.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
