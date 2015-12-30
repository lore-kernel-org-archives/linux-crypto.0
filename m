From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: use-after-free in rng_recvmsg
Date: Wed, 30 Dec 2015 21:54:09 +0100
Message-ID: <1770781.3L9ebnaMWA@myon.chronox.de>
References: <CACT4Y+b4tFGXuaTbTkbt5u=E2K5RXOcihXnj7jtEZaCB+FwqPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:41072 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbbL3UyM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Dec 2015 15:54:12 -0500
In-Reply-To: <CACT4Y+b4tFGXuaTbTkbt5u=E2K5RXOcihXnj7jtEZaCB+FwqPg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 28. Dezember 2015, 14:48:48 schrieb Dmitry Vyukov:

Hi Dmitry,

> Hello,
> 
> On commit a88164345b81292b55a8d4829fdd35c8d611cd7d (Dec 23)
> + crypto: algif_skcipher - Use new skcipher interface
> + crypto: algif_skcipher - Require setkey before accept(2)
> 
> The following program triggers use-after-free in rng_recvmsg:

Thank you for the bug report.

After applying the patch from Herbert [1], I was not able to reproduce the 
issue even after 1000 rounds of the test code. Considering the issue and the 
patch from Herbert, I would consider the issue being fixed.

[1] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg17450.html

Thank you.
-- 
Ciao
Stephan
