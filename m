From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment.
Date: Wed, 5 Mar 2008 17:37:53 +0100
Message-ID: <20080305163753.GA20787@Chamillionaire.breakpoint.cc>
References: <20080302135135.GC16659@Chamillionaire.breakpoint.cc> <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc> <20080305111602.GB27552@gondor.apana.org.au> <20080305114652.GA18070@Chamillionaire.breakpoint.cc> <20080305115203.GA28021@gondor.apana.org.au> <20080305120153.GA18425@Chamillionaire.breakpoint.cc> <47CEA7F5.2080700@the2masters.de>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54215 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533AbYCEQhz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Mar 2008 11:37:55 -0500
Content-Disposition: inline
In-Reply-To: <47CEA7F5.2080700@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Stefan Hellermann | 2008-03-05 15:02:29 [+0100]:

>I think it crashed one time, but I haven't really tried using LRW since XTS is said to
>provide better security. Now I'm not able to reproduce the crash, it works with vanilla
>2.6.25-rc4.
Okey, I drop the LRW patch and provide only a XTS fix.

Sebastian
