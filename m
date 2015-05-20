From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing nonblocking_pool
Date: Wed, 20 May 2015 08:13:19 +0200
Message-ID: <8139656.Uju5HyhhS3@tauon>
References: <1921857.OvxEu6y28S@tachyon.chronox.de> <1889464.W6X1COIBGJ@tauon> <20150519225533.GA5718@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:57982 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbbETGNZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 May 2015 02:13:25 -0400
In-Reply-To: <20150519225533.GA5718@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 20. Mai 2015, 06:55:33 schrieb Herbert Xu:

Hi Herbert,
>
>You still need to handle the case where wait_event_interruptible
>returns an error.  Otherwise this looks fine.

Thank you. I would suggest to add a while loop around the call that sets up 
the wait if it terminated with ERESTARTSYS. This way we can maintain a void 
function that is almost identical to the get_random_bytes function.


Ciao
Stephan
