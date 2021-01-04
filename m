Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A1BC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 12:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7624A207AE
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 12:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbhADMuV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 07:50:21 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:49846 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbhADMuV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 07:50:21 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kwPIL-000763-Ja; Mon, 04 Jan 2021 23:49:10 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 04 Jan 2021 23:49:09 +1100
Date:   Mon, 4 Jan 2021 23:49:09 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
Cc:     "yumeng18@huawei.com" <yumeng18@huawei.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xuzaibo@huawei.com" <xuzaibo@huawei.com>,
        "wangzhou1@hisilicon.com" <wangzhou1@hisilicon.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v5 3/5] crypto: expose elliptic curve parameters as
 Crypto APIs
Message-ID: <20210104124909.GA21283@gondor.apana.org.au>
References: <1608790107-32617-1-git-send-email-yumeng18@huawei.com>
 <1608790107-32617-4-git-send-email-yumeng18@huawei.com>
 <20210102212929.GA1996@gondor.apana.org.au>
 <a260ceec-e3ca-8fbd-e80e-f08ddc2029a4@huawei.com>
 <1661cb6eaaa7ba456345851781b64dde5b91d22a.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1661cb6eaaa7ba456345851781b64dde5b91d22a.camel@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 04, 2021 at 11:36:57AM +0000, Alessandrelli, Daniele wrote:
>
> Herbert, should I send an updated RFC now or should I wait for the
> discussion on the RFC open points to be completed first?

I think you should wait for the existing discussion to settle
first before sending out an update as this is a rather trivial
change.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
