From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 7/8] random: remove noop function call to
 xfer_secondary_pool
Date: Wed, 18 Jan 2017 11:10:56 -0500
Message-ID: <20170118161056.2l3tlo4gxnisgjxm@thunk.org>
References: <3254875.f5A5oHPdxF@positron.chronox.de>
 <9955153.9pz8KSq437@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58304 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752514AbdARQLA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Jan 2017 11:11:00 -0500
Content-Disposition: inline
In-Reply-To: <9955153.9pz8KSq437@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 27, 2016 at 11:41:46PM +0100, Stephan Müller wrote:
> Since the introduction of the ChaCha20 DRNG, extract_entropy is only
> invoked with the input_pool. For this entropy pool, xfer_secondary_pool
> is a no-op and can therefore be safely removed.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Instead of doing some minor deletions of single lines, what I want to
do is to look at a more comprehensive refactoring of the code.  The
fact that we have extract_entropy() only being used for the input
pool, and extract_entropy_user() ony being used for the non-blocking
pool, is not obvious from the function name and the arguments that
these functions take.

Either the functions should be kept general (so someone else using
them in the future won't get confused about how they work), or they
should be made more speceific.  But doing light modifications like
have the danger of causing confusion and bugs in the future.

     	 	   	   	     	 - Ted
