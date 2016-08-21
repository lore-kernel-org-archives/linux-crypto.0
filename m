From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/7] random: make /dev/urandom scalable for silly
 userspace programs
Date: Sun, 21 Aug 2016 07:36:52 -0400
Message-ID: <20160821113652.y7r3uhdxymcon2zx@thunk.org>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
 <1465832919-11316-7-git-send-email-tytso@mit.edu>
 <CABSDX40G2V9w-OfGU7xP06V5qkreq89CmdaJDc89b-2EskhCQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, smueller@chronox.de,
        herbert@gondor.apana.org.au, andi@firstfloor.org,
        sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com
To: Jan Varho <jan.varho@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49380 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751694AbcHULhr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Aug 2016 07:37:47 -0400
Content-Disposition: inline
In-Reply-To: <CABSDX40G2V9w-OfGU7xP06V5qkreq89CmdaJDc89b-2EskhCQg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Aug 21, 2016 at 12:53:15PM +0300, Jan Varho wrote:
> On Mon, Jun 13, 2016 at 6:48 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > +static inline void maybe_reseed_primary_crng(void)
> > +{
> > +       if (crng_init > 2 &&
> > +           time_after(jiffies, primary_crng.init_time + CRNG_RESEED_INTERVAL))
> > +               crng_reseed(&primary_crng, &input_pool);
> > +}
> 
> Is the above function (which is now in 4.8-rc2) supposed to do
> something? It seems to have no callers and the maximum value of
> crng_init is 2.

It's dead code.  Its function got moved into _extra_crng(), and you're
right, these days crng_init never gets above 2.  Thanks for pointing
that out.  I'll take it out as a cleanup patch.

     	   	     	       	 	 - Ted
