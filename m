From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Thu, 15 Feb 2007 22:03:06 +0100
Message-ID: <20070215210306.GF13958@stusta.de>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, davej@redhat.com,
	arjan@infradead.org, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57977 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161271AbXBOVDB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Feb 2007 16:03:01 -0500
Content-Disposition: inline
In-Reply-To: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 14, 2007 at 07:09:38PM +0000, David Howells wrote:
>...
> There are several reasons why these patches are useful, amongst which are:
>...
>  (4) to allow other support providers to do likewise, or at least to _detect_
>      the fact that unsupported modules are loaded;
> 
>  (5) to allow the detection of modules replaced by a second-order distro or a
>      preloaded Linux purveyor.
>...

Who might have rebuilt the whole kernel using a new signature.

Or a bug reporter might have edited out the parts containing the 
information that unsupported code was loaded.

Or the unsupported module itself might have removed all traces of having 
been loaded from the kernel.

For printing nvidia(U), you could simply add some marker similar to 
MODULE_LICENSE() that gets added to supported modules during "official" 
builds and gets checked when loading a module.

That's 10k LOC less and the same level of security...

> David

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
