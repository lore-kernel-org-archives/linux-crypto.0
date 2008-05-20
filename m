From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH 0/3] [CRYPTO] ripemd: Fix endian issues
Date: Tue, 20 May 2008 23:32:34 +0200
Message-ID: <20080520213234.GA998@Chamillionaire.breakpoint.cc>
References: <1211312992-6439-1-git-send-email-rueegsegger@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60316 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758213AbYETVcg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 May 2008 17:32:36 -0400
Content-Disposition: inline
In-Reply-To: <1211312992-6439-1-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Adrian-Ken Rueegsegger | 2008-05-20 21:49:49 [+0200]:

>These patches fix the endian issues reported by Sebastian Siewior for
>the three remaining RIPEMD modules rmd160, rmd256 and rmd320.
>
> crypto/rmd160.c |   37 +++++++++----------------------------
> crypto/rmd256.c |   37 +++++++++----------------------------
> crypto/rmd320.c |   37 +++++++++----------------------------
> 3 files changed, 27 insertions(+), 84 deletions(-)
For the whole series:
Acked-by: Sebastian Siewior <sebastian@breakpoint.cc>

Thanks for fixing this.
Sebastian
