From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Link order of the AES-module(s)
Date: Tue, 22 Jan 2008 23:20:12 +0100
Message-ID: <20080122222012.GA6920@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34469 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbYAVWUU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Jan 2008 17:20:20 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

this is just for the protocol. If you build the two aes modules into
the kernel (1x asm + 1x generic) than the asm module is initialized
before the generic one and even before the crypto API itself. This was
allready the case before I started to dig around :)
This is currently not a problem because the module itself isn't used at
that time and the init code doesn't do much.

Sebastian
