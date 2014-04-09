From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH V2] crypto: omap-des - use devm_ioremap_resource()
Date: Wed, 9 Apr 2014 19:36:01 +0200
Message-ID: <201404091936.01872.marex@denx.de>
References: <001d01cf4ed2$494fd0e0$dbef72a0$%han@samsung.com> <008301cf52e6$9b764990$d262dcb0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Herbert Xu'" <herbert@gondor.apana.org.au>,
	"'David Miller'" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, "'Joel Fernandes'" <joelf@ti.com>
To: Jingoo Han <jg1.han@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:54042 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbaDIRqj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Apr 2014 13:46:39 -0400
In-Reply-To: <008301cf52e6$9b764990$d262dcb0$%han@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday, April 08, 2014 at 06:54:22 AM, Jingoo Han wrote:
> Use devm_ioremap_resource() because devm_request_and_ioremap() is
> obsoleted by devm_ioremap_resource().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
