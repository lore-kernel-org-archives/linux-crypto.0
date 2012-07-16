From: Simon Baatz <gmbnomis@gmail.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Mon, 16 Jul 2012 19:32:34 +0200
Message-ID: <20120716173234.GA14418@schnuecks.de>
References: <20120618134718.GL9122@philter.vipri.net>
 <20120618201235.GA20755@schnuecks.de>
 <20120619115123.GN9122@philter.vipri.net>
 <4FE09637.2020802@gmail.com>
 <20120619171304.GQ9122@philter.vipri.net>
 <4FE12478.2030104@gmail.com>
 <20120716093225.GB2489@lunn.ch>
 <20120716135216.GA18870@philter.vipri.net>
 <20120716140344.GH2489@lunn.ch>
 <20120716145318.GB18870@philter.vipri.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "cloudy.linux" <cloudy.linux@gmail.com>,
	Simon Baatz <gmbnomis@gmail.com>, linux-crypto@vger.kernel.org
To: Phil Sutter <phil.sutter@viprinet.com>,
	Andrew Lunn <andrew@lunn.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39100 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2GPRch (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jul 2012 13:32:37 -0400
Received: by weyx8 with SMTP id x8so4111152wey.19
        for <linux-crypto@vger.kernel.org>; Mon, 16 Jul 2012 10:32:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120716145318.GB18870@philter.vipri.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Andrew, Phil,

On Mon, Jul 16, 2012 at 04:53:18PM +0200, Phil Sutter wrote:
> On Mon, Jul 16, 2012 at 04:03:44PM +0200, Andrew Lunn wrote:
> > On Mon, Jul 16, 2012 at 03:52:16PM +0200, Phil Sutter wrote:
> > > Hey Andrew,
> > > 
> > > On Mon, Jul 16, 2012 at 11:32:25AM +0200, Andrew Lunn wrote:
> > > > I've not been following this thread too closely..
> > > > 
> > > > Do you have any patches you want included into mainline?
> > > 
> > > No need to fix anything mainline
> > 
> > O.K. I thought there was a problem with user space using it, some
> > flushes missing somewhere? Or VM mapping problem? Has that been fixed?
> 
> Hmm, there was some discussion about an issue like that in this list at
> end of February/beginning of March, which was resolved then. On the
> other hand there is an unanswered mail from Cloudy at 20. April about a
> failing kernel hash test. Maybe he can elaborate on this?
> 

I think the problem is not in mv_cesa but in
flush_kernel_dcache_page(). I have proposed a fix here:

http://www.spinics.net/lists/arm-kernel/msg176913.html

There was a little bit of discussion on the patch, but it has not
been picked up yet.

- Simon
