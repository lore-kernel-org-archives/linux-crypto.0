From: <linux-crypto@ml.breakpoint.cc>
Subject: [RFC 0/6] small geode cleanup + fallback
Date: Fri, 12 Oct 2007 17:21:01 +0200
Message-ID: <1192202467-10335-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42112 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752283AbXJLPVK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Oct 2007 11:21:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Herbert,

This patchset started in order to verify broken Geode driver [1] without
the actual hardware. [2] contains a version of the geode-aes driver where
the hardware routines are replaced with software because I assume that 
the hardware is actually working (and this is the closest I get). I came
to the conclusion that the driver should work (I was able to mkfs,cp, sha1 
files on the crypto partition).

This patch set contains a small "clean up" of the driver and a fallback 
mode for keysize != 128. Hebert, if you like this way of fallback (patch 5) 
than I would try to hook the s390 driver with something similar.

This way of fallback allocates a "fully working" driver within the actual
driver. Therefore if we request cbc(aes) with 192 bit key, than we have
1 fallback blkcipher and 1 fallback cipher (due to the chaining nature of
the crypto API).

[1] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg01041.html
[2] git://breakpoint.cc/bigeasy/linux geode_nohw

Sebastian
