From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] RFC4106 AES-GCM Driver - fixed problem with packets
	that are not multiple of 64bytes
Date: Sun, 13 Mar 2011 16:56:36 +0800
Message-ID: <20110313085636.GB12392@gondor.apana.org.au>
References: <4d77a344.ufBJ2BimO/o2UpKI%tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aidan.o.mahony@intel.com, gabriele.paoloni@intel.com,
	adrian.hoban@intel.com
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:46988 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab1CMI4j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 13 Mar 2011 04:56:39 -0400
Content-Disposition: inline
In-Reply-To: <4d77a344.ufBJ2BimO/o2UpKI%tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 09, 2011 at 03:56:52PM +0000, tadeusz.struk@intel.com wrote:
> From: Tadeusz Struk <tadeusz.struk@intel.com>
> Date: Wed, 9 Mar 2011 15:01:06 +0000
> Subject: [PATCH] RFC4106 AES-GCM Driver - fixed problem with packets that are not multiple of 64bytes
> 
> Hi Herbert,
> This patch fixes problem with packets that are not multiple of 64bytes.

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
