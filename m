From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/8] crypto: rsa-pkcs1pad - Require hash to be present
Date: Wed, 22 Jun 2016 22:33:41 +0800
Message-ID: <20160622143341.GA747@gondor.apana.org.au>
References: <20160622101432.GA30454@gondor.apana.org.au>
 <E1bFfDK-0007yq-FV@gondolin.me.apana.org.au>
 <CAOq732+p7M5Cn2mPnbN3H3tkxvjf_UkKqQSR+eceBp4-CJYh-w@mail.gmail.com>
 <20160622140225.GA315@gondor.apana.org.au>
 <576A9E64.2020209@gmail.com>
 <20160622142050.GA540@gondor.apana.org.au>
 <576AA0F4.2020605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>
To: Denis Kenzior <denkenz@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44598 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbcFVOds (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 10:33:48 -0400
Content-Disposition: inline
In-Reply-To: <576AA0F4.2020605@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 09:30:12AM -0500, Denis Kenzior wrote:
>
> We live on the bleeding edge :)
> 
> I realize that these features are not upstream yet, but that doesn't
> mean that we can't influence / see the direction that the kernel is
> taking and act accordingly.
> 
> We'd like to have both pkcs1pad + hash, and simple pkcs1pad go
> upstream.  That will make our job in userspace much easier.  Andrew
> submitted pkcs1pad transform to the kernel specifically so we could
> get rid of this logic in our userspace code.  So please consider
> leaving both versions for upstream inclusion.

Sorry but the crypto API isn't a repository for general algorithms.
It's first and foremost a place for algorithms that we use in the
kernel.

The user-space interface (if we ever add one for akcipher, right now
there are strong objections against it) is mainly there to allow
access to hardware accelerators.  So I'm afraid I cannot keep the
hashless pkcs1pad until such a time that either we have a kernel
user for it or there is a piece of hardware implementing it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
