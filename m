From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: Odroid HC1 cryptsetup:encrypt sata driver
Date: Fri, 02 Feb 2018 18:35:13 +0100
Message-ID: <c9a4ea55-4ab1-3f9a-6381-af1ce7d56590@partner.samsung.com>
References: <CANAwSgQ3WE9XmjmzHxJstDz52fj_SFvmBKnMjY3MVjhxJuoFmg@mail.gmail.com>
        <CGME20180124140134epcas1p1e219c8e4e75e52a512220dc5788ac70b@epcas1p1.samsung.com>
        <CAJKOXPeudajDX9EouSz=eB7r+OG1vcJD8Yg139CDpWGs-7bSOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Anand Moon <linux.amoon@gmail.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <CAJKOXPeudajDX9EouSz=eB7r+OG1vcJD8Yg139CDpWGs-7bSOw@mail.gmail.com>
Content-language: en-US
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 24.01.2018 15:01, Krzysztof Kozlowski wrote:
> On Wed, Jan 24, 2018 at 2:04 PM, Anand Moon <linux.amoon@gmail.com> wrote:
>> Hi Kamil Konieczny,
>>
>> I am looking in setup of encrypted sata hard-disk on Odroid XU4/HC1 device.
>> using following encryption method.
>>
>> aes-cbc-essiv:sha256 128
>> aes-cbc-essiv:sha256 256
>>
>> Here is my defconfig I am using. https://pastebin.com/gF5T2stp
>>
>> Following crypt benchmark we use to test : https://pastebin.com/WiexsJA2
> 
> No problems on my side with a 128 MB file (not a device):
> # cryptsetup -v luksFormat /tmp/testcrypt /dev/urandom
> --keyfile-size=32 --cipher aes-cbc-essiv:sha256
> # Command successful.
> # cryptsetup -v luksFormat ~/testcrypt /dev/urandom --keyfile-size=32
> --cipher aes-cbc-essiv:sha256
> # Command successful.

What version is cryptsetup ?

> 
> Linux 4.15.0-rc9-00023-g1f07476ec143.
> 
> Some time ago you were building from not usual source code and your
> kernel version from WARN is not unambiguous.
> 
> What is necessary to reproduce it?
>>[...]

I get OOPS with cryptsetup 2.0.0, kernel 4.15

If you have older cryptsetup, please keep it for reference.

For now, I found that crypto-api or dm-crypt try to use aes-ecb
instead of aes-cbc, and sets req->info (pointer used for passing IV) to 0x10

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
