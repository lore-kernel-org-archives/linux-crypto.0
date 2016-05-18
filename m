From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [patch] crypto: omap-sham - potential Oops on error in probe
Date: Wed, 18 May 2016 14:50:12 +0300
Message-ID: <92f2009b-95c6-6659-02e9-6ce21f140aef@ti.com>
References: <20160518103905.GA10470@mwanda>
 <21712178-666f-e2e2-24f3-fb0c513acc83@ti.com> <20160518114443.GG11011@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160518114443.GG11011@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/18/16 14:44, Dan Carpenter wrote:
> On Wed, May 18, 2016 at 01:42:36PM +0300, Peter Ujfalusi wrote:
>> On 05/18/16 13:39, Dan Carpenter wrote:
>>> This if statement is reversed so we end up either leaking or Oopsin=
g on
>>> error.
>>
>> Oops, sorry for that.
>> Probably the other omap-* crypto drivers have the same issue? Can yo=
u send a
>> patch for them or should I do it?
>=20
> I didn't see those static checker warnings so probably it means I can=
't
> compile the drivers.  Could you do it?

I have taken a look at omap-aes and omap-des. They are OK.

--=20
P=E9ter
--
To unsubscribe from this list: send the line "unsubscribe kernel-janito=
rs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
