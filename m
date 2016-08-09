From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/7] crypto: img-hash - fixes and interface changes
Date: Tue, 9 Aug 2016 19:02:14 +0800
Message-ID: <20160809110213.GE7099@gondor.apana.org.au>
References: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Will Thomas <will.thomas@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56707 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbcHILCY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 07:02:24 -0400
Content-Disposition: inline
In-Reply-To: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 05, 2016 at 02:00:13PM +0100, Will Thomas wrote:
> Hi Herbert,
> 
> This patchset includes small stability fixes, power management
> and import/export interface functions for the img-hash driver.
> 
> Changes as discussed for [1/7], [2/7] and [5/7].
> 
> 
> Govindraj Raja (1):
>   crypto: img-hash - Add suspend resume hooks for img hash
> 
> James Hartley (2):
>   crypto: img-hash - Add support for export and import
>   crypto: img-hash - log a successful probe
> 
> Will Thomas (4):
>   crypto: img-hash - Fix null pointer exception
>   crypto: img-hash - Fix hash request context
>   crypto: img-hash - Reconfigure DMA Burst length
>   crypto: img-hash - Fix set_reqsize call

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
