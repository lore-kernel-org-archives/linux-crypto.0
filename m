From: Andreas Gerlich <agl@online.de>
Subject: hifn_7955 and Linux
Date: Fri, 31 Oct 2008 14:36:16 +0100
Message-ID: <490B09D0.1080808@online.de>
References: <49034927.9080803@online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:64006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYJaNgS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Oct 2008 09:36:18 -0400
In-Reply-To: <49034927.9080803@online.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I have following hardware:

	net5501 - Board of Soekris with AMD GoedeLX Processor 500 MHz
	vpn1401 - PCI-Card with HIFN 7955 Crypto acceleration chip also
		  from Soekris.

I'am use Debian Lenny/sid on this board. It works fine.
I can also use the geode-aes engine for encryption partiions on the HD.
But I can only use 128 bit keysize with this engine.

So I bougth the vpn1401 card with the HIFN 7955 Chip. I tought that this
Chip is fully supported by the hifn_795x module which is included in the
kernel 2.6.27 of Lenny/sid.
But it doesn't work. I get errors when I try tu use the AES-engine
of the hifn_795x/Chip/Module.

Can you tell me what the parameters are nessesary for cryptsetup to use
the hifn_7955?

I try with cryptsetup: aes-cbc-essiv:sha256, keysize=256 but that
doesn't work.

Regards
Andreas Gerlich
-- 
Andreas Gerlich, University of Ulm, Germany
open source project --> http://yaze-ag.de/ (Yet Another Z80 Emulator)
