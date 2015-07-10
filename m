From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH v2 6/7] crypto: omap-aes: Add support for GCM mode
Date: Fri, 10 Jul 2015 19:39:35 +0530
Message-ID: <559FD21F.2020903@ti.com>
References: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com> <1436283109-13318-7-git-send-email-lokeshvutla@ti.com> <20150708041838.GA12744@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>,
	<linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52427 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846AbbGJOMe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jul 2015 10:12:34 -0400
In-Reply-To: <20150708041838.GA12744@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On Wednesday 08 July 2015 09:48 AM, Herbert Xu wrote:
> On Tue, Jul 07, 2015 at 09:01:48PM +0530, Lokesh Vutla wrote:
>>
>> +static int omap_aes_gcm_copy_buffers(struct omap_aes_dev *dd,
>> +				     struct aead_request *req)

[..snip..]

>> +static int do_encrypt_iv(struct aead_request *req, u32 *tag)
>> +{
>> +	struct scatterlist iv_sg;
>> +	struct ablkcipher_request *ablk_req;
>> +	struct crypto_ablkcipher *tfm;
>> +	struct tcrypt_result result;
>> +	struct omap_aes_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
>> +	int ret = 0;
>> +
>> +	tfm = crypto_alloc_ablkcipher("ctr(aes)", 0, 0);
> 
> Ugh, you cannot allocate crypto transforms in the data path.  You
> should allocate it in init instead.  Also using ctr(aes) is overkill.
> Just use aes and do the xor by hand.
> 
>> +static int omap_aes_gcm_crypt(struct aead_request *req, unsigned long mode)
>> +{
>> +	struct omap_aes_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
>> +	struct omap_aes_reqctx *rctx = aead_request_ctx(req);
>> +	struct crypto_aead *aead = crypto_aead_reqtfm(req);
>> +	unsigned int authlen = crypto_aead_authsize(aead);
>> +	struct omap_aes_dev *dd;
>> +	__be32 counter = cpu_to_be32(1);
>> +	int err;
>> +
>> +	memset(ctx->auth_tag, 0, sizeof(ctx->auth_tag));
> 
> The ctx is shared memory and you must not write to it as multiple
> requests can be called on the same tfm.  Use rctx instead.

May be a dumb question. 
If you don't mind can you elaborate more on the usage of rctx and ctx
in the driver?

Thanks and regards,
Lokesh
> 
>> +	memcpy(req->iv + 12, &counter, 4);
> 
> The IV is only 12 bytes long so you're corrupting memory here.
> You should use rctx here too.
> 
>> +	if (req->assoclen + req->cryptlen == 0) {
>> +		scatterwalk_map_and_copy(ctx->auth_tag, req->dst, 0, authlen,
>> +					 1);
>> +		return 0;
>> +	}
> 
> How can this be right? Did you enable the selftest?
> 
> Cheers,
> 
