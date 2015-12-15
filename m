From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: WARNING in crypto_wait_for_test
Date: Tue, 15 Dec 2015 12:14:52 +0800
Message-ID: <20151215041452.GA9196@gondor.apana.org.au>
References: <CACT4Y+bws9Scv7o3AB2wPM0ZJAeDvO+kZ45h-p5viDk9ZAe9KQ@mail.gmail.com>
 <6672511.rbcxt2K4Lk@tauon.atsec.com>
 <20151214125219.GA1514@gondor.apana.org.au>
 <3121405.vKidzTde2R@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Vyukov <dvyukov@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42047 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321AbbLOEPF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Dec 2015 23:15:05 -0500
Content-Disposition: inline
In-Reply-To: <3121405.vKidzTde2R@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 14, 2015 at 11:45:02PM +0100, Stephan Mueller wrote:
>
> But with the given code, when you remove the bogus mask setting (which in turn 
> leaves it as 0), the code works flawless.

Please find out exactly why this would be triggering the warning
because your previous explanation of not being able to find the
algorithm due to the mask does not make sense.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
