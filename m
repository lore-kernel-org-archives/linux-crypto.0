From: Dean Jenkins <djenkins@mvista.com>
Subject: Does ESP support 64 bit sequence numbering for authentication hash
	?
Date: Wed, 14 Jan 2009 14:23:53 +0000
Message-ID: <1231943033.7937.120.camel@libdev3.mvista.co.uk>
Reply-To: djenkins@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: list crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:42468 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZANOXx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 09:23:53 -0500
Received: from [192.168.5.105] (unknown [10.120.0.200])
	by hermes.mvista.com (Postfix) with ESMTP id 8A7F0189AA
	for <linux-crypto@vger.kernel.org>; Wed, 14 Jan 2009 06:23:49 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Does ESP support 64 bit sequence numbering for use with the
authentication HMAC ?

I've looked at struct aead_givcrypt_request and it has a u64 seq member.
Does ESP populate this with a 64 bit sequence number ?

If 32 bit sequence numbering negotiated then how does the HMAC routine
know that it should not use the top 32 bits of seq ? Or is it simply
that if the top 32 bits are zero then the HMAC just uses the lower 32
bits ?

Thanks for any insight.

Regards,
Dean Jenkins
MontaVista Software

