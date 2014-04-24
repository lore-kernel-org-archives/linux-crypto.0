From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Freescale SEC1 and AEAD / IPSEC
Date: Thu, 24 Apr 2014 15:34:25 +0200
Message-ID: <535912E1.5000109@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:21542 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbaDXNea (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 09:34:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'm progressing well on the SEC1 implementation. I now have HASH (non 
HMAC) , DES and AES working properly.
So it is now time to look at AEAD.
I don't know much yet about crypto algorithm so forgive me if I ask 
stupid questions.

The SEC1 doesn't have the IPSEC descriptor that SEC2 has. However, the 
SEC Lite Descriptor Programmer's Guide tells us to use the 
hmac_snoop_no_afeu descriptor to perform IPSEC.

Are both descriptors (more or less) equivalent ? Can the Talitos driver 
be easily modified to use that descriptor ? Are there any limitations or 
impossibilities to do so ?

Christophe
