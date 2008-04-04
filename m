From: Joy Latten <latten@us.ibm.com>
Subject: RE: Test AES-CCM mode via IPSec (NETKEY)
Date: Fri, 04 Apr 2008 17:37:26 -0500
Message-ID: <1207348646.4158.3.camel@faith.austin.ibm.com>
References: <E1JSQiw-0002dT-00@gondolin.me.apana.org.au>
	 <0CA0A16855646F4FA96D25A158E299D6043753E4@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56490 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbYDDWtb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Apr 2008 18:49:31 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m34MnUTn014980
	for <linux-crypto@vger.kernel.org>; Fri, 4 Apr 2008 18:49:30 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m34MnUft246314
	for <linux-crypto@vger.kernel.org>; Fri, 4 Apr 2008 18:49:30 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m34MnTeN014028
	for <linux-crypto@vger.kernel.org>; Fri, 4 Apr 2008 18:49:30 -0400
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D6043753E4@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I was wondering if you could post what you passed to ip command for ccm
to get it to work with ipsec. I have not had much luck so far.

thanks!!

regards, 
Joy

On Thu, 2008-03-13 at 10:34 -0700, Loc Ho wrote:
> Hi,
> 
> I had tried this and it works after I manual performed the patch to
> iproute2.
> 
> It is possible to use program "ip" to setup algorithm non-combined mode,
> such as "authenc(cbc(aes),hmac(md5))"? If so, how?
> 
> -Loc 
> 
> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org
> [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
> Sent: Thursday, February 21, 2008 9:46 PM
> To: Loc Ho
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: Test AES-CCM mode via IPSec (NETKEY)
> 
> Loc Ho <locnho@sbcglobal.net> wrote:
> > 
> > I am trying to test AES-CCM mode via IPSec. Setkey doesn't seem to 
> > support "aes-ccm" mode. Anyone try this yet? Or should I checkout 
> > OpenSwan or racoon?
> 
> Sorry, I forgot to submit the iproute2 patch for this.
> 
> See if this one helps.
> 

