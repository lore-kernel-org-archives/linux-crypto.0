From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: Fix next IV issue for CTS template
Date: Fri, 17 Feb 2017 09:23:00 +0000
Message-ID: <486E1F1E-8905-45C5-9AD7-9DB3E33CA338@linaro.org>
References: <1487303262-5602-1-git-send-email-Libo.Wang@arm.com> <CAKv+Gu8s6PrAv9ZMGa_TsRn2UYKoo8KhqERU0NZPjfBhMDK88Q@mail.gmail.com> <20170217091724.GA28198@arm.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Libo.Wang@arm.com, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Ofir.Drang@arm.com, nd@arm.com
To: Dennis Chen <dennis.chen@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:36535 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750780AbdBQJXE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2017 04:23:04 -0500
Received: by mail-wr0-f171.google.com with SMTP id 89so21795460wrr.3
        for <linux-crypto@vger.kernel.org>; Fri, 17 Feb 2017 01:23:03 -0800 (PST)
In-Reply-To: <20170217091724.GA28198@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> On 17 Feb 2017, at 09:17, Dennis Chen <dennis.chen@arm.com> wrote:
>=20
> Hello Ard,
> Morning!
>> On Fri, Feb 17, 2017 at 07:12:46AM +0000, Ard Biesheuvel wrote:
>> Hello Libo,
>>=20
>>> On 17 February 2017 at 03:47,  <Libo.Wang@arm.com> wrote:
>>> From: Libo Wang <Libo Wang@arm.com>
>>>=20
>>> CTS template assumes underlying CBC algorithm will carry out next IV for=

>>> further process.But some implementations of CBC algorithm in kernel brea=
k
>>> this assumption, for example, some hardware crypto drivers ignore next I=
V
>>> for performance consider, inthis case, tcry cts(cbc(aes)) test case will=

>>> fail. This patch is trying to fix it by getting next IV information read=
y
>>> before last two blocks processed.
>>>=20
>>> Signed-off-by: Libo Wang <libo.wang@arm.com>
>>> Signed-off-by: Dennis Chen <dennis.chen@arm.com>
>>=20
>> Which algorithms in particular break this assumption? I recently fixed
>> some ARM accelerated software drivers for this reason. If there are
>> others, we should fix those rather than try to fix it in the CTS
>> driver.
>>=20
> There're some ARM HW accelerated drivers which are not upstream yet(IP lic=
ense)
> breaks this assumption. The current CTS template requires the underlying C=
BC=20
> algorithm always fill the next IV, but in some cases like CBC standalone m=
ode,=20
> it doesn't need to fill the next IV, so apparently it will induce performa=
nce
> degrade from the point of drivers, that's why we fix it in the CTS templat=
e,except
> that it will also mitigate the potential defect of other HW-based CBC driv=
ers.=20

You should fix this in the driver, not in the cts code.

>>=20
>>> ---
>>> crypto/cts.c | 29 +++++++++++++++++++++++++----
>>> 1 file changed, 25 insertions(+), 4 deletions(-)
>>>=20
>>> diff --git a/crypto/cts.c b/crypto/cts.c
>>> index a1335d6..712164b 100644
>>> --- a/crypto/cts.c
>>> +++ b/crypto/cts.c
>>> @@ -154,6 +154,7 @@ static int crypto_cts_encrypt(struct skcipher_reques=
t *req)
>>>        unsigned int nbytes =3D req->cryptlen;
>>>        int cbc_blocks =3D (nbytes + bsize - 1) / bsize - 1;
>>>        unsigned int offset;
>>> +       int ret =3D 0;
>>>=20
>>>        skcipher_request_set_tfm(subreq, ctx->child);
>>>=20
>>> @@ -174,8 +175,17 @@ static int crypto_cts_encrypt(struct skcipher_reque=
st *req)
>>>        skcipher_request_set_crypt(subreq, req->src, req->dst,
>>>                                   offset, req->iv);
>>>=20
>>> -       return crypto_skcipher_encrypt(subreq) ?:
>>> -              cts_cbc_encrypt(req);
>>> +       /* process CBC blocks */
>>> +       ret =3D crypto_skcipher_encrypt(subreq);
>>> +       /* process last two blocks */
>>> +       if (!ret) {
>>=20
>> What happens if an async driver returns -EINPROGRESS here?
> For this case, the CTS will return -EINPROGRESS directly.
>=20

I see. But how do you handle the missing out IV when the async call complete=
s?

>>=20
>>> +               /* Get IVn-1 back */
>>> +               scatterwalk_map_and_copy(req->iv, req->dst, (offset - bs=
ize), bsize, 0);
>>> +               /* Continue last two blocks */
>>> +               return cts_cbc_encrypt(req);
>>> +       }
>>> +
>>> +       return ret;
>>> }
>>>=20
>>> static int cts_cbc_decrypt(struct skcipher_request *req)
>>> @@ -248,6 +258,8 @@ static int crypto_cts_decrypt(struct skcipher_reques=
t *req)
>>>        int cbc_blocks =3D (nbytes + bsize - 1) / bsize - 1;
>>>        unsigned int offset;
>>>        u8 *space;
>>> +       int ret =3D 0;
>>> +       u8 iv_next[bsize];
>>>=20
>>>        skcipher_request_set_tfm(subreq, ctx->child);
>>>=20
>>> @@ -277,8 +289,17 @@ static int crypto_cts_decrypt(struct skcipher_reque=
st *req)
>>>        skcipher_request_set_crypt(subreq, req->src, req->dst,
>>>                                   offset, req->iv);
>>>=20
>>> -       return crypto_skcipher_decrypt(subreq) ?:
>>> -              cts_cbc_decrypt(req);
>>> +       /* process last two blocks */
>>> +       scatterwalk_map_and_copy(iv_next, req->src, (offset - bsize), bs=
ize, 0);
>>> +       ret =3D crypto_skcipher_decrypt(subreq);
>>> +       if (!ret) {
>>> +               /* Set Next IV */
>>> +               subreq->iv =3D iv_next;
>>> +               /* process last two blocks */
>>> +               return cts_cbc_decrypt(req);
>>> +       }
>>> +
>>> +       return ret;
>>> }
>>>=20
>>> static int crypto_cts_init_tfm(struct crypto_skcipher *tfm)
>>> --
>>> 1.8.3.1
>>>=20
