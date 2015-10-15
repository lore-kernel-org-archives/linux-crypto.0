From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 3/3] crypto: keywrap - add testmgr support
Date: Thu, 15 Oct 2015 08:58:33 +0800
Message-ID: <20151015005833.GA22073@gondor.apana.org.au>
References: <3564891.reL3VOPkWo@tachyon.chronox.de>
 <2239265.sodxccK8do@tachyon.chronox.de>
 <20151014142623.GA17455@gondor.apana.org.au>
 <2368869.z13cidVPPU@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46773 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbbJOA6i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 20:58:38 -0400
Content-Disposition: inline
In-Reply-To: <2368869.z13cidVPPU@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 14, 2015 at 08:44:53PM +0200, Stephan Mueller wrote:
>
> Did you apply the depending patch referenced in the beginning?
> 
> https://lkml.org/lkml/2015/6/16/342
> 
> I thought I understood you wanted to pull it. If not, I will add the necessary 
> code and resubmit.

Yes but I want to finish the skcipher conversion before applying
these patches so please don't depend on them just yet.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
