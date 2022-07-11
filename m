Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74268C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jul 2022 17:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiGKR6N (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jul 2022 13:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiGKR6M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jul 2022 13:58:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D2D7D789
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2022 10:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 835346145D
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2022 17:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8110C34115;
        Mon, 11 Jul 2022 17:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657562290;
        bh=dqKL1ZHaU9DALuFJcYhh0LDAOizflbirqGTWzM+maT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bhdB18exvKnYksKC+IKTrJECibcSsYbwShPuYH36PhnpzakjoumTw6QKC6jm9PMSC
         A2QJ4mgqZElLiLa8Sz0Rmmsa3vqbfPZUwTgHSowQXozSd563rvgPsc1U8B4LHBmbYP
         Ux9yMxECgREQbQR0RWdgtn2i4qg5tXlv+vS7u0UbGGarYyTPlB+7k8viWcoEtz7MYA
         9v6dxXx/JtQw1YKVo3oLaXbynbX/v2VC3Hzenosuk+59lHxDHbIHKEnXvmlkJssZIQ
         OcrdrUelZw5zvYgNgiz7LtmUL+OOyB/qJj7L+YmFsECWGuGV8LNGm+f2GUjEF8ROsQ
         bksOFZN5mSNTg==
Date:   Mon, 11 Jul 2022 17:58:09 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        catalin.marinas@arm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, zengxianjun3@huawei.com,
        yunjia.wang@huawei.com
Subject: Re: An inquire about a read out-of-bound found in poly1305-neon
Message-ID: <YsxksSnCsk3TQVD+@gmail.com>
References: <65952163-6b78-a02a-ba14-933807d3cfec@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65952163-6b78-a02a-ba14-933807d3cfec@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 11, 2022 at 09:34:49PM +0800, Guozihua (Scott) wrote:
> Directly calling poly1305_init_arm64 instead of poly1305_init_arch() is also
> tried but it would fail the self-test as well.

I think that's the correct fix.  Are you sure it fails the self-test?  It should
look like:

	poly1305_init_arm64(&dctx->h, src);

Just like the arm32 version in arch/arm/crypto/poly1305-glue.c.  Note that
&dctx->h must be used rather than just dctx.

- Eric
