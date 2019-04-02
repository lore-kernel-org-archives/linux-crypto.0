Return-Path: <SRS0=5Ot1=SE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D89DC10F00
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Apr 2019 15:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDDA320882
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Apr 2019 15:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554220112;
	bh=ownzf89iJXONQ5XELSOgBBc/FahgsKxbfpkarpQKQJc=;
	h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=dshuSyRhzbaG4YvZd5gUopJ5FQU/R6uH2LhXrjGtddkXMPgox3LcCX41Ky2COjyVm
	 Z/DD8q8TPKntVFIZ419pUw2V7v2gAe0iOrbomtsEC2fG52MQPijPTL6qVxdzl0t9aD
	 PHBbY7qKxI2a1Mf4LMs7+OWEK6/eC6L4kyBcaA9o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbfDBPsb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Apr 2019 11:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfDBPs3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Apr 2019 11:48:29 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 220732084C;
        Tue,  2 Apr 2019 15:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554220108;
        bh=ownzf89iJXONQ5XELSOgBBc/FahgsKxbfpkarpQKQJc=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=tcgK3jA1gg29KzZrULT2APxVQfVsXdxZaAWvVBGLie99tErSsfXICrRDGqZV9ZM2Y
         UUPOwKqByGpQPLgnU9JEVXtXy79FIi8LP18dAP7jkKeCQ0YFrHj/hz/N63Rb3U07QL
         3t+wNP9GL3Al5VJ09gegMxK7fJYViQBlE73LtPzs=
Date:   Tue, 02 Apr 2019 15:48:27 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 08/18] crypto: ccm - fix incompatibility between "ccm" and "ccm_base"
In-Reply-To: <20190331200428.26597-9-ebiggers@kernel.org>
References: <20190331200428.26597-9-ebiggers@kernel.org>
Message-Id: <20190402154828.220732084C@mail.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 4a49b499dfa0 [CRYPTO] ccm: Added CCM mode.

The bot has tested the following trees: v5.0.5, v4.19.32, v4.14.109, v4.9.166, v4.4.177, v3.18.137.

v5.0.5: Build OK!
v4.19.32: Build OK!
v4.14.109: Build OK!
v4.9.166: Failed to apply! Possible dependencies:
    f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")

v4.4.177: Failed to apply! Possible dependencies:
    464b93a3c7d1 ("crypto: ccm - Use skcipher")
    f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")

v3.18.137: Failed to apply! Possible dependencies:
    2c221ad39424 ("crypto: ccm - Use crypto_aead_set_reqsize helper")
    464b93a3c7d1 ("crypto: ccm - Use skcipher")
    81c4c35eb61a ("crypto: ccm - Convert to new AEAD interface")
    f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")


How should we proceed with this patch?

--
Thanks,
Sasha
