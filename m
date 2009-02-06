From: Lee Nipper <lee.nipper@freescale.com>
Subject: ablkcipher algorithm with givencrypt
Date: Fri, 06 Feb 2009 17:26:52 -0600
Message-ID: <1233962812.362.378.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:56252 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467AbZBFXYr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Feb 2009 18:24:47 -0500
Received: from az33smr01.freescale.net (az33smr01.freescale.net [10.64.34.199])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id n16NOjpk005001
	for <linux-crypto@vger.kernel.org>; Fri, 6 Feb 2009 16:24:46 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by az33smr01.freescale.net (8.13.1/8.13.0) with ESMTP id n16NOjbl027978
	for <linux-crypto@vger.kernel.org>; Fri, 6 Feb 2009 17:24:45 -0600 (CST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

I'm implementing ablkcipher algorithms in talitos and need some clarification.

If an ablkcipher crypto algorithm implements .givencrypt with geniv as "<built-in>"
what is the reason that it cannot be used as a building block cipher for
an IPsec use case ?

I've noticed that if an ablkcipher algorithm does not implement givencrypt,
and sets geniv to eseqiv, then the algorithm can somewhat support an IPsec use case.
During testing however, it seems that eseqiv_givencrypt doesn't handle a scatterlist
fully for an already fragmented src.  For example, a large ping (> 1460 bytes)
going out causes a scatterlist with two entries within esp_output, but it appears that
the src scatterlist doesn't carry forth properly through eseqiv_givencrypt
into the ablkcipher encrypt routine.

I'm wondering if I've stumbled onto a bug in this case.
At the least my understanding is incomplete.

Thank you,

Lee Nipper
Freescale Semiconductor Inc.
 





