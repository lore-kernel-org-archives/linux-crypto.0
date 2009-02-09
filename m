From: Lee Nipper <lee.nipper@freescale.com>
Subject: Re: ablkcipher algorithm with givencrypt
Date: Mon, 09 Feb 2009 16:19:44 -0600
Message-ID: <1234217984.362.397.camel@al08linux99>
References: <1233962812.362.378.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:42115 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZBIWRf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Feb 2009 17:17:35 -0500
Received: from az33smr01.freescale.net (az33smr01.freescale.net [10.64.34.199])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id n19MHY0Q004866
	for <linux-crypto@vger.kernel.org>; Mon, 9 Feb 2009 15:17:34 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by az33smr01.freescale.net (8.13.1/8.13.0) with ESMTP id n19MHYx9001441
	for <linux-crypto@vger.kernel.org>; Mon, 9 Feb 2009 16:17:34 -0600 (CST)
In-Reply-To: <1233962812.362.378.camel@al08linux99>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2009-02-06 at 17:26 -0600, Lee Nipper wrote:
> During testing however, it seems that eseqiv_givencrypt doesn't handle a scatterlist
> fully for an already fragmented src.  For example, a large ping (> 1460 bytes)
> going out causes a scatterlist with two entries within esp_output, but it appears that
> the src scatterlist doesn't carry forth properly through eseqiv_givencrypt
> into the ablkcipher encrypt routine.

I was mistaken.  I was unaware of the chained sg from eseqiv_givencrypt.
Using scatterwalk_sg_next instead of sg_next handles it.

Lee

