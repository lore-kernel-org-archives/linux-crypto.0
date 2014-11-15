From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 1/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Sat, 15 Nov 2014 08:55:58 +0100
Message-ID: <5467070E.5040104@gmail.com>
References: <1415621455-10468-1-git-send-email-james.hartley@imgtec.com>	<1415621455-10468-2-git-send-email-james.hartley@imgtec.com> <CAL1qeaGN9q_WHP2YJ3fY3r11v0pitcmwbjam5dRzeZhHCp7c8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net, Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	joe@perches.com, mchehab@osg.samsung.com,
	Antti Palosaari <crope@iki.fi>, jg1.han@samsung.com,
	linux-crypto@vger.kernel.org,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
	linux-crypto@vger.kernel.org
To: Andrew Bresticker <abrestic@chromium.org>,
	James Hartley <james.hartley@imgtec.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33345 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaKOH4D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 15 Nov 2014 02:56:03 -0500
In-Reply-To: <CAL1qeaGN9q_WHP2YJ3fY3r11v0pitcmwbjam5dRzeZhHCp7c8g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le 15/11/2014 00:59, Andrew Bresticker a =C3=A9crit :
> Hi James,
>=20
>> +
>> +struct img_hash_drv {
>> +       struct list_head dev_list;
>> +       spinlock_t lock;
>> +};
>> +
>> +static struct img_hash_drv img_hash =3D {
>> +       .dev_list =3D LIST_HEAD_INIT(img_hash.dev_list),
>> +       .lock =3D __SPIN_LOCK_UNLOCKED(img_hash.lock),
>> +};
>=20
> It looks like the only purpose of this list is to get the
> corresponding struct img_hash_dev in img_hash_init().  If there's
> never going to be multiple instances within an SoC, perhaps you could
> just use a global?  Otherwise, you could do something like the
> qualcomm driver, see drivers/crypto/qce/sha.c.  It looks like there i=
s
> some precedent for this device list though...
>=20

I don't understand, you propose to use a global, something that lots of=
 people want to be removed in my driver.
It is not better than this global list.

I have the fealing that there no good way to get a pointer to a driver =
structure inside the cryptoAPI.
What to you think about adding a void *data in struct crypto_alg

Before registering an alg you could do:
mv_aes_alg_ecb.data =3D myprivatedriverdata;
ret =3D crypto_register_alg(&mv_aes_alg_ecb);

and then get it via
struct crypto_priv *cp =3D req->base.tfm->__crt_alg->data;
(a function will be better than that)

So what is the recommended way to get driver structure inside the crypt=
oAPI function (init/udpate/final)?

Regards
