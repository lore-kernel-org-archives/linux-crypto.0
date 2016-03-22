From: Vinicius Tinti <viniciustinti@gmail.com>
Subject: Re: [PATCH] x86: Avoid undefined behavior in macro expansion
Date: Mon, 21 Mar 2016 23:18:42 -0300
Message-ID: <CALD9WKx1XxbntrWd5RusKeY9cWzLzphOR2qAEK8h5PHZ=1CJCg@mail.gmail.com>
References: <1458182929-23866-1-git-send-email-viniciustinti@gmail.com>
	<20160319021533.GT17997@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37084 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbcCVCSo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2016 22:18:44 -0400
In-Reply-To: <20160319021533.GT17997@ZenIV.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 18, 2016 at 11:15 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Mar 16, 2016 at 11:48:49PM -0300, Vinicius Tinti wrote:
>> C11 standard (at 6.10.3.3) says that ## operator (paste) has undefined
>> behavior when one of the result operands is not a valid preprocessing
>> token.
>>
>> Therefore the macro expansion may depend on compiler implementation
>> which may or no preserve the leading white space.
>>
>> Moreover other places in kernel use CONCAT(a,b) instead of CONCAT(a, b).
>> Changing favors concise usage.
>
> Huh?
>
>> -#define      XMM(i)          CONCAT(%xmm, i)
>> +#define      XMM(i)          CONCAT(%xmm,i)
>
> What are you talking about?  Undefined behaviour is when the result of
> concatenation of adjacent tokens is not a valid preprocessor token.
> It says nothing about the either argument being a single token.

Please check the example below otherwise it will be hard to explain.

The problem is that _i_ can be a macro to be expanded too. And
it can be a parameter for a _paste_ operator.

  // tricky code
  #define CONCAT(a,b)    a##b
  #define    XMM(i)        CONCAT(%xmm, i)
  .macro foo n
    x = XMM(\n)
  .endm

_%xmm_ is not a problem but _i_ is.

> In this case after the substitution of e.g. XMM(42) we get 3 tokens:
> Punctuator[%] Identifier[xmm] Pp-number[42]
> with ## instructing us to replace the last two with preprocessor token that
> would be represented as concatenation of their representations.  Which is
> to say, concatenation of xmm and 42, i.e. xmm42.  Which *is* a
> representation of a valid preprocessor token - namely, Identifier[xmm42].

Agree. But it is not this case. I will add the code above at commit and
describe it. It will be easy to explain what I am trying to solve.

> No undefined behaviour at all.  And yes, you get two preprocessor tokens
> in the expansion - % and xmm42.  Preprocessor works in terms of tokens,
> not strings...

Understood.

> If you know of any compiler where these two variants would produce different
> expansions of XMM(<sequence of digits>), please report it to maintainers of
> the compiler in question; it's a bug, plain and simple.  And no, there's
> no undefined behaviour in that.

I reported a bug and discussed over it and I too believe that the tricky
code that I have just sent triggers an undefined behavior.

What do you think?

-- 
Simplicity is the ultimate sophistication
