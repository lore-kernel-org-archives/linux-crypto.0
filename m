Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C662AC54EAA
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Jan 2023 15:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbjA0Pjd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Jan 2023 10:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbjA0Pjc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Jan 2023 10:39:32 -0500
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B287482403;
        Fri, 27 Jan 2023 07:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1674833966;
  x=1706369966;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7SwjJfOjvhpwldezc8vYuWrmD0WppKmzZSdSKl2axqg=;
  b=dtmAGTj+kVRHFldGadvDCqRRj6yuQ4YcmP+KBBCYAFcgBxyRMVvPzJUb
   E0hs7ppXF7BLCzFtla1wpqUJhS0TTqxbZPIOw7j3y6PwGBkqAmqJyoadJ
   /Ryc8a1WTcQBoPQZNhZJj+mS6Aoxt8sdKzT0GiPruB1XRtRsAOWvjbnEu
   9539UiEQzLzNTR4lgCMvpQV6F5Xllq6QycJH9nLcZg+Mn7mF7ud8QPP32
   qUGrI1IMv/kLYeeNVnV68iE31Mxn46h0dCeIotrC0zgE3wMRxaOCXMQBQ
   Z1KJVR2VtRS7OWvr7R3zPcfHqPLTju2CVtDb4f23Xxhv7K4mlduPfSse8
   Q==;
Date:   Fri, 27 Jan 2023 16:39:23 +0100
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Jesper Nilsson <Jesper.Nilsson@axis.com>,
        Lars Persson <Lars.Persson@axis.com>, kernel <kernel@axis.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/12] crypto: axis - do not DMA to IV
Message-ID: <Y9PwK/aVuD/dN1Lh@axis.com>
References: <20230110135042.2940847-1-vincent.whitchurch@axis.com>
 <20230110135042.2940847-3-vincent.whitchurch@axis.com>
 <Y8pa15wREUvWO1L8@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y8pa15wREUvWO1L8@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 20, 2023 at 10:11:51AM +0100, Herbert Xu wrote:
> On Tue, Jan 10, 2023 at 02:50:32PM +0100, Vincent Whitchurch wrote:
> > +	unsigned char iv_bounce[AES_BLOCK_SIZE] CRYPTO_MINALIGN_ATTR;
> 
> Please use the newly introduced CRYPTO_DMA_ALIGN macro.
> 
> CRYPTO_MINALIGN only reflects minimum kmalloc alignment, which
> may be less than that required for DMA.  You're currently safe
> on arm32, but we should not rely on this in new code.

Thanks, I'll fix this in v2.  Should we add a CRYPTO_DMA_ALIGN_ATTR
macro similar to CRYPTO_MINALIGN_ATTR?
