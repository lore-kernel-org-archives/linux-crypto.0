From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
	rfc4106_set_hash_subkey().
Date: Mon, 7 Feb 2011 07:48:29 +1100
Message-ID: <20110206204829.GA12652@gondor.apana.org.au>
References: <alpine.LNX.2.00.1101161527440.8049@swampdragon.chaosbits.net> <24483BA4C9F69C43A7379639D35543D7C5398DB6@irsmsx502.ger.corp.intel.com> <alpine.LNX.2.00.1102062039080.13593@swampdragon.chaosbits.net> <20110206203408.GA12426@gondor.apana.org.au> <alpine.LNX.2.00.1102062134150.13593@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Struk, Tadeusz" <tadeusz.struk@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	"Huang, Ying" <ying.huang@intel.com>,
	"Hoban, Adrian" <adrian.hoban@intel.com>,
	"Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
	"O Mahony, Aidan" <aidan.o.mahony@intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:43993 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab1BFUsd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 6 Feb 2011 15:48:33 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1102062134150.13593@swampdragon.chaosbits.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 06, 2011 at 09:34:33PM +0100, Jesper Juhl wrote:
> On Mon, 7 Feb 2011, Herbert Xu wrote:
> 
> > On Sun, Feb 06, 2011 at 08:43:22PM +0100, Jesper Juhl wrote:
> > > 
> > > Herbert: If Tadeusz agrees, could you please replace the patch you merged 
> > > with the one above?
> > 
> > Please send an incremental patch.
> > 
> Sure thing. What would you like it based on exactly?

The current cryptodev-2.6 tree should do.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
