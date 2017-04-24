From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2 6/9] staging: ccree: add FIPS support
Date: Mon, 24 Apr 2017 10:07:45 +0300
Message-ID: <CAOtvUMdYtLa10dUQ--5hxeYOAi+vw9OTLZF=WPmDS27cr6KvJg@mail.gmail.com>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
 <CAOtvUMdF53Bu65oLtDaUKvnxcMCBY1h=Dq8LaPwTGOwg4YKYVg@mail.gmail.com>
 <2108964.Kb0ivG6kmD@tauon.chronox.de> <2100092.9meQszc5SR@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Stuart Yoder <stuart.yoder@arm.com>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2100092.9meQszc5SR@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 24, 2017 at 9:21 AM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:
> Am Montag, 24. April 2017, 08:16:50 CEST schrieb Stephan M=C3=BCller:
>
> Hi Gilad,
>
>> >
>> > int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
>> >
>> >                       unsigned int keylen)
>> >
>> > However, this does not check that k1 =3D=3D k3. In this case DES3
>> > becomes 2DES (2-keys TDEA), the use of which was dropped post 2015
>> > by NIST Special Publication 800-131A*.
>>
>> It is correct that the RFC wants at least a 2key 3DES. And it is correct
>> that SP800-131A mandates 3key 3DES post 2015. All I am saying is that FI=
PS
>> 140-2 does *not* require a technical verification of the 3 keys being no=
t
>> identical.
>
> One side note: we had discussed a patch to this function in the past, see=
 [1].
>
> [1] https://patchwork.kernel.org/patch/8293441/
>

Thanks, I was not aware of that.

I guess we could change the function to indicate that a key is valid
for decryption but not encryption
and have the implementation limiting based on that if there is an
interest in SP800-131A compliance.

Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
