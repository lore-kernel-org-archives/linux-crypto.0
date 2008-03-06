From: Stefan Hellermann <stefan@the2masters.de>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment v2
Date: Thu, 06 Mar 2008 11:53:03 +0100
Message-ID: <47CFCD0F.70802@the2masters.de>
References: <20080302135135.GC16659@Chamillionaire.breakpoint.cc> <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc> <20080305111602.GB27552@gondor.apana.org.au> <20080305114652.GA18070@Chamillionaire.breakpoint.cc> <20080305115203.GA28021@gondor.apana.org.au> <20080305120153.GA18425@Chamillionaire.breakpoint.cc> <47CEA7F5.2080700@the2masters.de> <20080305163753.GA20787@Chamillionaire.breakpoint.cc> <20080305221746.GA32072@Chamillionaire.breakpoint.cc> <47CF2321.6020100@the2masters.de> <20080306085231.GA4234@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp11.unit.tiscali.de ([213.205.33.47]:39465 "EHLO
	smtp11.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYCFKxx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Mar 2008 05:53:53 -0500
In-Reply-To: <20080306085231.GA4234@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Siewior schrieb:
> * Stefan Hellermann | 2008-03-05 23:48:01 [+0100]:
> 
>> PS: The segfaults I got with 2.6.25-rc[1-3] are gone ... LRW is stable here.
> Good to hear. Now that everything seems to run, do you thing that you
> could test my key unification patches when you have some spare time?

I'm away till Tuesday, but then I can test everything :)

Stefan

> 
> Sebastian
