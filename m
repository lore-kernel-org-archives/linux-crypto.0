From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] crypto: testmgr: add test vectors for skein
Date: Sun, 1 Jul 2018 11:47:19 +0200
Message-ID: <20180701094719.GC9956@kroah.com>
References: <20180620105714.18359-1-j.m.torrespalma@gmail.com>
 <20180620181051.GC76265@gmail.com>
 <20180620221247.GA25379@randy-betty>
 <20180701091611.z24lln7cyho6ktlb@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Juan Manuel Torres Palma <j.m.torrespalma@gmail.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180701091611.z24lln7cyho6ktlb@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jul 01, 2018 at 05:16:11PM +0800, Herbert Xu wrote:
> On Thu, Jun 21, 2018 at 07:12:47AM +0900, Juan Manuel Torres Palma wrote:
> > On Wed, Jun 20, 2018 at 11:10:51AM -0700, Eric Biggers wrote:
> > > Also, can you describe the users of Skein in the kernel?  If there are no users,
> > > there's no need to move it out of staging, or even have it in the kernel at all
> > > anymore.  I say that as someone who has had to volunteer to fix critical bugs
> > > found by fuzzing in crypto algorithms for which it's unclear why they are in the
> > > kernel at all, as there are no apparent users.
> > 
> > To be honest I'm not aware of anyone actually using Skein.
> > 
> > So by this are you suggesting that we drop support? If not removed, I believe
> > it's better to use test vectors as regression tests for further modifications.
> 
> Let's just remove skein.  In fact staging should never add generic
> crypto algorithms.

Ok, I'll go drop it.  I forgot why we added it in the first place, it
has been there for 4 years and not moved out, so it's not a problem to
drop it now.

thanks,

greg k-h
