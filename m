From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [2.6.25 patch] drivers/crypto/hifn_795x.c: fix 64bit division
Date: Tue, 26 Feb 2008 21:52:40 +0300
Message-ID: <20080226185240.GA2521@2ka.mipt.ru>
References: <20080226122100.GB22699@deprecation.cyrius.com> <20080226153421.GB10717@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Michlmayr <tbm@cyrius.com>, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ralf Baechle <ralf@linux-mips.org>,
	linux-crypto@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:55325 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251AbYBZSxo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Feb 2008 13:53:44 -0500
Content-Disposition: inline
In-Reply-To: <20080226153421.GB10717@cs181133002.pp.htv.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Adrian.

On Tue, Feb 26, 2008 at 05:34:21PM +0200, Adrian Bunk (bunk@kernel.org) wrote:
> Using ndelay() with a 64bit variable as parameter can result in build 
> errors like the following on some 32bit systems when it results in a 
> 64bit division:
> 
> <--  snip  -->
> 
>  ...
>   MODPOST 759 modules
> ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
> 
> <--  snip  -->
> 
> Reported by Martin Michlmayr.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Yep, ndelay() uses division, thanks a lot Adrian for spotting this.

Herbert, please apply.

ACK.

-- 
	Evgeniy Polyakov
