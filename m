From: Dean Jenkins <djenkins@mvista.com>
Subject: Are there any drivers that use aead.ko
Date: Fri, 7 Nov 2008 10:40:38 +0000
Message-ID: <200811071040.38853.djenkins@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:47057 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbYKGKkk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 05:40:40 -0500
Received: from liblap4.mvista.co.uk (asshur.mvista.com [10.0.0.11])
	by hermes.mvista.com (Postfix) with ESMTP id 79F1318515
	for <linux-crypto@vger.kernel.org>; Fri,  7 Nov 2008 02:40:39 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Are there any example drivers that make use of aead.ko ?

Is it true that an AEAD driver can perform encryption and hashing in a single 
call ?

I assume aead.ko is designed for hardware crypto drivers that can do both 
encryption and hashing concurrently. Am I correct ?

Thanks for any info.

Regards,
Dean Jenkins
MontaVista software
