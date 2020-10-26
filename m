Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB67C4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 17:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77AF920791
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 17:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603734759;
	bh=KFtu/NZNvgNe6TTGzBuUKpV14ikFgvjMFkZhl1sUIDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Ni4a5H1y6I1+fSTMMei2YXbR6a04cg+NjaAmcb6ZVjUM/xwpFsyhDfJKX48a6pFHY
	 5s5whjr8ha73cu37/HKPOttmUVh6ksk18VBUC6m4Xe0HvOTLYsqa6sir1uXc8pxYs+
	 c9UuuXx4uImjiXIrMSEDFCZtcwv/bfCWL3mjhRYo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788569AbgJZRwe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 13:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1788565AbgJZRwd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 13:52:33 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C592020790;
        Mon, 26 Oct 2020 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603734753;
        bh=KFtu/NZNvgNe6TTGzBuUKpV14ikFgvjMFkZhl1sUIDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fzrH56fSrUIOoyFYI+1aFazvExThzR1aHA4Av7NPY3zN3ebfvdu4fJqU3KZkXJS9H
         vkbdy7g4v//mzg/0gJ+wH2gC9BoAJOZ4Nuh7ECj560RYjOZzAsRHV1bZaj54aLcUjk
         1lqxtsGk7nXiN4m7N6JdKhbo38El8wgaEZQQxqmQ=
Date:   Mon, 26 Oct 2020 10:52:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Ofir Drang <ofir.drang@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/4] dm crypt: switch to EBOIV crypto API template
Message-ID: <20201026175231.GG858@sol.localdomain>
References: <20201026130450.6947-1-gilad@benyossef.com>
 <20201026130450.6947-4-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026130450.6947-4-gilad@benyossef.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 26, 2020 at 03:04:46PM +0200, Gilad Ben-Yossef wrote:
> Replace the explicit EBOIV handling in the dm-crypt driver with calls
> into the crypto API, which now possesses the capability to perform
> this processing within the crypto subsystem.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> 
> ---
>  drivers/md/Kconfig    |  1 +
>  drivers/md/dm-crypt.c | 61 ++++++++++++++-----------------------------
>  2 files changed, 20 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 30ba3573626c..ca6e56a72281 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -273,6 +273,7 @@ config DM_CRYPT
>  	select CRYPTO
>  	select CRYPTO_CBC
>  	select CRYPTO_ESSIV
> +	select CRYPTO_EBOIV
>  	help
>  	  This device-mapper target allows you to create a device that
>  	  transparently encrypts the data on it. You'll need to activate

Can CRYPTO_EBOIV please not be selected by default?  If someone really wants
Bitlocker compatibility support, they can select this option themselves.

- Eric
