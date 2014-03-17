From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] arm64/lib: add optimized implementation of sha_transform
Date: Mon, 17 Mar 2014 19:18:35 +0100
Message-ID: <201403171918.35632.marex@denx.de>
References: <1394809353-16707-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	linux-crypto@vger.kernel.org, catalin.marinas@arm.com,
	will.deacon@arm.com, steve.capper@linaro.org, nico@linaro.org
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:54186 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaCQSn6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Mar 2014 14:43:58 -0400
In-Reply-To: <1394809353-16707-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, March 14, 2014 at 04:02:33 PM, Ard Biesheuvel wrote:
> This implementation keeps the 64 bytes of workspace in registers rather
> than on the stack, eliminating most of the loads and stores, and reducing
> the instruction count by about 25%.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> Hello all,
> 
> No performance numbers I am allowed to share, unfortunately, so if anyone
> else (with access to actual, representative hardware) would care to have a
> go, I would be very grateful.
> 
> This can be done by building the tcrypt.ko module (CONFIG_CRYPTO_TEST=m),
> and inserting the module using 'mode=303' as a parameter (note that the
> insmod always fails, but produces its test output to the kernel log). Also
> note that the sha_transform() function will be part of the kernel proper,
> so just rebuilding the sha1_generic module is not sufficient.
> 
> Cheers,

Won't the function sha_transform() collide with the one in lib/sha1.c ? Or will 
the one in lib/sha1.c be overriden somehow ?

Otherwise:

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
