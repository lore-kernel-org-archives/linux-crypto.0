From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: crypto-ixp4xx: Deletion of a few unnecessary checks
Date: Wed, 18 Nov 2015 08:28:26 +0100
Message-ID: <564C289A.5010507@users.sourceforge.net>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <5648D2C1.8050603@users.sourceforge.net>
 <564B489F.10308@users.sourceforge.net>
 <20151118000358.GA13894@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:63614 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbbKRH2s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Nov 2015 02:28:48 -0500
In-Reply-To: <20151118000358.GA13894@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>>   Delete unnecessary checks before the function call "dma_pool_destroy"

It seems that you accepted this specific update suggestion, didn't you?
https://lkml.org/lkml/2015/11/17/391
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1021951.html


>>   Reduce assignment for a variable in init_ixp_crypto()
>>   crypto-ixp4xx: Less function calls in init_ixp_crypto() after error detection
> 
> You completely ignored my comments.  Nack.

Will it be useful to clarify the proposed changes a bit more?

Regards,
Markus
