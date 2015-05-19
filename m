From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing nonblocking_pool
Date: Tue, 19 May 2015 09:56:20 +0200
Message-ID: <3206340.zt3CC7Msc7@tauon>
References: <1921857.OvxEu6y28S@tachyon.chronox.de> <2404915.vbuKFfjVR8@tachyon.chronox.de> <20150519075155.GA29242@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34854 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbbESH4Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 May 2015 03:56:24 -0400
In-Reply-To: <20150519075155.GA29242@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 19. Mai 2015, 15:51:55 schrieb Herbert Xu:

Hi Herbert,

>You're right.  The cancel function is indeed simpler.  I can
>certainly live with that.

Thank you. I will test my patch a bit more and then release it with the 
discussed changes.

Ciao
Stephan
