From: Ofir Drang <Ofir.Drang@arm.com>
Subject: RE: dm-crypt optimization
Date: Thu, 22 Dec 2016 10:14:57 +0000
Message-ID: <DB6PR0801MB17979EB2FD1EC7109B8A288589920@DB6PR0801MB1797.eurprd08.prod.outlook.com>
References: <CAHv-k_98w-9whFiCLAnTGL2QAirExsix_S8ZWc8tM7wj=gzD6Q@mail.gmail.com>
 <bf5e7237-2f5c-3fc6-c7d6-38c3b13ac2c3@gmail.com>
 <CAHv-k_-K9dOiM+Pm_wqVJrvmNYhjtS82-emKVZ8OjsoMHf+7hg@mail.gmail.com>
 <20161222085927.GB2160@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Milan Broz <gmazyland@gmail.com>,
        Oded Golombek <Oded.Golombek@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>,
        "Alasdair Kergon" <agk@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "private-kwg@linaro.org" <private-kwg@linaro.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Rajendra <rnayak@codeaurora.org>,
        "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Shaohua Li <shli@kernel.org>, Mike Snitzer <snitzer@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Binoy Jayan <binoy.jayan@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0069.outbound.protection.outlook.com ([104.47.2.69]:38002
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754810AbcLVKQG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2016 05:16:06 -0500
In-Reply-To: <20161222085927.GB2160@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
Sent: Thursday, December 22, 2016 10:59 AM
To: Binoy Jayan
Cc: Milan Broz; Oded Golombek; Ofir Drang; Arnd Bergmann; Mark Brown; Alasd=
air Kergon; David S. Miller; private-kwg@linaro.org; dm-devel@redhat.com; l=
inux-crypto@vger.kernel.org; Rajendra; Linux kernel mailing list; linux-rai=
d@vger.kernel.org; Shaohua Li; Mike Snitzer
Subject: Re: dm-crypt optimization

On Thu, Dec 22, 2016 at 01:55:59PM +0530, Binoy Jayan wrote:
>>
>> > Support of bigger block sizes would be unsafe without additional
>> > mechanism that provides atomic writes of multiple sectors. Maybe it
>> > applies to 4k as well on some devices though...)
>>
>> Did you mean write to the crypto output buffers or the actual disk write=
?
>> I didn't quite understand how the block size for encryption affects
>> atomic writes as it is the block layer which handles them. As far as
>> dm-crypt is, concerned it just encrypts/decrypts a 'struct bio'
>> instance and submits the IO operation to the block layer.

>I think Milan's talking about increasing the real block size, which would =
obviously require the hardware to be able to write that out atomically, as =
otherwise it breaks the crypto.
>
>But if we can instead do the IV generation within the crypto API, then the=
 block size won't be an issue at all.  Because you can supply as many block=
s as you want and they would be processed block-by-block.
>
>Now there is a disadvantage to this approach, and that is you have to wait=
 for the whole thing to be encrypted before you can start doing the IO.  I'=
m not sure how big a problem that is but if it is bad enough to affect perf=
ormance, we can look into adding >some form of partial completion to the cr=
ypto API.
>
>Cheers,

But assuming we have hardware accelerator that know to handle the IV genera=
tion for each sector, it will make sense to send out to the hardware the ma=
ximum block size as this will allow us to better utilize the hardware and o=
ffload the software. So if possible we need to provide generic interface th=
at will be able to optimize the hardware accelerates.

Thx Ofir
--
Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.ap=
ana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
