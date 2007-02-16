From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Fri, 16 Feb 2007 15:21:35 -0500
Message-ID: <20070216202135.GA22121@redhat.com>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <20070215221304.GB6602@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
	akpm@osdl.org, herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
	arjan@infradead.org, linux-crypto@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946121AbXBPUV7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Feb 2007 15:21:59 -0500
Content-Disposition: inline
In-Reply-To: <20070215221304.GB6602@ucw.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 15, 2007 at 10:13:04PM +0000, Pavel Machek wrote:
 > Hi!
 > 
 > > Now, this is not a complete solution by any means: the core kernel is not
 > > protected, and nor are /dev/mem or /dev/kmem, but it denies (or at least
 > > controls) one relatively simple attack vector.
 > 
 > Could we fix the /dev/*mem holes, first? They are already used by
 > malicious modules (aka rootkits...).  Or can selinux already provide
 > /dev/*mem protection with no way for admin to turn it off?

There are some valid uses for peeking through /dev/mem. Things like
dmidecode for example.  So you don't want to disable it completely
in a lot of cases, but have fine-grained access to specific parts
of the file.  I'm not sure SELinux can do this. Maybe the MLS stuff
helps here (though I'm far from an expert on this, so I could be
talking out of my rear).

The restricted dev/mem patches we've had in Fedora for a while
do the right thing, but they're a bit crufty (in part due to
drivers/char/mem.c being a bit of a mess before we even start
patching it).  I've had "clean these up for upstream" on my
todo for a while. I might get around to it one of these days.

		Dave

-- 
http://www.codemonkey.org.uk
