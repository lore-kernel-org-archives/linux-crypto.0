From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v1] crypto: ccp - Limit the amount of information exported
Date: Mon, 1 Feb 2016 16:18:44 -0600
Message-ID: <56AFD9C4.3030701@amd.com>
References: <20160129184514.10863.45404.stgit@tlendack-t1.amdoffice.net>
 <20160201143506.GC11410@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <stable@vger.kernel.org>,
	David Miller <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0085.outbound.protection.outlook.com ([207.46.100.85]:28000
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754034AbcBAWSw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 17:18:52 -0500
In-Reply-To: <20160201143506.GC11410@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/01/2016 08:35 AM, Herbert Xu wrote:
> On Fri, Jan 29, 2016 at 12:45:14PM -0600, Tom Lendacky wrote:
>> Since the exported information can be exposed to user-space, instead of
>> exporting the entire request context only export the minimum information
>> needed.
>>
>> Cc: <stable@vger.kernel.org> # 3.14.x-
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  drivers/crypto/ccp/ccp-crypto-aes-cmac.c |   16 +++++++++++-----
>>  drivers/crypto/ccp/ccp-crypto-sha.c      |   20 +++++++++++++++-----
>>  drivers/crypto/ccp/ccp-crypto.h          |   22 ++++++++++++++++++++++
>>  3 files changed, 48 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
>> index 00207cf..6a2d836 100644
>> --- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
>> +++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
>> @@ -223,9 +223,12 @@ static int ccp_aes_cmac_digest(struct ahash_request *req)
>>  static int ccp_aes_cmac_export(struct ahash_request *req, void *out)
>>  {
>>  	struct ccp_aes_cmac_req_ctx *rctx = ahash_request_ctx(req);
>> -	struct ccp_aes_cmac_req_ctx *state = out;
>> +	struct ccp_aes_cmac_exp_ctx *state = out;
>>  
>> -	*state = *rctx;
>> +	state->null_msg = rctx->null_msg;
>> +	memcpy(state->iv, rctx->iv, sizeof(state->iv));
>> +	state->buf_count = rctx->buf_count;
>> +	memcpy(state->buf, rctx->buf, sizeof(state->buf));
>>  
>>  	return 0;
>>  }
> 
> BTW this code needs to be fixed to not assume that in/out are
> aligned.
> 

Ugh, yeah I missed that.  I'll follow up with (yet) another patch
to be alignment safe.

Thanks,
Tom

> Cheers,
> 
