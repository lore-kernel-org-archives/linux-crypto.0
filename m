From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Sat, 4 Aug 2018 20:25:14 -0400
Message-ID: <20180805002514.GF4461@thunk.org>
References: <20180718014344.1309-1-tytso@mit.edu>
 <37046662f2b38f98854abfa1b5868a27c3fa0888.camel@opteya.com>
 <20180718142625.GA5942@thunk.org>
 <20180804215209.GA3201@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180804215209.GA3201@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Aug 04, 2018 at 11:52:10PM +0200, Pavel Machek wrote:
> > However, enabling config option means that the CRNG will be
> > initialized with potentially information available to the CPU
> > manufacturer and/or Nation States, and this persists *after*
> > initialization / early boot.  So to say, "we're perfectly safe after
> > we leave initialization / early boot" is not true.
> 
> This should really be explained in the help text.
> 
> I assume that after 10 seconds of moving mouse, user is safe even when
> rdrand is backoored?

You'll hate this answer, but "it depends".  Suppose someone is using
an init script which generates ssh keys upon first boot if they are
missing.  If this is the case, *and* RDRAND is backdoored, then the
keys will be generated in such a way that they *might* be succeptible
to being guessed by a nation state.  Moving your mouse around for 1000
or 10,000 seconds won't help if the host's ssh keys has already been
generated.

Depending on your hardware, no mouse motion might be necessary at all.
On my laptop (a Dell XPS 13 model 9370) using an dm-crypt protected
root disk, and running a Debian testing userspace, with a 4.18-rc6
based kernel, the "CRNG is initialized" message is printed *before*
the root file system is mounted.

On other systems, where the hardware does not issue as many
interrupts, the mouse motion might be extremely important in order to
get the "CRNG is initialized" message.

> (Plus, I'd say this should be kernel command line option, not config
> option...?)

Agreed, there should be a command line option as well.  I just haven't
gotten around to it yet, and in the meantime, having a config option
is better than nothing.   Patches gratefully accepted...  :-)

   	       		  	  	     		  - Ted
