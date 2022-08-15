Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B12C19F2C
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 05:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiHPFO5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 01:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiHPFOi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 01:14:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889421EB7DC
        for <linux-crypto@vger.kernel.org>; Mon, 15 Aug 2022 14:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C841B811F9
        for <linux-crypto@vger.kernel.org>; Mon, 15 Aug 2022 21:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79E0C433C1;
        Mon, 15 Aug 2022 21:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660599014;
        bh=feO2cxwFis6LOaZ6FmU3TAcTU6imAQByNOy/kl/1Ss0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ao+Fabt9/JBtI1L/NvKuJC1KAdr+9q2qZNH1Y6gbQI/uKbQDvFQbluCT+ZbMkLwHU
         7Lj7AQaGuGbnukMBocd1aYhr9HPaz63Bo9lM219AvshUjjoi3E2M6UZIf48BtTiX3A
         CI4+8wnTXSfpxkyjVAPH94tpay94PAqwLp8yonj5DuIWeclYXIpAqCZeSxKI7AqY3W
         feJGmCdi1nZPZDXu0hHu321k/d3ob1XLDRWhcZeAhD+H+6xZIOWZPhkvXh5+7VFxvf
         MaB8CZocsSnbyPNMQra/6URP4IsUBjrnBA1StKYFgbgz83nCa2wboiAV377Qlor21v
         pKd02AJ5ajntQ==
Date:   Mon, 15 Aug 2022 14:30:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Robert Elliott <elliott@hpe.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     tim.c.chen@linux.intel.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, toshi.kani@hpe.com, rwright@hpe.com
Subject: Re: [PATCH] crypto: testmgr - don't generate WARN for missing modules
Message-ID: <Yvq65Xd6GjeLdmO5@sol.localdomain>
References: <20220813231443.2706-1-elliott@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220813231443.2706-1-elliott@hpe.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 13, 2022 at 06:14:43PM -0500, Robert Elliott wrote:
> This userspace command:
>     modprobe tcrypt
> or
>     modprobe tcrypt mode=0
> 
> runs all the tcrypt test cases numbered <200 (i.e., all the
> test cases calling tcrypt_test() and returning return values).
> 
> Tests are sparsely numbered from 0 to 1000. For example:
>     modprobe tcrypt mode=12
> tests sha512, and
>     modprobe tcrypt mode=152
> tests rfc4543(gcm(aes))) - AES-GCM as GMAC
> 
> The test manager generates WARNING crashdumps every time it attempts
> a test using an algorithm that is not available (not built-in to the
> kernel or available as a module):

Note that this is only a problem because tcrypt calls alg_test() directly.  The
normal way that alg_test() gets called is for the registration-time self-test.
It's not clear to me why tcrypt calls alg_test() directly; the registration-time
test should be enough.  Herbert, do you know?

- Eric
