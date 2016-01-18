From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: qat - update init_esram for C3xxx dev type
Date: Mon, 18 Jan 2016 23:23:21 +0800
Message-ID: <20160118152321.GC717@gondor.apana.org.au>
References: <1452277194-4804-1-git-send-email-tadeusz.struk@intel.com>
 <56993A78.4030500@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pingchao.yang@intel.com, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50429 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbcARPXY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 10:23:24 -0500
Content-Disposition: inline
In-Reply-To: <56993A78.4030500@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 15, 2016 at 10:29:12AM -0800, Tadeusz Struk wrote:
> On 01/08/2016 10:19 AM, Tadeusz Struk wrote:
> > There is no esram on C3xxx devices so we don't need to wait for
> > it to initialize.
> > 
> > Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
