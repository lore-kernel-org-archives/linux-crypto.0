From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 00/12] x86/crypto: Fix RBP usage in several crypto .S
 files
Date: Fri, 8 Sep 2017 10:57:05 -0700
Message-ID: <20170908175705.GA623@zzz.localdomain>
References: <cover.1504029132.git.jpoimboe@redhat.com>
 <20170902000919.GA139193@gmail.com>
 <20170907071534.ztbxvyfoo7m7esmw@gmail.com>
 <20170907175800.GA92996@gmail.com>
 <20170907212646.q3y5wmhyaaqblg5m@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: Ingo Molnar <mingo@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170907212646.q3y5wmhyaaqblg5m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 07, 2017 at 11:26:47PM +0200, Ingo Molnar wrote:
> 
> * Eric Biggers <ebiggers3@gmail.com> wrote:
> 
> > On Thu, Sep 07, 2017 at 09:15:34AM +0200, Ingo Molnar wrote:
> > > 
> > > * Eric Biggers <ebiggers3@gmail.com> wrote:
> > > 
> > > > Thanks for fixing these!  I don't have time to review these in detail, but I ran
> > > > the crypto self-tests on the affected algorithms, and they all pass.  I also
> > > > benchmarked them before and after; the only noticable performance difference was
> > > > that sha256-avx2 and sha512-avx2 became a few percent slower.  I don't suppose
> > > > there is a way around that?  Otherwise it's probably not a big deal.
> > > 
> > > Which CPU model did you use for the test?
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > 
> > This was on Haswell, "Intel(R) Xeon(R) CPU E5-1650 v3 @ 3.50GHz".
> 
> Any chance to test this with the latest microarchitecture - any Skylake derivative 
> Intel CPU you have access to?
> 
> Thanks,
> 
> 	Ingo

Tested with Skylake, "Intel(R) Core(TM) i5-6200U CPU @ 2.30GHz".  The results
were the following which seemed a bit worse than Haswell:

	sha256-avx2 became 3.5% slower
	sha512-avx2 became 7.5% slower

Note: it's tricky to benchmark this, especially with just a few percent
difference, so don't read too much into the exact numbers.

Eric
