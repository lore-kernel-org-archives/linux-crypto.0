From: Joel Fernandes <joelf@ti.com>
Subject: Re: [PATCH V2] crypto: omap-des - use devm_ioremap_resource()
Date: Thu, 10 Apr 2014 10:55:34 -0500
Message-ID: <5346BEF6.9090104@ti.com>
References: <001d01cf4ed2$494fd0e0$dbef72a0$%han@samsung.com> <008301cf52e6$9b764990$d262dcb0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "'David Miller'" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
To: Jingoo Han <jg1.han@samsung.com>,
	"'Herbert Xu'" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54079 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758560AbaDJPzn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Apr 2014 11:55:43 -0400
In-Reply-To: <008301cf52e6$9b764990$d262dcb0$%han@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/07/2014 11:54 PM, Jingoo Han wrote:
> Use devm_ioremap_resource() because devm_request_and_ioremap() is
> obsoleted by devm_ioremap_resource().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Joel Fernandes <joelf@ti.com>
