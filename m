From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Wed, 14 Feb 2007 23:13:45 -0500
Message-ID: <20070215041345.GA15654@redhat.com>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <20070214194112.5bec3110.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
	herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
	arjan@infradead.org, linux-crypto@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbXBOEOa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Feb 2007 23:14:30 -0500
Content-Disposition: inline
In-Reply-To: <20070214194112.5bec3110.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 14, 2007 at 07:41:12PM -0800, Andrew Morton wrote:

 >  77 files changed, 9681 insertions(+), 10 deletions(-)
 > 
 > just to be able to sign modules.
 > 
 > Normally I'd collapse writhing in laughter, but..
 > 
 > > These patches have been in use by RHEL and Fedora kernels for years, and so
 > > have been thoroughly tested.
 > 
 > so I guess there's an argument for merging them so we can send them back to
 > you guys.  But there's also an argument to declare all this gunk a
 > vendor-only thing.  How much pain would that cause?

it needs rediffing pretty much every time the cryptoapi changes.
On a good month that means once per point release, otherwise...

One argument in its favour is aparently Red Hat isn't the only vendor
with something like this.  I've not investigated it, but I hear rumours
that suse has something similar.  Having everyone using the same code
would be a win for obvious reasons.

		Dave

-- 
http://www.codemonkey.org.uk
