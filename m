From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH  v2 3/3] crypto: qat - Add support for RSA algorithm
Date: Wed, 15 Jul 2015 08:05:35 -0700
Message-ID: <55A676BF.3090500@intel.com>
References: <20150714183243.18949.93255.stgit@tstruk-mobl1> <20150714183259.18949.581.stgit@tstruk-mobl1> <20150715130333.GA2006@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3302 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbbGOPGK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2015 11:06:10 -0400
In-Reply-To: <20150715130333.GA2006@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/15/2015 06:03 AM, Herbert Xu wrote:
>> +		ctx->fallback = crypto_alloc_akcipher("rsa-generic", 0, 0);
> You need to set CRYPTO_ALG_NEED_FALLBACK in the mask here.  You
> should also set it in your cra_flags.  Then you can have rsa here
> instead of rsa-generic.
> 
> There is also an issue with reqsize since your fallback's reqsize
> may be bigger than yours.  You'll need to change akcipher first
> to move the reqsize field into crypto_akcipher.  Then you can
> set the reqsize here.

This is even more complicated because the user can first allocate request
and then call setkey causing fallback. I'm now thinking about adding the
limitation to rsa generic or I can still use rsa-generic which I know that
its ctx is smaller than mine. What do you think?

> 
>> > +	ret = mpi_read_buffer(pkey->n, ctx->n, ctx->key_sz, &len, NULL);
>> > +	if (ret)
>> > +		goto free_d;
> Huh? Why are you converting in and out of MPI? If the hardware wants
> raw integers, then you should just give the raw numbers to it.

The rsa_parse_key helper in the rsa generic that parses the key in BER format
produces the MPIs.I didn't want to add yet another BER parser here. Should I?
