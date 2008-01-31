From: Andi Kleen <ak@suse.de>
Subject: Trouble with non modular ciphers
Date: Thu, 31 Jan 2008 10:21:24 +0100
Message-ID: <200801311021.24240.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:39548 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbYAaJVb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Jan 2008 04:21:31 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


FYI -- with a linus git kernel of yesterday or so I ran into a problem where 
one cipher module (CBC) was compiled in and the rest modular. dm_crypt 
could not resolve the cipher module until I turned it into a module.
I don't remember if cryptomanager was modular or not.

I don't have the exact configuration anymore unfortunately, but just
wanted to report the problem.

Also I found that cryptomanager is quite unhappy when CONFIG_KMOD
is not defined. Perhaps it should Kconfig select it?

-Andi
