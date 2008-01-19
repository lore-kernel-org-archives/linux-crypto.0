From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: small patch queue
Date: Sat, 19 Jan 2008 01:02:10 +0100
Message-ID: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@ml.breakpoint.cc
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38851 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbYASId3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2008 03:33:29 -0500
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1JG98p-0002cs-Qh
	for linux-crypto@vger.kernel.org; Sat, 19 Jan 2008 09:33:27 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

Patch 1 and 2 are shrinking the speed template a little. Did you had
something like this in mind?
Patch 3 removes the return parameter from the AES-i586 asm module   
because it is unused anyway.
Patch 4 + 5 is not an attempt to touch as many file as possible but 
something you asked for [1] :) I'm not sure if the patches are worth it.
The problem I have is patch 5 since 4 is easy :) I'm touching only ecb &
cbc. I don't thing error recovery makes sense here. If an error occurs in
ecb mode and the operation is not inplace than you can repeat it without a
problem. If the operation is inplace than you may have destroyed your src.
In case of cbc you are in trouble anyway because your IV is undefined.
The error recovery could get quite complex here, so maybe a BUG() statement
isn't that bad at all or?

[1] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg01236.html

Sebastian
