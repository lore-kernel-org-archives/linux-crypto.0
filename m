From: Stephan Mueller <smueller@chronox.de>
Subject: Re: GPF in gf128mul_64k_bbe
Date: Thu, 17 Dec 2015 15:29:39 +0100
Message-ID: <2023148.9S5ZNxD1It@tauon.atsec.com>
References: <CACT4Y+aQg8LqJ-S37FnZDL5bLpxozji-0hRK1BjHVjafPpCriw@mail.gmail.com>
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
Received: from mail.eperm.de ([89.247.134.16]:40514 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991AbbLQO3p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Dec 2015 09:29:45 -0500
In-Reply-To: <CACT4Y+aQg8LqJ-S37FnZDL5bLpxozji-0hRK1BjHVjafPpCriw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 17. Dezember 2015, 14:00:23 schrieb Dmitry Vyukov:

Hi Dmitry,

>Hello,
>
>The following program causes GPF in gf128mul_64k_bbe:

thank you very much for the bug reports.

I will have a look into them.

Ciao
Stephan
