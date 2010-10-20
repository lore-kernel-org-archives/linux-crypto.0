From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Date: Wed, 20 Oct 2010 21:02:34 +0800
Message-ID: <20101020130233.GB25827@gondor.apana.org.au>
References: <4CB41CED.mailDED1NSGGA@intel.com> <20101019124908.GA12898@gondor.apana.org.au> <44813D8942D35947805CBEEA94195BB001B135B69E@irsmsx505.ger.corp.intel.com> <24483BA4C9F69C43A7379639D35543D7C2F99F27@irsmsx502.ger.corp.intel.com> <CFBC532374C38D45810FA00BC2D2C204012D3E76C4@irsmsx502.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Struk, Tadeusz" <tadeusz.struk@intel.com>,
	"O Mahony, Aidan" <aidan.o.mahony@intel.com>,
	"Paoloni, Gabriele" <gabriele.paoloni@intel.com>
To: "Hoban, Adrian" <adrian.hoban@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:38953 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0JTNCg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Oct 2010 09:02:36 -0400
Content-Disposition: inline
In-Reply-To: <CFBC532374C38D45810FA00BC2D2C204012D3E76C4@irsmsx502.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 20, 2010 at 11:49:10AM +0100, Hoban, Adrian wrote:
> Hi Herbert,
> 
> We have been using binutils v2.19. 
> 
> Can you please recommend the version(s) of binutils (gas) that we should test with before submitting a patch? V2.16.1, or perhaps the older version (2.12) described in /Documentation/Changes? 
> 
> We will retest with the recommended version, update the code and resubmit the patch ASAP. 

I was using 2.18 so if you can make it work with 2.16 I think it
should be fine as it wouldn't require any of the new AES instructions.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
