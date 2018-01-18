From: LABBE Corentin <clabbe@baylibre.com>
Subject: Re: [PATCH 1/2] crypto: Implement a generic crypto statistics
Date: Thu, 18 Jan 2018 09:58:13 +0100
Message-ID: <20180118085813.GA1988@Red>
References: <1515700617-3513-1-git-send-email-clabbe@baylibre.com>
 <3297958.ndliyBY1jk@tauon.chronox.de>
 <20180112090730.GA15630@Red>
 <16302559.hxlYq3rOsN@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, nhorman@tuxdriver.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        smueller@chronox.de
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:44615 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754840AbeARI6R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 03:58:17 -0500
Received: by mail-lf0-f68.google.com with SMTP id w23so25533849lfd.11
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2018 00:58:17 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <16302559.hxlYq3rOsN@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 12, 2018 at 10:11:18AM +0100, Stephan Mueller wrote:
> Am Freitag, 12. Januar 2018, 10:07:30 CET schrieb LABBE Corentin:
> 
> > > > +	__u64 stat_hash_tlen;
> > > > 
> > > >  };
> > > 
> > > What I am slightly unsure here is: how should user space detect whether
> > > these additional parameters are part of the NETLINK_USER API or not? I
> > > use that interface in my libkcapi whose binary may be used on multiple
> > > different kernel versions. How should that library operate if one kernel
> > > has these parameters and another does not?
> > 
> > Userspace could check for kernel version and know if stat are present or
> > not. Another way is to add a new netlink request.
> 
> Well, I am not sure that checking the kernel version is good enough. Distros 
> and other vendors may backport this patch. This means that for some older 
> kernel versions this interface is present.
> 
> Hence I would rather opt for a separate stat message where the user spacee 
> caller receives an error on kernels that does not support it.
> 
Herbert,
I have two way of adding a new netlink request
- keep the current patch and simply add a new CRYPTO_MSG_GETSTAT which use the same function than CRYPTO_MSG_GETALG
	=> minimal changes, in fact CRYPTO_MSG_GETSTAT and CRYPTO_MSG_GETALG would be the same, but it is easy for userspace to test presence of stat.
- Create a new CRYPTO_MSG_GETSTAT which imply lot of code and add a new crypto_user_stat.c
	=> this imply also to change makefile (rename crypto_user.c to crypto_user_base.c) since crypto_user.ko is made of two files.

Which one do you prefer ?

Regards
