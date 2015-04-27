From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Mon, 27 Apr 2015 21:10:14 +0200
Message-ID: <11353383.zL7vZDIZ69@tauon>
References: <20150318095345.GA12923@zoho.com> <5527E22C.9080909@iogearbox.net> <2604864.n87lBBrmsR@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	mancha <mancha1@zoho.com>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34544 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965122AbbD0TK4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 15:10:56 -0400
In-Reply-To: <2604864.n87lBBrmsR@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 10. April 2015, 16:50:22 schrieb Stephan Mueller:

Hi Stephan,

>Am Freitag, 10. April 2015, 16:46:04 schrieb Daniel Borkmann:
>
>Hi Daniel,
>
>>On 04/10/2015 04:36 PM, Stephan Mueller wrote:
>>> Am Freitag, 10. April 2015, 16:26:00 schrieb Hannes Frederic Sowa:
>>...
>>
>>>> I suspected a problem in how volatile with non-present output args could
>>>> be different, but this seems not to be the case.
>>>> 
>>>> I would contact llvm/clang mailing list and ask. Maybe there is a
>>>> problem? It seems kind of strange to me...
>>
>>+1
>>
>>> Do you really think this is a compiler issue?
>>
>>If clang/LLVM advertises "GCC compatibility", then this would
>>certainly be a different behavior.
>
>As you wish. I will contact the clang folks. As the proposed fix is not super
>urgend, I think we can leave it until I got word from clang.

I posted the issue on the clang mailing list on April 10 -- no word so far. I 
would interpret this as a sign that it is a no-issue for them.

Thus, I propose we update our memzero_explicit implementation to use

__asm__ __volatile__("" : "=r" (s) : "0" (s) : "memory");

Concerns?

Ciao
Stephan
