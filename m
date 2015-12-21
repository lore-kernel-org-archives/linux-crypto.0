From: Stephan Mueller <smueller@chronox.de>
Subject: Re: GPF in gf128mul_64k_bbe
Date: Mon, 21 Dec 2015 23:56:19 +0100
Message-ID: <1807243.L6zcoIfgPu@myon.chronox.de>
References: <CACT4Y+aQg8LqJ-S37FnZDL5bLpxozji-0hRK1BjHVjafPpCriw@mail.gmail.com> <1811742.mEEtKqi93R@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Kees Cook <keescook@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:40778 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbbLUW4W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Dec 2015 17:56:22 -0500
In-Reply-To: <1811742.mEEtKqi93R@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 21. Dezember 2015, 23:53:14 schrieb Stephan Mueller:

Hi,

> Am Donnerstag, 17. Dezember 2015, 14:00:23 schrieb Dmitry Vyukov:
> 
> Hi Dmitry,
> 
> > Hello,
> 
> > The following program causes GPF in gf128mul_64k_bbe:
> This looks very much like the issue you reported for lrw_crypt.

Oops, I was looking at the wrong email. Please disregard this one reply.

-- 
Ciao
Stephan
