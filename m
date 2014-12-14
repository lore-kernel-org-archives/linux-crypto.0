From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: 14 Dec 2014 15:37:38 -0500
Message-ID: <20141214203738.20811.qmail@ns.horizon.com>
References: <2320511.tdzPj5eXcj@tachyon.chronox.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:38148 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750883AbaLNUhj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Dec 2014 15:37:39 -0500
In-Reply-To: <2320511.tdzPj5eXcj@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In an earlier conversation with Neil, I had an idea that I'd like
your opinion on.

I still think whether true-random mode is wanted is up in the air,
but if it is, a better way to proide it would be to create a separate
crypto_alg for it, with a smaller seed size (no DT seed) and its own name.

But I have no idea what name to use.  Any suggestions?  And a FIPS
version, too?
