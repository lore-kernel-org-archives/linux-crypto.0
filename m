From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v12 1/4] crypto: make Jitter RNG directly accessible
Date: Tue, 18 Jul 2017 10:40:07 +0200
Message-ID: <5020806.nso7MErEBx@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <22067042.Wh8NKMhEMa@positron.chronox.de> <20170718083014.GA18340@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60624 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751336AbdGRIkJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 04:40:09 -0400
In-Reply-To: <20170718083014.GA18340@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 18. Juli 2017, 10:30:14 CEST schrieb Greg Kroah-Hartman:

Hi Greg,

> > +typedef	unsigned long long	__u64;
> > +typedef	long long		__s64;
> 
> types.h already has these defines, don't re-typedef them again...

The issue is that the C code is compiled without optimizations. Thus, the C 
code shall not depend on any other header file.

This issue was discussed during the inclusion of the Jitter RNG C code into 
the kernel.

Ciao
Stephan
