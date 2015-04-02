From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH] crypto: omap-sham: Check for HIGHMEM before mapping SG
 pages
Date: Thu, 2 Apr 2015 15:30:46 +0530
Message-ID: <551D134E.9020504@ti.com>
References: <1427775745-4674-1-git-send-email-lokeshvutla@ti.com> <20150401141814.GA28592@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <t-kristo@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <20150401141814.GA28592@gondor.apana.org.au>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,
On Wednesday 01 April 2015 07:48 PM, Herbert Xu wrote:
> On Tue, Mar 31, 2015 at 09:52:23AM +0530, Lokesh Vutla wrote:
>> Commit 26a05489ee0e ("crypto: omap-sham - Map SG pages if they are HIGHMEM before accessing")
>> says that HIGHMEM pages may not be mapped so we must
>> kmap them before accessing, but it doesn't check whether the
>> corresponding page is in highmem or not. Because of this all
>> the crypto tests are failing.
>>
>> 00000000: d9 a1 1b 7c aa 90 3b aa 11 ab cb 25 00 b8 ac bf
>> [    2.338169] 00000010: c1 39 cd ff 48 d0 a8 e2 2b fa 33 a1
>> [    2.344008] alg: hash: Chunking test 1 failed for omap-sha256
>>
>> So Checking for HIGHMEM before mapping SG pages.
>>
>> Fixes: 26a05489ee0 ("crypto: omap-sham - Map SG pages if they are HIGHMEM before accessing")
>> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
>> ---
>>  drivers/crypto/omap-sham.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
>> index 3c76696..ace5852 100644
>> --- a/drivers/crypto/omap-sham.c
>> +++ b/drivers/crypto/omap-sham.c
>> @@ -639,13 +639,17 @@ static size_t omap_sham_append_sg(struct omap_sham_reqctx *ctx)
>>  	const u8 *vaddr;
>>  
>>  	while (ctx->sg) {
>> -		vaddr = kmap_atomic(sg_page(ctx->sg));
>> +		if (PageHighMem(sg_page(ctx->sg)))
>> +			vaddr = kmap_atomic(sg_page(ctx->sg));
>> +		else
>> +			vaddr = sg_virt(ctx->sg);
> 
> This is completely bogus.  kmap_atomic should be identical to
> sg_virt(sg_page()) for the lowmem case.
> 
> So either your architecture is broken (because the same problem
> would obviously affect the core crypto code which does exactly
> the same thing), or there is some other bug causing the selftest
> to fail.
Oops my bad. You are right.
Here the problem is sg->offset is not being added to vaddr.
sg_virt gives page address + sg->offset but
kmap_atomic gives only the page address.

Ill update and repost the patch.

Thanks and regards,
Lokesh
> 
> Cheers,
> 

