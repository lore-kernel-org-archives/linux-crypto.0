Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41963C433FE
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Nov 2022 10:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiKEKSv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Nov 2022 06:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKEKSu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Nov 2022 06:18:50 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944B3E9F;
        Sat,  5 Nov 2022 03:18:49 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1orGFc-00APzR-O6; Sat, 05 Nov 2022 18:18:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Nov 2022 18:18:45 +0800
Date:   Sat, 5 Nov 2022 18:18:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v2 1/4] crypto: hisilicon/qm - modify the process of regs
 dfx
Message-ID: <Y2Y4hWc+cUJ4VZgy@gondor.apana.org.au>
References: <20221105095357.21199-1-yekai13@huawei.com>
 <20221105095357.21199-2-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221105095357.21199-2-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 05, 2022 at 09:53:54AM +0000, Kai Ye wrote:
>
> +static void dfx_regs_uninit(struct hisi_qm *qm,
> +		struct dfx_diff_registers *dregs, int reg_len)
> +{
> +	int i;
> +
> +	/* Setting the pointer is NULL to prevent double free */
> +	for (i = 0; i < reg_len; i++) {
> +		kfree(dregs[i].regs);
> +		dregs[i].regs = NULL;
> +	}
> +	kfree(dregs);
> +	dregs = NULL;
> +}

The line that I complained about is still here.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
