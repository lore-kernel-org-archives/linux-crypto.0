From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Bug of dm-crypt?
Date: Fri, 27 Feb 2009 13:41:47 +0800
Message-ID: <20090227054147.GA22159@gondor.apana.org.au>
References: <1235712716.6204.100.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <mbroz@redhat.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38171 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752064AbZB0Flz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2009 00:41:55 -0500
Content-Disposition: inline
In-Reply-To: <1235712716.6204.100.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 27, 2009 at 01:31:56PM +0800, Huang Ying wrote:
> Hi, Herbert,
> 
> I had ever heard from you that the only thing guaranteed in the
> completion function of async ablkcipher cryption is the req->data has
> the value you set before. The request pointer itself may be changed. But
> in dm-crypt, I found they rely on request pointer in completion
> function: kcryptd_async_done. This makes my AES-NI cryptd usage panic.
> 
> Do you think that is a bug?

Absolutely.

It should use cc->req instead.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
