From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: New Crypto Hardware
Date: Wed, 23 Jan 2008 00:18:18 +0100
Message-ID: <20080122231818.GB6920@Chamillionaire.breakpoint.cc>
References: <E1IrkmY-0007gp-00@gondolin.me.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603EB866F@SDCEXCHANGE01.ad.amcc.com> <20071225073202.GA31076@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603FCC15D@SDCEXCHANGE01.ad.amcc.com> <20080117112314.GC9020@gondor.apana.org.au> <001c01c85937$ff3313f0$5c05420a@amcc.com> <20080117202735.GA22733@Chamillionaire.breakpoint.cc> <0CA0A16855646F4FA96D25A158E299D603FCC4D7@SDCEXCHANGE01.ad.amcc.com> <20080118230721.GA30470@Chamillionaire.breakpoint.cc> <002301c85c96$32a67a40$5c05420a@amcc.com>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: 'Sebastian Siewior' <linux-crypto@ml.breakpoint.cc>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Loc Ho <locnho@sbcglobal.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36490 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbYAVXSV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Jan 2008 18:18:21 -0500
Content-Disposition: inline
In-Reply-To: <002301c85c96$32a67a40$5c05420a@amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Loc Ho | 2008-01-21 17:29:13 [-0800]:

>If that is the case, then in order to fully support async hashing, I would
>need an async version of HASH interface and an async version of digest. Am I
>correct?
Yes. In case you support hmac+sha1 in HW and you don't do sha1 (as
digest) at all you could skip that part.

>Do you think it will be inconsistent if it is assumed that if the
>functional setkey is not called, then it is digest. If it is called, then it
>is hash.
I would prefer to seperate them. However, this is one of those things
where Herbert has the last word :)

>-Loc

Sebastian
