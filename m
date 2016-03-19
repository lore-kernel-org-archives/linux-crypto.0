From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] x86: Avoid undefined behavior in macro expansion
Date: Sat, 19 Mar 2016 02:15:33 +0000
Message-ID: <20160319021533.GT17997@ZenIV.linux.org.uk>
References: <1458182929-23866-1-git-send-email-viniciustinti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Vinicius Tinti <viniciustinti@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48174 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbcCSCPz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 22:15:55 -0400
Content-Disposition: inline
In-Reply-To: <1458182929-23866-1-git-send-email-viniciustinti@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 16, 2016 at 11:48:49PM -0300, Vinicius Tinti wrote:
> C11 standard (at 6.10.3.3) says that ## operator (paste) has undefined
> behavior when one of the result operands is not a valid preprocessing
> token.
> 
> Therefore the macro expansion may depend on compiler implementation
> which may or no preserve the leading white space.
> 
> Moreover other places in kernel use CONCAT(a,b) instead of CONCAT(a, b).
> Changing favors concise usage.

Huh?

> -#define	XMM(i)		CONCAT(%xmm, i)
> +#define	XMM(i)		CONCAT(%xmm,i)

What are you talking about?  Undefined behaviour is when the result of
concatenation of adjacent tokens is not a valid preprocessor token.
It says nothing about the either argument being a single token.

In this case after the substitution of e.g. XMM(42) we get 3 tokens:
Punctuator[%] Identifier[xmm] Pp-number[42]
with ## instructing us to replace the last two with preprocessor token that
would be represented as concatenation of their representations.  Which is
to say, concatenation of xmm and 42, i.e. xmm42.  Which *is* a
representation of a valid preprocessor token - namely, Identifier[xmm42].
No undefined behaviour at all.  And yes, you get two preprocessor tokens
in the expansion - % and xmm42.  Preprocessor works in terms of tokens,
not strings...

If you know of any compiler where these two variants would produce different
expansions of XMM(<sequence of digits>), please report it to maintainers of
the compiler in question; it's a bug, plain and simple.  And no, there's
no undefined behaviour in that.
