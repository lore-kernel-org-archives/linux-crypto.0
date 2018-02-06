From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH] crypto: s5p-sss.c: Fix kernel Oops in AES-ECB mode
Date: Tue, 06 Feb 2018 18:10:55 +0100
Message-ID: <b3b0b170-f10b-fb8a-74f9-b6aa0cb41980@partner.samsung.com>
References: <CGME20180205174022eucas1p101e8339284c1f0ac8f40f70c24de1c1f@eucas1p1.samsung.com>
        <224788c7-426b-d3a9-d0a6-412d2b8afb75@partner.samsung.com>
        <CANAwSgTO5_mL9GEYrXDJyKakY3JTeF+VxbCTuHczAvfVY0zUsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
To: Anand Moon <linux.amoon@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37967 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752286AbeBFRLA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Feb 2018 12:11:00 -0500
In-reply-to: <CANAwSgTO5_mL9GEYrXDJyKakY3JTeF+VxbCTuHczAvfVY0zUsg@mail.gmail.com>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 06.02.2018 17:48, Anand Moon wrote:
> Hi Kamil,
> 
> Thanks for providing the fix to this issue.
> 
> On 5 February 2018 at 23:10, Kamil Konieczny
> <k.konieczny@partner.samsung.com> wrote:
>>
>> In AES-ECB mode crypt is done with key only, so any use of IV
>> can cause kernel Oops, as reported by Anand Moon.
> 
> If possible could you avoid the name in commit message.

This is added after '---' line, so it will not appear in commit message.

>> Fixed it by using IV only in AES-CBC and AES-CTR.
>>
>> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
>> Reported-by: Anand Moon <linux.amoon@gmail.com>
> 
> [snip]
> 
> Please add my. Tested on Odroid HC2
> 
> Tested-by: Anand Moon <linux.amoon@gmail.com>

This will add you name in commit message,
additionally with 'Reported-by:' line.

> Below are the result at my end.
> 
> aes-cbc-essiv:sha256 (128 bit key)
> WRITE:
> 100+0 records in
> 100+0 records out
> 838860800 bytes (839 MB, 800 MiB) copied, 11.7225 s, 71.6 MB/s
> [...]

is it from 'cryptsetup benchmark' ? benchmark did not cause oops.
Please test with luksFormat, ie. use

cryptsetup luksFormat --debug -q -d /tmp/testkey.key \
  --cipher aes-cbc-essiv:sha256 -h sha256 -s 128 /tmp/test.bin

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
