From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v2 10/10] crypto: marvell: Increase the size of the
 crypto queue
Date: Fri, 17 Jun 2016 15:28:25 +0200
Message-ID: <20160617152825.09dd083e@bbrezillon>
References: <1466162649-29911-1-git-send-email-romain.perier@free-electrons.com>
	<1466162649-29911-11-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52556 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752665AbcFQN21 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2016 09:28:27 -0400
In-Reply-To: <1466162649-29911-11-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 17 Jun 2016 13:24:09 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> Now that crypto requests are chained together at the DMA level, we
> increase the size of the crypto queue for each engine. The result is
> that as the backlog list is reached later, it does not stop the crypto
> stack from sending asychronous requests, so more cryptographic tasks
> are processed by the engines.
> 
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/crypto/marvell/cesa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
> index bb91156..5147073 100644
> --- a/drivers/crypto/marvell/cesa.c
> +++ b/drivers/crypto/marvell/cesa.c
> @@ -32,7 +32,7 @@
>  #include "cesa.h"
>  
>  /* Limit of the crypto queue before reaching the backlog */
> -#define CESA_CRYPTO_DEFAULT_MAX_QLEN 50
> +#define CESA_CRYPTO_DEFAULT_MAX_QLEN 128
>  
>  static int allhwsupport = !IS_ENABLED(CONFIG_CRYPTO_DEV_MV_CESA);
>  module_param_named(allhwsupport, allhwsupport, int, 0444);
