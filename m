From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC 2/2] [crypto] make the crypto subsystem fully modular
Date: Fri, 28 Mar 2008 23:23:54 +0100
Message-ID: <20080328222354.GA24018@Chamillionaire.breakpoint.cc>
References: <20080105123637.GA12561@Chamillionaire.breakpoint.cc> <E1JB8IB-0003Pt-Kk@Chamillionaire.breakpoint.cc> <20080324123559.GA7097@gondor.apana.org.au>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51156 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbYC1WX5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Mar 2008 18:23:57 -0400
Content-Disposition: inline
In-Reply-To: <20080324123559.GA7097@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-03-24 20:35:59 [+0800]:

>On Sat, Jan 05, 2008 at 01:36:37PM +0100, Sebastian Siewior wrote:
>>
>> diff --git a/crypto/api.c b/crypto/api.c
>> index a2496d1..0a0f41e 100644
>> --- a/crypto/api.c
>> +++ b/crypto/api.c
>> @@ -445,3 +445,6 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(crypto_has_alg);
>> +
>> +MODULE_DESCRIPTION("Cryptographic core API");
>> +MODULE_LICENSE("GPL");
>
>Could you please add an exit handler? That way we can unload the
>module which is probably the most important application of this.
We can do this allready because we don't have an init function.

Sebastian
