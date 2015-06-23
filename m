From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] random: add random_initialized command line param
Date: Tue, 23 Jun 2015 22:44:11 +0200
Message-ID: <20150623204411.GB30826@amd>
References: <4206400.x843ypJTc1@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35872 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909AbbFWUoO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2015 16:44:14 -0400
Content-Disposition: inline
In-Reply-To: <4206400.x843ypJTc1@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon 2015-05-18 18:25:25, Stephan Mueller wrote:
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

Speaking of random and kernel parameters... should we add random=<hex
digits> parameter to pass entropy from bootloader to the kernel?

u-boot-SPL does DRAM calibration, for example, and I guess that may
provide some rather hard to guess values...

[I initialy misread parameter below as "random_initize=" and thought
it does exactly this...]
								Pavel

> +	random_initialized= [KNL] Set the threshold in bits at which the
> +			Linux random number generator considers an output
> +			entropy pool initialized.
> +			Format: <int> (must be >= 112 and <= size of output
> +				       entropy pool in bits)
> +			Default: 128
> +
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
