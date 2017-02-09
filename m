From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] random: Don't overwrite CRNG state in crng_initialize()
Date: Thu, 9 Feb 2017 10:23:35 +0100
Message-ID: <20170209092335.GB10164@kroah.com>
References: <1486611086-2290-1-git-send-email-alden.tondettar@gmail.com>
 <20170209064725.GA4363@kroah.com>
 <20170209090432.GA18039@rincewind>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Alden Tondettar <alden.tondettar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdBIJYB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 04:24:01 -0500
Content-Disposition: inline
In-Reply-To: <20170209090432.GA18039@rincewind>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 09, 2017 at 02:04:32AM -0700, Alden Tondettar wrote:
> On Thu, Feb 09, 2017 at 07:47:25AM +0100, Greg Kroah-Hartman wrote:
> > On Wed, Feb 08, 2017 at 08:31:26PM -0700, Alden Tondettar wrote:
> > > In short, the situation is:
> > > 
> > > A) No usable hardware RNG or arch_get_random() (or we don't trust it...)
> > 
> > Wait, why would you not trust arch_get_random()?  Is it broken somehow
> > on some arches?  If so, why not fix that as well?
> 
> arch_get_random() makes use of RDRAND and similar CPU features. Some people
> do not wish to trust black-box RNG implementations.

It does not use those features "raw", it uses the output to feed the
entropy, which, from my understanding, should be the same as feeding any
other form of data into the system, right?

So while it is always nice to worry about different things, I think this
is something that is very low on the "possible to cause an issue" scale.

thanks,

greg k-h
