From: Dean Jenkins <djenkins@mvista.com>
Subject: Can anyone explain the AEAD implementation
Date: Mon, 3 Nov 2008 11:01:16 +0000
Message-ID: <200811031101.16398.djenkins@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:60123 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbYKCLBS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Nov 2008 06:01:18 -0500
Received: from liblap4.mvista.co.uk (asshur.mvista.com [10.0.0.11])
	by hermes.mvista.com (Postfix) with ESMTP id 095A218584
	for <linux-crypto@vger.kernel.org>; Mon,  3 Nov 2008 03:01:17 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I observe that the ESP module uses an AEAD crypto API. AEAD means 
Authentication Encryption with Associated Data. It seems Encryption and HMAC 
are combined into a single API. Am I correct ?

Please can anyone explain how individual Encryption algorithms and Hashing 
algorithms are selected for the AEAD API ? For example, I want to use a 
particular AES and SHA-1 implementations in a hardware accelerator.

Thanks,

Regards,
Dean Jenkins
MontaVista Software
