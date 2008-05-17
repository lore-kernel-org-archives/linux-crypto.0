From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
	architecture
Date: Sat, 17 May 2008 11:14:51 +0200
Message-ID: <20080517091451.GE19540@Chamillionaire.breakpoint.cc>
References: <20080517082754.GC19540@Chamillionaire.breakpoint.cc> <20080517083738.GA17452@gondor.apana.org.au> <20080517084735.GD19540@Chamillionaire.breakpoint.cc> <20080517.020122.229980431.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43966 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbYEQJOz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 May 2008 05:14:55 -0400
Content-Disposition: inline
In-Reply-To: <20080517.020122.229980431.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* David Miller | 2008-05-17 02:01:22 [-0700]:

>From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
>Date: Sat, 17 May 2008 10:47:35 +0200
>
>> David: would you please be so kind to run a test on sparc machine?
>
>How do I run the test?

modprobe tcrypt mode=314

do you need / want the three patches or do you convert them yourself?

Sebastian
