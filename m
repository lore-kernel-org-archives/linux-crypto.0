From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: AES-NI: slower than aes-generic?
Date: Mon, 30 May 2016 00:08:03 -0400
Message-ID: <20160530040803.GB12629@thunk.org>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com>
 <4972668.UQ1QRNriDb@positron.chronox.de>
 <FEA29793-B67A-4C0D-A904-909A62BB3E65@azet.org>
 <7574982.B7hkDJezet@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Aaron Zauner <azet@azet.org>, linux-crypto@vger.kernel.org,
	Sandy Harris <sandyinchina@gmail.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45288 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbcE3EIH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 May 2016 00:08:07 -0400
Content-Disposition: inline
In-Reply-To: <7574982.B7hkDJezet@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 29, 2016 at 09:51:59PM +0200, Stephan Mueller wrote:
> 
> I personally am not sure that taking some arbitrary cipher and turning it into 
> a DRNG by simply using a self-feeding loop based on the ideas of X9.31 
> Appendix A2.4 is good. Chacha20 is a good cipher, but is it equally good for a 
> DRNG? I do not know. There are too little assessments from mathematicians out 
> there regarding that topic.

If ChCha20 is a good (stream) cipher, it must be a good DRNG by
definition.  In other words, if you can predict the output of
ChaCha20-base DRNG with any accuracy greater than chance, this can be
used as a wedge to attack the stream cipher..

I will note that OpenBSD's "ARC4" random number generator is currently
using ChaCha20, BTW.

Regards,

						- Ted
