Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBDDC433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 07:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8416610FC
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 07:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhDBHGq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Apr 2021 03:06:46 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51420 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229594AbhDBHGp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Apr 2021 03:06:45 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lSDtB-0001Hi-0e; Fri, 02 Apr 2021 18:06:42 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Apr 2021 18:06:40 +1100
Date:   Fri, 2 Apr 2021 18:06:40 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH 0/3] crypto: replace memset by memzero_explicit
Message-ID: <20210402070640.GA10374@gondor.apana.org.au>
References: <1616721648-56258-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1616721648-56258-1-git-send-email-yekai13@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 26, 2021 at 09:20:45AM +0800, Kai Ye wrote:
>  use memzero_explicit instead of memset to clear sensitive data,
>  such as buffer or key.

Does this fix a real issue? If not then it's just unnecessary
churn.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
