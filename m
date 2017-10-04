From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: Re: [PATCH 2/2] MIPS: crypto: Add crc32 and crc32c hw accelerated
 module
Date: Wed, 4 Oct 2017 09:49:06 +0200
Message-ID: <057939a9-a17e-f304-44af-c7c0e3ada21e@imgtec.com>
References: <1506514716-29470-1-git-send-email-marcin.nowakowski@imgtec.com>
 <1506514716-29470-3-git-send-email-marcin.nowakowski@imgtec.com>
 <20170929213451.GB24591@jhogan-linux.le.imgtec.org>
 <CAOiHx=kMH+ujTw2myQ0uR3DxHnsBsmaGtmeVniGNf7VHytTa6g@mail.gmail.com>
 <7d9d2e3a-a78f-bbb6-f957-1419473fb90e@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Jonas Gorski <jonas.gorski@gmail.com>,
        James Hogan <james.hogan@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:63350 "EHLO
        mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdJDHtJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Oct 2017 03:49:09 -0400
In-Reply-To: <7d9d2e3a-a78f-bbb6-f957-1419473fb90e@imgtec.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James,

On 03.10.2017 08:38, Marcin Nowakowski wrote:

>>>
>>> The need for 64-bit signed length is unfortunate. Do you get decent
>>> assembly and comparable/better performance on 32-bit if you just use len
>>> and only decrement it in the loops? i.e.
>>>
>>> -       while ((length -= sizeof(uXX)) >= 0) {
>>> +       while (len >= sizeof(uXX)) {
>>>                  register uXX value = get_unaligned_leXX(p);
>>>
>>>                  CRC32(crc, value, XX);
>>>                  p += sizeof(uXX);
>>> +               len -= sizeof(uXX);
>>>          }
>>>
>>> That would be more readable too IMHO.
>>
>> or maybe just do some pointer arithmetic like
>>
>>    const u8 *end = p + len;
>>
>>    while ((end - p) >= sizeof(uXX)) {
>>             register uXX value = get_unaligned_leXX(p);
>>
>>             CRC32(crc, value, XX);
>>             p += sizeof(uXX);
>>    }
> 
> Thank you both for these suggestions. All solutions are very similar in 
> terms of the assembly produced, although the original code is the 
> smallest of all:
> 
> original vs James':
> crc32_mips_le_hw                             104     132     +28
> vermagic                                      72      78      +6
> chksumc_finup                                 40      44      +4
> chksumc_digest                                44      48      +4
> chksum_finup                                  92      96      +4
> chksum_digest                                100     104      +4
> 
> original vs Jonas':
> add/remove: 0/0 grow/shrink: 7/0 up/down: 90/0 (90)
> function                                     old     new   delta
> crc32_mips_le_hw                             104     148     +44
> vermagic                                      72      78      +6
> chksumc_finup                                 40      44      +4
> chksumc_digest                                44      48      +4
> chksum_finup                                  92      96      +4
> chksum_digest                                100     104      +4
> 
> 
> However - the key thing which is the processing loop is 6 instructions 
> long in all variants. It's only the pre/post loop processing that adds 
> the extra instructions so all these solutions should be roughly equal in 
> terms of performance.
> I find James' code a bit more readable so I'll go with it and post an 
> updated patch.
> 

The comparisons above were for 64-bit, where the difference is 
negligible. On 32-bit builds, however, the difference is more significant:

original vs James':

function                                     old     new   delta
vermagic                                      80      86      +6
crc32c_mips_le_hw                            144     104     -40
crc32_mips_le_hw                             144     104     -40

and the main crc loop is down from 9 to 5 instructions, so it's a 
significant reduction of the loop size.

Marcin
