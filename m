Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126A3C43468
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 12:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5CE322262
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 12:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600692888;
	bh=/j/ViP8gdyjK4n8PeZDIi6lk1/pg4bbkLNZVq1siCgA=;
	h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=MkQJZHsxHD31pRYjluQLT23Cd6co2TgI4spE1WXAA+7BYYOZtTa997FFFpo67/9qb
	 XuT4Ne/3Dn+tiJBqb62OtTEu0uUuV6ZNH5Ncfg3Wo9YYrLRASDRMJG3jkyvvmtaGvD
	 q6vt0aT+mFIE+2kmWWGku3uMKLpv4ud1bx8+/Yyg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgIUMys (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 08:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgIUMyr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 08:54:47 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F825218AC;
        Mon, 21 Sep 2020 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692887;
        bh=/j/ViP8gdyjK4n8PeZDIi6lk1/pg4bbkLNZVq1siCgA=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=ltnnPfyQQa4w82Ia1HFQ1DlP5bt9AwTDHIDJT3GHeIKJAvOnjerEieQDkCq1YPApk
         zYAoHAwTll3lXuCf8OgsRsMjEzeaznaVdvx+ee9Ibzqfr4gk7B5Yqp/2S0CbHByJT7
         pM8KsHQi0Fg+FIPl9odBxaszxHY2R86jPd37PElU=
Date:   Mon, 21 Sep 2020 12:54:46 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/7] crypto: sun4i-ss: checking sg length is not sufficient
In-Reply-To: <1600367758-28589-3-git-send-email-clabbe@baylibre.com>
References: <1600367758-28589-3-git-send-email-clabbe@baylibre.com>
Message-Id: <20200921125447.2F825218AC@mail.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator").

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146, v4.14.198, v4.9.236, v4.4.236.

v5.8.10: Build OK!
v5.4.66: Build OK!
v4.19.146: Build OK!
v4.14.198: Build OK!
v4.9.236: Failed to apply! Possible dependencies:
    a595e60a70c0 ("crypto: sun4i-ss - remove conditional checks against 0")

v4.4.236: Failed to apply! Possible dependencies:
    477d9b2e591b ("crypto: sun4i-ss - unify update/final function")
    a595e60a70c0 ("crypto: sun4i-ss - remove conditional checks against 0")
    bfb2892018ca ("crypto: sunxi - don't print confusing data")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
