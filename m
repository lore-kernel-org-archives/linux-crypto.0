From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Date: Wed, 13 Nov 2013 18:14:44 +0100
Message-ID: <20131113171444.GA4973@amd.pavel.ucw.cz>
References: <2579337.FPgJGgHYdz@tauon>
 <1391779.T98KINxAMQ@myon.chronox.de>
 <528367D0.6010900@ladisch.de>
 <27146362.bQgmetPpTV@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Clemens Ladisch <clemens@ladisch.de>,
	Theodore Ts'o <tytso@mit.edu>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Nicholas Mc Guire <der.herr@hofr.at>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47877 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab3KMROz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Nov 2013 12:14:55 -0500
Content-Disposition: inline
In-Reply-To: <27146362.bQgmetPpTV@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

> >BTW: MFENCE is not guaranteed to flush the instruction pipeline; you
> >need CPUID for that.
> 
> I was not aware of that. Can I simply call the CPUID instruction to read 
> it or do I have to do something special?

Simply call CPUID (warning, it clobbers some registers.).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
