From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH 4/8] crypto: rsa-pkcs1pad - Require hash to be present
Date: Wed, 22 Jun 2016 08:39:09 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1606220813200.16013@mjmartin-mac01.local>
References: <20160622101432.GA30454@gondor.apana.org.au> <E1bFfDK-0007yq-FV@gondolin.me.apana.org.au> <CAOq732+p7M5Cn2mPnbN3H3tkxvjf_UkKqQSR+eceBp4-CJYh-w@mail.gmail.com> <20160622140225.GA315@gondor.apana.org.au> <576A9E64.2020209@gmail.com>
 <20160622142050.GA540@gondor.apana.org.au> <576AA0F4.2020605@gmail.com> <20160622143341.GA747@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: Denis Kenzior <denkenz@gmail.com>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, dhowells@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56792 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbcFVPjQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 11:39:16 -0400
In-Reply-To: <20160622143341.GA747@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Herbert,

On Wed, 22 Jun 2016, Herbert Xu wrote:

> On Wed, Jun 22, 2016 at 09:30:12AM -0500, Denis Kenzior wrote:
>>
>> We live on the bleeding edge :)
>>
>> I realize that these features are not upstream yet, but that doesn't
>> mean that we can't influence / see the direction that the kernel is
>> taking and act accordingly.
>>
>> We'd like to have both pkcs1pad + hash, and simple pkcs1pad go
>> upstream.  That will make our job in userspace much easier.  Andrew
>> submitted pkcs1pad transform to the kernel specifically so we could
>> get rid of this logic in our userspace code.  So please consider
>> leaving both versions for upstream inclusion.
>
> Sorry but the crypto API isn't a repository for general algorithms.
> It's first and foremost a place for algorithms that we use in the
> kernel.
>
> The user-space interface (if we ever add one for akcipher, right now
> there are strong objections against it) is mainly there to allow
> access to hardware accelerators.  So I'm afraid I cannot keep the
> hashless pkcs1pad until such a time that either we have a kernel
> user for it or there is a piece of hardware implementing it.

David Howells has a keyctl patch set in progress that makes use of 
pkcs1pad, with or without a hash:

https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/commit/?h=keys-asym-keyctl&id=6fe3b4aa7df524f4867868b01d4cb4345b1bf2de

Please leave the non-hash code in, or consider deferring this patch until 
we can also discuss the issue at the upcoming security summit. We've been 
having a lot of trouble getting agreement on userspace access to 
asymmetric ciphers and I think we could make some progress with in-person 
discussion. (Mailing list discussion is also important because not 
everyone concerned can attend the summit)


Thanks,

--
Mat Martineau
Intel OTC
