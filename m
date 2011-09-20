From: Sven Schnelle <svens@stackframe.org>
Subject: Re: Kernel OOPS with Freescale talitos driver on ppc
Date: Tue, 20 Sep 2011 15:34:17 +0200
Message-ID: <8762kn2v8m.fsf@begreifnix.stackframe.org>
References: <877h544vh6.fsf@begreifnix.stackframe.org>
	<20110919162001.e296597e.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: <linux-crypto@vger.kernel.org>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.duncanthrax.net ([89.31.1.170]:36497 "EHLO
	smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1ITNeW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Sep 2011 09:34:22 -0400
In-Reply-To: <20110919162001.e296597e.kim.phillips@freescale.com> (Kim Phillips's message of "Mon\, 19 Sep 2011 16\:20\:01 -0500")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kim,

Kim Phillips <kim.phillips@freescale.com> writes:

> fwiw, I just booted a vanilla 3.1-rc6 kernel on a p1020 with your
> config and CONFIG_CRYPTO_MANAGER_DISABLE_TESTS not set, and the
> selftests passed.  IPSec isn't enabled in your config.  Are you
> implementing a new algorithm?  If not, how to reproduce?

It turned out that the reason for this problem was actually a missing
crypto_aead_setauthsize() call. Setting authsize to 20 bytes
(i'm using aead with AES/SHA1) made things work.

However, we should add your patch to the talitos driver, as responding
to such an error with a Kernel OOPS isn't very polite :)

Thanks,

Sven.
