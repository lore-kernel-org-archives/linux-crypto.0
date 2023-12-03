Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28363C8
	for <linux-crypto@vger.kernel.org>; Sun,  3 Dec 2023 09:22:02 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VxgQUtK_1701624118;
Received: from 30.27.123.200(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VxgQUtK_1701624118)
          by smtp.aliyun-inc.com;
          Mon, 04 Dec 2023 01:22:00 +0800
Message-ID: <649a3bc4-58bb-1dc8-85fb-a56e47b3d5c9@linux.alibaba.com>
Date: Mon, 4 Dec 2023 01:21:58 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: Weird EROFS data corruption
To: Juhyung Park <qkrwngud825@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org,
 Yann Collet <yann.collet.73@gmail.com>
References: <CAD14+f2AVKf8Fa2OO1aAUdDNTDsVzzR6ctU_oJSmTyd6zSYR2Q@mail.gmail.com>
 <5a0e8b44-6feb-b489-cdea-e3be3811804a@linux.alibaba.com>
 <CAD14+f2G-buxTaWgb23DYW-HSd1sch6tJNKV2strt=toASZXQQ@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAD14+f2G-buxTaWgb23DYW-HSd1sch6tJNKV2strt=toASZXQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2023/12/4 01:01, Juhyung Park wrote:
> Hi Gao,
> 
> On Mon, Dec 4, 2023 at 1:52 AM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>> Hi Juhyung,
>>
>> On 2023/12/4 00:22, Juhyung Park wrote:
>>> (Cc'ing f2fs and crypto as I've noticed something similar with f2fs a
>>> while ago, which may mean that this is not specific to EROFS:
>>> https://lore.kernel.org/all/CAD14+f2nBZtLfLC6CwNjgCOuRRRjwzttp3D3iK4Of+1EEjK+cw@mail.gmail.com/
>>> )
>>>
>>> Hi.
>>>
>>> I'm encountering a very weird EROFS data corruption.
>>>
>>> I noticed when I build an EROFS image for AOSP development, the device
>>> would randomly not boot from a certain build.
>>> After inspecting the log, I noticed that a file got corrupted.
>>
>> Is it observed on your laptop (i7-1185G7), yes? or some other arm64
>> device?
> 
> Yes, only on my laptop. The arm64 device seems fine.
> The reason that it would not boot was that the host machine (my
> laptop) was repacking the EROFS image wrongfully.
> 
> The workflow is something like this:
> Server-built EROFS AOSP image -> Image copied to laptop -> Laptop
> mounts the EROFS image -> Copies the entire content to a scratch
> directory (CORRUPT!) -> Changes some files -> mkfs.erofs
> 
> So the device is not responsible for the corruption, the laptop is.

Ok.

> 
>>
>>>
>>> After adding a hash check during the build flow, I noticed that EROFS
>>> would randomly read data wrong.
>>>
>>> I now have a reliable method of reproducing the issue, but here's the
>>> funny/weird part: it's only happening on my laptop (i7-1185G7). This
>>> is not happening with my 128 cores buildfarm machine (Threadripper
>>> 3990X).>
>>> I first suspected a hardware issue, but:
>>> a. The laptop had its motherboard replaced recently (due to a failing
>>> physical Type-C port).
>>> b. The laptop passes memory test (memtest86).
>>> c. This happens on all kernel versions from v5.4 to the latest v6.6
>>> including my personal custom builds and Canonical's official Ubuntu
>>> kernels.
>>> d. This happens on different host SSDs and file-system combinations.
>>> e. This only happens on LZ4. LZ4HC doesn't trigger the issue.
>>> f. This only happens when mounting the image natively by the kernel.
>>> Using fuse with erofsfuse is fine.
>>
>> I think it's a weird issue with inplace decompression because you said
>> it depends on the hardware.  In addition, with your dataset sadly I
>> cannot reproduce on my local server (Xeon(R) CPU E5-2682 v4).
> 
> As I feared. Bummer :(
> 
>>
>> What is the difference between these two machines? just different CPU or
>> they have some other difference like different compliers?
> 
> I fully and exclusively control both devices, and the setup is almost the same.
> Same Ubuntu version, kernel/compiler version.
> 
> But as I said, on my laptop, the issue happens on kernels that someone
> else (Canonical) built, so I don't think it matters.

The only thing I could say is that the kernel side has optimized
inplace decompression compared to fuse so that it will reuse the
same buffer for decompression but with a safe margin (according to
the current lz4 decompression implementation).  It shouldn't behave
different just due to different CPUs.  Let me find more clues
later, also maybe we should introduce a way for users to turn off
this if needed.

Thanks,
Gao Xiang
