From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [CRYPTO] rmd128: Fix endian problems
Date: Mon, 19 May 2008 00:01:20 +0200
Message-ID: <20080518220120.GB6711@Chamillionaire.breakpoint.cc>
References: <20080517081003.GA19540@Chamillionaire.breakpoint.cc> <12111465553916-git-send-email-rueegsegger@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40774 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233AbYERWBW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 May 2008 18:01:22 -0400
Content-Disposition: inline
In-Reply-To: <12111465553916-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Adrian-Ken Rueegsegger | 2008-05-18 23:35:55 [+0200]:

>I put the le32_to_cpu call in the ROUND-define so code-size is smaller
>compared to Sebastians patch. I also removed the three now obsolete
>functions (le32_to_cpu_array, cpu_to_le32_array and rmd_transform_helper),
>which makes the code smaller.
Looks nice.

>I will fix the other RIPEMD modules once consensus is reached on how to
>fix the endian issues for rmd128.
cool.

>Sebastian, would you be so kind to test this patch on PowerPC?
Sure. I do it once I'm able to and let you know.

Sebastian
