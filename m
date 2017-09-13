From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH] crypto: s5p-sss: Add HASH support for Exynos
Date: Wed, 13 Sep 2017 16:24:05 +0200
Message-ID: <77dbef9a-a648-8380-ca08-e6874b4d27fb@partner.samsung.com>
References: <CGME20170913124433eucas1p11ac46af1676151477000f8952b0ca654@eucas1p1.samsung.com>
        <51b3b386-22c0-7663-6f54-d166ebebd332@partner.samsung.com>
        <CAJKOXPcQhn9gq2cm_1nc8N6MEbJ0ntZqfwmY9XDYwc5VEERvdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <CAJKOXPcQhn9gq2cm_1nc8N6MEbJ0ntZqfwmY9XDYwc5VEERvdA@mail.gmail.com>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Krzysztof,

On 13.09.2017 15:18, Krzysztof Kozlowski wrote:
> On Wed, Sep 13, 2017 at 2:44 PM, Kamil Konieczny
> <k.konieczny@partner.samsung.com> wrote:
>> Add support for MD5, SHA1, SHA256 hash algorithms for Exynos HW.
>> It uses the crypto framework asynchronous hash api.
>> It is based on omap-sham.c driver.
>> S5P has some HW differencies and is not implemented.
>>
>> Modifications in s5p-sss:
>>
>> - Add hash supporting structures and functions.
>>
>> - Modify irq handler to handle both aes and hash signals.
>>
>> - Disable HASH in probe if Exynos PRNG is enabled.
>>
>> - Add new copyright line and new author.
>>
>> - Tested on Odroid-U3 with Exynos 4412 CPU, kernel 4.13-rc6
>>   with crypto run-time self test testmgr
>>   and with tcrypt module with: modprobe tcrypt sec=1 mode=N
>>   where N=402, 403, 404 (MD5, SHA1, SHA256).
>>
>> Modifications in drivers/crypto/Kconfig:
>>
>> - Select sw algorithms MD5, SHA1 and SHA256 in S5P
>>   as they are nedded for fallback.
>>
>> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
>> ---
>>  drivers/crypto/Kconfig   |    6 +
>>  drivers/crypto/s5p-sss.c | 2062 +++++++++++++++++++++++++++++++++++++++++++---
>>  2 files changed, 1939 insertions(+), 129 deletions(-)
>>
> 
> Nice work, thanks!
> 
> You need to split the patch, it is just too huge making it very
> difficult to review. Please split it per logically sensible
> improvements. 

Can you suggest how to break it up ?

It is now big update, added working functionallity in one piece,
but I agree it can be hard to read
as git did some strange things,
like delete few aes functions (and mixing this delete with '+' lines)
and then adding the same aes without any change.

> I see some cleanups mixed with new features - this
> definitely must be split out.

What cleanups do you see ? 
You mean this one "#if 0" ?
 
> This looks more or less like an early work or RFC... because I see
> things like "#if 0",

You are right, I will remove it.

> "HACK" or "CONFIG_....". If so, ask the question
> about your problems directly. Do not force readers to find them out...

The problem is in dts there are described
only AES registers (the range is too small),
and HASH and PRNG uses the same HASH_CONTROL_1 register 
(setting SecSS engine).
Both AES and HASH must use FC control registers for irq
and flow setting.

So this 'hack' prevents using both exynos-prng and s5p-sss HASH,
and in presence of exynos-prng it will load only s5p-sss aes part.

This will disable exynos-prng in scenario:

remove exynos-prng
remove s5p-sss
load s5p-sss

now exynos-prng module will not load.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
