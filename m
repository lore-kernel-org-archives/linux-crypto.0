From: Dean Jenkins <djenkins@mvista.com>
Subject: What is the difference between aead.ko and authenc.ko ?
Date: Fri, 7 Nov 2008 10:27:21 +0000
Message-ID: <200811071027.21178.djenkins@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:44690 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYKGK1X (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 05:27:23 -0500
Received: from liblap4.mvista.co.uk (asshur.mvista.com [10.0.0.11])
	by hermes.mvista.com (Postfix) with ESMTP id E8BF018798
	for <linux-crypto@vger.kernel.org>; Fri,  7 Nov 2008 02:27:21 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Can anyone explain the difference between aead.ko and authenc.ko ?

How does crypto decide to use aead.ko instead of authenc.ko ? I am guessing it 
is something to do with XFRM ?

Thanks,

Regards,
Dean Jenkins
MontaVista Software
