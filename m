From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Thu, 10 Jan 2008 14:35:29 +0100
Message-ID: <20080110133529.GA13851@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi> <p73ve62nzzk.fsf@bingen.suse.de> <Pine.LNX.4.64.0801101114070.1408@kivilampi-30.cs.helsinki.fi> <20080110092555.GB25076@one.firstfloor.org> <20080110092746.GA11613@gondor.apana.org.au>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Andi Kleen <andi@firstfloor.org>,
	Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56090 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116AbYAJNfj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2008 08:35:39 -0500
Content-Disposition: inline
In-Reply-To: <20080110092746.GA11613@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-01-10 20:27:46 [+1100]:

>On Thu, Jan 10, 2008 at 10:25:55AM +0100, Andi Kleen wrote:
>>
>> Then I don't think the patch should have been applied.
>
>I disagree.  There isn't any evidence showing that the inlined version
>is significantly faster either.  In the absence of that, the version
>with the smaller size is preferable.
I tried to get rid of all those macros in AES and replace them with
static only. I noticed that this makes the implementation slower. The
performance increased a little after switch to static inline but was
still less than with those macros. Unfortunately I had not the time to
investigate it any further.

Sebastian
