From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Freescale SEC1 and HMAC
Date: Thu, 24 Apr 2014 15:22:28 +0200
Message-ID: <53591014.4060408@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:21398 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbaDXNWa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 09:22:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In the Talitos driver, there is a TALITOS_FTR_HMAC_OK flag which is set 
only for SEC2.1
Is there any reason for that ?

According to the doc, SEC2 and SEC1 all seems to support HMAC.
However I have tried it on SEC1 and it seems that it doesn't work 
properly when wanting to perform a continuation with several descriptors 
(which is the case for the last test vector).

And when reading the doc I get confused: the MPC885 Reference Manual 
describes a CONT bit in MDEU Mode Register to be used for implementing 
continuation mode. The bits seems to be properly set by the driver, but 
the result is not the one expected.
Then when I looks into the addendum document AN2912 "SEC Lite Descriptor 
Programmer's Guide", the CONT bit is not included in the mode register, 
and for the INT bit (which is supposed to be used to initialize for the 
first packet of a continuation) it is said it must be set to 1 at all time.

Do you know anything about that ?

Christophe
