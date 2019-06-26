Return-Path: <SRS0=1/ZA=UZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1C5C4646B
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 03:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E461C20883
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 03:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561520426;
	bh=++N4PlzWE12KyFTmdd/KlzbDAQKmuXXZ7fvyx2vJ6PQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Z0mAmn8ZOO0IK5JHQDDDY25wrIEM0YLWT7CKF3d5DTUFGr7q/lzsvlAjxUtn5dh8z
	 ov5dYCkFZoXVlrBkekLBO5uhPuN1b7LV8/AKafzjJy+8Z4e7RvQyV8BNa3RTqcGibW
	 JCDIiwm28qgIUzinyz2EfW/pe/kJAJJ18WhH0T20=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfFZDkZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 23:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfFZDkZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 23:40:25 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 448A620659;
        Wed, 26 Jun 2019 03:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520424;
        bh=++N4PlzWE12KyFTmdd/KlzbDAQKmuXXZ7fvyx2vJ6PQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z+BJY8gJPUxwCoqGsBWhF5wcSxOqEpDWl9Kbg0rIfW6uTYvLZhwJhmDE2YMz19rzW
         sgknGex7jaZHAqbSYKYPAE8kMqgadPL8fsBW2lPiFPLKNkgFj0bOMMQ8IVL0/+qRyg
         q1fT8Qhaz8xtCI9b1BJp5/MYbHuGPxXmjKqxvyF4=
Date:   Tue, 25 Jun 2019 20:40:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [RFC PATCH 30/30] fs: cifs: move from the crypto cipher API to
 the new DES library interface
Message-ID: <20190626034022.GB745@sol.localdomain>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
 <20190622003112.31033-31-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190622003112.31033-31-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 22, 2019 at 02:31:12AM +0200, Ard Biesheuvel wrote:
> Some legacy code in the CIFS driver uses single DES to calculate
> some password hash, and uses the crypto cipher API to do so. Given
> that there is no point in invoking an accelerated cipher for doing
> 56-bit symmetric encryption on a single 8-byte block of input, the
> flexibility of the crypto cipher API does not add much value here,
> and so we're much better off using a library call into the generic
> C implementation.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  fs/cifs/Kconfig      |  2 +-
>  fs/cifs/smbencrypt.c | 18 +++++++++---------
>  2 files changed, 10 insertions(+), 10 deletions(-)

You could also remove the:

	MODULE_SOFTDEP("pre: des");

... like was done for arc4.

- Eric
