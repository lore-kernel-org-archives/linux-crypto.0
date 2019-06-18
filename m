Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACE6C31E5C
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 03:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82C2A2089E
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 03:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560827995;
	bh=cVwUgvpthCIfOlkvKKJ0rtxT+EtZpK0NgTGeSQI83jw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IukfOYzPBFX7s/hX9OFs4hp4Szm51/A38BJyBV5yI1M+ZWaAr73Qxp9N/4vCHhwEY
	 xNAeNbRa6N6XvLrkSp5uHQLw1+XTj5jN6qqmHdxLrLZ0JGdvxZBRgtdhdNLRoDdQ+h
	 7HHsYnTtq5q3VjhQ4GhXVgNXBowbuJWvJ2rRu6+o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFRDTy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 23:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfFRDTx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 23:19:53 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0EA82084B;
        Tue, 18 Jun 2019 03:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560827992;
        bh=cVwUgvpthCIfOlkvKKJ0rtxT+EtZpK0NgTGeSQI83jw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xn/5ENu41WjIXlEdMNgtlz8x/UcPMWYZBFVrSZ1v6F2WUatIhnDocnRjh0fxeTztE
         WjvED2rFL7hMo3+nXpAwC88KNK6eRxrpZYoQX5vtWXCLdVN1S2ZXQeuC4IJi8cqytv
         5vaBwuiFCQAakXrgbLNXgu9EZHDHmaHreJDZ+S5c=
Date:   Mon, 17 Jun 2019 20:19:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: serpent - mark __serpent_setkey_sbox noinline
Message-ID: <20190618031951.GA2266@sol.localdomain>
References: <20190617115927.3813471-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617115927.3813471-1-arnd@arndb.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Arnd,

On Mon, Jun 17, 2019 at 01:59:08PM +0200, Arnd Bergmann wrote:
> The same bug that gcc hit in the past is apparently now showing
> up with clang, which decides to inline __serpent_setkey_sbox:
> 
> crypto/serpent_generic.c:268:5: error: stack frame size of 2112 bytes in function '__serpent_setkey' [-Werror,-Wframe-larger-than=]
> 
> Marking it 'noinline' reduces the stack usage from 2112 bytes to
> 192 and 96 bytes, respectively, and seems to generate more
> useful object code.
> 
> Fixes: c871c10e4ea7 ("crypto: serpent - improve __serpent_setkey with UBSAN")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/serpent_generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
> index e57757904677..183661faf420 100644
> --- a/crypto/serpent_generic.c
> +++ b/crypto/serpent_generic.c
> @@ -225,7 +225,7 @@
>  	x4 ^= x2;					\
>  	})
>  
> -static void __serpent_setkey_sbox(u32 r0, u32 r1, u32 r2, u32 r3, u32 r4, u32 *k)
> +static void noinline __serpent_setkey_sbox(u32 r0, u32 r1, u32 r2, u32 r3, u32 r4, u32 *k)
>  {
>  	k += 100;
>  	S3(r3, r4, r0, r1, r2); store_and_load_keys(r1, r2, r4, r3, 28, 24);
> -- 
> 2.20.0
> 

A few nits: 'static noinline void' seems to be the much more common order,
presumably to match 'static inline void'.  Line breaking at 80 characters would
also be nice.  Finally, a brief comment explaining the purpose of 'noinline'
might be helpful for people working with this code later.

- Eric
