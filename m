From: Pavel Roskin <proski@gnu.org>
Subject: Converting mac80211 CCMP to packet-at-a-time processing
Date: Fri, 12 Mar 2010 00:29:22 -0500
Message-ID: <1268371762.6763.26.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:11043 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab0CLF3X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Mar 2010 00:29:23 -0500
Received: from [192.168.0.22] (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by smtprelay2.cesmail.net (Postfix) with ESMTPSA id BE9DC34C6A
	for <linux-crypto@vger.kernel.org>; Fri, 12 Mar 2010 00:30:01 -0500 (EST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello!

The CCMP encryption in mac80211 uses crypto API to encrypt 16 bytes at a
time.  I believe this is not the best approach if hardware acceleration
is used.  The ixp4xx_crypto driver doesn't even provide the "aes"
ciphers.  It only provides block ciphers, such as "cbc(des)".

It would be much better if mac80211 could encrypt the whole packet at a
time.  Actually, that's what the WEP code is doing.

I realize that CCMP is a more sophisticated cipher, so maybe it's not so
easy.  "ccm(aes)" is probably the closest thing to what is needed, but
it's not even a block cipher, it's an AEAD.

Unfortunately, I don't see any examples of AEAD use in the kernel other
than the crypto testing module.  And I'm not even sure if "ccm(aes)" is
the right choice for CCMP.

I'll appreciate if somebody with a cryptographic background could have a
look at net/mac80211/aes_ccm.c and suggest whether it could be converted
to packet-at-a-time processing.

-- 
Regards,
Pavel Roskin
