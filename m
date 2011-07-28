From: Ralf Jung <ralfjung-e@gmx.de>
Subject: cryptsetup: "FATAL" padlock_{aes,sha} error during boot
Date: Thu, 28 Jul 2011 14:03:26 +0200
Message-ID: <201107281403.27224.ralfjung-e@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: 485070@bugs.debian.org, katzj@redhat.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:41449 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754366Ab1G1MDR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jul 2011 08:03:17 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

as per request of Jonathan at http://bugs.debian.org/cgi-
bin/bugreport.cgi?bug=485070, I am reporting the mentioned bug to this list as 
well:

With current Debian testing (Kernel 2.6.39), I am getting this error on each 
boot:
FATAL: Error inserting padlock_sha (/lib/modules/2.6.39-2-
amd64/kernel/drivers/crypto/padlock-sha.ko): No such device
I understand it is harmless, but it should still be fixed since it irritates 
users suggesting something is seriously going wrong.

No patch though, sorry, compiling and botting a custom kernel still sounds 
like black magic for me ;-)

Kind regards,
Ralf
