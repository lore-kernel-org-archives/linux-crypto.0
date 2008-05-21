From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
 architecture
Date: Wed, 21 May 2008 00:11:42 -0700 (PDT)
Message-ID: <20080521.001142.114608182.davem@davemloft.net>
References: <20080517095625.GA17878@gondor.apana.org.au>
	<20080520.194723.268247612.davem@davemloft.net>
	<20080521070954.GA5290@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: linux-crypto@ml.breakpoint.cc
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48440
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbYEUHLs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 May 2008 03:11:48 -0400
In-Reply-To: <20080521070954.GA5290@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Date: Wed, 21 May 2008 09:09:54 +0200

> That was, what I expected as well but the numbers were different. I
> checked the assembly code and I had the le loads but more code. I will
> check with different compiler maybe it will get better here as well.

Your particular powerpc cpu might also do these loads more slowly
than other ones.
