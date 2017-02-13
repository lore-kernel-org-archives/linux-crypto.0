From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: Re: [PATCH] lz4: fix performance regressions
Date: Mon, 13 Feb 2017 12:53:49 +0100
Message-ID: <20170213115349.GA22510@bierbaron.springfield.local>
References: <20170210001311.GA25078@bbox>
 <1486898178-17125-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1486898178-17125-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170212130508.GA27710@1wt.eu>
 <20170212152000.GA24704@bierbaron.springfield.local>
 <20170212214117.GA30583@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: minchan@kernel.org, ebiggers3@gmail.com, akpm@linux-foundation.org,
        bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com
To: Willy Tarreau <w@1wt.eu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:59909 "EHLO
        mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752336AbdBMLx7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Feb 2017 06:53:59 -0500
Content-Disposition: inline
In-Reply-To: <20170212214117.GA30583@1wt.eu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 12, 2017 at 10:41:17PM +0100, Willy Tarreau wrote:
> On Sun, Feb 12, 2017 at 04:20:00PM +0100, Sven Schmidt wrote:
> > On Sun, Feb 12, 2017 at 02:05:08PM +0100, Willy Tarreau wrote:
> > > Hi Sven,
> > > 
> > > On Sun, Feb 12, 2017 at 12:16:18PM +0100, Sven Schmidt wrote:
> > > > Fix performance regressions compared to current kernel LZ4
> > > 
> > > Your patch contains mostly style cleanups which certainly are welcome
> > > but make the whole patch hard to review. These cleanups would have been
> > > better into a separate, preliminary patch IMHO.
> > > 
> > > Regards,
> > > Willy
> > 
> > Hi Willy,
> > 
> > the problem was, I wanted to compare my version to the upstream LZ4 to find bugs (as with my last patch version: wrong indentation in LZ4HC 
> > in two for loops). But since the LZ4 code is a pain to read, I made additional style cleanups "on the way".
> 
> Oh I can easily understand!
> 
> > Hope you can manage to review the patch though, because it is difficult to separate the cleanups now.
> 
> When I need to split a patch into pieces, usually what I do is that I
> revert it, re-apply it without committing, then "git add -p", validate
> all the hunks to be taken as the first patch (ie here the cleanups),
> commit, then commit the rest as a separate one. It seems to me that the
> fix is in the last few hunks though I'm not sure yet.
> 
> Thanks,
> Willy

Hi Willy,

I didn't know about this 'trick' until now. Thanks for sharing it! I gave it a short try recently, that's really cool!

Since the problem discussed in this branch of this thread seems to be solved (see Minchans E-Mail), I won't split the patches, though.
Or is there an actual need for doing so? I will send an updated patchset (containing these patches + the other ones suggested by Eric) later.

Regards,

Sven
