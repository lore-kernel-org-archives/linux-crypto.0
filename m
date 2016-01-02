From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: af_alg - Disallow bind/setkey/... after accept(2)
Date: Sat, 02 Jan 2016 10:20:16 +0100
Message-ID: <1722859.P06iN7WPkX@myon.chronox.de>
References: <CACT4Y+Y0k-SuTCVMJOdymwvgEHiM+dSJ3hLOmEb6ZdK=t39gXA@mail.gmail.com> <20151230034753.GA8776@gondor.apana.org.au> <65988221.D1d1cZYMWB@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Dmitry Vyukov <dvyukov@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:41196 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbcABJUT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Jan 2016 04:20:19 -0500
In-Reply-To: <65988221.D1d1cZYMWB@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 1. Januar 2016, 21:12:40 schrieb Stephan Mueller:

Hi Herbert,

> Am Mittwoch, 30. Dezember 2015, 11:47:53 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Tue, Dec 29, 2015 at 07:36:14PM +0100, Dmitry Vyukov wrote:
> > > Hello,
> > > 
> > > On commit 8513342170278468bac126640a5d2d12ffbff106
> > > + crypto: algif_skcipher - Use new skcipher interface
> > > + crypto: algif_skcipher - Require setkey before accept(2)
> > > + crypto: af_alg - Disallow bind/setkey/... after accept(2)
> > 
> > OK there is a silly bug in the last patch.  Here is an updated
> > version.
> 
> With this patch, the AF_ALG interface stops working. I tested the HMAC
> operation and I am unable to set the key with the following call:
> 
> ret = setsockopt(handle->tfmfd, SOL_ALG, ALG_SET_KEY, key, keylen);
> 
> This call returns EBUSY.

Please disregard my email. I did not update my library to the newly requested 
order of performing the setkey before the accept call. After the update of my 
library I can confirm that the modification works for all AF_ALG interfaces.

-- 
Ciao
Stephan
