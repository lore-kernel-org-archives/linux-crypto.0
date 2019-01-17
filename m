Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:40928 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727449AbfAQCvP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jan 2019 21:51:15 -0500
Subject: Re: [PATCH 0/5] Crypto Cleanup
To: Eric Biggers <ebiggers@kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <broonie@kernel.org>, <ard.biesheuvel@linaro.org>,
        <jonathan.cameron@huawei.com>
References: <1547607034-40948-1-git-send-email-wangxiongfeng2@huawei.com>
 <20190116174949.GA152952@gmail.com>
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Message-ID: <62435a58-91fb-c48d-73f8-0b7634721924@huawei.com>
Date: Thu, 17 Jan 2019 10:50:08 +0800
MIME-Version: 1.0
In-Reply-To: <20190116174949.GA152952@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 2019/1/17 1:49, Eric Biggers wrote:
> On Wed, Jan 16, 2019 at 10:50:29AM +0800, Xiongfeng Wang wrote:
>> The patchset introduce a helper to (un)register a array of crypto templates.
>> The following patches use this helper to simplify the code. This is also
>> a preparation for a coming patchset, which will register several crypto
>> templates.
>>
>> Xiongfeng Wang (5):
>>   crypto: api - add a helper to (un)register a array of templates
>>   crypto: ccm - use template array registering API to simplify the code
>>   crypto: gcm - use template array registering API to simplify the code
>>   crypto: ctr - use template array registering API to simplify the code
>>   crypto: chacha20poly1305 - use template array registering API to
>>     simplify the code
>>
>>  crypto/algapi.c           | 27 ++++++++++++++++
>>  crypto/ccm.c              | 81 +++++++++++++++--------------------------------
>>  crypto/chacha20poly1305.c | 38 +++++++++-------------
>>  crypto/ctr.c              | 46 ++++++++++-----------------
>>  crypto/gcm.c              | 76 +++++++++++++++-----------------------------
>>  include/crypto/algapi.h   |  2 ++
>>  6 files changed, 113 insertions(+), 157 deletions(-)
>>
>> -- 
>> 1.7.12.4
>>
> 
> Hi Xiongfeng, I think this a useful cleanup but can you please rebase this onto
> cryptodev?  There is a conflict in crypto/ctr.c.

Hi Eric, thanks for your reply. I will change it in the next version.

Thanks,
Xiongfeng
> 
> - Eric
> 
> .
> 
