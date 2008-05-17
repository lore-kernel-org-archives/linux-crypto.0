From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
 architecture
Date: Sat, 17 May 2008 02:55:42 -0700 (PDT)
Message-ID: <20080517.025542.243618557.davem@davemloft.net>
References: <20080517084735.GD19540@Chamillionaire.breakpoint.cc>
	<20080517.020122.229980431.davem@davemloft.net>
	<20080517091451.GE19540@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: linux-crypto@ml.breakpoint.cc
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47000
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752031AbYEQJzr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 May 2008 05:55:47 -0400
In-Reply-To: <20080517091451.GE19540@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Date: Sat, 17 May 2008 11:14:51 +0200

> * David Miller | 2008-05-17 02:01:22 [-0700]:
> 
> >From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
> >Date: Sat, 17 May 2008 10:47:35 +0200
> >
> >> David: would you please be so kind to run a test on sparc machine?
> >
> >How do I run the test?
> 
> modprobe tcrypt mode=314
> 
> do you need / want the three patches or do you convert them yourself?

I'll use your patch and result posting as a guide and let you
know if I need any help :)
