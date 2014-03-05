From: "Fernandes, Joel" <joelf@ti.com>
Subject: Re: [PATCH v2] crypto: omap-sham: kmap SG pages before appending
Date: Wed, 5 Mar 2014 04:18:12 +0000
Message-ID: <39412163-4B61-4490-ABC8-5BA633CC6618@ti.com>
References: <1393957854-10961-1-git-send-email-joelf@ti.com>,<20140305015953.GA20702@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Vutla, Lokesh" <lokeshvutla@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53471 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbaCEEST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Mar 2014 23:18:19 -0500
In-Reply-To: <20140305015953.GA20702@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> On Mar 4, 2014, at 8:00 PM, "Herbert Xu" <herbert@gondor.apana.org.au> wrote:
> 
>> On Tue, Mar 04, 2014 at 12:30:54PM -0600, Joel Fernandes wrote:
>> HIGHMEM pages may not be mapped so we must kmap them before accessing.
>> This resolves a random OOPs error that was showing up during OpenSSL SHA tests.
>> 
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> ---
>> v2 changes:
>>    - don't check for HIGHMEM, kmap/kunmap do them anyway (Thanks Herbert).
>> 
>> drivers/crypto/omap-sham.c |    8 +++++++-
>> 1 file changed, 7 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
>> index e45aaaf..207eac1 100644
>> --- a/drivers/crypto/omap-sham.c
>> +++ b/drivers/crypto/omap-sham.c
>> @@ -636,11 +636,17 @@ static size_t omap_sham_append_buffer(struct omap_sham_reqctx *ctx,
>> static size_t omap_sham_append_sg(struct omap_sham_reqctx *ctx)
>> {
>>    size_t count;
>> +    const u8 *vaddr;
>> 
>>    while (ctx->sg) {
>> +        vaddr = kmap(sg_page(ctx->sg));
> 
> Are you sure you can safely use kmap here as opposed to kmap_atomic?

Yes I made sure it is not called in interrupt context and also tested the patch.

Regards,
-Joel

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
