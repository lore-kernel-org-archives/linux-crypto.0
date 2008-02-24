From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [RFC] padlock aes, unification of setkey()
Date: Sun, 24 Feb 2008 12:01:02 +0100
Message-ID: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41754 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbYBXLBI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Feb 2008 06:01:08 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>From Sebastian Siewior <sebastian@breakpoint.cc> # This line is ignored.
Subject: [RFC] padlock aes, unification of setkey()

Hello Herbert,

I sit on those two since November. Back then Michal dropped me an email
and told me that he will test it and get back to me. This didn't happen
so far.
The binary format of the key was the same, the last time I checked, so
the second patch could really work :)

One thing I'm concerned about is the stack utilization. The initial
version had a structure with 256 bytes on the stack. Mine has a bigger
structure with 484 bytes. I'm not sure if it is better to dynamically
allocate it, move it to the private key structure or pad the generic
aes structure in order to enforce the required alignment.

Sebastian
