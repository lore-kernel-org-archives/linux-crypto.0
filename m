Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65843C282CE
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 19:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36BF720820
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 19:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554923891;
	bh=6CHeT8CtEU6ZlQLlYG5BL3sJ8bnD6Tgddy+A4EHsRRw=;
	h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=Co2lmvSuSCPrOwCpkNULCi3yqqbM/2z18EpJdPvWsFPR88sQ8Fo4/OitQiiUIEJT1
	 Sh+Z3IXI7fqqvR3i8yUwOhgtC0T8VI7g98XtZzCfopJuDwsdeKcTxe8NuJJXPFHKZm
	 Qy7+Dtf76V+SmZ3G8U4KFB7FfjGT+rLq2mP8mDIc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfDJTSK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 15:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbfDJTSJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 15:18:09 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9F302082A;
        Wed, 10 Apr 2019 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554923888;
        bh=6CHeT8CtEU6ZlQLlYG5BL3sJ8bnD6Tgddy+A4EHsRRw=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=2wTG6EA4mRZEr1XP+s9GOkfCghVn3ICjhAo7zx1wvjHTVxGwP6V0JYZfqXF0w0RDz
         9t5OReZ4ZCS75KYd38KoLduqkrGfvb7K7ZQTRvZdXKg37agzjoFHXrVXW6SMKSHIca
         P5BvC8Y08YIC2lYTze3WgSSk52mqrbbH6W19V5os=
Date:   Wed, 10 Apr 2019 19:18:07 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 3/7] crypto: arm/aes-neonbs - don't access already-freed walk.iv
In-Reply-To: <20190410064635.11813-4-ebiggers@kernel.org>
References: <20190410064635.11813-4-ebiggers@kernel.org>
Message-Id: <20190410191808.A9F302082A@mail.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: e4e7f10bfc40 ARM: add support for bit sliced AES using NEON instructions.

The bot has tested the following trees: v5.0.7, v4.19.34, v4.14.111, v4.9.168, v4.4.178, v3.18.138.

v5.0.7: Build OK!
v4.19.34: Build OK!
v4.14.111: Build OK!
v4.9.168: Failed to apply! Possible dependencies:
    211f41af534a ("crypto: aesbs - Convert to skcipher")
    585b5fa63da9 ("crypto: arm/aes - Select SIMD in Kconfig")
    6fdf436fd854 ("crypto: arm/aes - Add missing SIMD select for aesbs")
    81126d1a8bc2 ("crypto: arm/aesbs - fix brokenness after skcipher conversion")
    81edb4262975 ("crypto: arm/aes - replace scalar AES cipher")
    cc477bf64573 ("crypto: arm/aes - replace bit-sliced OpenSSL NEON code")

v4.4.178: Failed to apply! Possible dependencies:
    211f41af534a ("crypto: aesbs - Convert to skcipher")
    28856a9e52c7 ("crypto: xts - consolidate sanity check for keys")
    49abc0d2e19b ("crypto: xts - fix compile errors")
    585b5fa63da9 ("crypto: arm/aes - Select SIMD in Kconfig")
    6fdf436fd854 ("crypto: arm/aes - Add missing SIMD select for aesbs")
    81126d1a8bc2 ("crypto: arm/aesbs - fix brokenness after skcipher conversion")
    81edb4262975 ("crypto: arm/aes - replace scalar AES cipher")
    cc477bf64573 ("crypto: arm/aes - replace bit-sliced OpenSSL NEON code")

v3.18.138: Failed to apply! Possible dependencies:
    006d0624fa0d ("crypto: arm - add support for SHA-224/256 using ARMv8 Crypto Extensions")
    12ac3efe74f8 ("arm64/crypto: use crypto instructions to generate AES key schedule")
    504c6143c53d ("crypto: powerpc/aes - kernel config")
    585b5fa63da9 ("crypto: arm/aes - Select SIMD in Kconfig")
    652ccae5cc4e ("crypto: arm - move ARM specific Kconfig definitions to a dedicated file")
    6fdf436fd854 ("crypto: arm/aes - Add missing SIMD select for aesbs")
    81edb4262975 ("crypto: arm/aes - replace scalar AES cipher")
    86464859cc77 ("crypto: arm - AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions")
    864cbeed4ab2 ("crypto: arm - add support for SHA1 using ARMv8 Crypto Instructions")
    cc477bf64573 ("crypto: arm/aes - replace bit-sliced OpenSSL NEON code")


How should we proceed with this patch?

--
Thanks,
Sasha
