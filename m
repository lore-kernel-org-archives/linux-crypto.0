From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] crypto: testmgr: add test vectors for skein
Date: Sun, 1 Jul 2018 16:32:04 +0000
Message-ID: <20180701163204.GE26205@io.lakedaemon.net>
References: <20180620105714.18359-1-j.m.torrespalma@gmail.com>
 <20180620181051.GC76265@gmail.com>
 <20180620221247.GA25379@randy-betty>
 <20180701091611.z24lln7cyho6ktlb@gondor.apana.org.au>
 <20180701094719.GC9956@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Juan Manuel Torres Palma <j.m.torrespalma@gmail.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180701094719.GC9956@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Greg,

On Sun, Jul 01, 2018 at 11:47:19AM +0200, Greg Kroah-Hartman wrote:
> On Sun, Jul 01, 2018 at 05:16:11PM +0800, Herbert Xu wrote:
> > On Thu, Jun 21, 2018 at 07:12:47AM +0900, Juan Manuel Torres Palma wrote:
> > > On Wed, Jun 20, 2018 at 11:10:51AM -0700, Eric Biggers wrote:
> > > > Also, can you describe the users of Skein in the kernel?  If there are no users,
> > > > there's no need to move it out of staging, or even have it in the kernel at all
> > > > anymore.  I say that as someone who has had to volunteer to fix critical bugs
> > > > found by fuzzing in crypto algorithms for which it's unclear why they are in the
> > > > kernel at all, as there are no apparent users.
> > > 
> > > To be honest I'm not aware of anyone actually using Skein.
> > > 
> > > So by this are you suggesting that we drop support? If not removed, I believe
> > > it's better to use test vectors as regression tests for further modifications.
> > 
> > Let's just remove skein.  In fact staging should never add generic
> > crypto algorithms.

The original reason was that I was testing an automated method for
making a massive number of style changes to cryptographic code (convert
to kernel coding style), while being able to automatically determine
that no changes had been made to the resulting object code.  The purpose
being, if you chose to place trust in Werner Dittman's implementation,
you could programatically prove that the re-styled code in the kernel
was the exact same when it came to the resulting machine code.  Thus,
you could extend your trust to the code in the kernel.

That's how ./scripts/objdiff.sh came to be.  If you look at the first 20
- 22 commits in the history of drivers/staging/skein, you can try it
yourself.

> Ok, I'll go drop it.  I forgot why we added it in the first place, it
> has been there for 4 years and not moved out, so it's not a problem to
> drop it now.

Yes, that was me that added it.  In the intervening time, unfortunately,
Skein / Threefish hasn't picked up adoption anywhere afaict.  For
example, it's not one of the candidates for replacing SHA1 within git.
So, as much as I hate to delete it, I agree that it's time to drop it.

I'll submit a patch to that effect soon.  Thanks for adding me to the
Cc.

Thanks,

Jason.
