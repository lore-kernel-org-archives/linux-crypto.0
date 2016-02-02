From: Rui Wang <rui.y.wang@intel.com>
Subject: Re: [PATCH v2 4/4] crypto: testmgr - Add a test case for import()/export()
Date: Tue,  2 Feb 2016 23:03:40 +0800
Message-ID: <1454425420-20656-1-git-send-email-rui.y.wang@intel.com>
Cc: rui.y.wang@intel.com, tim.c.chen@linux.intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Feb 2, 2016 10:45 PM Herbert Xu wrote:
>
> On Tue, Feb 02, 2016 at 10:16:34PM +0800, Rui Wang wrote:
> >
> > I initially made it unconditional, but then I found that it can easily
> > hang the machine during boot due to any import/export bug in any of
> > the hash drivers. So I used this .partial flag to guard against this
> > risk. Only when an author is confident that his driver can do this
> > test, should he add this flag. What do you think?
> 
> Well if they're buggy they may crash anyway.  Considering that all the buggy
> drivers have probably been disabled for the time being I'd say let's make it
> unconditional.

You are right the ahash drivers are already disabled. The shash drivers using
cryptd or mcryptd are probably OK by now. I'll do some tests.

Thanks
Rui 
