From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Date: Wed, 6 Nov 2013 07:43:54 -0500
Message-ID: <20131106124354.GJ14235@thunk.org>
References: <2579337.FPgJGgHYdz@tauon>
 <20131103124135.GB32091@thunk.org>
 <1762585.cs6mj77ady@tauon>
 <4306229.ErfOL470s2@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Machek <pavel@ucw.cz>, sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Nicholas Mc Guire <der.herr@hofr.at>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4306229.ErfOL470s2@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 06, 2013 at 12:49:45PM +0100, Stephan Mueller wrote:
> Here is a quote from his answer to my question whether he was able to 
> identify the root cause:
> 
> "its inherent in the microtiming of Hardware and there is nothing you 
> can do about it if you want the root cause is quantum physics"

That's unfortunate, since it leaves open the question of whether this
jitter is something that could be at least somewhat predictable if you
had a lot more information about the internal works of the CPU or not....

      	       		   	     	      - Ted
