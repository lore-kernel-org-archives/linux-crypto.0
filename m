From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] geode: do not copy the IV too often
Date: Mon, 26 Nov 2007 10:25:21 +0100
Message-ID: <20071126092521.GC18309@Chamillionaire.breakpoint.cc>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115212335.GB21159@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46224 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536AbXKZJZW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 04:25:22 -0500
Content-Disposition: inline
In-Reply-To: <20071115212335.GB21159@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Sebastian Siewior | 2007-11-15 22:23:35 [+0100]:

>There is no reason to keep the IV in the private structre.
>This also remove a few memcpy()s
>
>Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Hi Herbert,

I saw that you rebased your cryptodev tree but you did not include
this patch. Should I resend it?

Sebastian
