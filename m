From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] drivers/crypto/nx: Add CRC and validation support for
 nx842
Date: Mon, 21 Sep 2015 22:26:07 +0800
Message-ID: <20150921142607.GA2405@gondor.apana.org.au>
References: <1442707362.6178.11.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, ddstreet@ieee.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	hbabu@us.ibm.com
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37039 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbbIUO0R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 10:26:17 -0400
Content-Disposition: inline
In-Reply-To: <1442707362.6178.11.camel@hbabu-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Sep 19, 2015 at 05:02:42PM -0700, Haren Myneni wrote:
> Hi, 
> 
> This patch allows nx842 coprocessor to add CRC for compression and
> check the computed CRC value for uncompression. Please let me know 
> if you have any comments.
> 
> Thanks
> Haren
> 
> commit d0b34d2e3ed41e7ec2afdbd654f0dd7716e4d4c0
> Author: Haren Myneni <haren@us.ibm.com>
> Date:   Sat Sep 12 01:20:51 2015 -0700
> 
>     crypto/nx842: Add CRC and validation support
>     
>     This patch adds CRC generation and validation support for nx-842. 
>     Add CRC flag so that nx842 coprocessor includes CRC during 
>     compression and validates during uncompression. 
>     
>     Signed-off-by: Haren Myneni <haren@us.ibm.com>

In future please post the patch without all the metadata.  You
can use the helper git format-patch to help you prepare the patch
for submission.

As to the CRC itself what is the purpose of this and wouldn't it
fail our test vectors if we had any? Remember that we also have a
software implementation now and the hardware should produce exactly
the same output as the software version.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
