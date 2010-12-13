From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3 v2] RFC4106 AES-GCM Driver Using Intel New
	Instructions - fixed build with binutils 2.16
Date: Mon, 13 Dec 2010 19:50:51 +0800
Message-ID: <20101213115051.GA1697@gondor.apana.org.au>
References: <4d021e3f.GLP/bq7kQUH5U6yI%tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	akpm@linux-foundation.org, aidan.o.mahony@intel.com,
	gabriele.paoloni@intel.com, adrian.hoban@intel.com
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33370 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab0LMLu5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Dec 2010 06:50:57 -0500
Content-Disposition: inline
In-Reply-To: <4d021e3f.GLP/bq7kQUH5U6yI%tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 10, 2010 at 12:34:07PM +0000, tadeusz.struk@intel.com wrote:
> >From tadeusz.struk@intel.com Mon Sep 17 00:00:00 2001
> From: root <root@tweedle-dum.ir.intel.com>
> Date: Fri, 10 Dec 2010 12:10:57 +0000
> Subject: [PATCH 2/3 v2] RFC4106 AES-GCM Driver Using Intel New Instructions - fixed build with binutils 2.16
> 
> Hi Herbert,
> This patch fixes the problem with 2.16 binutils.
> Regards,
> Tadeusz
> 
> Signed-off-by: Aidan O'Mahony <aidan.o.mahony@intel.com>
> Signed-off-by: Adrian Hoban <adrian.hoban@intel.com>
> Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
