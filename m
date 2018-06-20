From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] crypto: testmgr: add test vectors for skein
Date: Wed, 20 Jun 2018 16:27:47 -0700
Message-ID: <20180620232747.GA111712@gmail.com>
References: <20180620105714.18359-1-j.m.torrespalma@gmail.com>
 <20180620181051.GC76265@gmail.com>
 <20180620221247.GA25379@randy-betty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        Jason Cooper <jason@lakedaemon.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Rost <eric.rost@mybabylon.net>
To: Juan Manuel Torres Palma <j.m.torrespalma@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180620221247.GA25379@randy-betty>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[+Cc Jason Cooper <jason@lakedaemon.net>]
[+Cc Greg Kroah-Hartman <gregkh@linuxfoundation.org>]
[+Cc Eric Rost <eric.rost@mybabylon.net>]

On Thu, Jun 21, 2018 at 07:12:47AM +0900, Juan Manuel Torres Palma wrote:
> On Wed, Jun 20, 2018 at 11:10:51AM -0700, Eric Biggers wrote:
> > Also, can you describe the users of Skein in the kernel?  If there are no users,
> > there's no need to move it out of staging, or even have it in the kernel at all
> > anymore.  I say that as someone who has had to volunteer to fix critical bugs
> > found by fuzzing in crypto algorithms for which it's unclear why they are in the
> > kernel at all, as there are no apparent users.
> 
> To be honest I'm not aware of anyone actually using Skein.
> 
> So by this are you suggesting that we drop support? If not removed, I believe
> it's better to use test vectors as regression tests for further modifications.
> 

Yes, either we remove Skein, *or* we fix all the bugs and other issues such as
the lack of test vectors and continue to maintain the code in the future, e.g.
responding to bug reports from fuzzers and keeping it up to date with API
changes.  But if there are no current or planned users, then removing it is the
obvious choice.  Note that it's been in staging for over 4 years, and AFAICS the
original commits say nothing about any actual users or even why the code would
even be useful.  There's no need to waste time doing work that no one cares
about, and creating more bloat and kernel attack surface.  Skein is a good hash
algorithm, but it wasn't selected as SHA-3, so I'm not sure who would actually
want to use it in the kernel now in preference to SHA-2, SHA-3, etc.

I did recently investigate the Threefish block cipher (which is used internally
by Skein) as a possible alternative for Speck for fast encryption on processors
with AES instructions.  But it wasn't fast enough, among other disadvantages.

Eric
