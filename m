Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EC8C10F14
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 19:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46DCB2084B
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 19:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554923886;
	bh=OEmXITh8ps+q+/X7H9exUItY39+VQyk+mPoIMo8DRNE=;
	h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=w2Y0hmboAQ4hWM2RVQD4GxaeCXMSa3KZUP9JIrsoVHfT/HnHFNiC2WG1dafLmxpp6
	 XnRJQl71ZPp1dAq5UWeZAeHYf45OdzyP/qDiML3Hl/fP6UaYUUHdq+CLkKcmpvET13
	 b27npQ0H/TOFMQv+KnEPPYitCTusDLJ493U0FkX0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfDJTSF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 15:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfDJTSE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 15:18:04 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAD5020820;
        Wed, 10 Apr 2019 19:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554923884;
        bh=OEmXITh8ps+q+/X7H9exUItY39+VQyk+mPoIMo8DRNE=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=O9Yz9BCUSn1Pgefcu1mPr5++7G0OAZs5mnTeePXiZEQJcYf4apYxwx49swDADFSvM
         G2MgPDD3kdafqmuGuU5p3iIbpPVvuAOQYKKMZK64W0qUZNRYHxGGwpQW+oRuM36Qbi
         TrRwZzvcKPH+7b4AAqRF9QBZ2Eb3IMAdlxI5znNw=
Date:   Wed, 10 Apr 2019 19:18:02 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 4/7] crypto: arm64/aes-neonbs - don't access already-freed walk.iv
In-Reply-To: <20190410064635.11813-5-ebiggers@kernel.org>
References: <20190410064635.11813-5-ebiggers@kernel.org>
Message-Id: <20190410191803.EAD5020820@mail.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 1abee99eafab crypto: arm64/aes - reimplement bit-sliced ARM/NEON implementation for arm64.

The bot has tested the following trees: v5.0.7, v4.19.34, v4.14.111.

v5.0.7: Build OK!
v4.19.34: Build OK!
v4.14.111: Failed to apply! Possible dependencies:
    683381747270 ("crypto: arm64/aes-blk - move kernel mode neon en/disable into loop")
    78ad7b08d8e0 ("crypto: arm64/aes-bs - move kernel mode neon en/disable into loop")


How should we proceed with this patch?

--
Thanks,
Sasha
