From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] crypto: Add Allwinner Security System crypto accelerator
Date: Wed, 23 Jul 2014 20:52:12 +0200
Message-ID: <53D0045C.6090605@gmail.com>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <201407231607.21106.marex@denx.de> <20140723141309.GA30324@gondor.apana.org.au> <201407231751.02050.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
	rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
	linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marek Vasut <marex-ynQEQJNshbs@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201407231751.02050.marex-ynQEQJNshbs@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Le 23/07/2014 17:51, Marek Vasut a =E9crit :
> On Wednesday, July 23, 2014 at 04:13:09 PM, Herbert Xu wrote:
>> On Wed, Jul 23, 2014 at 04:07:20PM +0200, Marek Vasut wrote:
>>> On Wednesday, July 23, 2014 at 03:57:35 PM, Herbert Xu wrote:
>>>> On Sat, May 24, 2014 at 02:00:03PM +0200, Marek Vasut wrote:
>>>>>> +	}
>>>>>> +#endif
>>>>>> +
>>>>>> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_MD5
>>>>>> +	err =3D crypto_register_shash(&sunxi_md5_alg);
>>>>>
>>>>> Do not use shash for such device. This is clearly and ahash (and
>>>>> async in general) device. The rule of a thumb here is that you us=
e
>>>>> sync algos only for devices which have dedicated instructions for
>>>>> computing the transformation. For devices which are attached to s=
ome
>>>>> kind of bus, you use async algos (ahash etc).
>>>>
>>>> I'm sorry that I didn't catch this earlier but there is no such
>>>> rule.
>>>>
>>>> Unless you need the async interface you should stick to the sync
>>>> interfaces for the sake of simplicity.
>>>>
>>>> We have a number of existing drivers that are synchronous but
>>>> using the async interface.  They should either be converted
>>>> over to the sync interface or made interrupt-driven if possible.
>>>
>>> Sure, but this device is interrupt driven and uses DMA to feed the =
crypto
>>> engine, therefore async, right ?
>>
>> If it's interrupt-driven, then yes it would certainly make sense to
>> be async.  But all I see is polling in the latest posting, was the
>> first version different?
>=20
> I stand corrected then, sorry.
>=20
> Is it possible to use DMA to feed the crypto accelerator, Corentin?
>=20
> Best regards,
> Marek Vasut
>=20

Yes, DMA is possible and will be implemented soon.
So if I have well understood, I keep using async interface.

--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
