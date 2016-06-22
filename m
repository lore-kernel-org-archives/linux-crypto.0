From: Denis Kenzior <denkenz@gmail.com>
Subject: Re: [PATCH 4/8] crypto: rsa-pkcs1pad - Require hash to be present
Date: Wed, 22 Jun 2016 09:30:12 -0500
Message-ID: <576AA0F4.2020605@gmail.com>
References: <20160622101432.GA30454@gondor.apana.org.au>
 <E1bFfDK-0007yq-FV@gondolin.me.apana.org.au>
 <CAOq732+p7M5Cn2mPnbN3H3tkxvjf_UkKqQSR+eceBp4-CJYh-w@mail.gmail.com>
 <20160622140225.GA315@gondor.apana.org.au> <576A9E64.2020209@gmail.com>
 <20160622142050.GA540@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33345 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbcFVOpW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 10:45:22 -0400
Received: by mail-pf0-f193.google.com with SMTP id c74so4260008pfb.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2016 07:45:21 -0700 (PDT)
In-Reply-To: <20160622142050.GA540@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 06/22/2016 09:20 AM, Herbert Xu wrote:
> On Wed, Jun 22, 2016 at 09:19:16AM -0500, Denis Kenzior wrote:
>> Just to clarify, we use this from userspace.  So we _already_ depend
>> on this functionality.  Please keep the hash and non-hash versions
>> of pkcs1pad available.
>
> How can you be depending on this in userspace when we haven't
> even exported akcipher to userspace? Colour me confused.
>

We live on the bleeding edge :)

I realize that these features are not upstream yet, but that doesn't 
mean that we can't influence / see the direction that the kernel is 
taking and act accordingly.

We'd like to have both pkcs1pad + hash, and simple pkcs1pad go upstream. 
  That will make our job in userspace much easier.  Andrew submitted 
pkcs1pad transform to the kernel specifically so we could get rid of 
this logic in our userspace code.  So please consider leaving both 
versions for upstream inclusion.

Regards,
-Denis
