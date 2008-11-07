From: Dean Jenkins <djenkins@mvista.com>
Subject: Module load sequence
Date: Fri, 7 Nov 2008 10:46:20 +0000
Message-ID: <200811071046.20959.djenkins@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:48190 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYKGKqW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 05:46:22 -0500
Received: from liblap4.mvista.co.uk (asshur.mvista.com [10.0.0.11])
	by hermes.mvista.com (Postfix) with ESMTP id 969DE18646
	for <linux-crypto@vger.kernel.org>; Fri,  7 Nov 2008 02:46:21 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I notice that the crypto in the kernel dynamically loads in crypto modules.

It appears that crypto algorithms are loaded first followed by cbc.ko, then 
crypto_blkcipher.ko and authenc.

How does crypto decide which modules to load. It seems related to the 
string "authenc(hmac(sha1),cbc(aes))" ?

Thanks for any info.

Regards,
Dean Jenkins
MontaVista Software
