From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Wed, 14 Feb 2007 22:14:53 -0800
Message-ID: <200702142214.53625.agruen@suse.de>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <200702142135.40832.agruen@suse.de> <20070215054559.GD15654@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	torvalds@linux-foundation.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, arjan@infradead.org,
	linux-crypto@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:41046 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbXBOGPD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Feb 2007 01:15:03 -0500
In-Reply-To: <20070215054559.GD15654@redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wednesday 14 February 2007 21:45, Dave Jones wrote:
> well, the situation for external modules is no worse than usual.
> They still work, they just aren't signed. Which from a distributor point
> of view, is actually a nice thing, as they stick out like a sore thumb
> in oops reports with (U) markers :)

I agree, that's really what should happen. We solve this by marking modules as 
supported, partner supported, or unsupported, but in an "insecure" way, so 
partners and users could try to fake the support status of a module and/or 
remove status flags from Oopses, and cryptography wouldn't save us. We could 
try to sign Oopses which I guess you guys are doing. This whole issue hasn't 
been a serious problem in the past though, and we generally try to trust 
users not to play games on us.

In the end, it all seems to boils down to a difference in philosophy.

Thanks,
Andreas
