Return-Path: <SRS0=Rknj=QD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C74C282C7
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 00:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C66E21903
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 00:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548547677;
	bh=jMkfqoVZ3STo8cv96Vrd9G6L5fyZlOKr/E4M70cXCvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=pB61LStYYvEBS6p3yxQzN3wP5LyNZU/MxNok+xhEs0sKZMF2DN3x6UR77SyZIDqL6
	 aQWv/Txaz2wNMF44nAG/v4rokONl2TBBnjXhg45TenqScphaMDU7Rld8wTH3PqmPKy
	 G+Qs6mAEK0xnL2lgdNYJBNgl1qv22NI3KVUV9Wo0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfA0AH4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Jan 2019 19:07:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfA0AHz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Jan 2019 19:07:55 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3971B218CD;
        Sun, 27 Jan 2019 00:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548547675;
        bh=jMkfqoVZ3STo8cv96Vrd9G6L5fyZlOKr/E4M70cXCvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x8h6YhoOiPywx7kn1JCchLpbt+dDi5y8c2aymjX55uOoazejGenFq8IfECMx6MYO2
         +gjo7he81vhztqMhQe9aFcozzfm1CYtIyR4z41j+UuHYePyMXmIhJOmWbMVRUEeYBa
         fm1Qg5aYyfAO0kMP/G/eq7ti+IyUb3+UR0BpZkf8=
Date:   Sat, 26 Jan 2019 16:07:53 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH v2 0/4] crypto: fix crct10dif for ARM and arm64
Message-ID: <20190127000752.GC709@sol.localdomain>
References: <20190125084915.25411-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125084915.25411-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 25, 2019 at 09:49:11AM +0100, Ard Biesheuvel wrote:
> Fix the issues in both NEON implementations of the CRC-T10DIF routines,
> that were reported by Eric's new testing code.
> 
> v2:
> - keep alignment specifiers where possible (#1)
> - clarify/fix commit log (#2)
> - add fixes/cc-stable/etc tags
> - add patches that drop the now unreacheable code (#3 - #4)
> 
> Ard Biesheuvel (4):
>   crypto: arm/crct10dif - revert to C code for short inputs
>   crypto: arm64/crct10dif - revert to C code for short inputs
>   crypto: arm/crct10dif - remove dead code
>   crypto: arm64/crct10dif - remove dead code
> 
>  arch/arm/crypto/crct10dif-ce-core.S   | 27 +++++---------------
>  arch/arm/crypto/crct10dif-ce-glue.c   | 23 +++++------------
>  arch/arm64/crypto/crct10dif-ce-core.S | 11 --------
>  arch/arm64/crypto/crct10dif-ce-glue.c | 25 +++++-------------
>  4 files changed, 19 insertions(+), 67 deletions(-)
> 

In the commit message of patches 1-2, "more than 16 bytes" should be
"at least 16 bytes".

Otherwise for all 4 patches:

	Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
