From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] crypto: ccp - Reduce stack frame size with KASAN
Date: Tue, 28 Mar 2017 17:03:40 +0200
Message-ID: <CAK8P3a3tmjRJzd-ng3U0YF1zrwGg8+zW8CF2zj4=NN3XzH3fDw@mail.gmail.com>
References: <20170328095814.3734615-1-arnd@arndb.de> <f04b2ede-f291-2ffa-d4a8-124d4af06199@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:35579 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbdC1PEB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 11:04:01 -0400
In-Reply-To: <f04b2ede-f291-2ffa-d4a8-124d4af06199@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 28, 2017 at 4:15 PM, Gary R Hook <ghook@amd.com> wrote:

>> A more drastic refactoring of the driver might be needed to reduce the
>> stack usage more substantially, but this patch is fairly simple and
>> at least addresses the third one of the problems I mentioned, reducing the
>> stack size by about 150 bytes and bringing it below the warning limit
>> I picked.
>
>
> Again, I'll devote some time to this.
>
>> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
>> index 3a45c2af2fbd..c5ea0796a891 100644
>> --- a/drivers/crypto/ccp/ccp-dev.h
>> +++ b/drivers/crypto/ccp/ccp-dev.h
>> @@ -432,24 +432,24 @@ struct ccp_dma_info {
>>          unsigned int offset;
>>          unsigned int length;
>>          enum dma_data_direction dir;
>> -};
>> +} __packed __aligned(4);
>
>
> My gcc 4.8 doesn't understand __aligned(). Shouldn't we use
> #pragma(4) here?



>>  struct ccp_dm_workarea {
>>          struct device *dev;
>>          struct dma_pool *dma_pool;
>> -       unsigned int length;
>>
>>          u8 *address;
>>          struct ccp_dma_info dma;
>> +       unsigned int length;
>>  };
>>
>>  struct ccp_sg_workarea {
>>          struct scatterlist *sg;
>>          int nents;
>> +       unsigned int dma_count;
>>
>>          struct scatterlist *dma_sg;
>>          struct device *dma_dev;
>> -       unsigned int dma_count;
>>          enum dma_data_direction dma_dir;
>>
>>          unsigned int sg_used;
>
>
> I'm okay with rearranging, but I'm going to submit an alternative patch.

Ok, thanks a lot!
