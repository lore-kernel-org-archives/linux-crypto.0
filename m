Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D190C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0177C20774
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgGIMDK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 08:03:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35980 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgGIMDK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 08:03:10 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jtVGV-000345-JO; Thu, 09 Jul 2020 22:03:00 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Jul 2020 22:02:59 +1000
Date:   Thu, 9 Jul 2020 22:02:59 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "shenyang (M)" <shenyang39@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [Patch v2 8/9] crypto: hisilicon/qm - fix the process of
 register algorithms to crypto
Message-ID: <20200709120259.GA11508@gondor.apana.org.au>
References: <1593587995-7391-1-git-send-email-shenyang39@huawei.com>
 <1593587995-7391-9-git-send-email-shenyang39@huawei.com>
 <20200709053619.GA5637@gondor.apana.org.au>
 <4e79b1ce-2b2a-7db3-dc55-380c2229657a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e79b1ce-2b2a-7db3-dc55-380c2229657a@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 09, 2020 at 07:05:11PM +0800, shenyang (M) wrote:
>
> Yes, this patch just fixes the bug for 'hisi_zip'. As for 'hisi_hpre'
> and 'hisi_sec2', this patch doesn't change the logic.
> We have noticed the problem you say, and the patch is prepared. We fix
> this in 'hisi_qm', and you will see it soon.

I cannot accept a clearly buggy patch.  So please fix this and
resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
