From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: sha-512...
Date: Thu, 16 Feb 2012 11:16:34 +1100
Message-ID: <20120216001634.GA18494@gondor.apana.org.au>
References: <20120215051608.GA9126@gondor.apana.org.au> <20120215.002352.2053362114668441348.davem@davemloft.net> <20120215192751.GA27144@p183.telecom.by> <20120215.160010.95041058128954427.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adobriyan@gmail.com, linux-crypto@vger.kernel.org,
	torvalds@linux-foundation.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60756 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2BPAQp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Feb 2012 19:16:45 -0500
Content-Disposition: inline
In-Reply-To: <20120215.160010.95041058128954427.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 15, 2012 at 04:00:10PM -0500, David Miller wrote:
>
> In fact, in my tree, this change brings the stack allocation instruction
> down to:
> 
>         save    %sp, -824, %sp  !
> 
> which is actually BETTER than what the old per-cpu code got:
> 
>         save    %sp, -984, %sp  !
> 
> Therefore I highly recommend we apply that ror() change to Linus's
> tree now. :-)

Great, I'll push that out today.

Thanks,!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
