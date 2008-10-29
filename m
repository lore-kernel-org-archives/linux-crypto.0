From: James Hsiao <jhsiao@amcc.com>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v2
Date: Wed, 29 Oct 2008 16:05:24 -0700
Message-ID: <1225321524.4841.58.camel@jhsiao-usb>
References: <1225158336-8777-1-git-send-email-jhsiao@amcc.com>
	 <1225158932.4768.29.camel@jhsiao-usb>
	 <20081029131428.GA13501@Chamillionaire.breakpoint.cc>
Reply-To: jhsiao@amcc.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:17604 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268AbYJ2XEJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Oct 2008 19:04:09 -0400
In-Reply-To: <20081029131428.GA13501@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I think the patch format in the email is incorrect, so the one go to
linux-crypto was filtered out. And the one directly to Kim was received
and Kim kindly reviewed....

Thanks for review.

James

On Wed, 2008-10-29 at 14:14 +0100, Sebastian Andrzej Siewior wrote:
> * James Hsiao | 2008-10-27 18:55:32 [-0700]:
> >Kim suggest us submit this to linuxppc-dev for more review.
> so do I
> 
> >> 
> >> diff --git a/arch/powerpc/boot/dts/kilauea.dts b/arch/powerpc/boot/dts/kilauea.dts
> >> index dececc4..58b48a0 100644
> >> --- a/arch/powerpc/boot/dts/kilauea.dts
> >> +++ b/arch/powerpc/boot/dts/kilauea.dts
> >> @@ -1,4 +1,4 @@
> >> -/*
> >> +/* 
> >>   * Device Tree Source for AMCC Kilauea (405EX)
> >>   *
> Usually we are removing leading/trailing blanks. Not the other way
> around. 
> I haven't seen this change in the submit at Date: Fri, 19 Sep 2008
> 16:46:43 -0700. Is this an updated version or does my mailbox leak
> emails?
> 
> Sebastian

