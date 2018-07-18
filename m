From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] random: addu a config option to trust the CPU's hwrng
Date: Wed, 18 Jul 2018 13:36:21 -0400
Message-ID: <20180718173621.GC30706@thunk.org>
References: <20180718014344.1309-1-tytso@mit.edu>
 <20180718015154.GE3489@thunk.org>
 <CACXcFmk7D5t9yg9VxhKZgMvqK-LmFF0d7Dh9A3hsoGTfzzeM8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACXcFmk7D5t9yg9VxhKZgMvqK-LmFF0d7Dh9A3hsoGTfzzeM8A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 18, 2018 at 11:14:20AM -0400, Sandy Harris wrote:
> Instead, I had a compile-time option to choose a number 0-32
> for how much entropy to assume a 32-bit value from the HWRNG
> contains. Default was something less than 32. I debated values
> in the 24-30 range, don't recall what I chose & don't think it
> Matters hugely.
> 
> Is that a better approach than the binary choice?

This patch is only affecting the initialization of the CRNG.  It
doesn't do anything about the entropy estimator, so it doesn't change
the behavior of /dev/random, for example.

In practice I doubt most people would be able to deal with a numerical
dial, and I'm trying to ecourage people to use getrandom(2).  I view
/dev/random as a legacy interface, and for most people a CRNG is quite
sufficient.  For those people who are super paranoid and want a "true
random number generator" (and the meaning of that is hazy) because a
CRNG is Not Enough, my recommendation these days is that they get
something like an open hardware RNG solution, such as ChaosKey from
Altus Metrum[1].

[1] https://altusmetrum.org/ChaosKey/

						- Ted
