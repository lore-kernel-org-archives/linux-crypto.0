From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] crypto: prevent 112bit key for 3DES
Date: Fri, 12 Feb 2016 17:02:53 -0500
Message-ID: <20160212220253.GD7928@thunk.org>
References: <alpine.LNX.2.02.1602121744210.2898@i8.fpunygfrxha.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Roman Drahtmueller <draht@schaltsekun.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58992 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbcBLWC4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Feb 2016 17:02:56 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.02.1602121744210.2898@i8.fpunygfrxha.qr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 12, 2016 at 05:45:24PM +0100, Roman Drahtmueller wrote:
> 
> 56 bit keys are already prevented from being used, which conforms to rfc2451.
> As of 2016, 112 bit 3DES should be prevented, too, if the expectation
> is that the algorithm uses 168 bit.

I'm not sure this is a place to be making policy statements.  3DES
supports two key lengths: 112 and 168 bits, just as AES supports three
key lengths: 128, 192, and 256.

NIST recommends that you use 128 bits if you need data to be kept
confidential after 2030, but if you only need data to be kept safe
until 2030, 112 bits is still OK.  But that's just NIST, and even NIST
SP800-131A (Transitions: Recommendation for Transitioning the Use of
Cryptographic Algorithms and Key Lengths) disallows, for US Federal
Government users, use of 112 bit TDES for _encryption_ after December
31, 2015.  However, 112 bit TDES is still allowed for _decryption_ for
legacy use (e.g., maybe you want to decrypt a document that was
encrypted using 112 bits).

So if you're making a product where you are selling to the US Federal
Government, and compliance to SP800-131A is required, prohibiting 2
key TDES for encryption might be somethign you want to do.  But
disalowig it in the setkey function means that you also aren't
allowing decryption of legacy data.  How much does this matter for the
kernel crypto layer?  Meh.  But I'm also not so sure this is the right
place to be making policy pronouncements.  After all, it's not like we
are enforcing key length restrictions in crypto/arc4.c, so a caller
can use 40-bit RC4 keys.  That seems rather inconsistent with making
restrictions about TDES's key size.

Cheers,

					- Ted
