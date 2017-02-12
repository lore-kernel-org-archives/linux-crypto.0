From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: Re: [PATCH v7 0/5] Update LZ4 compressor module
Date: Sun, 12 Feb 2017 12:16:17 +0100
Message-ID: <1486898178-17125-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
References: <20170210001311.GA25078@bbox>
Cc: ebiggers3@gmail.com, akpm@linux-foundation.org,
        bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com
To: minchan@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:39315 "EHLO
        mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751153AbdBLLQl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Feb 2017 06:16:41 -0500
In-Reply-To: <20170210001311.GA25078@bbox>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>




On 02/10/2017 01:13 AM, Minchan Kim wrote:
> Hello Sven,
>
> On Thu, Feb 09, 2017 at 11:56:17AM +0100, Sven Schmidt wrote:
>> Hey Minchan,
>>
>> On Thu, Feb 09, 2017 at 08:31:21AM +0900, Minchan Kim wrote:
>>> Hello Sven,
>>>
>>> On Sun, Feb 05, 2017 at 08:09:03PM +0100, Sven Schmidt wrote:
>>>>
>>>> This patchset is for updating the LZ4 compression module to a version based
>>>> on LZ4 v1.7.3 allowing to use the fast compression algorithm aka LZ4 fast
>>>> which provides an "acceleration" parameter as a tradeoff between
>>>> high compression ratio and high compression speed.
>>>>
>>>> We want to use LZ4 fast in order to support compression in lustre
>>>> and (mostly, based on that) investigate data reduction techniques in behalf of
>>>> storage systems.
>>>>
>>>> Also, it will be useful for other users of LZ4 compression, as with LZ4 fast
>>>> it is possible to enable applications to use fast and/or high compression
>>>> depending on the usecase.
>>>> For instance, ZRAM is offering a LZ4 backend and could benefit from an updated
>>>> LZ4 in the kernel.
>>>>
>>>> LZ4 homepage: http://www.lz4.org/
>>>> LZ4 source repository: https://github.com/lz4/lz4
>>>> Source version: 1.7.3
>>>>
>>>> Benchmark (taken from [1], Core i5-4300U @1.9GHz):
>>>> ----------------|--------------|----------------|----------
>>>> Compressor      | Compression  | Decompression  | Ratio
>>>> ----------------|--------------|----------------|----------
>>>> memcpy          |  4200 MB/s   |  4200 MB/s     | 1.000
>>>> LZ4 fast 50     |  1080 MB/s   |  2650 MB/s     | 1.375
>>>> LZ4 fast 17     |   680 MB/s   |  2220 MB/s     | 1.607
>>>> LZ4 fast 5      |   475 MB/s   |  1920 MB/s     | 1.886
>>>> LZ4 default     |   385 MB/s   |  1850 MB/s     | 2.101
>>>>
>>>> [1] http://fastcompression.blogspot.de/2015/04/sampling-or-faster-lz4.html
>>>>
>>>> [PATCH 1/5] lib: Update LZ4 compressor module
>>>> [PATCH 2/5] lib/decompress_unlz4: Change module to work with new LZ4 module version
>>>> [PATCH 3/5] crypto: Change LZ4 modules to work with new LZ4 module version
>>>> [PATCH 4/5] fs/pstore: fs/squashfs: Change usage of LZ4 to work with new LZ4 version
>>>> [PATCH 5/5] lib/lz4: Remove back-compat wrappers
>>>
>>> Today, I did zram-lz4 performance test with fio in current mmotm and
>>> found it makes regression about 20%.
>>>
>>> "lz4-update" means current mmots(git://git.cmpxchg.org/linux-mmots.git) so
>>> applied your 5 patches. (But now sure current mmots has recent uptodate
>>> patches)
>>> "revert" means I reverted your 5 patches in current mmots.
>>>
>>>                      revert    lz4-update
>>>
>>>       seq-write       1547       1339      86.55%
>>>      rand-write      22775      19381      85.10%
>>>        seq-read       7035       5589      79.45%
>>>       rand-read      78556      68479      87.17%
>>>    mixed-seq(R)       1305       1066      81.69%
>>>    mixed-seq(W)       1205        984      81.66%
>>>   mixed-rand(R)      17421      14993      86.06%
>>>   mixed-rand(W)      17391      14968      86.07%
>>
>> which parts of the output (as well as units) are these values exactly?
>> I did not work with fio until now, so I think I might ask before misinterpreting my results.
>
> It is IOPS.
>
>>  
>>> My fio description file
>>>
>>> [global]
>>> bs=4k
>>> ioengine=sync
>>> size=100m
>>> numjobs=1
>>> group_reporting
>>> buffer_compress_percentage=30
>>> scramble_buffers=0
>>> filename=/dev/zram0
>>> loops=10
>>> fsync_on_close=1
>>>
>>> [seq-write]
>>> bs=64k
>>> rw=write
>>> stonewall
>>>
>>> [rand-write]
>>> rw=randwrite
>>> stonewall
>>>
>>> [seq-read]
>>> bs=64k
>>> rw=read
>>> stonewall
>>>
>>> [rand-read]
>>> rw=randread
>>> stonewall
>>>
>>> [mixed-seq]
>>> bs=64k
>>> rw=rw
>>> stonewall
>>>
>>> [mixed-rand]
>>> rw=randrw
>>> stonewall
>>>
>>
>> Great, this makes it easy for me to reproduce your test.
>
> If you have trouble to reproduce, feel free to ask me. I'm happy to test it. :)
>
> Thanks!
>

Hi Minchan,

I will send an updated patch as a reply to this E-Mail. Would be really grateful If you'd test it and provide feedback!
The patch should be applied to the current mmots tree.

In fact, the updated LZ4 _is_ slower than the current one in kernel. But I was not able to reproduce such large regressions
as you did. I now tried to define FORCE_INLINE as Eric suggested. I also inlined some functions which weren't in upstream LZ4,
but are defined as macros in the current kernel LZ4. The approach to replace LZ4_ARCH64 with the function call _seemed_ to behave
worse than the macro, so I withdrew the change.

The main difference is, that I replaced the read32/read16/write... etc. functions using memcpy with the other ones defined 
in upstream LZ4 (which can be switched using a macro). 
The comment of the author stated, that they're as fast as the memcpy variants (or faster), but not as portable
(which does not matter since we're not dependent for multiple compilers).

In my tests, this version is mostly as fast as the current kernel LZ4.

Thank you!

Sven
