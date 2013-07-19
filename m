From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module
 dependency.
Date: Fri, 19 Jul 2013 16:26:09 -0700
Message-ID: <20130719232609.GA2852@kroah.com>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>
 <2493652.fjZLqTL8IF@vostro.rjw.lan>
 <1374257329.22432.382.camel@schen9-DESK>
 <4295105.1txhDL4OOg@vostro.rjw.lan>
 <20130719231630.GC1701@kroah.com>
 <51E9C9E5.2060602@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	ak <ak@linux.intel.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3GSX0B (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jul 2013 19:26:01 -0400
Content-Disposition: inline
In-Reply-To: <51E9C9E5.2060602@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 19, 2013 at 04:21:09PM -0700, H. Peter Anvin wrote:
> On 07/19/2013 04:16 PM, Greg Kroah-Hartman wrote:
> > 
> > udev isn't doing any module loading, 'modprobe' is just being called for
> > any new module alias that shows up in the system, and all of the drivers
> > that match it then get loaded.
> > 
> > How is it a problem if a module is attempted to be loaded that is
> > already loaded?  How is it a problem if a different module is loaded for
> > a device already bound to a driver?  Both of those should be total
> > "no-ops" for the kernel.
> > 
> > But, I don't know anything about the cpu code, how is loading a module
> > causing problems?  That sounds like it needs to be fixes, as any root
> > user can load modules whenever they want, you can't protect the kernel
> > from doing that.
> > 
> 
> The issue here seems to be the dynamic binding nature of the crypto
> subsystem.  When something needs crypto, it will request the appropriate
> crypto module (e.g. crct10dif), which may race with detecting a specific
> hardware accelerator based on CPUID or device information (e.g.
> crct10dif_pclmul).
> 
> RAID has effectively the same issue, and we just "solved" it by
> compiling in all the accelerators into the top-level module.

Then there's nothing to be done in udev or kmod, right?

greg k-h
