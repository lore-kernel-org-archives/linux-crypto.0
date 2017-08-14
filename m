From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: caam - properly set IV after {en,de}crypt
Date: Mon, 14 Aug 2017 10:59:20 +0300
Message-ID: <CAOtvUMfa66v6_MfasHRG8Qk9h81GMTnObuBSObBGcSL4QoOMDQ@mail.gmail.com>
References: <20170602122446.2427-1-david@sigma-star.at> <20170628132710.97278-1-david@sigma-star.at>
 <VI1PR0401MB2591AE2CA996495656C797B398DD0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <VI1PR0401MB2591C51C446CFA129B50022298D20@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: David Gstir <david@sigma-star.at>,
        Dan Douglass <dan.douglass@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:34186 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752449AbdHNH7V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 03:59:21 -0400
Received: by mail-yw0-f193.google.com with SMTP id t139so5754398ywg.1
        for <linux-crypto@vger.kernel.org>; Mon, 14 Aug 2017 00:59:21 -0700 (PDT)
In-Reply-To: <VI1PR0401MB2591C51C446CFA129B50022298D20@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Thu, Jun 29, 2017 at 1:19 PM, Horia Geant=C4=83 <horia.geanta@nxp.com> w=
rote:
> On 6/28/2017 4:42 PM, Horia Geant=C4=83 wrote:
>> On 6/28/2017 4:27 PM, David Gstir wrote:
>>> Certain cipher modes like CTS expect the IV (req->info) of
>>> ablkcipher_request (or equivalently req->iv of skcipher_request) to
>>> contain the last ciphertext block when the {en,de}crypt operation is do=
ne.
>>> This is currently not the case for the CAAM driver which in turn breaks
>>> e.g. cts(cbc(aes)) when the CAAM driver is enabled.
>>>
>>> This patch fixes the CAAM driver to properly set the IV after the
>>> {en,de}crypt operation of ablkcipher finishes.
>>>
>>> This issue was revealed by the changes in the SW CTS mode in commit
>>> 0605c41cc53ca ("crypto: cts - Convert to skcipher")
>>>
>>> Cc: <stable@vger.kernel.org> # 4.8+
>>> Signed-off-by: David Gstir <david@sigma-star.at>
>> Reviewed-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
>>
> Btw, instead of updating the IV in SW, CAAM engine could be programmed
> to do it - by saving the Context Register of the AES accelerator.
>
> Unfortunately this would require changes in quite a few places: shared
> descriptor, HW S/G generation logic, IV dma (un)mapping and maybe others.
>
> So it's better to have this fix now (which, considering size, is
> appropriate for -stable) and later, if needed, offload IV updating in HW.
>

My apologies for reviving this thread from the dead, but doesn't the patch =
fail
for in-place decryption since we are copying from req->dst after
the operation is done, and therefore it no longer contains the ciphertext?

I'm asking since I ran into a similar issue in the ccree driver and thought
to deploy a similar fix but could not convince myself why this works.

Thanks!
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
