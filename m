Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B625C2D0E4
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 02:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 355812067D
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 02:06:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJOu74+D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgKYCFz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Nov 2020 21:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgKYCFy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Nov 2020 21:05:54 -0500
Received: from kernel.org (unknown [104.132.1.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00E362067D;
        Wed, 25 Nov 2020 02:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606269954;
        bh=kW5ukZ+4XieOrj46zD/jIyOr6boy+rCZW7xgzBGe2c4=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=oJOu74+DecM/01avMUTCuX57S/ltJTnA/Lz5zCj818jNWFf16nVmM8iFzV2d9gwQ0
         8N6XwIDI8zZrr6Bl4ObCcqYhCoAZk1lDYUqEwVeBPhQAJBIciIHQqNJeowl3w1eqRZ
         fO4n9Vhmiuq1zdDFLdfz66TScKxg3+inSBi8kngE=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201119155233.3974286-5-thara.gopinath@linaro.org>
References: <20201119155233.3974286-1-thara.gopinath@linaro.org> <20201119155233.3974286-5-thara.gopinath@linaro.org>
Subject: Re: [Patch v2 4/6] drivers: crypto: qce: Fix SHA result buffer corruption issues.
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
To:     Thara Gopinath <thara.gopinath@linaro.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, mturquette@baylibre.com,
        robh+dt@kernel.org
Date:   Tue, 24 Nov 2020 18:05:52 -0800
Message-ID: <160626995264.2717324.12789219183680216256@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Thara Gopinath (2020-11-19 07:52:31)
> Partial hash was being copied into the final result buffer without the
> entire message block processed. Depending on how the end user processes
> this result buffer, errors vary from result buffer corruption to result
> buffer poisoing. Fix this issue by ensuring that only the final hash value
> is copied into the result buffer.
>=20
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---

Any Fixes tag?
