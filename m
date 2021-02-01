Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9184EC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 17:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B23D64EA2
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 17:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhBARLo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:11:44 -0500
Received: from mga04.intel.com ([192.55.52.120]:58930 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231284AbhBARLf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 12:11:35 -0500
IronPort-SDR: GsAfh9fYpW+M4YAYDVi33Kntmm86+5S13BrGdLYHP3Zi1rQnB983ZAO+YJnDyLzw9lGCG8EshA
 XxoXATWa/5YA==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="178155736"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="178155736"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 09:09:49 -0800
IronPort-SDR: 7g/nrfiQHaZNp5laeul/q4onJMeUVAA3thjEDrpRMpjApx57DJGIKyCqiXa9xg5u/Ctxv8DCfU
 B2j0dimBY5dA==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="391001227"
Received: from ljfrost-mobl1.amr.corp.intel.com ([10.252.14.106])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 09:09:45 -0800
Message-ID: <c3c3d47edbfd61c338deea5a10a4fb39e2ace68a.camel@linux.intel.com>
Subject: Re: [PATCH v7 4/7] crypto: add ecc curve and expose them
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Meng Yu <yumeng18@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Zaibo Xu <xuzaibo@huawei.com>, wangzhou1@hisilicon.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Date:   Mon, 01 Feb 2021 17:09:41 +0000
In-Reply-To: <20210128103908.GA32495@gondor.apana.org.au>
References: <1611299395-675-1-git-send-email-yumeng18@huawei.com>
         <1611299395-675-5-git-send-email-yumeng18@huawei.com>
         <20210128050354.GA30874@gondor.apana.org.au>
         <CAMj1kXHvY9JveFyhtETALCH=AFGMGVbGGFMNDGc6ZVngEKbyDQ@mail.gmail.com>
         <20210128103908.GA32495@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2021-01-28 at 21:39 +1100, Herbert Xu wrote:
> Once they're distinct algorithms, we can then make sure that only
> the ones that are used in the kernel is added, even if some hardware
> may support more curves.

I like the idea of having different algorithms names (ecdh-nist-
pXXX) for different curves, but I'm not fully convinced by the above
statement.

What's the downside of letting device drivers enable all the curves
supported by the HW (with the exception of obsolete curves /
algorithms), even if there is (currently) no user of such curves in the
kernel? Code size and maintainability?

I think that once there is support for certain curves, it's more likely
that drivers / modules using them will appear.

Also, even if there are no in-tree users, there might be a few out-of-
tree ones.

