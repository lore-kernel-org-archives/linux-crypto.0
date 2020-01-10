Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96FEC33CA2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 08:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC35D20721
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 08:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgAJIum (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 03:50:42 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:45026 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbgAJIum (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 03:50:42 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ipq09-0008By-29; Fri, 10 Jan 2020 16:50:41 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ipq06-0005Cq-IG; Fri, 10 Jan 2020 16:50:38 +0800
Date:   Fri, 10 Jan 2020 16:50:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zaibo Xu <xuzaibo@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linuxarm@huawei.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com, tanghui20@huawei.com, yekai13@huawei.com,
        liulongfang@huawei.com, qianweili@huawei.com,
        zhangwei375@huawei.com, fanghao11@huawei.com,
        forest.zhouchang@huawei.com
Subject: Re: [PATCH 1/9] crypto: hisilicon - fix debugfs usage of SEC V2
Message-ID: <20200110085038.pebelen7a7g2kwwf@gondor.apana.org.au>
References: <1578642598-8584-1-git-send-email-xuzaibo@huawei.com>
 <1578642598-8584-2-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578642598-8584-2-git-send-email-xuzaibo@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 10, 2020 at 03:49:50PM +0800, Zaibo Xu wrote:
> Applied some advices of Marco Elver on atomic usage of Debugfs.
> 
> Reported-by: Marco Elver <elver@google.com>
> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec.h        |  6 +++---
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 10 +++++-----
>  drivers/crypto/hisilicon/sec2/sec_main.c   | 14 ++++++++++++--
>  3 files changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
> index 26754d0..841f4c5 100644
> --- a/drivers/crypto/hisilicon/sec2/sec.h
> +++ b/drivers/crypto/hisilicon/sec2/sec.h
> @@ -40,7 +40,7 @@ struct sec_req {
>  	int req_id;
>  
>  	/* Status of the SEC request */
> -	int fake_busy;
> +	bool fake_busy;

I have already applied Arnd's patch and it's in the crypto tree.
Please rebase yours on top of his patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
