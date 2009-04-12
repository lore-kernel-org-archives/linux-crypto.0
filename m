From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] ixp4xx_crypto: check firmware for crypto support
Date: Sun, 12 Apr 2009 13:02:58 +0800
Message-ID: <20090412050258.GA8883@gondor.apana.org.au>
References: <200904091256010463689@163.com> <49DD9E23.9070101@hiramoto.org> <20090409134634.GO21117@mail3.prorata.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Karl Hiramoto <karl@hiramoto.org>, timenhhf <timenhhf@163.com>,
	hzlyc <hzlyc@tom.com>, linux-crypto@vger.kernel.org
To: Christian Hohnstaedt <christian@hohnstaedt.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57022 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752019AbZDLFDY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 12 Apr 2009 01:03:24 -0400
Content-Disposition: inline
In-Reply-To: <20090409134634.GO21117@mail3.prorata.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 09, 2009 at 01:46:34PM +0000, Christian Hohnstaedt wrote:
>  - the loaded firmware may not support crypto at all or
>    only support DES and 3DES but not AES or
>    support DES, 3DES and AES.
> 
>  - in case of no crypto support of the firmware, the module load will fail.
>  - in case of missing AES support, the AES algorithms are not registered
>    and a warning is printed during module load.
> 
> Signed-off-by: Christian Hohnstaedt <chohnstaedt@innominate.com>

Applied to crypto-2.6 and I'll queue this up for stable as well.
Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
