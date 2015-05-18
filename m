From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: add random_initialized command line param
Date: Mon, 18 May 2015 14:42:09 -0400
Message-ID: <20150518184209.GA2871@thunk.org>
References: <4206400.x843ypJTc1@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4206400.x843ypJTc1@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 18, 2015 at 06:25:25PM +0200, Stephan Mueller wrote:
> Make the threshold at which the output entropy pools are considered to
> be initialized configurable via a kernel command line option. The
> current integer value of 128 bits is a good default value. However, some
> user groups may want to use different values. For example, the SOGIS
> group now requires 125 bits at least (BSI, the participant at that group
> used to require 100 bits). NIST moved from 80 bits to 112 bits starting
> with 2014.
> 
> It is therefore to be expected that in the future, this threshold may
> increase for different user groups.
> 
> CC: Ted Tso <tytso@mit.edu>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

How much does 125 vs 112 vs 128 bits really matter?  Is the cost of
waiting the extra 16 bits (the difference between 112 and 128 bits)
really that high?  I'm not entirely convincd that adding Yet Another
Tuning parameter is really worth it.  If we stick with 128 bits, we
will satisfy SOGIS, BSI, NIST, etc., and I would find it difficult to
believe that someone would want 132, 147, etc., bits.

	     	     	   	     	  - Ted
