From: Li Kun <hw.likun@huawei.com>
Subject: Re: [PATCH] crypto: af_alg - add keylen checking to avoid NULL ptr
 passing down
Date: Mon, 18 Dec 2017 21:34:05 +0800
Message-ID: <62ca2507-464f-d1b5-8c79-8de6df79b7de@huawei.com>
References: <1513595363-27577-1-git-send-email-hw.likun@huawei.com>
 <20171218120009.GA8328@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>, <stable@vger.kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171218120009.GA8328@kroah.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



在 2017/12/18 20:00, Greg KH 写道:
> On Mon, Dec 18, 2017 at 11:09:23AM +0000, Li Kun wrote:
>> alg_setkey do not check the keylen whether it is zero, so the key
>> may be ZERO_SIZE_PTR when keylen is 0, which will pass the
>> copy_from_user's checking and be passed to the lower functions as key.
>>
>> If the lower functions only check the key if it is NULL, ZERO_SIZE_PTR
>> will pass the checking, and will cause null ptr dereference, so it's
>> better to intercept the invalid parameters in the upper functions.
>>
>> This patch is also suitable to fix CVE-2017-15116 for stable trees.
>>
>> Signed-off-by: Li Kun <hw.likun@huawei.com>
>> ---
>>   crypto/af_alg.c | 2 ++
>>   1 file changed, 2 insertions(+)
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
sorry, i will resend this patch with "Cc: stable@vger.kernel.org"
>
> </formletter>

-- 
Best Regards
Li Kun
