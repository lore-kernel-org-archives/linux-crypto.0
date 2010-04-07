From: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH v2] crypto: add blkcipher implementation of ARC4
Date: Wed, 07 Apr 2010 02:19:55 -0400
Message-ID: <1270621195.31184.45.camel@mj>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
	 <1270280969-11357-3-git-send-email-sebastian@breakpoint.cc>
	 <20100405084209.GA16788@gondor.apana.org.au>
	 <20100405170406.GA24215@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-ppp@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32555 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab0DGGT5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Apr 2010 02:19:57 -0400
In-Reply-To: <20100405170406.GA24215@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2010-04-05 at 19:04 +0200, Sebastian Andrzej Siewior wrote:

> +module_init(arc4_init);
> +module_exit(arc4_exit);

I'm feelings uneasy about using the same module init/exit functions
names in arc4blk.c and arc4cip.c.

Even though it doesn't break for me on x86_64 (whether I'm compiling
modules or a solid kernel), and even though the potential name conflict
is temporary until arc4cip.c is removed, it could break on some other
architecture or maybe with another linker.

Let's use arc4blk_init and arc4blk_exit.

-- 
Regards,
Pavel Roskin
