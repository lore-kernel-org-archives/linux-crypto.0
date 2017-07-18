From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH v12 1/4] crypto: make Jitter RNG directly accessible
Date: Tue, 18 Jul 2017 10:49:59 +0200
Message-ID: <20170718084959.GA25267@kroah.com>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
 <22067042.Wh8NKMhEMa@positron.chronox.de>
 <20170718083014.GA18340@kroah.com>
 <5020806.nso7MErEBx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43486 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdGRIuF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 04:50:05 -0400
Content-Disposition: inline
In-Reply-To: <5020806.nso7MErEBx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 18, 2017 at 10:40:07AM +0200, Stephan Müller wrote:
> Am Dienstag, 18. Juli 2017, 10:30:14 CEST schrieb Greg Kroah-Hartman:
> 
> Hi Greg,
> 
> > > +typedef	unsigned long long	__u64;
> > > +typedef	long long		__s64;
> > 
> > types.h already has these defines, don't re-typedef them again...
> 
> The issue is that the C code is compiled without optimizations. Thus, the C 
> code shall not depend on any other header file.

That is very strange for a kernel file, I don't know what to say...

> This issue was discussed during the inclusion of the Jitter RNG C code into 
> the kernel.

Ok, that was then, this is now, why not change it now?  How does
including types.h change anything?

thanks,

greg k-h
