From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Re: [PATCH v5 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Fri, 24 Oct 2014 20:50:23 +0200
Message-ID: <544A9F6F.4090607@gmail.com>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com> <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com> <2751026.4HEPlZfN7W@wuerfel>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
 ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
 maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
 herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
 grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
 gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org,
 crope-X3B1VOXEql0@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBB6V6VKRAKGQE5UJPZ6A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <2751026.4HEPlZfN7W@wuerfel>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Le 22/10/2014 11:00, Arnd Bergmann a =E9crit :
> On Sunday 19 October 2014 16:16:22 LABBE Corentin wrote:
>> Add support for the Security System included in Allwinner SoC A20.
>> The Security System is a hardware cryptographic accelerator that support=
 AES/MD5/SHA1/DES/3DES/PRNG algorithms.
>>
>> Signed-off-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> Please wrap lines in the changelog after about 70 characters.
>=20

Oups I just see the corresponding part in submittingpatches.txt
Sorry

>> --- /dev/null
>> +++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
>> @@ -0,0 +1,489 @@
>=20
>> +#include "sunxi-ss.h"
>> +
>> +extern struct sunxi_ss_ctx *ss;
>=20
> 'extern' declarations belong into header files, not .c files. It would
> be even better to avoid this completely and carry the pointer to the
> context in an object that gets passed around. In general we want drivers
> to be written in a way that allows having multiple instances of the
> device, which the global pointer prevents.
>=20

As I already said I think the driver will never be used with multiple insta=
nce.
But since many people want this pointer dead, I will work on it.

>> +
>> +	src32 =3D (u32 *)src_addr;
>> +	dst32 =3D (u32 *)dst_addr;
>=20
>=20
> You appear to be missing '__iomem' annotations for the mmio pointers.
> Please always run your code through the 'sparse' checker using 'make C=3D=
1'
> to catch and fix this and other erros.
>=20

Ok, but with which version of sparse do you have such a warning. I use the =
0.5.0 version and I got no warning at all.

>> +	ileft =3D areq->nbytes / 4;
>> +	oleft =3D areq->nbytes / 4;
>> +	i =3D 0;
>> +	do {
>> +		if (ileft > 0 && rx_cnt > 0) {
>> +			todo =3D min(rx_cnt, ileft);
>> +			ileft -=3D todo;
>> +			do {
>> +				writel_relaxed(*src32++,
>> +						ss->base +
>> +						SS_RXFIFO);
>> +				todo--;
>> +			} while (todo > 0);
>> +		}
>=20
> This looks like it should be using writesl() instead of the=20
> writel_relaxed() loop. That should not only be faster but it will
> also change the byte ordering if you are running a big-endian
> kernel.
>=20
> Since this is a FIFO register, the ordering that writesl uses
> is likely the correct one.

Great, the code is much cleaner with it. (with up to 10% speed gain)

Thanks

Corentin


--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
