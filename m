From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Poor RNG performance on Ryzen
Date: Sat, 22 Jul 2017 14:16:41 -0400
Message-ID: <20170722181641.ru33olaiougqpr2d@thunk.org>
References: <1218e9b7-4eeb-d8a0-02b2-8ddd672ec454@gmail.com>
 <20170721092656.GA18604@wintermute>
 <09c9be2b-8b4d-ee06-8071-4f748fdb5970@gmail.com>
 <20170721144741.4igkvsd2fowptsy2@thunk.org>
 <c1010252-5648-85de-d71b-750aa2881b64@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Oliver Mangold <o.mangold@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50902 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751602AbdGVSQn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jul 2017 14:16:43 -0400
Content-Disposition: inline
In-Reply-To: <c1010252-5648-85de-d71b-750aa2881b64@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 21, 2017 at 04:55:12PM +0200, Oliver Mangold wrote:
> On 21.07.2017 16:47, Theodore Ts'o wrote:
> > On Fri, Jul 21, 2017 at 01:39:13PM +0200, Oliver Mangold wrote:
> > > Better, but obviously there is still much room for improvement by reducing
> > > the number of calls to RDRAND.
> > Hmm, is there some way we can easily tell we are running on Ryzen?  Or
> > do we believe this is going to be true for all AMD devices?
> I would like to note that my first measurement on Broadwell suggest that the
> current frequency of RDRAND calls seems to slow things down on Intel also
> (but not as much as on Ryzen).

On my T470 laptop (with an Intel mobile core i7 processor), using your
benchmark, I am getting 136 MB/s, versus your 75 MB/s.  But so what?

More realistically, if we are generating 256 bit keys (so we're
reading from /dev/urandom 32 bytes at a time), it takes 2.24
microseconds per key generation.  What do you get when you run:

dd if=/dev/urandom of=/dev/zero bs=256 count=1000000

Even if on Ryzen it's slower by a factor of two, 5 microseconds per
key generation is pretty fast!  The time to do the Diffie-Hellman
exchange and the RSA operations will probably completely swamp the
time to generate the session key.

And if you think 2.24 or 5 microseconds is to slow for the IV
generation --- then use a userspace ChaCha20 CRNG for that purpose.

I'm not really sure I see a real-life operational problem here.

	    	       	      	    - Ted
