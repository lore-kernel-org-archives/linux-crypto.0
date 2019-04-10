Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF36C282DA
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 19:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26EBD20820
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554923887;
	bh=ncI1nLFJRc1TtyCPk07WK8DiZkWqor2FbvEzvYF1ljk=;
	h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=KpF/wNk9eIxS4WTJ14ZypcSvTlU9NXbw0nwITnlL0LkeKWBnxrciHc9y2FEJPreo+
	 tJGZSwC1g4f0gz65jQ+1HQYA3GODdLEet0EJCBk+RuPXvkheEhU9N+MncmDe6JpHIN
	 FeDa7rQBivF1CVcvz2hUqtYJxBD9ZMtRTAhc1vNE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfDJTSG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 15:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfDJTSF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 15:18:05 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30A112082A;
        Wed, 10 Apr 2019 19:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554923885;
        bh=ncI1nLFJRc1TtyCPk07WK8DiZkWqor2FbvEzvYF1ljk=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=Eu4ngg7hzV/KXioYivCWWB+HmD3qQVOakjKaWvuPo9AJHVKCdBKzQe/pqIa3U6DaP
         SsLEx1WDxAJRh/nBDceHiZPK/g8Bztqz/ciDIXjnSQ9YQZ0+JP1ekWIWEhakWgj8CB
         YzcIkDMeiZFPl4vYfxx6rMI2KQbGfZc/5SqjqTj8=
Date:   Wed, 10 Apr 2019 19:18:04 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 2/7] crypto: salsa20 - don't access already-freed walk.iv
In-Reply-To: <20190410064635.11813-3-ebiggers@kernel.org>
References: <20190410064635.11813-3-ebiggers@kernel.org>
Message-Id: <20190410191805.30A112082A@mail.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 2407d60872dd [CRYPTO] salsa20: Salsa20 stream cipher.

The bot has tested the following trees: v5.0.7, v4.19.34, v4.14.111, v4.9.168, v4.4.178, v3.18.138.

v5.0.7: Build OK!
v4.19.34: Build OK!
v4.14.111: Failed to apply! Possible dependencies:
    015a03704df1 ("crypto: salsa20 - Revert "crypto: salsa20 - export generic helpers"")
    b62b3db76f73 ("crypto: salsa20-generic - cleanup and convert to skcipher API")
    eb772f37ae81 ("crypto: salsa20 - export generic helpers")

v4.9.168: Failed to apply! Possible dependencies:
    015a03704df1 ("crypto: salsa20 - Revert "crypto: salsa20 - export generic helpers"")
    b62b3db76f73 ("crypto: salsa20-generic - cleanup and convert to skcipher API")
    eb772f37ae81 ("crypto: salsa20 - export generic helpers")

v4.4.178: Failed to apply! Possible dependencies:
    015a03704df1 ("crypto: salsa20 - Revert "crypto: salsa20 - export generic helpers"")
    b62b3db76f73 ("crypto: salsa20-generic - cleanup and convert to skcipher API")
    eb772f37ae81 ("crypto: salsa20 - export generic helpers")

v3.18.138: Failed to apply! Possible dependencies:
    015a03704df1 ("crypto: salsa20 - Revert "crypto: salsa20 - export generic helpers"")
    b62b3db76f73 ("crypto: salsa20-generic - cleanup and convert to skcipher API")
    eb772f37ae81 ("crypto: salsa20 - export generic helpers")


How should we proceed with this patch?

--
Thanks,
Sasha
