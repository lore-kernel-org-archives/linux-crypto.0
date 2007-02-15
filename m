From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Thu, 15 Feb 2007 01:22:18 -0500
Message-ID: <20070215062218.GA917@redhat.com>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <200702142135.40832.agruen@suse.de> <20070215054559.GD15654@redhat.com> <200702142214.53625.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	torvalds@linux-foundation.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, arjan@infradead.org,
	linux-crypto@vger.kernel.org
To: Andreas Gruenbacher <agruen@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbXBOGWa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Feb 2007 01:22:30 -0500
Content-Disposition: inline
In-Reply-To: <200702142214.53625.agruen@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 14, 2007 at 10:14:53PM -0800, Andreas Gruenbacher wrote:
 > On Wednesday 14 February 2007 21:45, Dave Jones wrote:
 > > well, the situation for external modules is no worse than usual.
 > > They still work, they just aren't signed. Which from a distributor point
 > > of view, is actually a nice thing, as they stick out like a sore thumb
 > > in oops reports with (U) markers :)
 > 
 > I agree, that's really what should happen. We solve this by marking modules as 
 > supported, partner supported, or unsupported, but in an "insecure" way, so 
 > partners and users could try to fake the support status of a module and/or 
 > remove status flags from Oopses, and cryptography wouldn't save us. We could 
 > try to sign Oopses which I guess you guys are doing. This whole issue hasn't 
 > been a serious problem in the past though, and we generally try to trust 
 > users not to play games on us.

For the most part it works out.  I've had users file oopses where they've editted
out Tainted: P, and left in nvidia(U) for example :-)

		Dave

-- 
http://www.codemonkey.org.uk
