From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: HELP writing crypto driver for HW with blocksize hash
Date: Tue, 11 Jul 2017 13:59:27 +0300
Message-ID: <CAOtvUMdnGscDTPoRDhVnbvHgK=zTnq6cHW2SUoUKWXLOXoyDxQ@mail.gmail.com>
References: <CGME20170711075213eucas1p1816f12edc165dfe05cb791b155e6f658@eucas1p1.samsung.com>
 <09fb0bef-ee22-edff-c651-a81e3ee6a2ae@partner.samsung.com>
 <CAOtvUMf=CKjZPOi5m7DMzN10Ytd81v_qK3n6aTaCqP1gRMQ6Pg@mail.gmail.com> <6f26d70d-6222-a325-d66b-b00b3591f2ae@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org, linux-newbie@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-newbie-owner@vger.kernel.org>
In-Reply-To: <6f26d70d-6222-a325-d66b-b00b3591f2ae@partner.samsung.com>
Sender: linux-newbie-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 11, 2017 at 1:50 PM, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
> On 11.07.2017 12:30, Gilad Ben-Yossef wrote:
>> On Tue, Jul 11, 2017 at 10:52 AM, Kamil Konieczny
>> <k.konieczny@partner.samsung.com> wrote:
>>>
>>>
>>> I am writing crypto driver for hash MD5/SHA1/SHA256 on Exynos 4412,
>>> and I am facing some (minor?) difficulties. [...]
>
>>> So there is no [...] final method.
>>>
>>> It must be feeded with at least one message byte to produce hash.
>>>
>>> One more constrain is to process data in constant-sized chunks,
>>> here it is 64 bytes, the same as for AES block,
>>> i.e. it cannot stop and export state while in middle of block,
>>> example - if we feed 16 bytes, we must then feed 48 bytes
>>> to stop, but ideally we should feed it always 64 bytes. [...]
>>>
>>> Any suggestions ?
>>>
>>> Can i keep some bytes unfeeded from ahash_request
>>> and return -EINPROGRESS ?
>>> Should i set timer and copy rest bytes after some timeout,
>>> where no more requests are incoming ? Or not ? cause it is
>>> async mode ?
>>> can i wait for more requests for processing waiting one ?
>> Your two constraints are actually inter-related -
>>
>> If you can only feed the HW a constant size chunk, than indeed need to
>> keey bytes fed
>> to the driver the are below the chunk size in a software buffer, but
>> than you need the final()
>> method to feed these bytes (padded as needed) to the HW if they are
>> the last bytes
>>
>> Gilad
>
> HW will done padding
>
> I want to avoid memcpy iff possible for async hash

Why? you're talking about a copy of a single cache line at most.
That hardly seem worth the trouble.

Gilad

>
> --
> Best regards,
> Kamil Konieczny
> Samsung R&D Institute Poland



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
--
To unsubscribe from this list: send the line "unsubscribe linux-newbie" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at http://www.linux-learn.org/faqs
