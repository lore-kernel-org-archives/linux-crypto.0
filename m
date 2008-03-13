From: "Loc Ho" <lho@amcc.com>
Subject: RE: Test AES-CCM mode via IPSec (NETKEY)
Date: Thu, 13 Mar 2008 10:34:32 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D6043753E4@SDCEXCHANGE01.ad.amcc.com>
References: <E1JSQiw-0002dT-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail01-ext1.amcc.com ([198.137.200.72]:45164 "EHLO
	sdcmail01.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbYCMRoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Mar 2008 13:44:04 -0400
Content-class: urn:content-classes:message
In-Reply-To: <E1JSQiw-0002dT-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I had tried this and it works after I manual performed the patch to
iproute2.

It is possible to use program "ip" to setup algorithm non-combined mode,
such as "authenc(cbc(aes),hmac(md5))"? If so, how?

-Loc 

-----Original Message-----
From: linux-crypto-owner@vger.kernel.org
[mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
Sent: Thursday, February 21, 2008 9:46 PM
To: Loc Ho
Cc: linux-crypto@vger.kernel.org
Subject: Re: Test AES-CCM mode via IPSec (NETKEY)

Loc Ho <locnho@sbcglobal.net> wrote:
> 
> I am trying to test AES-CCM mode via IPSec. Setkey doesn't seem to 
> support "aes-ccm" mode. Anyone try this yet? Or should I checkout 
> OpenSwan or racoon?

Sorry, I forgot to submit the iproute2 patch for this.

See if this one helps.

Cheers,
--
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au> Home Page:
http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
