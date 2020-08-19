Return-Path: <SRS0=AsAY=B5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B859C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Aug 2020 23:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FC4320888
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Aug 2020 23:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597881482;
	bh=30FnG0R0uTJZppd+GdCN9PaDYguSkAXnvSNc1Izoe7Y=;
	h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=JxvGdkZiWqqNwB4f6CRV80ghDW7GZAanBwFCtT/h8OfiC5joeTw98Sl2T6MItXJD0
	 t57FhQISu4gQkRe203kdM6/Fbg5Q9ay/suCBKny34DwOvYU7OEMItfDGiYPkBTiwI8
	 TUqwANGZZ37mMYGf7p+EVfaVFIh9Y2rKe0+xml08=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgHSX54 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Aug 2020 19:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbgHSX4i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:38 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 778572173E;
        Wed, 19 Aug 2020 23:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881397;
        bh=30FnG0R0uTJZppd+GdCN9PaDYguSkAXnvSNc1Izoe7Y=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=X9CWsx1tDgl5zCSjUXhWk4rj47xKy49sf94cZW8FQ0fg2y7CtvZ6sw7/CXs31/nVT
         rryPKVQ0ZHCxo6uz6/4r9338TKFOjUTat7kBfHG+6wXBINNmq3XUZT1xZB9U52qvzn
         NkJbfhGH6Eo9hTVeXrfYPSfrcE3qV/E2mRP/g/eo=
Date:   Wed, 19 Aug 2020 23:56:36 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Andrei Botila <andrei.botila@oss.nxp.com>
To:     Andrei Botila <andrei.botila@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH RESEND 3/9] crypto: caam/qi2 - add fallback for XTS with more than 8B IV
In-Reply-To: <20200806163551.14395-4-andrei.botila@oss.nxp.com>
References: <20200806163551.14395-4-andrei.botila@oss.nxp.com>
Message-Id: <20200819235637.778572173E@mail.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 226853ac3ebe ("crypto: caam/qi2 - add skcipher algorithms").

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58.

v5.8.1: Failed to apply! Possible dependencies:
    528f776df67c ("crypto: qat - allow xts requests not multiple of block")
    a85211f36f3d ("crypto: qat - fallback for xts with 192 bit keys")
    b185a68710e0 ("crypto: qat - validate xts key")
    b8aa7dc5c753 ("crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY")
    da6a66853a38 ("crypto: caam - silence .setkey in case of bad key length")

v5.7.15: Failed to apply! Possible dependencies:
    528f776df67c ("crypto: qat - allow xts requests not multiple of block")
    a85211f36f3d ("crypto: qat - fallback for xts with 192 bit keys")
    b185a68710e0 ("crypto: qat - validate xts key")
    b8aa7dc5c753 ("crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY")
    da6a66853a38 ("crypto: caam - silence .setkey in case of bad key length")

v5.4.58: Failed to apply! Possible dependencies:
    64db5e7439fb ("crypto: sparc/aes - convert to skcipher API")
    66d7fb94e4ff ("crypto: blake2s - generic C library implementation and selftest")
    674f368a952c ("crypto: remove CRYPTO_TFM_RES_BAD_KEY_LEN")
    746b2e024c67 ("crypto: lib - tidy up lib/crypto Kconfig and Makefile")
    7988fb2c03c8 ("crypto: s390/aes - convert to skcipher API")
    7f725f41f627 ("crypto: powerpc - convert SPE AES algorithms to skcipher API")
    7f9b0880925f ("crypto: blake2s - implement generic shash driver")
    91d689337fe8 ("crypto: blake2b - add blake2b generic implementation")
    b4d0c0aad57a ("crypto: arm - use Kconfig based compiler checks for crypto opcodes")
    b95bba5d0114 ("crypto: skcipher - rename the crypto_blkcipher module and kconfig option")
    d00c06398154 ("crypto: s390/paes - convert to skcipher API")
    da6a66853a38 ("crypto: caam - silence .setkey in case of bad key length")
    ed0356eda153 ("crypto: blake2s - x86_64 SIMD implementation")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
