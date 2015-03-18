From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 11:50:09 +0100
Message-ID: <1426675809.2143223.241946097.20888470@webmail.messagingengine.com>
References: <20150318095345.GA12923@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	dborkman@redhat.com
To: mancha <mancha1@zoho.com>, tytso@mit.edu,
	linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60919 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755928AbbCRKuM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 06:50:12 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by mailout.nyi.internal (Postfix) with ESMTP id DB2B420C1D
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2015 06:50:07 -0400 (EDT)
In-Reply-To: <20150318095345.GA12923@zoho.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Wed, Mar 18, 2015, at 10:53, mancha wrote:
> Hi.
> 
> The kernel RNG introduced memzero_explicit in d4c5efdb9777 to protect
> memory cleansing against things like dead store optimization:
> 
>    void memzero_explicit(void *s, size_t count)
>    {
>            memset(s, 0, count);
>            OPTIMIZER_HIDE_VAR(s);
>    }
> 
> OPTIMIZER_HIDE_VAR, introduced in fe8c8a126806 to protect crypto_memneq
> against timing analysis, is defined when using gcc as:
> 
>    #define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=r" (var) : "0" (var))
> 
> My tests with gcc 4.8.2 on x86 find it insufficient to prevent gcc from
> optimizing out memset (i.e. secrets remain in memory).
> 
> Two things that do work:
> 
>    __asm__ __volatile__ ("" : "=r" (var) : "0" (var))

You are correct, volatile signature should be added to
OPTIMIZER_HIDE_VAR. Because we use an output variable "=r", gcc is
allowed to check if it is needed and may remove the asm statement.
Another option would be to just use var as an input variable - asm
blocks without output variables are always considered being volatile by
gcc.

Can you send a patch?

I don't think it is security critical, as Daniel pointed out, the call
will happen because the function is an external call to the crypto
functions, thus the compiler has to flush memory on return.

Bye,
Hannes
