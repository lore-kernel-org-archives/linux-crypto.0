From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rsa-pkcs1pad - Fix akcipher request allocation
Date: Mon, 18 Jul 2016 18:23:14 +0800
Message-ID: <20160718102314.GB13780@gondor.apana.org.au>
References: <1468491905-2597-1-git-send-email-salvatore.benedetto@intel.com>
 <bed68e2b-6397-1663-606c-6f19695d94ed@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Salvatore Benedetto <salvatore.benedetto@intel.com>,
	davem@davemloft.net, andrew.zaborowski@intel.com,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tstruk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57215 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbcGRKXc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jul 2016 06:23:32 -0400
Content-Disposition: inline
In-Reply-To: <bed68e2b-6397-1663-606c-6f19695d94ed@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 14, 2016 at 08:39:18PM -0700, Tadeusz Struk wrote:
> Hi Salvatore,
> On 07/14/2016 03:25 AM, Salvatore Benedetto wrote:
> > Embedding the akcipher_request in pkcs1pad_request don't take
> > into account the context space required by the akcipher object.
> 
> I think we do take into account the sub request context. See line 675.
> The only thing that is wrong is that the child_req should be at
> the end of the structure. This is build tested only.
> 
> ---8<---
> From: Tadeusz Struk <tadeusz.struk@intel.com>
> Subject: [PATCH] crypto: rsa-pkcs1pad - fix rsa-pkcs1pad request struct
> 
> To allow for child request context the struct akcipher_request child_req
> needs to be at the end of the structure.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
