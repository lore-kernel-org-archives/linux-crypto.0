From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] aesni-intel: Merge with fpu.ko
Date: Mon, 16 May 2011 15:13:34 +1000
Message-ID: <20110516051334.GA32458@gondor.apana.org.au>
References: <7d8af8fba578ff152819ae196694d351d9741c2e.1304820759.git.luto@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Milan Broz <mbroz@redhat.com>
To: Andy Lutomirski <luto@MIT.EDU>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58716 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1EPFNl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 May 2011 01:13:41 -0400
Content-Disposition: inline
In-Reply-To: <7d8af8fba578ff152819ae196694d351d9741c2e.1304820759.git.luto@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, May 07, 2011 at 10:22:00PM -0400, Andy Lutomirski wrote:
> Loading fpu without aesni-intel does nothing.  Loading aesni-intel
> without fpu causes modes like xts to fail.  (Unloading
> aesni-intel will restore those modes.)
> 
> One solution would be to make aesni-intel depend on fpu, but it
> seems cleaner to just combine the modules.
> 
> This is probably responsible for bugs like:
> https://bugzilla.redhat.com/show_bug.cgi?id=589390
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
