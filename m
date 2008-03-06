From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment v2
Date: Thu, 6 Mar 2008 09:52:31 +0100
Message-ID: <20080306085231.GA4234@Chamillionaire.breakpoint.cc>
References: <20080302135135.GC16659@Chamillionaire.breakpoint.cc> <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc> <20080305111602.GB27552@gondor.apana.org.au> <20080305114652.GA18070@Chamillionaire.breakpoint.cc> <20080305115203.GA28021@gondor.apana.org.au> <20080305120153.GA18425@Chamillionaire.breakpoint.cc> <47CEA7F5.2080700@the2masters.de> <20080305163753.GA20787@Chamillionaire.breakpoint.cc> <20080305221746.GA32072@Chamillionaire.breakpoint.cc> <47CF2321.6020100@the2masters.de>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35311 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658AbYCFIwd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Mar 2008 03:52:33 -0500
Content-Disposition: inline
In-Reply-To: <47CF2321.6020100@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Stefan Hellermann | 2008-03-05 23:48:01 [+0100]:

>PS: The segfaults I got with 2.6.25-rc[1-3] are gone ... LRW is stable here.
Good to hear. Now that everything seems to run, do you thing that you
could test my key unification patches when you have some spare time?

Sebastian
