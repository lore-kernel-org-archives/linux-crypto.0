From: Stephan Mueller <smueller@chronox.de>
Subject: Re: DRBG seeding
Date: Thu, 16 Apr 2015 17:32:27 +0200
Message-ID: <2037814.HNld8WWmfI@tauon>
References: <20150416143617.GA17178@gondor.apana.org.au> <1505308.pr7rreheuo@tauon> <20150416152618.GA17690@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34141 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbbDPPcd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Apr 2015 11:32:33 -0400
In-Reply-To: <20150416152618.GA17690@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 16. April 2015, 23:26:18 schrieb Herbert Xu:

Hi Herbert,

>On Thu, Apr 16, 2015 at 05:07:20PM +0200, Stephan Mueller wrote:
>> I do not see a specific requirement in SP800-90A about the quality of the
>> noise source.
>
>Well it explicitly says that you cannot use a DRBG.  In the worst
>case get_random_bytes is completely deterministic.
>
>> That said, I already developed an in-kernel version of /dev/random. I sent
>> the patch to LKML some half year ago. If I understood Ted Tso right, there
>> is no general objection against adding that in-kernel interface. See [1]
>> for the thread.
>> 
>> Furthermore, I already started working on updating the DRBG to use that in-
>> kernel /dev/random interface.
>> 
>> Shall I pursue that work in earnest now?
>> 
>> [1] https://lkml.org/lkml/2014/5/11/276
>
>Yes I think we should do this.

Ok, I will work on that after I added the global lock to the DRBG.
>
>Thanks,


Ciao
Stephan
