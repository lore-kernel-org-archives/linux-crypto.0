From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: Talitos input data format
Date: Wed, 19 Aug 2009 11:43:04 -0500
Message-ID: <20090819114304.e56153d8.kim.phillips@freescale.com>
References: <085C99672E8EFD479528708F30B80A090366E629@VIECLEX01.frequentis.frq>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: "CEVAN Ondrej" <Ondrej.CEVAN@frequentis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:59233 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbZHSQnM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2009 12:43:12 -0400
In-Reply-To: <085C99672E8EFD479528708F30B80A090366E629@VIECLEX01.frequentis.frq>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 19 Aug 2009 13:19:54 +0200
"CEVAN Ondrej" <Ondrej.CEVAN@frequentis.com> wrote:

> Hello everybody,
> 
> according to the function call in drivers/crypto/talitos.c (Linux version
> 2.6.29) in function ipsec_esp():
> 
> /*hmac data*/
> map_single_talitos_ptr(dev, &desc->ptr[1], sg_virt(areq->src) -
> sg_virt(areq->assoc), sg_virt(areq->assoc), 0, DMA_TO_DEVICE);
> 
> if initialization vector (IV) should be included for HMAC computation, it
> must be in the memory after the associated data (ASSOC) and after ASSOC and
> IV the areq->src data must follow. Thus in memory it should look like: 
> +---------+------+-------------------------+
> |  ASSOC  |  IV  | DATA to encrypt/decrypt |
> +---------+------+-------------------------+
> 
> Is my assumption right? Well my code is working but I want to ask you if it

yes, I recently posted a patch to change the above (assoc - src) pointer
math, to an (assoclen + ivsize) calculation.

> is really a requirement that is hopefully somewhere specified. Where could I
> find such information? My searching in Documentation dir and Google was
> without success.  

it's specified in the code :)

It's a requirement for IPSec ESP, of which a good guide can be found
here:

http://unixwiz.net/techtips/iguide-ipsec.html

> Also, how does it work when I do not want to use ASSOC but still the IV
> should be included in HMAC computation? Is it then intended that the pointer
> areq->assoc points on the IV? Or am I not in the right ballpark?

yes, I imagine the request would come in with its 'assoc' pointer equal
to its 'giv'.

For an authenc request for IPsec ESP, req->assoc points to the ESP
header (SPI+seq.num), req->giv points after the ESP header to the IV,
and req->src points to the data to be ciphered (which directly follows
the IV).

Kim
