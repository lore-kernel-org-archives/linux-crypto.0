From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Thu, 21 Apr 2016 22:51:55 -0400
Message-ID: <20160422025155.GA6690@thunk.org>
References: <9192755.iDgo3Omyqe@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55542 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbcDVCwC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Apr 2016 22:52:02 -0400
Content-Disposition: inline
In-Reply-To: <9192755.iDgo3Omyqe@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I still have a massive problem with the claims that the "Jitter" RNG
provides any amount of entropy.  Just because you and I might not be
able to analyze it doesn't mean that somebody else couldn't.  After
all, DUAL-EC DRNG was very complicated and hard to analyze.  So would
be something like

   AES(NSA_KEY, COUNTER++)

Very hard to analyze indeed.  Shall we run statistical tests?  They'll
pass with flying colors.

Secure?  Not so much.

					- Ted
