From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: testmgr: change `guard` to unsigned char
Date: Fri, 12 Jan 2018 23:23:28 +1100
Message-ID: <20180112122328.GC21636@gondor.apana.org.au>
References: <20180101103319.fmmlpeg6kjdmhloq@gmail.com>
 <1514819026.1967.37.camel@perches.com>
 <20180101204014.643vntmxqdbfqmvb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joe Perches <joe@perches.com>, linux-crypto@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org
To: Joey Pabalinas <joeypabalinas@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:54460 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933388AbeALMYZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 07:24:25 -0500
Content-Disposition: inline
In-Reply-To: <20180101204014.643vntmxqdbfqmvb@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 01, 2018 at 10:40:14AM -1000, Joey Pabalinas wrote:
> When char is signed, storing the values 0xba (186) and 0xad (173) in the
> `guard` array produces signed overflow. Change the type of `guard` to
> static unsigned char to correct undefined behavior and reduce function
> stack usage.
> 
> Signed-off-by: Joey Pabalinas <joeypabalinas@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
