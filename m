Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7673C49EA3
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 08:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9020361166
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 08:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhFQIDp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 04:03:45 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50732 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230283AbhFQIDc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 04:03:32 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1ltmxo-0003k1-Ht; Thu, 17 Jun 2021 16:01:24 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ltmxn-0002oE-RU; Thu, 17 Jun 2021 16:01:23 +0800
Date:   Thu, 17 Jun 2021 16:01:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH 0/8] crypto: hisilicon - supports to configure function's
 QoS for ACC
Message-ID: <20210617080123.GE10662@gondor.apana.org.au>
References: <1623402410-63906-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623402410-63906-1-git-send-email-yekai13@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 11, 2021 at 05:06:42PM +0800, Kai Ye wrote:
> Based on the Token bucket algorithm. The QM can limit the throughput
> of functions in Kunpeng930. By the device debugfs node that named
> "alg_qos", the ACC driver supports to configue each function's QoS
> in the host. Based on the communication between pf and vf, the driver
> supports reading each function's QoS in the host and VM also by the
> debugfs node.
> 
> Kai Ye (8):
>   crypto: hisilicon/qm - supports writing QoS int the Host
>   crypto: hisilicon/qm - add the "alg_qos" file node
>   crypto: hisilicon/qm - merges the work initialization process into a
>     single function
>   crypto: hisilicon/qm - add pf ping single vf function
>   crypto: hisilicon/qm - supports to inquiry each function's QoS
>   crypto: hisilicon/sec - adds the max shaper type rate
>   crypto: hisilicon/hpre - adds the max shaper type rate
>   crypto: hisilicon/zip - adds the max shaper type rate
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c |   7 +
>  drivers/crypto/hisilicon/qm.c             | 909 +++++++++++++++++++++++-------
>  drivers/crypto/hisilicon/qm.h             |  14 +
>  drivers/crypto/hisilicon/sec2/sec_main.c  |   7 +
>  drivers/crypto/hisilicon/zip/zip_main.c   |  11 +
>  5 files changed, 757 insertions(+), 191 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
