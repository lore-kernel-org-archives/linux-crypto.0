Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58733C10F14
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 19:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 203AD217D7
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554923888;
	bh=dbLYSR7qutp0txTM/PlFg7+bKJGx5kdigCwZY9Xf8Yw=;
	h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=KRuLfGQOlnwba1R6pLrQEVNTlONrvg7i1fx8i+3iG3j4XjQg32pK2vkAEJeCWBa9Q
	 C4Unn82nX5YOURcjBdFslw6n/3DUuNaLtuwU7EMhZhsCZHrNeRDIzKuZ9zjRlcbOFA
	 X+QAlJQzDFd7sWz08uDbIMUsVZTk6FZURspkdCTU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfDJTSH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 15:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfDJTSH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 15:18:07 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5739E2133D;
        Wed, 10 Apr 2019 19:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554923886;
        bh=dbLYSR7qutp0txTM/PlFg7+bKJGx5kdigCwZY9Xf8Yw=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=SjxBMVjxVumRodFCQPDg5unbuKHfJXYHvc3kp6A1vUGDEuIlenOPvNtIehybVgaxX
         JbBfVcOQng455f8w+cmgw0KBwviTkuHKl0cpsjRaHqr+wfIyZQ8UViZcN4UIZdbtQ+
         9jV5vphQRk5aYbfPkd+k+zXMydLf92yYbAGYdrrA=
Date:   Wed, 10 Apr 2019 19:18:05 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 6/7] crypto: ccm - fix incompatibility between "ccm" and "ccm_base"
In-Reply-To: <20190410064635.11813-7-ebiggers@kernel.org>
References: <20190410064635.11813-7-ebiggers@kernel.org>
Message-Id: <20190410191806.5739E2133D@mail.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 4a49b499dfa0 [CRYPTO] ccm: Added CCM mode.

The bot has tested the following trees: v5.0.7, v4.19.34, v4.14.111, v4.9.168, v4.4.178, v3.18.138.

v5.0.7: Build OK!
v4.19.34: Build OK!
v4.14.111: Build OK!
v4.9.168: Failed to apply! Possible dependencies:
    f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")

v4.4.178: Failed to apply! Possible dependencies:
    464b93a3c7d1 ("crypto: ccm - Use skcipher")
    f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")

v3.18.138: Failed to apply! Possible dependencies:
    2c221ad39424 ("crypto: ccm - Use crypto_aead_set_reqsize helper")
    464b93a3c7d1 ("crypto: ccm - Use skcipher")
    81c4c35eb61a ("crypto: ccm - Convert to new AEAD interface")
    f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")


How should we proceed with this patch?

--
Thanks,
Sasha
