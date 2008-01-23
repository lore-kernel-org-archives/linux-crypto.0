From: "Loc Ho" <locnho@sbcglobal.net>
Subject: RE: New Crypto Hardware
Date: Tue, 22 Jan 2008 18:17:14 -0800
Message-ID: <002d01c85d66$11e1d7c0$5c05420a@amcc.com>
References: <E1IrkmY-0007gp-00@gondolin.me.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603EB866F@SDCEXCHANGE01.ad.amcc.com> <20071225073202.GA31076@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603FCC15D@SDCEXCHANGE01.ad.amcc.com> <20080117112314.GC9020@gondor.apana.org.au> <001c01c85937$ff3313f0$5c05420a@amcc.com> <20080117202735.GA22733@Chamillionaire.breakpoint.cc> <0CA0A16855646F4FA96D25A158E299D603FCC4D7@SDCEXCHANGE01.ad.amcc.com> <20080118230721.GA30470@Chamillionaire.breakpoint.cc> <002301c85c96$32a67a40$5c05420a@amcc.com> <20080122231818.GB6920@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
To: "'Sebastian Siewior'" <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:34450 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751222AbYAWCRQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Jan 2008 21:17:16 -0500
In-Reply-To: <20080122231818.GB6920@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I had an working version of async hashing (for HMAC mode). Have not tested
with software wrapper yet like async blkciper implementation but with an
async hash sample driver wrapped directly over hmac(md5). 

Currently, async block ciper calls crypto_alloc_ablkciper for various mode.
I would like to do the same. If we do need two version, I would still like
to keep the interface called by tcrypt.c to be identical, except calling
'setkey' would be either no operation or return error.

Until this is confirmed, will start testing the async software wrapper over
synchronous interface.

-Loc
 

-----Original Message-----
From: linux-crypto-owner@vger.kernel.org
[mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Sebastian Siewior
Sent: Tuesday, January 22, 2008 3:18 PM
To: Loc Ho
Cc: 'Sebastian Siewior'; Herbert Xu; linux-crypto@vger.kernel.org
Subject: Re: New Crypto Hardware

* Loc Ho | 2008-01-21 17:29:13 [-0800]:

>If that is the case, then in order to fully support async hashing, I 
>would need an async version of HASH interface and an async version of 
>digest. Am I correct?
Yes. In case you support hmac+sha1 in HW and you don't do sha1 (as
digest) at all you could skip that part.

>Do you think it will be inconsistent if it is assumed that if the 
>functional setkey is not called, then it is digest. If it is called, 
>then it is hash.
I would prefer to seperate them. However, this is one of those things where
Herbert has the last word :)

>-Loc

Sebastian
