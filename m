From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Wed, 18 Jul 2018 10:26:25 -0400
Message-ID: <20180718142625.GA5942@thunk.org>
References: <20180718014344.1309-1-tytso@mit.edu>
 <37046662f2b38f98854abfa1b5868a27c3fa0888.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
To: Yann Droneaud <ydroneaud@opteya.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <37046662f2b38f98854abfa1b5868a27c3fa0888.camel@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 18, 2018 at 09:22:13AM +0200, Yann Droneaud wrote:
> 
> The text message should explain this is only relevant during
> initialization / early boot.
> 
> The config option name should state this.

There are other workarounds for hangs that happen after initialization
/ early boot, yes.  They are of varying levels of quality / safely,
but that's neither here nor there.

However, enabling config option means that the CRNG will be
initialized with potentially information available to the CPU
manufacturer and/or Nation States, and this persists *after*
initialization / early boot.  So to say, "we're perfectly safe after
we leave initialization / early boot" is not true.

So I'd much rather make it clear that we are trusting the CPU
manufacturer far more than just during early boot.

Cheers,

					- Ted
