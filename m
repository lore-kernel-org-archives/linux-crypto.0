Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E40B6
	for <linux-crypto@vger.kernel.org>; Sun,  3 Dec 2023 19:28:07 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Vxhh90d_1701660484;
Received: from 30.97.49.36(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vxhh90d_1701660484)
          by smtp.aliyun-inc.com;
          Mon, 04 Dec 2023 11:28:05 +0800
Message-ID: <275f025d-e2f1-eaff-6af1-e909d370cee0@linux.alibaba.com>
Date: Mon, 4 Dec 2023 11:28:02 +0800
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
 <649a3bc4-58bb-1dc8-85fb-a56e47b3d5c9@linux.alibaba.com>
 <CAD14+f1u6gnHLhGSoQxL9wLq9vDYse+Ac8zxep-O2E8hHreT2w@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAD14+f1u6gnHLhGSoQxL9wLq9vDYse+Ac8zxep-O2E8hHreT2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2023/12/4 01:32, Juhyung Park wrote:
> Hi Gao,

...

>>>
>>>>
>>>> What is the difference between these two machines? just different CPU or
>>>> they have some other difference like different compliers?
>>>
>>> I fully and exclusively control both devices, and the setup is almost the same.
>>> Same Ubuntu version, kernel/compiler version.
>>>
>>> But as I said, on my laptop, the issue happens on kernels that someone
>>> else (Canonical) built, so I don't think it matters.
>>
>> The only thing I could say is that the kernel side has optimized
>> inplace decompression compared to fuse so that it will reuse the
>> same buffer for decompression but with a safe margin (according to
>> the current lz4 decompression implementation).  It shouldn't behave
>> different just due to different CPUs.  Let me find more clues
>> later, also maybe we should introduce a way for users to turn off
>> this if needed.
> 
> Cool :)
> 
> I'm comfortable changing and building my own custom kernel for this
> specific laptop. Feel free to ask me to try out some patches.

Thanks, I need to narrow down this issue:

-  First, could you apply the following diff to test if it's still
    reproducable?

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 021be5feb1bc..40a306628e1a 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -131,7 +131,7 @@ static void *z_erofs_lz4_handle_overlap(struct z_erofs_lz4_decompress_ctx *ctx,

  	if (rq->inplace_io) {
  		omargin = PAGE_ALIGN(ctx->oend) - ctx->oend;
-		if (rq->partial_decoding || !may_inplace ||
+		if (1 || rq->partial_decoding || !may_inplace ||
  		    omargin < LZ4_DECOMPRESS_INPLACE_MARGIN(rq->inputsize))
  			goto docopy;

- Could you share the full message about the output of `lscpu`?

Thanks,
Gao Xiang
