From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Sat, 4 Aug 2018 23:52:10 +0200
Message-ID: <20180804215209.GA3201@localhost>
References: <20180718014344.1309-1-tytso@mit.edu>
 <37046662f2b38f98854abfa1b5868a27c3fa0888.camel@opteya.com>
 <20180718142625.GA5942@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Yann Droneaud <ydroneaud@opteya.com>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180718142625.GA5942@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

On Wed 2018-07-18 10:26:25, Theodore Y. Ts'o wrote:
> On Wed, Jul 18, 2018 at 09:22:13AM +0200, Yann Droneaud wrote:
> > 
> > The text message should explain this is only relevant during
> > initialization / early boot.
> > 
> > The config option name should state this.
> 
> There are other workarounds for hangs that happen after initialization
> / early boot, yes.  They are of varying levels of quality / safely,
> but that's neither here nor there.
> 
> However, enabling config option means that the CRNG will be
> initialized with potentially information available to the CPU
> manufacturer and/or Nation States, and this persists *after*
> initialization / early boot.  So to say, "we're perfectly safe after
> we leave initialization / early boot" is not true.

This should really be explained in the help text.

I assume that after 10 seconds of moving mouse, user is safe even when
rdrand is backoored?

(Plus, I'd say this should be kernel command line optiom, not config
option...?)

Best regards,

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
