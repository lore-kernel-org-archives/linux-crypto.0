From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 2/8 v4] crypto:s5p-sss: Add device tree support
Date: Thu, 23 Jan 2014 18:47:25 +0100
Message-ID: <52E155AD.9070802@samsung.com>
References: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
 <1389777291-15026-1-git-send-email-ch.naveen@samsung.com>
 <52E0EEB8.4080602@samsung.com>
 <20140123174121.GI15586@e106331-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"vzapolskiy@gmail.com" <vzapolskiy@gmail.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
	"cpgs@samsung.com" <cpgs@samsung.com>,
	"tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	devicetree <devicetree@vger.kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <20140123174121.GI15586@e106331-lin.cambridge.arm.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 23/01/14 18:41, Mark Rutland wrote:
>>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>>> > > index 93cddeb..2da5617 100644
>>> > > --- a/drivers/crypto/s5p-sss.c
>>> > > +++ b/drivers/crypto/s5p-sss.c
>>> > > @@ -22,6 +22,7 @@
>>> > >  #include <linux/scatterlist.h>
>>> > >  #include <linux/dma-mapping.h>
>>> > >  #include <linux/io.h>
>>> > > +#include <linux/of.h>
>>> > >  #include <linux/crypto.h>
>>> > >  #include <linux/interrupt.h>
>>> > >  
>>> > > @@ -177,6 +178,12 @@ struct s5p_aes_dev {
>>> > >  
>>> > >  static struct s5p_aes_dev *s5p_dev;
>>> > >  
>>> > > +static const struct of_device_id s5p_sss_dt_match[] = {
>>> > > +	{ .compatible = "samsung,s5pv210-secss", },
>> > 
>> > nit: the first semicolon could be omitted.
>
> I assume you mean comma ratehr than semicolon?

Indeed...and it's actually the second one :-/

--
Regards,
Sylwester
