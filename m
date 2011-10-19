From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] talitos: handle descriptor not found in error path
Date: Wed, 19 Oct 2011 17:52:43 +0200
Message-ID: <20111019155243.GA28941@gondor.apana.org.au>
References: <20110924191649.a42c86d2.kim.phillips@freescale.com> <20111018073613.GA13923@gondor.apana.org.au> <20111018111700.75b79365.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: svens@stackframe.org, linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:48832 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab1JSPwx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Oct 2011 11:52:53 -0400
Content-Disposition: inline
In-Reply-To: <20111018111700.75b79365.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 18, 2011 at 11:17:00AM -0500, Kim Phillips wrote:
>
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05996.html
> 
> It makes IPSec AH work for async crypto implementations.

This needs to go through netdev@vger.kernel.org.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
