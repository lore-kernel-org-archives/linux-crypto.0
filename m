From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] Enable VIA PadLock on x86_64
Date: Mon, 11 May 2009 10:29:01 +0800
Message-ID: <20090511022901.GA4005@prithivi.gnumonks.org>
References: <20090510160341.GH12152@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:41635 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbZEKC6o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 May 2009 22:58:44 -0400
Content-Disposition: inline
In-Reply-To: <20090510160341.GH12152@prithivi.gnumonks.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 11, 2009 at 12:03:41AM +0800, Harald Welte wrote:
> [CRYPTO] Support VIA PadLock hardware crypto on x86-64
 
Sorry, I should have read the list archives before posting.

Please apply the more correct patch from Sebastian Andrzej Siewior
as available since March 14 at
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03024.html

Is there any reason I'm missing that this patch is not mainline yet? It's
a quite trivial bugfix.  So please consider this mail as a polite reminder :)

Thanks in advance.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
