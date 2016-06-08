From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 3/4] crypto: kdf - SP800-108 Key Derivation Function
Date: Wed, 08 Jun 2016 06:58:23 +0200
Message-ID: <1663627.f9Il2hHM4D@tauon.atsec.com>
References: <17649236.piPdUxUzaM@positron.chronox.de> <20634336.6yV5j7Wfmz@tauon.atsec.com> <20160608031334.GC12283@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	keyrings@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36022 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbcFHE61 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 00:58:27 -0400
In-Reply-To: <20160608031334.GC12283@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 8. Juni 2016, 11:13:34 schrieb Herbert Xu:

Hi Herbert,

> OK.  I don't think the RNG API really guarantees that you can do
> in-place generation anyway.  So don't even bother checking for
> src == dst.

Ok, I will remove the check.
> 
> When you submit this again can you please send it along with a
> user?

Yes, I will.

Ciao
Stephan
