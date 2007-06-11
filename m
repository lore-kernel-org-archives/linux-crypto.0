From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Date: Mon, 11 Jun 2007 13:39:12 -0400
Message-ID: <466D88C0.70403@cs.cmu.edu>
References: <20070608214242.23949.30350.stgit@dev> <20070608214253.23949.40465.stgit@dev> <20070609201159.GC11166@waste.org> <466B0C3F.3040300@garzik.org> <466B46D5.1020004@cs.cmu.edu> <20070610135956.GS11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.185.41]:48446 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbXFKRkG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jun 2007 13:40:06 -0400
In-Reply-To: <20070610135956.GS11115@waste.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Matt Mackall wrote:
> In 2003, I was getting 17MB/s out of my Athlon. Now I'm getting 2.7MB/s.
> Were your tests with or without the latest /dev/urandom fixes? This
> one in particular:
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.21.y.git;a=commitdiff;h=374f167dfb97c1785515a0c41e32a66b414859a8

With.  I just tried 2.6.11 (the oldest that will boot) on the Pentium IV 
box and got 3.7 MB/s, so if it's a regression it's been around for a while.

--Benjamin Gilbert
