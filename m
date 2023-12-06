Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900121AA
	for <linux-crypto@vger.kernel.org>; Tue,  5 Dec 2023 19:11:42 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VxwR.Im_1701832298;
Received: from 30.97.48.248(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VxwR.Im_1701832298)
          by smtp.aliyun-inc.com;
          Wed, 06 Dec 2023 11:11:40 +0800
Message-ID: <4df2694d-5675-2baf-5825-55730a49e1b0@linux.alibaba.com>
Date: Wed, 6 Dec 2023 11:11:37 +0800
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
 <275f025d-e2f1-eaff-6af1-e909d370cee0@linux.alibaba.com>
 <CAD14+f3zgwgUugjnB7UGCYh4j3iXYsvv_DJ3yvwduA1xf3xn=A@mail.gmail.com>
 <d7c7ea8c-6e2f-e8d8-88c3-4952c506ed13@linux.alibaba.com>
 <CAD14+f2hPLv6RPZdYyi8q8SQGiBox2fYUaWwuBEjEbZKQdyU7g@mail.gmail.com>
 <8597c64c-d26a-8073-9d00-b629bbb0ee33@linux.alibaba.com>
 <CAD14+f0PJiKVToxH6oULL6KuKqbKN+j6rcdwh7dpH8dHNZz42A@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAD14+f0PJiKVToxH6oULL6KuKqbKN+j6rcdwh7dpH8dHNZz42A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Juhyung,

On 2023/12/5 22:43, Juhyung Park wrote:
> On Tue, Dec 5, 2023 at 11:34 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>

...

>>
>> I'm still analyzing this behavior as well as the root cause and
>> I will also try to get a recent cloud server with FSRM myself
>> to find more clues.
> 
> Down the rabbit hole we go...
> 
> Let me know if you have trouble getting an instance with FSRM. I'll
> see what I can do.

I've sent out a fix to address this, please help check:
https://lore.kernel.org/r/20231206030758.3760521-1-hsiangkao@linux.alibaba.com

Thanks,
Gao Xiang
