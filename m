From: Phil Sutter <phil@nwl.cc>
Subject: Re: RFC: kcrypto - (yet another) user space interface
Date: Fri, 11 Jun 2010 19:00:51 +0200
Message-ID: <20100611170058.A9A7F4CD45@orbit.nwl.cc>
References: <20100610182237.1B48E4CD45@orbit.nwl.cc>
 <20100610211433.GA25864@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Nico Erfurth <nico.erfurth@viprinet.com>,
	Simon Kissel <simon.kissel@viprinet.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>, g@nwl.cc
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([91.121.169.95]:52477 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303Ab0FKRA7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jun 2010 13:00:59 -0400
Content-Disposition: inline
In-Reply-To: <20100610211433.GA25864@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey Bigeasy,

On Thu, Jun 10, 2010 at 11:14:33PM +0200, Sebastian Andrzej Siewior wrote:
> please take look at [0] and [1]. From README I can tell that those two
> posts are different from you have so far.

Hmm. Indeed, using something like AF_CRYPTO didn't come to my mind so
far. Though I'm not sure if this is good or bad - what's the big
advantage in introducing an address family for something which doesn't
even know addressing as such? No offense here, but all I have is a bunch
of bytes which should be transformed by the kernel. Using socket(),
connect() and sendmsg() for just that purpose seems a bit too fancy to
me.

> You might want to take a look at AF_PACKET interface. It does zero copy
> via a ring buffer interface of pre-mmaped user memory. So no
> get_user_pages() then :)

Yes, I've already thought about using just mmap() for the buffer
exchange. But what I don't like about it is that the shared buffer is
allocated from within the kernel, leading to two preconditions:

1) Unless the user anyway has to fill a locally allocated buffer with
the data to transform, at least a single copy is needed to get the data
into the kernel buffer. Although get_user_pages() is quite ugly to use,
it's flexible enough to take any buffer directly from user space to
operate on. (Page alignment constraints, especially with hardware crypto
engines, should be another interesting topic in this context.)

2) Space constraints. I can take a hundred 1.5k buffers along with a
single, 64M one. Despite that my PoC actually doesn't work with buffers
above 64k, using only an in-kernel buffer would make things quite a bit
more complicated.

> 
> I think that is the way to go.
> 
> [0] http://article.gmane.org/gmane.linux.kernel.cryptoapi/2656
> [1] http://article.gmane.org/gmane.linux.kernel.cryptoapi/2658

Reading a bit further from there, splice() is mentioned as another way
of exchanging the data buffers. But despite that it's doing about what
I've implemented (i.e., using get_user_pages() to fetch the userspace
data), there seems to be now sane way back, at least not according to
the comments in fs/splice.c.

This is actually a limitation of my implementation: all data
transformation is done in situ. Fine for stream ciphers, acceptable for
block ciphers, but probably FUBAR for hashes, I guess.

Greetings, Phil
