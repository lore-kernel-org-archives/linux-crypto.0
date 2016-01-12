From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: ablk_decrypt causes BUG in scatterwalk
Date: Tue, 12 Jan 2016 21:16:44 +0800
Message-ID: <20160112131644.GA906@gondor.apana.org.au>
References: <CACT4Y+bjJ9Hs-jT1SAWZS95xnr+dxP-1H8jGb8u7XzpEZKDX8Q@mail.gmail.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:44664 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758157AbcALNQu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2016 08:16:50 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+bjJ9Hs-jT1SAWZS95xnr+dxP-1H8jGb8u7XzpEZKDX8Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 12, 2016 at 10:27:44AM +0100, Dmitry Vyukov wrote:
> Hello,
> 
> The following program cause BUG in scatterwalk:

Weird, I can't reproduce the crash.  Can you perhaps convert this to
a non-racy reproduction, possibly by using strace to find the order
of execution that leads to the crash?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
