From: Stephan Mueller <smueller@chronox.de>
Subject: Re: tcrypt failing on hmac(crc32)
Date: Fri, 27 May 2016 11:24:23 +0200
Message-ID: <2026070.aoSVfl4Uuo@tauon.atsec.com>
References: <20160525070752.GB6559@suse.de> <20160525130528.GA30676@suse.de> <20160527091932.GB924@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Marcus Meissner <meissner@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34904 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529AbcE0JY0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 May 2016 05:24:26 -0400
In-Reply-To: <20160527091932.GB924@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 27. Mai 2016, 11:19:32 schrieb Marcus Meissner:

Hi Marcus,

> 
> And it actually is:
> 
> [  180.942532] hmac: blocksize check failed, ds=4, cra_blocksize=1, ss=4
> [  180.942541] alg: hash: Failed to load transform for hmac(crc32): -2
> [  180.989191] tcrypt: one or more tests failed!
> 
> Should I remove hmac(crc32) from the testmgr list?

I am wondering about that: there are test vectors for this cipher, so there 
seem to be valid use cases. But the implementation is broken and nobody 
noticed up to now. So, it seems it is not in use?

Given that, I would think that hmac(crc32) could be removed from testmgr.

Ciao
Stephan
