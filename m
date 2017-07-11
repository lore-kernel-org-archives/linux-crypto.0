From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: HELP writing crypto driver for HW with blocksize hash
Date: Tue, 11 Jul 2017 12:50:01 +0200
Message-ID: <6f26d70d-6222-a325-d66b-b00b3591f2ae@partner.samsung.com>
References: <CGME20170711075213eucas1p1816f12edc165dfe05cb791b155e6f658@eucas1p1.samsung.com>
 <09fb0bef-ee22-edff-c651-a81e3ee6a2ae@partner.samsung.com>
 <CAOtvUMf=CKjZPOi5m7DMzN10Ytd81v_qK3n6aTaCqP1gRMQ6Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-newbie@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56917 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755422AbdGKKuI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jul 2017 06:50:08 -0400
In-reply-to: <CAOtvUMf=CKjZPOi5m7DMzN10Ytd81v_qK3n6aTaCqP1gRMQ6Pg@mail.gmail.com>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11.07.2017 12:30, Gilad Ben-Yossef wrote:
> On Tue, Jul 11, 2017 at 10:52 AM, Kamil Konieczny
> <k.konieczny@partner.samsung.com> wrote:
>>
>>
>> I am writing crypto driver for hash MD5/SHA1/SHA256 on Exynos 4412,
>> and I am facing some (minor?) difficulties. [...]

>> So there is no [...] final method.
>>
>> It must be feeded with at least one message byte to produce hash.
>>
>> One more constrain is to process data in constant-sized chunks,
>> here it is 64 bytes, the same as for AES block,
>> i.e. it cannot stop and export state while in middle of block,
>> example - if we feed 16 bytes, we must then feed 48 bytes
>> to stop, but ideally we should feed it always 64 bytes. [...]
>>
>> Any suggestions ?
>>
>> Can i keep some bytes unfeeded from ahash_request
>> and return -EINPROGRESS ?
>> Should i set timer and copy rest bytes after some timeout,
>> where no more requests are incoming ? Or not ? cause it is
>> async mode ?
>> can i wait for more requests for processing waiting one ?
> Your two constraints are actually inter-related -
> 
> If you can only feed the HW a constant size chunk, than indeed need to
> keey bytes fed
> to the driver the are below the chunk size in a software buffer, but
> than you need the final()
> method to feed these bytes (padded as needed) to the HW if they are
> the last bytes
> 
> Gilad

HW will done padding

I want to avoid memcpy iff possible for async hash

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
