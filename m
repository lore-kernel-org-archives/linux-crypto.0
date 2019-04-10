Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3855DC10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 19:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2E332133D
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 19:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554923890;
	bh=97Zv/Zc2dcGLLhkLoIxVoLzZhvBAxbmgNdPAmTnYO6I=;
	h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=MdiG6sHbOf9EWH+546DZeFajs87kgDO37f9o3Fh9o7ugv5nikgYQKZABK/oUfxmrS
	 1IzXY0e6t+pN5ODQS1WwNWo3r0B+JDnFY5GHDfBCeVD6rcaWtna4IJVDZjRuks7eXC
	 +j4wN0blOEokBcxJ8olP/BRaZZymx0RMRELQ4pZU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfDJTSJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 15:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfDJTSI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 15:18:08 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C9D320820;
        Wed, 10 Apr 2019 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554923887;
        bh=97Zv/Zc2dcGLLhkLoIxVoLzZhvBAxbmgNdPAmTnYO6I=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=GVqbXgUuX5lH2rBjZAWXM/5TxK8K3J8UEaAsIN5WU/oTeqjj/j0H0AyUmA3uTvQwf
         VGZkX+Y8meGWH8U1sxYIhEVJIaoIPRKNwInHkUqyMGh2tR0FoOrRHVATBAywR6TSXP
         DwKkRFygVlkY4lpkRkB+MoBdefomzeOcyeyUqz5E=
Date:   Wed, 10 Apr 2019 19:18:06 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 5/7] crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
In-Reply-To: <20190410064635.11813-6-ebiggers@kernel.org>
References: <20190410064635.11813-6-ebiggers@kernel.org>
Message-Id: <20190410191807.7C9D320820@mail.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: d00aa19b507b [CRYPTO] gcm: Allow block cipher parameter.

The bot has tested the following trees: v5.0.7, v4.19.34, v4.14.111, v4.9.168, v4.4.178, v3.18.138.

v5.0.7: Build OK!
v4.19.34: Build OK!
v4.14.111: Build OK!
v4.9.168: Failed to apply! Possible dependencies:
    9b40f79c08e8 ("crypto: gcm - Fix error return code in crypto_gcm_create_common()")

v4.4.178: Failed to apply! Possible dependencies:
    16f37ecdd068 ("crypto: gcm - Use skcipher")
    9b40f79c08e8 ("crypto: gcm - Fix error return code in crypto_gcm_create_common()")

v3.18.138: Failed to apply! Possible dependencies:
    16f37ecdd068 ("crypto: gcm - Use skcipher")
    17db85469970 ("crypto: gcm - Use default null skcipher")
    5d72336f1b2c ("crypto: gcm - Use crypto_aead_set_reqsize helper")
    9b40f79c08e8 ("crypto: gcm - Fix error return code in crypto_gcm_create_common()")
    adcbc688fe2f ("crypto: gcm - Convert to new AEAD interface")


How should we proceed with this patch?

--
Thanks,
Sasha
