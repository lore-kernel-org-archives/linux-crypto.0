From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH V2 6/9] crypto: ccp - Add support for RSA on the CCP
Date: Tue, 15 Nov 2016 15:42:29 -0600
Message-ID: <3152c3e0-636e-e4b8-1b99-957f590e3a0b@amd.com>
References: <20161104160140.18155.75618.stgit@taos>
 <20161104160432.18155.29136.stgit@taos>
 <20161113093930.GA7299@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <thomas.lendacky@amd.com>,
        <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0083.outbound.protection.outlook.com ([104.47.33.83]:23147
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752308AbcKOVmm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Nov 2016 16:42:42 -0500
In-Reply-To: <20161113093930.GA7299@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/13/2016 03:39 AM, Herbert Xu wrote:
> On Fri, Nov 04, 2016 at 11:04:32AM -0500, Gary R Hook wrote:
>>
>> +	ctx->u.rsa.pkey.e = mpi_read_raw_data(raw_key.e, raw_key.e_sz);
>> +	if (!ctx->u.rsa.pkey.e)
>> +		goto e_ret;
>> +	ctx->u.rsa.e_buf = mpi_get_buffer(ctx->u.rsa.pkey.e,
>> +					  &ctx->u.rsa.e_len, NULL);
>
> You're converting a raw integer into an MPI and then back again.
> Why?
>
> In general drivers shouldn't touch the MPI stuff at all since the
> hardware generally deals with raw integers.

D'oh! Yes, I see now what I missed before.

I will send out another patch set.

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
