From: Cata Vasile <cata.vasile@nxp.com>
Subject: Re: ARM-CE aes encryption on uneven blocks
Date: Wed, 26 Oct 2016 07:49:24 +0000
Message-ID: <DB5PR04MB130295C42CB86046F64E487BEEAB0@DB5PR04MB1302.eurprd04.prod.outlook.com>
References: <HE1PR04MB13065DBD6C9844835123FAF9EEA90@HE1PR04MB1306.eurprd04.prod.outlook.com>,<CAFuf8QPCZPaLXh0nNY3Ktm-w6STKGwXpTEQcXGH-HCDvWD-jLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Hamid Nassiby <h.nassiby@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0056.outbound.protection.outlook.com ([104.47.2.56]:34829
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932124AbcJZOYd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 10:24:33 -0400
In-Reply-To: <CAFuf8QPCZPaLXh0nNY3Ktm-w6STKGwXpTEQcXGH-HCDvWD-jLQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Then what is the role of the "for" structure? Why not do just a single encr=
yption/decryption call?

Regards,
Cata

>From: Hamid Nassiby <h.nassiby@gmail.com>
>Sent: Wednesday, October 26, 2016 10:16 AM
>To: Cata Vasile
>Cc: linux-crypto@vger.kernel.org
>Subject: Re: ARM-CE aes encryption on uneven blocks
>=A0  =20
>Hi,>

>Based on my old experience with "struct crypto_alg" based drivers, the
>data you receive there, is padded beforehand(in the upper layers);
>Therefore the plaintext contains integral multiple of AES block size
>of data and based on the number of blocks, the crypto transform can be
>computed.>

>Regards,
>Hamid>

>On Mon, Oct 24, 2016 at 6:11 PM, Cata Vasile <cata.vasile@nxp.com> wrote:
>>
>> Hi,
>>
>> I'm trying to understand the code for AES encryption from ARM-CE.
>> From the aes-glue.S calls I understand that the encryption primitives re=
ceive the number of blocks, but have no way of determining the number of by=
tes to encrypt, if for example the plaintext does not have a length of a mu=
ltiple of AES block size.
>> How does, for example, ecb_encrypt() also encrypt the last remaining byt=
es in the plaintext if it is not a multiple of AES block size if It can nev=
er deduce the full plaintext size?
>>
>> Catalin Vasile--
>> To unsubscribe from this list: send the line "unsubscribe linux-crypto" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at=A0  https://emea01.safelinks.protection.outlook.c=
om/?url=3Dhttp%3A%2F%2Fvger.kernel.org%2Fmajordomo-info.html&data=3D01%7C01=
%7Ccata.vasile%40nxp.com%7C4c5ecc69183f40e96faf08d3fd701bab%7C686ea1d3bc2b4=
c6fa92cd99c5c301635%7C0&sdata=3DvVYloLYwzQl3keXvz%2FMdV3d2ruHmn26F%2FfY%2FA=
7GG8wA%3D&reserved=3D0
>    =
