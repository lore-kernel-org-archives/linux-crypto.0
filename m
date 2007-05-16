From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [XFRM] Camellia: fixed to add compat name for Camellia.
Date: Wed, 16 May 2007 19:18:56 +1000
Message-ID: <20070516091856.GA21695@gondor.apana.org.au>
References: <20061018.161510.796986352.takamiya@po.ntts.co.jp> <20061018.161749.782295638.takamiya@po.ntts.co.jp> <20070516.165231.783376564.takamiya@po.ntts.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	camellia-oss@sec.ms.ntts.co.jp
To: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4049 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758094AbXEPJTP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 May 2007 05:19:15 -0400
Content-Disposition: inline
In-Reply-To: <20070516.165231.783376564.takamiya@po.ntts.co.jp>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 16, 2007 at 04:52:31PM +0900, Noriaki TAKAMIYA wrote:
> 
>   I checked the linux-2.6.21.y.git and linux-2.6.git tree.
> 
>   The patch I sent had the compat name for "camellia", but applied
>   code doesn't have it.

Actually this was deliberate.  The compat name only exists so that
existing users aren't broken.  New users should always configure
it with the full name, that is, "cbc(camellia)".

Of course, af_key users will continue to use numerical IDs as they
currently do.

Is there a case where this is difficult?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
