From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Mon, 16 Jul 2012 19:59:27 +0200
Message-ID: <20120716175927.GE4015@lunn.ch>
References: <20120618201235.GA20755@schnuecks.de>
 <20120619115123.GN9122@philter.vipri.net>
 <4FE09637.2020802@gmail.com>
 <20120619171304.GQ9122@philter.vipri.net>
 <4FE12478.2030104@gmail.com>
 <20120716093225.GB2489@lunn.ch>
 <20120716135216.GA18870@philter.vipri.net>
 <20120716140344.GH2489@lunn.ch>
 <20120716145318.GB18870@philter.vipri.net>
 <20120716173234.GA14418@schnuecks.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Sutter <phil.sutter@viprinet.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"cloudy.linux" <cloudy.linux@gmail.com>,
	linux-crypto@vger.kernel.org
To: Simon Baatz <gmbnomis@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from londo.lunn.ch ([80.238.139.98]:55831 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab2GPSAY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jul 2012 14:00:24 -0400
Content-Disposition: inline
In-Reply-To: <20120716173234.GA14418@schnuecks.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I think the problem is not in mv_cesa but in
> flush_kernel_dcache_page(). I have proposed a fix here:
> 
> http://www.spinics.net/lists/arm-kernel/msg176913.html
> 
> There was a little bit of discussion on the patch, but it has not
> been picked up yet.
 
Hi Simon

This is core code, not an area i feel comfortable about.

I suggest you repost it, CC: Catalin and Russell.

  Andrew
