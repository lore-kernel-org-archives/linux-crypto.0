From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - Fix return value check in
 adf_chr_drv_create()
Date: Mon, 25 Aug 2014 20:41:47 +0800
Message-ID: <20140825124147.GF28815@gondor.apana.org.au>
References: <1407978044-15750-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Bruce W. Allan" <bruce.w.allan@intel.com>,
	John Griffin <john.griffin@intel.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org
To: weiyj_lk@163.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34703 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbaHYMmF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Aug 2014 08:42:05 -0400
Content-Disposition: inline
In-Reply-To: <1407978044-15750-1-git-send-email-weiyj_lk@163.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 14, 2014 at 09:00:44AM +0800, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function device_create() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check
> should be replaced with IS_ERR().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
