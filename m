From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: drop pointless static qualifier in
 atmel_aes_probe()
Date: Tue, 1 Nov 2016 08:43:21 +0800
Message-ID: <20161101004321.GB7375@gondor.apana.org.au>
References: <1477320682-6881-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33197 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161084AbcKAAnZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Oct 2016 20:43:25 -0400
Content-Disposition: inline
In-Reply-To: <1477320682-6881-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 24, 2016 at 02:51:22PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> There is no need to have the 'struct atmel_aes_dev *aes_dd' variable
> static since new value always be assigned before use it.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
