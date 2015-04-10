From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Fri, 10 Apr 2015 16:09:10 +0200
Message-ID: <1697288.aUGCRhyl06@tauon>
References: <20150318095345.GA12923@zoho.com> <2792913.x6Cv5ZCyOY@tauon> <1428674403.3377.4.camel@stressinduktion.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Daniel Borkmann <daniel@iogearbox.net>, mancha <mancha1@zoho.com>,
	tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	dborkman@redhat.com
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34086 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699AbbDJOJN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 10:09:13 -0400
In-Reply-To: <1428674403.3377.4.camel@stressinduktion.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 10. April 2015, 16:00:03 schrieb Hannes Frederic Sowa:

Hi Hannes,

>On Fr, 2015-04-10 at 15:25 +0200, Stephan Mueller wrote:
>> I would like to bring up that topic again as I did some more analyses:
>> 
>> For testing I used the following code:
>> 
>> static inline void memset_secure(void *s, int c, size_t n)
>> {
>> 
>>         memset(s, c, n);
>> 	
>> 	BARRIER
>> 
>> }
>> 
>> where BARRIER is defined as:
>> 
>> (1) __asm__ __volatile__("" : "=r" (s) : "0" (s));
>> 
>> (2) __asm__ __volatile__("": : :"memory");
>> 
>> (3) __asm__ __volatile__("" : "=r" (s) : "0" (s) : "memory");
>
>Hm, I wonder a little bit...
>
>Could you quickly test if you replace (s) with (n) just for the fun of
>it? I don't know if we should ask clang people about that, at least it
>is their goal to be as highly compatible with gcc inline asm.

Using 

 __asm__ __volatile__("" : "=r" (n) : "0" (n) : "memory");

clang O2/3: no mov

gcc O2/3: mov present

==> not good


Using
 __asm__ __volatile__("" : "=r" (n) : "0" (n));

clang O2/3: no mov

gcc O2/3: no mov


==> not good


What do you expect that change shall do?

>
>Thanks for looking into this!
>
>Bye,
>Hannes


Ciao
Stephan
