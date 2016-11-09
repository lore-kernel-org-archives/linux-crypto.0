From: yjin <yanjiang.jin@windriver.com>
Subject: Re: [PATCH] crypto: rsa: rename two rsa key files
Date: Wed, 9 Nov 2016 14:39:57 +0800
Message-ID: <5822C4BD.7030706@windriver.com>
References: <20161108120900.GA5267@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <jinyanjiang@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161108120900.GA5267@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Thanks for Herbert's reminder.
I have drop this patch in a previous mail.

Regards!
Yanjiang

On 2016年11月08日 20:09, Herbert Xu wrote:
> yanjiang.jin@windriver.com wrote:
>> From: Yanjiang Jin <yanjiang.jin@windriver.com>
>>
>> This is to eliminate the below compile error:
>>
>> crypto/rsa_helper.c:19:29: fatal error: rsaprivkey-asn1.h: No such file or directory
>> #include "rsaprivkey-asn1.h"
>>                              ^
>> compilation terminated.
>>
>> Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>
> This patch is bogus.  The header files are meant to be generated.
> Please find out why they are not being generated in your case.
>
> Thanks,
