From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: Re: [RFC PATCH] [XFRM] xfrm_algo: correct usage of RIPEMD-160
Date: Mon, 02 Jun 2008 09:09:40 +0200
Message-ID: <48439CB4.5090809@swiss-it.ch>
References: <1212340578-15574-1-git-send-email-rueegsegger@swiss-it.ch> <1212340578-15574-2-git-send-email-rueegsegger@swiss-it.ch> <20080602065132.GA11128@Chamillionaire.breakpoint.cc> <48439AF0.30508@swiss-it.ch> <20080602070456.GA21479@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:58233 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYFBHJn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 03:09:43 -0400
In-Reply-To: <20080602070456.GA21479@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> On Mon, Jun 02, 2008 at 09:02:08AM +0200, Adrian-Ken Rueegsegger wrote:
>> Yes, that would be the other way to do it. Is there a preference or specific reason
>> for renaming the hash algorithm than changing the reference to the algorithm?
> 
> I think the rmd name is fine.  The existing entry in IPsec has
> never worked (since we didn't have the implementation) so it
> isn't an issue.

Ok thanks for the clarification. I will resubmit the patch to the addresses you specified.
I assume linux-crypto should also be cc'd?

Adrian
