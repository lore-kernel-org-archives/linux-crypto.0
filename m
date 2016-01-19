From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: GPF in scatterwalk_start
Date: Tue, 19 Jan 2016 16:35:13 +0800
Message-ID: <20160119083513.GA8110@gondor.apana.org.au>
References: <CACT4Y+bQGUjabQVkN=9C84tj716Ux8GprLwFYJSapWOLy-r50Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52522 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbcASIfV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2016 03:35:21 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+bQGUjabQVkN=9C84tj716Ux8GprLwFYJSapWOLy-r50Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 19, 2016 at 09:30:40AM +0100, Dmitry Vyukov wrote:
> Hello,
> 
> The following program causes GPF in scatterwalk_start.
> 
> Herbert, I am on commit 5807fcaa9bf7dd87241df739161c119cf78a6bc4 with
> all your fixes applied, including the fix for out-of-bounds in
> skcipher_recvmsg.

Does it happen without the out-of-bounds patch?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
