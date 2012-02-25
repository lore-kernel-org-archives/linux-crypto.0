From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Hit OOPS on FPU save and restore while useing AESNI for IPSec
	on 32 bit System
Date: Sat, 25 Feb 2012 19:37:02 +1100
Message-ID: <20120225083702.GA19389@gondor.apana.org.au>
References: <20120223021435.BEE08153400@mail3-79.sinamail.sina.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: timlee@sina.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:48605 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752640Ab2BYIhH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Feb 2012 03:37:07 -0500
Content-Disposition: inline
In-Reply-To: <20120223021435.BEE08153400@mail3-79.sinamail.sina.com.cn>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

timlee@sina.com wrote:
> Hi All,
> 
> Recently I hit an OOPS on FPU save/restore in Linux version 2.6.38.8 using aesni_intel_asm.S and aesni_intel_glue.c for native IPSec(netkey) on 32bit System. The same OOPS were found in versions 2.6.39.4, 3.0.x and 3.1.x.But I did not hit this problem in 64 bit system for all these versions.
> 
> My platform information: 
> "Linux dnsubuntu 2.6.38.8 #7 SMP Sat Nov 12 03:11:12 CST 2011 i686 i686 i386 GNU/Linux"

Please try the latest git tree (rc4).  It should be fixed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
