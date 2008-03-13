From: "Loc Ho" <locnho@sbcglobal.net>
Subject: RE: [PATCH 1/1] CryptoAPI: Add Async Hash Support
Date: Thu, 13 Mar 2008 10:39:32 -0700
Message-ID: <008401c88531$331f7350$a820420a@amcc.com>
References: <20080117112314.GC9020@gondor.apana.org.au> <001c01c85937$ff3313f0$5c05420a@amcc.com> <20080117202735.GA22733@Chamillionaire.breakpoint.cc> <0CA0A16855646F4FA96D25A158E299D603FCC4D7@SDCEXCHANGE01.ad.amcc.com> <20080118230721.GA30470@Chamillionaire.breakpoint.cc> <002301c85c96$32a67a40$5c05420a@amcc.com> <20080122231818.GB6920@Chamillionaire.breakpoint.cc> <002d01c85d66$11e1d7c0$5c05420a@amcc.com> <004601c85ecd$1eb53d80$5c05420a@amcc.com> <004a01c85efc$56f2ee70$5c05420a@amcc.com> <20080313114230.GC8393@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	"'Sebastian Siewior'" <linux-crypto@ml.breakpoint.cc>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:45738 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752174AbYCMRqK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Mar 2008 13:46:10 -0400
In-Reply-To: <20080313114230.GC8393@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 Hi,

Okay... Don't forget the async digest patch (separate email) as well. Is
there a reason why we still need the "async crypto deamon"?

-Loc

-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: Thursday, March 13, 2008 4:43 AM
To: Loc Ho
Cc: linux-crypto@vger.kernel.org; 'Sebastian Siewior'
Subject: Re: [PATCH 1/1] CryptoAPI: Add Async Hash Support

On Thu, Jan 24, 2008 at 06:45:25PM -0800, Loc Ho wrote:
> >From e5d67c3670f1ec15339a92cc291027c0a059aaed Mon Sep 17 00:00:00 
> >2001
> From: Loc Ho <lho@amcc.com>
> Date: Thu, 24 Jan 2008 18:13:28 -0800
> Subject: [PATCH] Add Async Hash Support

I'm really sorry for not responding earlier.

Anyway the code looks good over all and I'm going to play with it here a
little before sticking it into cryptodev.

Thanks!
--
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au> Home Page:
http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

