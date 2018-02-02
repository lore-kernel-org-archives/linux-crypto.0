From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: Odroid HC1 cryptsetup:encrypt sata driver
Date: Fri, 02 Feb 2018 12:27:04 +0100
Message-ID: <fc3accfc-0dc1-d37b-3345-56aa981bbdfd@partner.samsung.com>
References: <CGME20180124130437epcas2p251156941d5fd0dab2c24807a26a156be@epcas2p2.samsung.com>
        <CANAwSgQ3WE9XmjmzHxJstDz52fj_SFvmBKnMjY3MVjhxJuoFmg@mail.gmail.com>
        <f1966769-106e-a95e-8068-642e93c390b4@partner.samsung.com>
        <CANAwSgT5buQ2ROmt-Bk0sh8=cSU5hp3GiHRuKwSagn0s57Nevw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Anand Moon <linux.amoon@gmail.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <CANAwSgT5buQ2ROmt-Bk0sh8=cSU5hp3GiHRuKwSagn0s57Nevw@mail.gmail.com>
Content-language: en-US
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On 31.01.2018 06:51, Anand Moon wrote:
> Hi Kamil,
> 
> On 30 January 2018 at 21:02, Kamil Konieczny
> <k.konieczny@partner.samsung.com> wrote:
>> Hi Anand,
>>
>> On 24.01.2018 14:04, Anand Moon wrote:
>>> Hi Kamil Konieczny,
>>>
>>> I am looking in setup of encrypted sata hard-disk on Odroid XU4/HC1 device.
>>> using following encryption method.
>>>
>>> aes-cbc-essiv:sha256 128
>>> aes-cbc-essiv:sha256 256
>>>
>>> Here is my defconfig I am using. https://pastebin.com/gF5T2stp
>>>
>>> Following crypt benchmark we use to test : https://pastebin.com/WiexsJA2
>>>
>>> When I am trying to format the the hard drive I am getting kernel panic.
>>> I have tired different option like below.
>>>
>>> *Please guide me in how to fix this bug*
>>> [...]
>>
>> Sorry for late response, I was on holidays. Try latest kernel 4.15
>> and turn off option:
>> [...]
> 
> Thanks for your input, but I tried your suggestion on latest kernel.
> but the result is the same.
> 
> How can I help trace this bug. please guide me.

I was able to reproduce this bug with latest kernel 4.15 on Odroid HC1,
I am debugging it now.
Thank you for reporting it.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
