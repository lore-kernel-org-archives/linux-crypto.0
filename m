From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Test AES-CCM mode via IPSec (NETKEY)
Date: Fri, 14 Mar 2008 09:12:47 +0800
Message-ID: <20080314011247.GA15294@gondor.apana.org.au>
References: <E1JSQiw-0002dT-00@gondolin.me.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6043753E4@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37943 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751813AbYCNBMu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Mar 2008 21:12:50 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D6043753E4@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 13, 2008 at 10:34:32AM -0700, Loc Ho wrote:
> Hi,
> 
> I had tried this and it works after I manual performed the patch to
> iproute2.
> 
> It is possible to use program "ip" to setup algorithm non-combined mode,
> such as "authenc(cbc(aes),hmac(md5))"? If so, how?

You need to specify two algorithms on the command-line, one for
type enc and one for type auth.  Otherwise the format is the same
as for aead, i.e., type name key.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
