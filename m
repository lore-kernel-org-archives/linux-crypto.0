Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_TONAME_EQ_TOLOCAL_SHORT,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C640C4361B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 01:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 195F322CF6
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 01:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgLGBeu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Dec 2020 20:34:50 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:41896 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbgLGBeu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Dec 2020 20:34:50 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1km5Pb-0005QZ-QP; Mon, 07 Dec 2020 12:34:00 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Dec 2020 12:33:59 +1100
Date:   Mon, 7 Dec 2020 12:33:59 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     liulongfang <liulongfang@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] crypto: hisilicon - add some new algorithms
Message-ID: <20201207013359.GA9845@gondor.apana.org.au>
References: <1606357086-9785-1-git-send-email-liulongfang@huawei.com>
 <20201204070525.GA26479@gondor.apana.org.au>
 <c74d3ea8-4286-b34f-36ef-8e0425b2dd19@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c74d3ea8-4286-b34f-36ef-8e0425b2dd19@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 07, 2020 at 09:20:05AM +0800, liulongfang wrote:
>
> Did any test case tests fail?

You tell me :)

If it passed all of the tests in your testing, please state that
in the cover letter or in one of the patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
