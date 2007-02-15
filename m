From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Thu, 15 Feb 2007 22:13:04 +0000
Message-ID: <20070215221304.GB6602@ucw.cz>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, davej@redhat.com,
	arjan@infradead.org, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1412 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946110AbXBPUP4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Feb 2007 15:15:56 -0500
Content-Disposition: inline
In-Reply-To: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

> Now, this is not a complete solution by any means: the core kernel is not
> protected, and nor are /dev/mem or /dev/kmem, but it denies (or at least
> controls) one relatively simple attack vector.

Could we fix the /dev/*mem holes, first? They are already used by
malicious modules (aka rootkits...).  Or can selinux already provide
/dev/*mem protection with no way for admin to turn it off?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
