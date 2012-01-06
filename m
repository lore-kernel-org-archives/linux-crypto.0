From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [PATCH 1/1] Added CRYPTO_ALG_KERN_DRIVER_ONLY flag (3rd attempt)
Date: Fri, 06 Jan 2012 09:19:01 +0100
Message-ID: <4F06AE75.9050806@gnutls.org>
References: <20120106013701.GA6484@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34245 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab2AFIPK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jan 2012 03:15:10 -0500
Received: by eekc4 with SMTP id c4so879490eek.19
        for <linux-crypto@vger.kernel.org>; Fri, 06 Jan 2012 00:15:09 -0800 (PST)
In-Reply-To: <20120106013701.GA6484@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/06/2012 02:37 AM, Herbert Xu wrote:

> Nikos Mavrogiannopoulos <nmav@gnutls.org> wrote:
>> The added CRYPTO_ALG_KERN_DRIVER_ONLY indicates whether a cipher
>> is only available via a kernel driver. If the cipher implementation
>> might be available by using an instruction set or by porting the
>> kernel code, then it must not be set.
[...]
>> +static inline u32 crypto_tfm_alg_flags(struct crypto_tfm *tfm)
>> +{
>> +       return tfm->__crt_alg->cra_flags;
>> +}
>> +
> Who is going to use this? For one it's not type-safe as we try
> to avoid directly using crypto_tfm in kernel code.


I needed this function in order to access the new flag without
relying on the structure format. The available crypto_tfm_alg_type() 
would apply a mask and remove it, thus I added this function.

regards,
Nikos
