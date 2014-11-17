From: Andrew Bresticker <abrestic@chromium.org>
Subject: Re: [PATCH 1/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Mon, 17 Nov 2014 09:11:48 -0800
Message-ID: <CAL1qeaH9-K3GSD50WBQRJyBS_q9uSsnQDMmTYdsTOC1rovcHgQ@mail.gmail.com>
References: <1415621455-10468-1-git-send-email-james.hartley@imgtec.com>
	<1415621455-10468-2-git-send-email-james.hartley@imgtec.com>
	<CAL1qeaGN9q_WHP2YJ3fY3r11v0pitcmwbjam5dRzeZhHCp7c8g@mail.gmail.com>
	<5467070E.5040104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: James Hartley <james.hartley@imgtec.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	Grant Likely <grant.likely@linaro.org>,
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
	Ezequiel Garcia <ezequiel.garcia@imgtec.com>
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:45762 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaKQRLt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Nov 2014 12:11:49 -0500
Received: by mail-vc0-f171.google.com with SMTP id id10so7338089vcb.16
        for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2014 09:11:48 -0800 (PST)
In-Reply-To: <5467070E.5040104@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 14, 2014 at 11:55 PM, Corentin LABBE
<clabbe.montjoie@gmail.com> wrote:
> Le 15/11/2014 00:59, Andrew Bresticker a =C3=A9crit :
>> Hi James,
>>
>>> +
>>> +struct img_hash_drv {
>>> +       struct list_head dev_list;
>>> +       spinlock_t lock;
>>> +};
>>> +
>>> +static struct img_hash_drv img_hash =3D {
>>> +       .dev_list =3D LIST_HEAD_INIT(img_hash.dev_list),
>>> +       .lock =3D __SPIN_LOCK_UNLOCKED(img_hash.lock),
>>> +};
>>
>> It looks like the only purpose of this list is to get the
>> corresponding struct img_hash_dev in img_hash_init().  If there's
>> never going to be multiple instances within an SoC, perhaps you coul=
d
>> just use a global?  Otherwise, you could do something like the
>> qualcomm driver, see drivers/crypto/qce/sha.c.  It looks like there =
is
>> some precedent for this device list though...
>>
>
> I don't understand, you propose to use a global, something that lots =
of people want to be removed in my driver.
> It is not better than this global list.
>
> I have the fealing that there no good way to get a pointer to a drive=
r structure inside the cryptoAPI.
> What to you think about adding a void *data in struct crypto_alg
>
> Before registering an alg you could do:
> mv_aes_alg_ecb.data =3D myprivatedriverdata;
> ret =3D crypto_register_alg(&mv_aes_alg_ecb);
>
> and then get it via
> struct crypto_priv *cp =3D req->base.tfm->__crt_alg->data;
> (a function will be better than that)

That sounds good to me.
