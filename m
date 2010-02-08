From: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: LZO irreversible output?
Date: Mon, 08 Feb 2010 19:33:11 +1100
Message-ID: <4B6FCC47.2030705@crca.org.au>
References: <4B69ECE5.5060505@crca.org.au> <201002032354.11284.rjw@sisk.pl> <4B6A4F07.3090509@crca.org.au> <hkneh9$djl$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	tuxonice-devel@lists.tuxonice.net
To: Bill Davidsen <davidsen@tmr.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.crca.org.au ([67.207.131.56]:40513 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab0BHIbG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Feb 2010 03:31:06 -0500
In-Reply-To: <hkneh9$djl$1@ger.gmane.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Bill.

Bill Davidsen wrote:
> I would hope someone will look at the real problem, though, that LZO
> isn't working properly. I have to assume that either the kernel
> decompress is broken or that the page you have given is invalid, and the
> error lies in the compression.
> 
> It doesn't look as if you are doing something wrong, it looks broken.

I did get hold of Richard Purdie and Nitin Gupta, who were the guys in
the know. We discovered that LZO is expecting decomp_size to be
initialised to the amount of available space when the decompression code
is called, so there was a bug in my testing code. Nitin was talking
about sending a patch to the documentation to make this requirement clearer.

That said, the actual code that TuxOnIce uses does already initialise
the variable to PAGE_SIZE, so it seems that I might just have to run
with the checking code enabled (with this fix) for a while, until the
issue is found.

Regards,

Nigel

