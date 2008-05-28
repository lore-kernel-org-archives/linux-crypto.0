From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IPSec ESP Authenc Offload
Date: Wed, 28 May 2008 16:34:34 +1000
Message-ID: <20080528063434.GA1173@gondor.apana.org.au>
References: <alpine.LFD.1.10.0805250731530.23219@localhost.localdomain> <20080526112058.GA16525@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D604814C4A@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52927 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752100AbYE1Geh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 May 2008 02:34:37 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D604814C4A@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 27, 2008 at 11:29:22AM -0700, Loc Ho wrote:
> 
> For authenc hardware offload outbound, we need to know the whole ESP
> header length - IP header + UDP header + ESP header + IV. I am thinking
> adding a field in struct aead_givcrypt_request as below:

Could you please let me know why it needs this information?
Is it doing ESP offload in addition to crypt/hash offload?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
