From: Lee Nipper <lee.nipper@freescale.com>
Subject: Re: [PATCH 1/3] crypto: talitos - pass correct interrupt status
	to	error handler
Date: Mon, 13 Oct 2008 09:52:35 -0500
Message-ID: <1223909555.25819.7.camel@al08linux99>
References: <E1Kp09g-0003in-8T@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:61801 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbYJMOmJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Oct 2008 10:42:09 -0400
Received: from de01smr01.freescale.net (de01smr01.freescale.net [10.208.0.31])
	by de01egw02.freescale.net (8.12.11/de01egw02) with ESMTP id m9DEg5in024753
	for <linux-crypto@vger.kernel.org>; Mon, 13 Oct 2008 07:42:06 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by de01smr01.freescale.net (8.13.1/8.13.0) with ESMTP id m9DEg5J9011275
	for <linux-crypto@vger.kernel.org>; Mon, 13 Oct 2008 09:42:05 -0500 (CDT)
In-Reply-To: <E1Kp09g-0003in-8T@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 2008-10-12 at 05:34 -0700, Herbert Xu wrote:
> I've applied all three patches.  However, I had to fix up the
> bits around INIT_LIST_HEAD in 1 and 3.  So please check the
> cryptodev-2.6 tree and let me know if it's wrong.
> 
I checked cryptodev-2.6 and it looks good.  Thank you!

I thought I had double checked the 3 patches against mainline
but obviously I had not.  I must have gotten skewed a bit.
I will be more careful.

Thanks for the fix up.

Lee

