From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Thu, 10 Jan 2008 16:46:50 +0100
Message-ID: <20080110154650.GA29453@one.firstfloor.org>
References: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi> <p73ve62nzzk.fsf@bingen.suse.de> <Pine.LNX.4.64.0801101114070.1408@kivilampi-30.cs.helsinki.fi> <20080110092555.GB25076@one.firstfloor.org> <20080110092746.GA11613@gondor.apana.org.au> <20080110133529.GA13851@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:34732 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbYAJPoR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2008 10:44:17 -0500
Content-Disposition: inline
In-Reply-To: <20080110133529.GA13851@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 10, 2008 at 02:35:29PM +0100, Sebastian Siewior wrote:
> * Herbert Xu | 2008-01-10 20:27:46 [+1100]:
> 
> >On Thu, Jan 10, 2008 at 10:25:55AM +0100, Andi Kleen wrote:
> >>
> >> Then I don't think the patch should have been applied.
> >
> >I disagree.  There isn't any evidence showing that the inlined version
> >is significantly faster either.  In the absence of that, the version
> >with the smaller size is preferable.
> I tried to get rid of all those macros in AES and replace them with
> static only. I noticed that this makes the implementation slower. The

Yes not unexpected. These crypto functions tend to be carefully tuned
(or at least their critical loops are) and changing inlines in carefully 
tuned code is usually a bad idea.

-Andi
