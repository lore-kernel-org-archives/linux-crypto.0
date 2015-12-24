From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: GPF in gf128mul_64k_bbe
Date: Thu, 24 Dec 2015 17:42:10 +0800
Message-ID: <20151224094210.GB8235@gondor.apana.org.au>
References: <CACT4Y+aQg8LqJ-S37FnZDL5bLpxozji-0hRK1BjHVjafPpCriw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Kees Cook <keescook@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40224 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbbLXJmO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Dec 2015 04:42:14 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+aQg8LqJ-S37FnZDL5bLpxozji-0hRK1BjHVjafPpCriw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 17, 2015 at 02:00:23PM +0100, Dmitry Vyukov wrote:
> 
> The following program causes GPF in gf128mul_64k_bbe:

This is identical to the lrw_crypt problem you found earlier.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
