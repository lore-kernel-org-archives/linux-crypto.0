From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 3/7] crypto: ccree: add ablkcipher support
Date: Mon, 22 Jan 2018 09:08:16 +0200
Message-ID: <CAOtvUMcmiKF6B3bM3T4mwNMO5xhXV_MFrJJKQZu+SP6wk3bFYA@mail.gmail.com>
References: <1515662239-1714-1-git-send-email-gilad@benyossef.com>
 <1515662239-1714-4-git-send-email-gilad@benyossef.com> <2378888.JBO5RdML52@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        devel@driverdev.osuosl.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2378888.JBO5RdML52@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 11, 2018 at 12:03 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Donnerstag, 11. Januar 2018, 10:17:10 CET schrieb Gilad Ben-Yossef:
>
> Hi Gilad,
>
>> +     // verify weak keys
>> +     if (ctx_p->flow_mode == S_DIN_to_DES) {
>> +             if (!des_ekey(tmp, key) &&
>> +                 (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_WEAK_KEY)) {
>> +                     tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
>> +                     dev_dbg(dev, "weak DES key");
>> +                     return -EINVAL;
>> +             }
>> +     }
>> +     if (ctx_p->cipher_mode == DRV_CIPHER_XTS &&
>> +         xts_check_key(tfm, key, keylen)) {
>> +             dev_dbg(dev, "weak XTS key");
>> +             return -EINVAL;
>> +     }
>> +     if (ctx_p->flow_mode == S_DIN_to_DES &&
>> +         keylen == DES3_EDE_KEY_SIZE &&
>> +         cc_verify_3des_keys(key, keylen)) {
>> +             dev_dbg(dev, "weak 3DES key");
>> +             return -EINVAL;
>> +     }
>
> For the DES key, wouldn't it make sense to use __des3_ede_setkey?
>
> Note, I would plan to release a patch for review to change that function to
> disallow key1 == key2 or key1 == key3 or key2 == key3 in FIPS mode.

I took your advise and did just that in v2.

Thanks for the review!

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
