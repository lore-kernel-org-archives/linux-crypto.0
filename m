From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Mon, 20 Aug 2007 09:01:57 +0800
Message-ID: <E1IMveX-0002Kv-00@gondolin.me.apana.org.au>
References: <200708200234.25620.ak@suse.de>
Cc: linux-crypto@vger.kernel.org
To: ak@suse.de (Andi Kleen)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3050 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750941AbXHTBPU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Aug 2007 21:15:20 -0400
In-Reply-To: <200708200234.25620.ak@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Andi Kleen <ak@suse.de> wrote:
> Hallo,
> 
> Currently there are two twofish and two aes implementions on x86.
> Worse when both are enabled as modules a modprobe aes
> will get the C version which seems to be slower on K8 
> and about the same speed on Core2 on my tests.

Hi Andi:

Are you sure you get the C version when both are built-in
or loaded as modules? If so then we have a bug in the priority
code.

If you only have the C version loaded then that is understandable
since the module loading code doesn't know about the other one.

> Is there a specific reason why anybody would prefer the C functions
> over the assembler functions? 

We don't, but the system is meant to allow multiple
implementations to coexist and picking the best one
at run-time.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
