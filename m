From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Tue, 21 Oct 2014 18:39:40 +0200
Message-ID: <54468C4C.3030204@gmail.com>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>	 <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>	 <54459AA5.2030705@mleia.com> <1413849173.5407.6.camel@perches.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
 ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
 maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
 herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
 grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
 gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org,
 devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Vladimir Zapolskiy <vz-ChpfBGZJDbMAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-sunxi+bncBD7YLCN32UNBBUMYTKRAKGQEEEYIQNY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1413849173.5407.6.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Le 21/10/2014 01:52, Joe Perches a =E9crit :
> On Tue, 2014-10-21 at 02:28 +0300, Vladimir Zapolskiy wrote:
>> On 19.10.2014 17:16, LABBE Corentin wrote:
>>> Add support for the Security System included in Allwinner SoC A20.
>>> The Security System is a hardware cryptographic accelerator that suppor=
t AES/MD5/SHA1/DES/3DES/PRNG algorithms.
> []
>>> diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-core.c b/drivers/crypto/s=
unxi-ss/sunxi-ss-core.c
> []
>>> +	cr =3D clk_get_rate(ss->busclk);
>>> +	if (cr >=3D cr_ahb)
>>> +		dev_dbg(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >=3D %lu)\n",
>>> +				cr, cr / 1000000, cr_ahb);
>>> +	else
>>> +		dev_warn(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >=3D %lu)\n",
>>> +				cr, cr / 1000000, cr_ahb);
>>
>> See next comment.
>>
>>> +	cr =3D clk_get_rate(ss->ssclk);
>>> +	if (cr <=3D cr_mod)
>>> +		if (cr < cr_mod)
>>> +			dev_info(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <=3D %lu)\n",
>>> +					cr, cr / 1000000, cr_mod);
>>> +		else
>>> +			dev_dbg(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <=3D %lu)\n",
>>> +					cr, cr / 1000000, cr_mod);
>>> +	else
>>> +		dev_warn(&pdev->dev, "Clock ss is at %lu (%lu MHz) (must be <=3D %lu=
)\n",
>>> +				cr, cr / 1000000, cr_mod);
>>
>> The management of kernel log levels looks pretty strange. As far as I
>> understand there is no error on any clock rate, I'd recommend to keep
>> only one information message.
>=20
> And if not, please add some braces.
>=20
>> hash_init: initialize request context */
>>> +int sunxi_hash_init(struct ahash_request *areq)
>>> +{
>>> +	const char *hash_type;
>>> +	struct sunxi_req_ctx *op =3D ahash_request_ctx(areq);
>>> +
>>> +	memset(op, 0, sizeof(struct sunxi_req_ctx));
>>> +
>>> +	hash_type =3D crypto_tfm_alg_name(areq->base.tfm);
>>> +
>>> +	if (strcmp(hash_type, "sha1") =3D=3D 0)
>>> +		op->mode =3D SS_OP_SHA1;
>>> +	if (strcmp(hash_type, "md5") =3D=3D 0)
>>> +		op->mode =3D SS_OP_MD5;
>=20
> else if ?
>=20
>>> +	if (op->mode =3D=3D 0)
>>> +		return -EINVAL;
>=20
> maybe this?
>=20
> 	if (!strcmp(hash_type, "sha1"))
> 		op->mode =3D SS_OP_SHA1;
> 	else if (!strcmp(hash_type, "md5"))
> 		op->mode =3D SH_OP_MD5;
> 	else
> 		return -EINVAL;
>=20

Ok it is better

>>> +
>>> +	return 0;
>>> +}
> []
>>> +int sunxi_hash_update(struct ahash_request *areq)
>>> +{
> []
>>> +	dev_dbg(ss->dev, "%s %s bc=3D%llu len=3D%u mode=3D%x bw=3D%u ww=3D%u"=
,
>>> +			__func__, crypto_tfm_alg_name(areq->base.tfm),
>>> +			op->byte_count, areq->nbytes, op->mode,
>>> +			op->nbw, op->nwait);
>=20
> dev_dbg statements generally don't need __func__ as
> dynamic_debug can add it.
>=20
> If you want to keep it, the most common output form for
> __func__ is '"%s: ...", __func__'
>=20

It is a big debug that I forgot to remove but I fixed that in other dev_dbg

thanks

--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
