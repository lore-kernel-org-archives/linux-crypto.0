From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC] group common used functions in software AES modules
Date: Mon, 22 Oct 2007 19:22:11 +0200
Message-ID: <1193073734-15789-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53750 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903AbXJVRWS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Oct 2007 13:22:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Herbert,

this little patch series moves the the key generation routine and the four
tables which are used encrypt/decrypt function into a separate module.
Currently I converted the generic AES and the x86_64 variant. My 32bit asm 
is rusted so the i586 assembly has to wait for a while :)

Sebastian
