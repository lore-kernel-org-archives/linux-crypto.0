From: =?ISO-8859-15?Q?Adrian-Ken_R=FCegsegger?= <rueegsegger@swiss-it.ch>
Subject: Re: [PATCH] [CRYPTO] rmd128: Fix endian problems
Date: Mon, 19 May 2008 22:37:31 +0200
Message-ID: <4831E50B.4060101@swiss-it.ch>
References: <20080517081003.GA19540@Chamillionaire.breakpoint.cc> <12111465553916-git-send-email-rueegsegger@swiss-it.ch> <20080519200145.GB16813@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2514 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbYESUh4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 May 2008 16:37:56 -0400
In-Reply-To: <20080519200145.GB16813@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Sebastian Siewior wrote:
> * Adrian-Ken Rueegsegger | 2008-05-18 23:35:55 [+0200]:
> 
>> Sebastian, would you be so kind to test this patch on PowerPC?
> Acked-by: Sebastian Siewior <sebastian@breakpoint.cc>

Sebastian, thanks for testing :)

If there are no objections I will prepare patches for the other RIPEMD modules and submit all of them in one patch set.

-Adrian
