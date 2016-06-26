From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 7/7] random: add backtracking protection to the CRNG
Date: Sun, 26 Jun 2016 19:05:47 -0400
Message-ID: <20160626230547.GD7132@thunk.org>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
 <1465832919-11316-8-git-send-email-tytso@mit.edu>
 <20160626184753.GB11162@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, smueller@chronox.de,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34256 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbcFZXFz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 26 Jun 2016 19:05:55 -0400
Content-Disposition: inline
In-Reply-To: <20160626184753.GB11162@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 26, 2016 at 08:47:53PM +0200, Pavel Machek wrote:
> 
> You are basically trying to turn CRNG into one way hash function here,
> right? Do you have any explanation that it has the required
> properties?

Well, not really.  A CRNG has the property that if you generate a
series of outputs: O_N-1, O_N, O_N+1, etc., knowledge of O_N does not
give you any special knowledge with respect to O_N+1 or O_N-1.

The anti-backtracking protection means that when we generate O_N, we
use O_N+1 to mutate the state used for the CRNG; specifically, we are
XOR'ing O_N+1 into the state.  Now let's suppose that state gets
exposed.  Even if you know O_N, that's not going to let you know
O_N+1, so knowledge of the exposed state post XOR with O_N+1 isn't
going to help you get back the original state.

More generally, if we assume ChaCha20 is secure, that means that you
can't derive the key even if you have known plaintext.  The output of
the CRNG is basically the keystream --- what you have after you XOR
the ciphertext with the plaintext.  If ChaCha20 is secure, knowledge
of large portions of the keystream should not help you determine the
key, which means is why knowledge of O_N-1, O_N, won't help you derive
either (a) the state of CRNG, aka the ChaCha20 key, or (b) O_N+1.

Cheers,

						- Ted
