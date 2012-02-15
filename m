From: David Miller <davem@davemloft.net>
Subject: sha-512...
Date: Tue, 14 Feb 2012 22:58:33 -0500 (EST)
Message-ID: <20120214.225833.303014660389989764.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:52011 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab2BOD6j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Feb 2012 22:58:39 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


FYI, I just started seeing this on sparc32 after all those
sha512 "optimizations":

crypto/sha512_generic.c: In function 'sha512_transform':
crypto/sha512_generic.c:135:1: warning: the frame size of 1136 bytes is larger than 1024 bytes [-Wframe-larger-than=]
