Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A1FC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 23:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiB1X1b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 18:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiB1X1b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 18:27:31 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63076D76E7;
        Mon, 28 Feb 2022 15:26:50 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nOpPZ-000832-Uq; Tue, 01 Mar 2022 10:26:39 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Mar 2022 11:26:37 +1200
Date:   Tue, 1 Mar 2022 11:26:37 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Kyle Sanderson <kyle.leet@gmail.com>,
        Dave Chinner <david@fromorbit.com>, qat-linux@intel.com,
        Linux-Kernal <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Intel QAT on A2SDi-8C-HLN4F causes massive data corruption with
 dm-crypt + xfs
Message-ID: <Yh1aLfy/oBawCJIg@gondor.apana.org.au>
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
 <20220219210354.GF59715@dread.disaster.area>
 <CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
 <YhN76/ONC9qgIKQc@silpixa00400314>
 <CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
 <CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
 <Yh0y75aegqS4jIP7@silpixa00400314>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh0y75aegqS4jIP7@silpixa00400314>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 28, 2022 at 08:39:11PM +0000, Giovanni Cabiddu wrote:
>
> The dm-crypt + QAT use-case is already disabled since kernel 5.10 due to
> a different issue.

Indeed, qat has been disabled for dm-crypt since

commit b8aa7dc5c7535f9abfca4bceb0ade9ee10cf5f54
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Thu Jul 9 23:20:41 2020 -0700

    crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY

So this should no longer be an issue with an up-to-date kernel.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
