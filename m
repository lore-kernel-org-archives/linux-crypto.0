Return-Path: <SRS0=fgde=7X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD7FC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 06:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45CDB207ED
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 06:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591771359;
	bh=VfMQMod1eLrxBAX1Hwb2cuxN/kSB9eOexl6gi2YWWmw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RpRtpcHbDypBddfFncpAbtld8ak2DtHxCmJb1bBbFQn4EtcXHOJlesTYQsP33+sQE
	 AkZRAI5D6TEwHmdJYXVykpprtEXsFpGRrFoPf9Gds4xjthKGfsRIp9a/b3PLgnmtS6
	 xW7DaZHU180YlkJJ8G+KDHUrbm3EaefiuNgqPvSs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgFJGmi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jun 2020 02:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgFJGmi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jun 2020 02:42:38 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37AC82074B;
        Wed, 10 Jun 2020 06:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591771357;
        bh=VfMQMod1eLrxBAX1Hwb2cuxN/kSB9eOexl6gi2YWWmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rIByuRnC2GSqGfqGsM2QJdzk0f3yw6vgVkG4pO+v0xtwfWszZlnN4YKS+r9Ge2aOK
         F2PWhC58dgDvEC75ZQE+R1RidWERFkBEzdNsCY6ML5PkAFXA/HCs1Ttc1K6GWR+FMt
         8WcC81eiBWt9BXte9M5But1jANxIegYQnj4oQbEw=
Date:   Tue, 9 Jun 2020 23:42:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [v2 PATCH] crc-t10dif: Fix potential crypto notify dead-lock
Message-ID: <20200610064235.GB6286@sol.localdomain>
References: <20200604063324.GA28813@gondor.apana.org.au>
 <20200605065918.GA813@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605065918.GA813@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 05, 2020 at 04:59:18PM +1000, Herbert Xu wrote:
> The crypto notify call occurs with a read mutex held so you must
> not do any substantial work directly.  In particular, you cannot
> call crypto_alloc_* as they may trigger further notifications
> which may dead-lock in the presence of another writer.
> 
> This patch fixes this by postponing the work into a work queue and
> taking the same lock in the module init function.
> 
> While we're at it this patch also ensures that all RCU accesses are
> marked appropriately (tested with sparse).
> 
> Finally this also reveals a race condition in module param show
> function as it may be called prior to the module init function.
> It's fixed by testing whether crct10dif_tfm is NULL (this is true
> iff the init function has not completed assuming fallback is false).
> 
> Fixes: 11dcb1037f40 ("crc-t10dif: Allow current transform to be...")
> Fixes: b76377543b73 ("crc-t10dif: Pick better transform if one...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
