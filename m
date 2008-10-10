From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Update for 2.6.28
Date: Fri, 10 Oct 2008 11:22:44 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0810101118050.3503@nehalem.linux-foundation.org>
References: <20080421024306.GA6813@gondor.apana.org.au> <20080714121403.GA28523@gondor.apana.org.au> <20081010070918.GA28057@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758561AbYJJSXz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Oct 2008 14:23:55 -0400
In-Reply-To: <20081010070918.GA28057@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Fri, 10 Oct 2008, Herbert Xu wrote:
> 
> Here is the crypto update for 2.6.28:

Umm. "Here" was empty.

Mind adding where it actually is, again?

Yeah, yeah, I can look at my old merges (you didn't think I _remember_ 
things, did you?), and I can see that it's going to be

	git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

but really, please do always say where things are supposed to come from!

Also, please us

	git diff -M --stat --summary

for the diffstat. That way I would have seen the

 crypto/{cryptomgr.c => algboss.c}  |   92 +-

as a rename in the email, instead of having to look why my numbers don't 
match the numbers you claimed..

		Linus
