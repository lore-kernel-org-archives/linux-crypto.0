From: James Yonan <james@openvpn.net>
Subject: Re: [PATCH] crypto: more robust crypto_memneq
Date: Mon, 25 Nov 2013 08:59:03 -0700
Message-ID: <529373C7.10201@openvpn.net>
References: <1385327535-27991-1-git-send-email-cesarb@cesarb.eti.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Daniel Borkmann <dborkman@redhat.com>,
	Florian Weimer <fw@deneb.enyo.de>, linux-kernel@vger.kernel.org
To: Cesar Eduardo Barros <cesarb@cesarb.eti.br>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.yonan.net ([54.244.116.145]:49823 "EHLO mail.yonan.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab3KYQIH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Nov 2013 11:08:07 -0500
In-Reply-To: <1385327535-27991-1-git-send-email-cesarb@cesarb.eti.br>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24/11/2013 14:12, Cesar Eduardo Barros wrote:
> Disabling compiler optimizations can be fragile, since a new
> optimization could be added to -O0 or -Os that breaks the assumptions
> the code is making.
>
> Instead of disabling compiler optimizations, use a dummy inline assembly
> (based on RELOC_HIDE) to block the problematic kinds of optimization,
> while still allowing other optimizations to be applied to the code.
>
> The dummy inline assembly is added after every OR, and has the
> accumulator variable as its input and output. The compiler is forced to
> assume that the dummy inline assembly could both depend on the
> accumulator variable and change the accumulator variable, so it is
> forced to compute the value correctly before the inline assembly, and
> cannot assume anything about its value after the inline assembly.
>
> This change should be enough to make crypto_memneq work correctly (with
> data-independent timing) even if it is inlined at its call sites. That
> can be done later in a followup patch.
>
> Compile-tested on x86_64.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.eti.br>

This approach using __asm__ ("" : "=r" (var) : "0" (var)) to try to 
prevent compiler optimizations of var is interesting.

I like the fact that it's finer-grained than -Os and doesn't preclude 
inlining.

One concern would be that __asm__ could be optimized out unless 
__volatile__ is present.

James
