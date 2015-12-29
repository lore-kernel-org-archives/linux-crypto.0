From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: algif_skcipher - Require setkey before
 accept(2)
Date: Tue, 29 Dec 2015 21:24:03 +0800
Message-ID: <20151229132403.GA5243@gondor.apana.org.au>
References: <CACT4Y+Y-K+QTNw3ZokVrRz4pCvMUN6GqRjDGdd1H2M=Qp1GRYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzkaller@googlegroups.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kcc@google.com, glider@google.com, edumazet@google.com,
	sasha.levin@oracle.com, keescook@google.com
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54690 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbbL2NYO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Dec 2015 08:24:14 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y-K+QTNw3ZokVrRz4pCvMUN6GqRjDGdd1H2M=Qp1GRYA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dmitry Vyukov <dvyukov@google.com> wrote:
>
> My email client just followed instructions in your email. You've said
> to Reply-to: syzkaller@googlegroups.com.

I did not set this Reply-To header.  It's most likely set by your
broken Google Groups setup.  So either you should start actually
replying to my email address or your future emails will most
likely not be read by me.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
