From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: Kernel 3.7.0-rc1 crash after TrueCrypt mount device on a
 computer with Intel i5
Date: Thu, 18 Oct 2012 22:58:13 +0300
Message-ID: <20121018225813.128527o0vb19hu1g@www.dalek.fi>
References: <508025FD.7010602@winsoft.pl>
 <CA+55aFxKBQwU8TxvzS2XY=grM090Pw5zEcXg9BTyO2WYu91TYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Kolasa <kkolasa@winsoft.pl>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kim Phillips <kim.phillips@freescale.com>,
	Huang Ying <ying.huang@intel.com>, linux-crypto@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:45113 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2JRT6Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Oct 2012 15:58:16 -0400
In-Reply-To: <CA+55aFxKBQwU8TxvzS2XY=grM090Pw5zEcXg9BTyO2WYu91TYw@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Linus Torvalds <torvalds@linux-foundation.org>:

> Krzysztof, please try to cc the appropriate people/list.
>
> I've added linux-crypto and the people who touched aesni-intel since
> 3.6, and am re-quoting the whole email (except for the continuation
> oopses that won't be relevant)
>
> It seems to crash on the very first instruction of _aesni_enc1,  
> which is just a
>
>    movaps (KEYP), KEY
>
> where on x86-32, KEYP is %edi and KEY is %xmm2.
>
> In the oops register dump, %edi is 0xf169fe64, which looks like a
> valid kernel pointer (depending on amount of memory), but it looks
> like the problem is that it's not 16-byte aligned.
>
> I dunno. None of the asm code seems to have changed since 3.6 afaik,
> so some calling code change triggers this? Guys, ideas?
>
>                    Linus

Problem is that aesni_enc is asmlinkage and it's casted to non-asmlinkage
function pointer (when using XTS mode). Doesn't break on x86-64, but on
x86-32 however.. My bad, sorry.

I'll send patch soon.

  -Jussi
