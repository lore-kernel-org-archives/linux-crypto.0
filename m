From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IPSec ESP Authenc Offload
Date: Thu, 29 May 2008 08:22:46 +1000
Message-ID: <20080528222246.GA7798@gondor.apana.org.au>
References: <alpine.LFD.1.10.0805250731530.23219@localhost.localdomain> <20080526112058.GA16525@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D604814C4A@SDCEXCHANGE01.ad.amcc.com> <20080528063434.GA1173@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D604814F16@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36870 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753428AbYE1WWt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 May 2008 18:22:49 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D604814F16@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 28, 2008 at 09:42:47AM -0700, Loc Ho wrote:
> Hi,
> 
> With IPSec ESP Authenc, it is expected that the selected driver
> generates "IV" as well as encrypts the data. Our 'hardware' (available
> currently), can only handle either no header processing or header
> processing (from ESP to IV processing but not individual field
> processing). 
> 
> For no header processing, we will have to do a lot more work in software
> - create a context SA for each requested operation, copy from the
> initial context SA, after the operation completed, retrieve the update
> IV from context SA, and then write it back to the packet.

Do you still need to do this if we used a software-generated IV?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
