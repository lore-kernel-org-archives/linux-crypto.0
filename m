From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto:caam - Define setbits32() and clrbits32() for ARM in the Freescale CAAM driver
Date: Sat, 24 May 2014 14:36:39 +0200
Message-ID: <201405241436.39306.marex@denx.de>
References: <1398766299-30412-1-git-send-email-ruchika.gupta@freescale.com> <20140501154650.48fde3cbe2036a062de08fb3@freescale.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ruchika Gupta <ruchika.gupta@freescale.com>,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	"Victoria Milhoan" <vicki.milhoan@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:39968 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaEXRvj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 May 2014 13:51:39 -0400
In-Reply-To: <20140501154650.48fde3cbe2036a062de08fb3@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, May 01, 2014 at 10:46:50 PM, Kim Phillips wrote:
> On Tue, 29 Apr 2014 15:41:39 +0530
> 
> Ruchika Gupta <ruchika.gupta@freescale.com> wrote:
> > The kernel defines setbits32() and clrbits32() macros only for
> > Power-based architectures.  This patch modifies the Freescale CAAM
> > driver to add macros for use on ARM architectures.
> > 
> > Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
> > Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
> > ---
> 
> Add these macros to arch/arm's io.h instead of duplicating their
> definitions in drivers such as caam.

I'd rather see the driver not using such ad-hoc stuff at all. Instead, it should 
just implement the r-m-w itself.

Best regards,
Marek Vasut
