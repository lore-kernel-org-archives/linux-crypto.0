From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: group common used functions in software AES modules, take 2
Date: Sun, 28 Oct 2007 16:35:42 +0100
Message-ID: <1193585742-26284-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33777 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbXJ1Pfr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 28 Oct 2007 11:35:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is almost a repost of an earlier series. I got rid of the 
aes_common module and the x86_64 selects the generic version.

Sebastian
