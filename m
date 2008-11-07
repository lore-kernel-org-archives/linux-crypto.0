From: Dean Jenkins <djenkins@mvista.com>
Subject: Unloading hardware based crypto to fallback to software based crypto
Date: Fri, 7 Nov 2008 10:34:41 +0000
Message-ID: <200811071034.41253.djenkins@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:45958 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYKGKem (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 05:34:42 -0500
Received: from liblap4.mvista.co.uk (asshur.mvista.com [10.0.0.11])
	by hermes.mvista.com (Postfix) with ESMTP id E392018515
	for <linux-crypto@vger.kernel.org>; Fri,  7 Nov 2008 02:34:41 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Is there a mechanism to allow a hardware crypto driver to be unloaded and the 
IPsec session to fallback to using software based crypto drivers ?

The requirement is to not take down the IPsec tunnel whilst unloading the 
hardware crypto driver. Bascially, the hardware become unavailable during the 
session.

Conversely, is there a mechanism to dynamically upgrade from using software 
based crypto to hardware based crypto without killing the IPsec tunnel ?

Thanks for any info.

Regards,
Dean Jenkins
MontaVista Software
