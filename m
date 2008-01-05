From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC 0/2] make crypto fully modularly
Date: Sat, 5 Jan 2008 13:36:37 +0100
Message-ID: <20080105123637.GA12561@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58412 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842AbYAEMgn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Jan 2008 07:36:43 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

I grep'ed for CONFIG_CRYPTO and crypto_has_alg() users and noticed that
only xfrm_algo.c must be fixed (patch #1).
The second patch than groups the four files together to a module. I
didn't add MODULE_AUTHOR() because I did not know who it might be but I
guess it would be you :)

Sebastian
