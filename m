From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
	architecture
Date: Wed, 21 May 2008 09:20:59 +0200
Message-ID: <20080521072059.GB5290@Chamillionaire.breakpoint.cc>
References: <20080517095625.GA17878@gondor.apana.org.au> <20080520.194723.268247612.davem@davemloft.net> <20080521070954.GA5290@Chamillionaire.breakpoint.cc> <20080521.001142.114608182.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36455 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756361AbYEUHVE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 May 2008 03:21:04 -0400
Content-Disposition: inline
In-Reply-To: <20080521.001142.114608182.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* David Miller | 2008-05-21 00:11:42 [-0700]:

>From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
>Date: Wed, 21 May 2008 09:09:54 +0200
>
>> That was, what I expected as well but the numbers were different. I
>> checked the assembly code and I had the le loads but more code. I will
>> check with different compiler maybe it will get better here as well.
>
>Your particular powerpc cpu might also do these loads more slowly
>than other ones.
Yes, that could be case. However a "manual" swap has three opcodes here,
the le load has one. I should not end up with more code in the latter
cases hould I?

Sebastian
