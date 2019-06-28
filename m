Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2446C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 944A92133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561698587;
	bh=/peHflkrKmzjbuBmMuvUh/DLiTO8hGnUbfVTz+1n2Nc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=TN8vzQ8ckRVYfJfUPU63MKVfUl1g54tp+9+2GngAqq+ytvwcPN6qKhRNNO1/i4Spl
	 WOYZdSnm/S2xGbyTrVNyGv7fUv56miEfycqzEpvoqMa6zF7esDw1cR29bcWYG2EpIz
	 NLpRfigHbrR0CzHyQZW+hPbSXNcEw59Z06KdZC0E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfF1FJr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 01:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfF1FJq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 01:09:46 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A85F3206E0;
        Fri, 28 Jun 2019 05:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561698586;
        bh=/peHflkrKmzjbuBmMuvUh/DLiTO8hGnUbfVTz+1n2Nc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tuUO3xjaZIWvv3Mbofdz1xB8AocKHnbI5XgL+ZE/Yrl4SQPS/oif9fvuu28wewGbF
         y3INDtDd1R3SOBrBKOxq5TNIordgAutrhTvLNsVlaCsvqOX+YyuOx9JEfflt3KkCLq
         PPafmL2uJvZ7PtFOxYWVbFGr29cYtAtZ3jO1gnHc=
Date:   Thu, 27 Jun 2019 22:09:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Keerthy <j-keerthy@ti.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        t-kristo@ti.com, linux-crypto@vger.kernel.org, nm@ti.com
Subject: Re: [RESEND PATCH 05/10] crypto: sha256_generic: Export the
 Transform function
Message-ID: <20190628050944.GE673@sol.localdomain>
References: <20190628042745.28455-1-j-keerthy@ti.com>
 <20190628042745.28455-6-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628042745.28455-6-j-keerthy@ti.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 28, 2019 at 09:57:40AM +0530, Keerthy wrote:
> The transform function can be used as is by other crypto
> drivers that need to transform the 256 bit key using cpu.
> Hence export it.

What is this supposed to mean?  SHA-256 is an unkeyed hash function.

Also, you need to actually explain why this is needed.  If your hardware
supports SHA-256, why do you need to use the C sha256_transform()?

- Eric
