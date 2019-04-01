Return-Path: <SRS0=dn2r=SD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A8D8C43381
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 17:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D9F520896
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 17:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554140919;
	bh=RN2ZZbMjDHYlc4yGbJxOaRqQcwMFoBWlY+v/Kvr6xDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=WlEyCRNhyu5c/U/YiJyttTnE3GXWRcXl7X6mDsMWHlSuLOsYbKCj1H7bcKXVnYVk+
	 WlUg5BC8xnDmlBeBXc0D78zvkY4IAiAfy0qxU01EHPQ5FnkV2ragKxkOmOReU9ehPO
	 QNpT0TZ4o66+MYCYTiNIKxac2q+2oMIyER8QKVfg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbfDARsc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 13:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733190AbfDARa7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 13:30:59 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DACD320856;
        Mon,  1 Apr 2019 17:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554139859;
        bh=RN2ZZbMjDHYlc4yGbJxOaRqQcwMFoBWlY+v/Kvr6xDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z8EkEhQqkR7yK8x7A1PLPZFVx3FIyY2cC0bbA9KFV6Br6yMMKIxAMAFsjIxneIcHz
         2ovlNo7qQOKkU2bHfdGKg8Mt+R+fAtuLHNCE0zQAYdvaxTY1Ssl0EYURemOrds7ILE
         pC7301ZDQoPxE7cxHJXotQpZ2ae4Tws8TJSoI2n0=
Date:   Mon, 1 Apr 2019 10:30:57 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Lionel Debieve <lionel.debieve@st.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH 1/1] crypto: testmgr - call shash_init in crc32c algo
Message-ID: <20190401173056.GD131675@gmail.com>
References: <1554123264-24243-1-git-send-email-lionel.debieve@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554123264-24243-1-git-send-email-lionel.debieve@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Lionel,

On Mon, Apr 01, 2019 at 02:54:24PM +0200, Lionel Debieve wrote:
> In case of device call required in low level driver,
> the context must be initialized before calling the final
> function.
> 
> Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
> ---
>  crypto/testmgr.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 8386038..4a00d7c 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -2181,6 +2181,13 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
>  		shash->tfm = tfm;
>  		shash->flags = 0;
>  
> +		err = crypto_shash_init(shash);
> +		if (err) {
> +			printk(KERN_ERR "alg: crc32c: init failed for "
> +			       "%s: %d\n", driver, err);
> +			break;
> +		}
> +
>  		*ctx = 420553207;
>  		err = crypto_shash_final(shash, (u8 *)&val);
>  		if (err) {
> -- 
> 2.7.4
> 

This defeats the point of the test, which is that crc32c implementations are
expected to use the same shash_desc context format and be usable by calling
crypto_shash_update() directly after initializing the context manually, without
a prior crypto_shash_init().  See for example ext4_chksum() in fs/ext4/ext4.h:

	static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
				      const void *address, unsigned int length)
	{
		struct {
			struct shash_desc shash;
			char ctx[4];
		} desc;

		BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=sizeof(desc.ctx));

		desc.shash.tfm = sbi->s_chksum_driver;
		desc.shash.flags = 0;
		*(u32 *)desc.ctx = crc;

		BUG_ON(crypto_shash_update(&desc.shash, address, length));

		return *(u32 *)desc.ctx;
	}

I think you need to fix the stm32 crc32 driver to not store anything extra in
the shash_desc context, and only use hardware during ->update().

- Eric
