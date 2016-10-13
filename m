From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH 3/6] crypto: ccp - Add support for RSA on the CCP
Date: Thu, 13 Oct 2016 15:08:41 -0500
Message-ID: <8b8ed058-6512-ab28-446b-3c32bf91fcb0@amd.com>
References: <20161013144542.19759.6924.stgit@taos>
 <20161013145309.19759.18493.stgit@taos> <1603902.uM94ZuZj0Q@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <thomas.lendacky@amd.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: Stephan Mueller <smueller@chronox.de>,
        Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0050.outbound.protection.outlook.com ([104.47.34.50]:33568
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757290AbcJMWqk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 18:46:40 -0400
In-Reply-To: <1603902.uM94ZuZj0Q@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/13/2016 01:25 PM, Stephan Mueller wrote:
> Am Donnerstag, 13. Oktober 2016, 09:53:09 CEST schrieb Gary R Hook:
>
> Hi Gary,
>
>> Wire up the v3 CCP as a cipher provider.
>>
>> Signed-off-by: Gary R Hook <gary.hook@amd.com>
>> ---
>>
>> ...snip...
>>
>> +}
>> +
>> +static void ccp_free_mpi_key(struct ccp_rsa_key *key)
>> +{
>> +	mpi_free(key->d);
>> +	key->d = NULL;
>> +	mpi_free(key->e);
>> +	key->e = NULL;
>> +	mpi_free(key->n);
>> +	key->n = NULL;
>> +}
>
> Could you please see whether that function can be turned into a common
> function call? crypto/rsa.c implements the same code in rsa_free_mpi_key.

I am happy to do so, but was unsure of protocol. rsa.c is in a module, which
makes my module depend upon another. I do not want to do that. And moving
this function elsewhere makes no sense.

I would go with an inline function, but there's no obvious place for it.
The RSA software implementation uses the MPI library, but there's no
requirement to do so (witness the qat driver). Thus, an inline function 
can't
be put in internal/rsa.h without moving the rsa_mpi_key definition and
referencing mpi.h.

I think that RSA+MPI things, such as rsa_mpi_key and this function, could go
into internal/rsa.h, but it would be necessary to #include mpi.h.

Or: create a new include file that contains these (and any other) RSA/MPI
amalgams.

Which would you prefer?

>> +
>> +static int ccp_check_key_length(unsigned int len)
>> +{
>> +	/* In bits */
>> +	if (len < 8 || len > 16384)
>> +		return -EINVAL;
>> +	return 0;
>> +}
>> +
>> +static void ccp_rsa_free_key_bufs(struct ccp_ctx *ctx)
>> +{
>> +	/* Clean up old key data */
>> +	kfree(ctx->u.rsa.e_buf);
>> +	ctx->u.rsa.e_buf = NULL;
>> +	ctx->u.rsa.e_len = 0;
>> +	kfree(ctx->u.rsa.n_buf);
>> +	ctx->u.rsa.n_buf = NULL;
>> +	ctx->u.rsa.n_len = 0;
>> +	kfree(ctx->u.rsa.d_buf);
>
> kzfree, please.

Of course. Done.

>>
>> ...snip...
>>
>> +}
>> +
>> +static struct akcipher_alg rsa = {
>> +	.encrypt = ccp_rsa_encrypt,
>> +	.decrypt = ccp_rsa_decrypt,
>> +	.sign = NULL,
>> +	.verify = NULL,
>> +	.set_pub_key = ccp_rsa_setpubkey,
>> +	.set_priv_key = ccp_rsa_setprivkey,
>> +	.max_size = ccp_rsa_maxsize,
>> +	.init = ccp_rsa_init_tfm,
>> +	.exit = ccp_rsa_exit_tfm,
>> +	.reqsize = sizeof(struct ccp_rsa_req_ctx),
>> +	.base = {
>> +		.cra_name = "rsa",
>> +		.cra_driver_name = "rsa-ccp",
>> +		.cra_priority = 100,
>
> Are you sure you want to leave it at 100? With this value, it will content
> with the C implementation.

No, I don't. Our other functions are at 300 (CCP_CRA_PRIORITY), which is 
what
this should be.

>
>> +		.cra_module = THIS_MODULE,
>> +		.cra_ctxsize = sizeof(struct ccp_ctx),
>> +	},
>> +};
>> +
>> ...snip...
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> Ciao
> Stephan
>

Thank you. I hope snipping is acceptable...

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
