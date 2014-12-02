From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH 02/17] crypto: ansi_cprng - Eliminate ctx->last_rand_data
Date: 2 Dec 2014 04:08:35 -0500
Message-ID: <20141202090835.20241.qmail@ns.horizon.com>
References: <1969422.t6jbN6M3rE@tauon>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:29479 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750884AbaLBJIh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 04:08:37 -0500
In-Reply-To: <1969422.t6jbN6M3rE@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>From smueller@chronox.de Tue Dec 02 08:57:23 2014
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: George Spelvin <linux@horizon.com>
Cc: herbert@gondor.apana.org.au, nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 02/17] crypto: ansi_cprng - Eliminate ctx->last_rand_data
Date: Tue, 02 Dec 2014 09:57:17 +0100
User-Agent: KMail/4.14.2 (Linux/3.17.2-200.fc20.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141202083550.17918.qmail@ns.horizon.com>
References: <20141202083550.17918.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Dienstag, 2. Dezember 2014, 03:35:50 schrieb George Spelvin:

Hi George,

>> It's simply not necessary.

> Can you please be a bit more verbose on why you think this is not 
> necessary?

Sorry, I thought the code made that obvious.  The two buffers have to
exist simultaneously very briefly in order to be compared, but the
old data can be overwritten immediately thereafter.

So what the revised code does is:

I := E(DT)	(The buffer is called "tmp")
V ^= I
V := E(V)	(This can be stored in V without problems)
compare V with read_data
read_data := V
V ^= I
V := E(V)

> Have you tested that change with reference test vectors -- what do 
> testmgr test vectors say?

As I explained in part 00, yes.  The behaviour is identical.

I should mention, however, that I did not exactly use testmgr; I cut &
pasted the relevant test vectors & code into ansi_cprng.c, then verified
that the tests passed with both old and modified code.  I have so far been
unable to figure out how to make the tcrypt module do anything useful.
