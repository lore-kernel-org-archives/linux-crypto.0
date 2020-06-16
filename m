Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14038C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 17:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D268A207C4
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 17:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592329825;
	bh=g7ios/s3I02DPjs0ABrvYdcdUrGeM5pb8RBMx9xux2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=H/CCLtgJ1OH4myNnDC68uGdF8TefwiTTcyQFmjFr2XK6kWuN8qi7aCoZumrBAcFfF
	 uS/FSSo+xiy9lAwR7z+WByDfX5EA6M3AyIErcqnOeLbbM3eBEIv1V/jaaK7R5qkxSJ
	 Gg0HXXeSU9fdx8lyB9uZL+9XQs/OnyCd25tvZ1HY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgFPRuZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 13:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728785AbgFPRuZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 13:50:25 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6636120739;
        Tue, 16 Jun 2020 17:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592329824;
        bh=g7ios/s3I02DPjs0ABrvYdcdUrGeM5pb8RBMx9xux2c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ws+wBGgPJoJJ1ulqBQPA4iR/uUgDrVMgFXNPSydGeX7CB16a8Ldh/rdeBRTn2u1mL
         u3UJdzLAcBgbk89c0njyA3h+nKMmgSvZiow0EBl3KnRp+Vy27zfVRWQmLBigAYi3Nu
         FxHaCLMFZQ2fRw7BpB2JqXPelkL+CdUpcdm32jBA=
Date:   Tue, 16 Jun 2020 10:50:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <msnitzer@redhat.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/4] crypto: fix the drivers that don't
 respect CRYPTO_TFM_REQ_MAY_SLEEP
Message-ID: <20200616175022.GD207319@gmail.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610010450.GA6449@gondor.apana.org.au>
 <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161102250.28052@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006161102250.28052@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 16, 2020 at 11:02:50AM -0400, Mikulas Patocka wrote:
> Fix the crypto drivers that don't respect CRYPTO_TFM_REQ_MAY_SLEEP. If
> CRYPTO_TFM_REQ_MAY_SLEEP is not set, the driver must not do allocation
> that sleeps.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

I think you need to split this up per driver with a proper explanation and a
"Fixes:" tag for each driver.

Also, these bugs should have been detected by the crypto self-tests already,
since they test having preemption disabled and CRYPTO_TFM_REQ_MAY_SLEEP cleared.
Can you double check whether these are all valid fixes?  One thing to watch out
for is that CRYPTO_TFM_REQ_MAY_SLEEP only applies to the function call like
crypto_skcipher_encrypt() itself.  If the implementation is asynchronous and the
request gets processed in the background (i.e. if crypto_skcipher_encrypt()
returns -EINPROGRESS), the background work doesn't have to honor
CRYPTO_TFM_REQ_MAY_SLEEP.

- Eric
