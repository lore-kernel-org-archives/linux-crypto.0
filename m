From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] crypto: s5p-sss: Add HASH support for Exynos
Date: Fri, 15 Sep 2017 08:10:16 +0200
Message-ID: <CAJKOXPcZT9S4Z5QoTOf_u2bDE=-dVq5+YYo3zLorTkeA6QiYtA@mail.gmail.com>
References: <CGME20170913124433eucas1p11ac46af1676151477000f8952b0ca654@eucas1p1.samsung.com>
 <51b3b386-22c0-7663-6f54-d166ebebd332@partner.samsung.com>
 <CAJKOXPcQhn9gq2cm_1nc8N6MEbJ0ntZqfwmY9XDYwc5VEERvdA@mail.gmail.com> <77dbef9a-a648-8380-ca08-e6874b4d27fb@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <77dbef9a-a648-8380-ca08-e6874b4d27fb@partner.samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 13, 2017 at 4:24 PM, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
> Hi Krzysztof,
>
> On 13.09.2017 15:18, Krzysztof Kozlowski wrote:
>> On Wed, Sep 13, 2017 at 2:44 PM, Kamil Konieczny
>> <k.konieczny@partner.samsung.com> wrote:
>>> Add support for MD5, SHA1, SHA256 hash algorithms for Exynos HW.
>>> It uses the crypto framework asynchronous hash api.
>>> It is based on omap-sham.c driver.
>>> S5P has some HW differencies and is not implemented.
>>>
>>> Modifications in s5p-sss:
>>>
>>> - Add hash supporting structures and functions.
>>>
>>> - Modify irq handler to handle both aes and hash signals.
>>>
>>> - Disable HASH in probe if Exynos PRNG is enabled.
>>>
>>> - Add new copyright line and new author.
>>>
>>> - Tested on Odroid-U3 with Exynos 4412 CPU, kernel 4.13-rc6
>>>   with crypto run-time self test testmgr
>>>   and with tcrypt module with: modprobe tcrypt sec=1 mode=N
>>>   where N=402, 403, 404 (MD5, SHA1, SHA256).
>>>
>>> Modifications in drivers/crypto/Kconfig:
>>>
>>> - Select sw algorithms MD5, SHA1 and SHA256 in S5P
>>>   as they are nedded for fallback.
>>>
>>> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
>>> ---
>>>  drivers/crypto/Kconfig   |    6 +
>>>  drivers/crypto/s5p-sss.c | 2062 +++++++++++++++++++++++++++++++++++++++++++---
>>>  2 files changed, 1939 insertions(+), 129 deletions(-)
>>>
>>
>> Nice work, thanks!
>>
>> You need to split the patch, it is just too huge making it very
>> difficult to review. Please split it per logically sensible
>> improvements.
>
> Can you suggest how to break it up ?>
> It is now big update, added working functionallity in one piece,
> but I agree it can be hard to read
> as git did some strange things,
> like delete few aes functions (and mixing this delete with '+' lines)
> and then adding the same aes without any change.

You know the changes you want to do, you know the new architecture so
usually it is easier for you to figure out the split.
But few ideas:
1. For the problem of functions being deleted-moved without any
changes, you can try to reorder new code so diff will not show these
hunks. Indeed a lot diff here looks like weird matching of diff/patch.
This definitely has to be fixed because I cannot figure out the real
changes around existing functions (e.g. s5p_set_indata_start(),
s5p_aes_crypt_start()).
2. You add debugging code - FLOW_LOG - this is one candidate to split entirely.
3. Cleanups go to separate patch.

Probably working on (1) above will bring the most benefit.

>
>> I see some cleanups mixed with new features - this
>> definitely must be split out.
>
> What cleanups do you see ?

For example:
- * @aes_ioaddr:        Per-varian offset for AES block IO memory
+ * @aes_ioaddr:        Per-variant offset for AES block IO memory

- * @tasklet:   New request scheduling jib
+ * @tasklet:   New request scheduling job

Seriously, you should not what you did in this patch, not me. There
might be more like this but it is difficult to find them out in
current patch.

> You mean this one "#if 0" ?
>
>> This looks more or less like an early work or RFC... because I see
>> things like "#if 0",
>
> You are right, I will remove it.
>
>> "HACK" or "CONFIG_....". If so, ask the question
>> about your problems directly. Do not force readers to find them out...
>
> The problem is in dts there are described
> only AES registers (the range is too small),
> and HASH and PRNG uses the same HASH_CONTROL_1 register
> (setting SecSS engine).
> Both AES and HASH must use FC control registers for irq
> and flow setting.
>
> So this 'hack' prevents using both exynos-prng and s5p-sss HASH,
> and in presence of exynos-prng it will load only s5p-sss aes part.
>
> This will disable exynos-prng in scenario:
>
> remove exynos-prng
> remove s5p-sss
> load s5p-sss
>
> now exynos-prng module will not load.

Then nack for this parts. Your driver cannot in hidden way influence
any other driver, you should not reference to any other CONFIG_ from
within the code... The solution for this problem depends whether it
would be possible to have them working in the same time or not. IOW,
whether there is a conflict on registers or not.

Possible solutions:
1. In case of conflict: Add Kconfig dependency (negative dependency),
2. If they use the same registers but in non-conflicting mode, make
both drivers children of MFD driver with regmap-mmio shared between
them. IRQ could be handled by regmap_irq_chip.
3. Combination of 1+2 above: split out some generic RNG code from RNG
driver, implement the RNG also here (so there will be two RNG drivers)
and add !dependency between these two.

Best regards,
Krzysztof
