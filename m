From: Jan Glauber <jglauber@cavium.com>
Subject: Re: Poor RNG performance on Ryzen
Date: Tue, 25 Jul 2017 08:20:19 +0200
Message-ID: <20170725062019.GA5429@wintermute>
References: <1218e9b7-4eeb-d8a0-02b2-8ddd672ec454@gmail.com>
 <20170721092656.GA18604@wintermute>
 <09c9be2b-8b4d-ee06-8071-4f748fdb5970@gmail.com>
 <20170721144741.4igkvsd2fowptsy2@thunk.org>
 <c1010252-5648-85de-d71b-750aa2881b64@gmail.com>
 <20170722181641.ru33olaiougqpr2d@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Oliver Mangold <o.mangold@gmail.com>, linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35121 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbdGYGUW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 02:20:22 -0400
Received: by mail-wm0-f49.google.com with SMTP id c184so42706432wmd.0
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jul 2017 23:20:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170722181641.ru33olaiougqpr2d@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jul 22, 2017 at 02:16:41PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 21, 2017 at 04:55:12PM +0200, Oliver Mangold wrote:
> > On 21.07.2017 16:47, Theodore Ts'o wrote:
> > > On Fri, Jul 21, 2017 at 01:39:13PM +0200, Oliver Mangold wrote:
> > > > Better, but obviously there is still much room for improvement by reducing
> > > > the number of calls to RDRAND.
> > > Hmm, is there some way we can easily tell we are running on Ryzen?  Or
> > > do we believe this is going to be true for all AMD devices?
> > I would like to note that my first measurement on Broadwell suggest that the
> > current frequency of RDRAND calls seems to slow things down on Intel also
> > (but not as much as on Ryzen).
> 
> On my T470 laptop (with an Intel mobile core i7 processor), using your
> benchmark, I am getting 136 MB/s, versus your 75 MB/s.  But so what?
> 
> More realistically, if we are generating 256 bit keys (so we're
> reading from /dev/urandom 32 bytes at a time), it takes 2.24
> microseconds per key generation.  What do you get when you run:
> 
> dd if=/dev/urandom of=/dev/zero bs=256 count=1000000
> 
> Even if on Ryzen it's slower by a factor of two, 5 microseconds per
> key generation is pretty fast!  The time to do the Diffie-Hellman
> exchange and the RSA operations will probably completely swamp the
> time to generate the session key.
> 
> And if you think 2.24 or 5 microseconds is to slow for the IV
> generation --- then use a userspace ChaCha20 CRNG for that purpose.
> 
> I'm not really sure I see a real-life operational problem here.
> 
> 	    	       	      	    - Ted

While I agree that it is not an issue if the hardware is just slow I
still wonder why we read 8 bytes with arch_get_random_long() and
only use half of them as Oliver pointed out.

If arch_get_random_int() is not slower on Intel we could use that.
Or am I missing something?

--Jan
