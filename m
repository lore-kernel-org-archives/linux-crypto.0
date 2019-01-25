Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678E9C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 07:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36625218DE
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 07:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548401392;
	bh=C7+wb730/3XKsMNiRj9KszZnH7HKQyvxkscH9k5PF+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=VTDYUGNh6Gevvf6GTBn+d1o2VuaWwECt1IqzZy8T8l8OR9pXeYi4vds9t+8i6DYAV
	 qLCBsvzUcdQkqQPURnSXKNCSxp5/HPOMnKLlumX6jz+eepS6d6Jlv6fJZY9tOwqo2U
	 /9MjrCPG0CvquKneX5qK2lS8jf9sd+Dq81C4fk48=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfAYH3v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 02:29:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbfAYH3v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 02:29:51 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96FED218D0;
        Fri, 25 Jan 2019 07:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548401390;
        bh=C7+wb730/3XKsMNiRj9KszZnH7HKQyvxkscH9k5PF+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RsDBUUhnJ1b9eureZO4p/KZwfT4PCVsmXtWLyL20lTDVheo++157kBm5idNtG+oqt
         tjG+qqiCJFGI8WVNNzyLy0+qLi/dQ57QvRWHqoDa2dsP5J06ULyZg7tfCpbQFfDvd0
         GU/DyMwJeFX4+uAzNAhLmZi2vio+n6+sieF16iIc=
Date:   Thu, 24 Jan 2019 23:29:49 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH 2/2] crypto: arm64/crct10dif - revert to C code for short
 inputs
Message-ID: <20190125072948.GC700@sol.localdomain>
References: <20190124182712.7142-1-ard.biesheuvel@linaro.org>
 <20190124182712.7142-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124182712.7142-3-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 24, 2019 at 07:27:12PM +0100, Ard Biesheuvel wrote:
> The SIMD routine ported from x86 used to have a special code path
> for inputs < 16 bytes, which got lost somewhere along the way.
> Instead, the current glue code aligns the input pointer to permit
> the NEON routine to use special versions of the vld1 instructions
> that assume 16 byte alignment, but this could result in inputs of
> less than 16 bytes to be passed in. 

This description doesn't quite match the patch since the arm64 version of the
assembly doesn't use any alignment specifiers.  I take it that actually means
the alignment in the glue code wasn't necessary in the first place?

> This not only fails the new
> extended tests that Eric has implemented, it also results in the
> code reading before the input pointer, which could potentially
> result in crashes when dealing with less than 16 bytes of input
> at the start of a page which is preceded by an unmapped page.
> 
> So update the glue code to only invoke the NEON routine if the
> input is more than 16 bytes.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Can you add:

Fixes: 6ef5737f3931 ("crypto: arm64/crct10dif - port x86 SSE implementation to arm64")
Cc: stable@vger.kernel.org

> ---
>  arch/arm64/crypto/crct10dif-ce-glue.c | 25 +++++---------------
>  1 file changed, 6 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
> index b461d62023f2..567c24f3d224 100644
> --- a/arch/arm64/crypto/crct10dif-ce-glue.c
> +++ b/arch/arm64/crypto/crct10dif-ce-glue.c
> @@ -39,26 +39,13 @@ static int crct10dif_update(struct shash_desc *desc, const u8 *data,
>  			    unsigned int length)
>  {
>  	u16 *crc = shash_desc_ctx(desc);
> -	unsigned int l;
>  
> -	if (unlikely((u64)data % CRC_T10DIF_PMULL_CHUNK_SIZE)) {
> -		l = min_t(u32, length, CRC_T10DIF_PMULL_CHUNK_SIZE -
> -			  ((u64)data % CRC_T10DIF_PMULL_CHUNK_SIZE));
> -
> -		*crc = crc_t10dif_generic(*crc, data, l);
> -
> -		length -= l;
> -		data += l;
> -	}
> -
> -	if (length > 0) {
> -		if (may_use_simd()) {
> -			kernel_neon_begin();
> -			*crc = crc_t10dif_pmull(*crc, data, length);
> -			kernel_neon_end();
> -		} else {
> -			*crc = crc_t10dif_generic(*crc, data, length);
> -		}
> +	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && may_use_simd()) {
> +		kernel_neon_begin();
> +		*crc = crc_t10dif_pmull(*crc, data, length);
> +		kernel_neon_end();
> +	} else {
> +		*crc = crc_t10dif_generic(*crc, data, length);
>  	}
>  
>  	return 0;
> -- 
> 2.17.1
> 
