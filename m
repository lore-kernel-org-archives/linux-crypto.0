From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: cavium: make several functions static
Date: Tue, 20 Jun 2017 11:59:31 -0400 (EDT)
Message-ID: <20170620.115931.349171159880534656.davem@davemloft.net>
References: <20170620103550.7660-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: george.cherian@cavium.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: colin.king@canonical.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbdFTP7d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 11:59:33 -0400
In-Reply-To: <20170620103550.7660-1-colin.king@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin King <colin.king@canonical.com>
Date: Tue, 20 Jun 2017 11:35:50 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The functions cvm_encrypt, cvm_decrypt, cvm_xts_setkey and
> cvm_enc_dec_init does not need to be in global scope, so make
> them static.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: David S. Miller <davem@davemloft.net>
