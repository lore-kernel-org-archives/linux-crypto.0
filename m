From: "Loc Ho" <lho@amcc.com>
Subject: RE: [PATCH 1/1] CryptoAPI: Add Async Hash Support
Date: Wed, 9 Apr 2008 19:03:45 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D6044D6442@SDCEXCHANGE01.ad.amcc.com>
References: <20080117112314.GC9020@gondor.apana.org.au> <001c01c85937$ff3313f0$5c05420a@amcc.com> <20080117202735.GA22733@Chamillionaire.breakpoint.cc> <0CA0A16855646F4FA96D25A158E299D603FCC4D7@SDCEXCHANGE01.ad.amcc.com> <20080118230721.GA30470@Chamillionaire.breakpoint.cc> <002301c85c96$32a67a40$5c05420a@amcc.com> <20080122231818.GB6920@Chamillionaire.breakpoint.cc> <002d01c85d66$11e1d7c0$5c05420a@amcc.com> <004601c85ecd$1eb53d80$5c05420a@amcc.com> <004a01c85efc$56f2ee70$5c05420a@amcc.com> <20080313114230.GC8393@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail01-ext1.amcc.com ([198.137.200.72]:46113 "EHLO
	sdcmail01.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbYDJCDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Apr 2008 22:03:49 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080313114230.GC8393@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I just sync with cryptodev git and don't see async hash/digest added.
Have it being committed?

-Loc

-----Original Message-----
From: linux-crypto-owner@vger.kernel.org
[mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
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

