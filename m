From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 3/3] crypto: scompress - defer allocation of scratch buffer to first use
Date: Wed, 26 Jul 2017 01:07:34 +0100
Message-ID: <E58FB1E5-1FA7-4410-B9FF-FECB647A75E6@linaro.org>
References: <20170721154238.21697-1-ard.biesheuvel@linaro.org> <20170721154238.21697-4-ard.biesheuvel@linaro.org> <20170725233653.GB28789@silv-upstream1.ir.intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35720 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdGZAHk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 20:07:40 -0400
Received: by mail-wm0-f41.google.com with SMTP id c184so64823593wmd.0
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jul 2017 17:07:39 -0700 (PDT)
In-Reply-To: <20170725233653.GB28789@silv-upstream1.ir.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> On 26 Jul 2017, at 00:36, Giovanni Cabiddu <giovanni.cabiddu@intel.com> wr=
ote:
>=20
> Hi Ard,
>=20
>> On Fri, Jul 21, 2017 at 04:42:38PM +0100, Ard Biesheuvel wrote:
>> +static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
>> +{
>> +    int ret;
>> +
>> +    mutex_lock(&scomp_lock);
>> +    ret =3D crypto_scomp_alloc_all_scratches();
>> +    mutex_unlock(&scomp_lock);
>> +
>> +    return ret;
>> +}
> If you allocate the scratch buffers at init_tfm, don't you end
> up with a situation where if you allocate two tfms of the same algo
> then you get twice the number of scratches?
> If that is the case, we should implement a reference count
> mechanism.
> Am I missing something?
>=20

Isn't the mutex supposed to take care of that?=
