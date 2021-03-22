Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1175FC433C1
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Mar 2021 18:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF6536192B
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Mar 2021 18:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCVSn0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Mar 2021 14:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbhCVSnL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Mar 2021 14:43:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45520C061574;
        Mon, 22 Mar 2021 11:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=eEhKa3fl9PM/rzBKsCj+1kZDKtxZalyhtzpfFhEyDXo=; b=ZHc/I2djlDRHSdVw/rZq5eKEEW
        8hG5E3PeLyc2qaFPN/dEcPW2lTKSFCcEfzNEqEbDL9EqiqVxhZRlVAVMZPFapknckwD32dwSPdvJN
        vbMC8/syhTnGdthLC/ANZUt2pbjmNykB5fNyFBhsmD/a9KTC2O9Y39LzlcMuXRG/m93w3sgyxPby4
        X3di1Beu+Lbwxdu6/MsLIO9paz2ce2C1zJbzUh+QHCWEdKNVDCvqZLPhKn9Nxc1wZX9TtLbN8cASl
        TR/pkCbELUb3SkVxsAZ/6HTrxzWOk7O26e3zxzeqG23snYbmgBUDbWTWDE9CC1VXdqr+n9zocAqbN
        tjvSNKEw==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOPVH-008vkn-7i; Mon, 22 Mar 2021 18:42:23 +0000
Subject: Re: [PATCH] s390/crc32-vx: Couple of typo fixes
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210322130533.3805976-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <62cbcb85-2120-cde2-80a3-41586b097141@infradead.org>
Date:   Mon, 22 Mar 2021 11:42:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322130533.3805976-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/22/21 6:05 AM, Bhaskar Chowdhury wrote:
> 
> s/defintions/definitions/
> s/intermedate/intermediate/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  arch/s390/crypto/crc32be-vx.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/crypto/crc32be-vx.S b/arch/s390/crypto/crc32be-vx.S
> index 0099044e2c86..6b3d1009c392 100644
> --- a/arch/s390/crypto/crc32be-vx.S
> +++ b/arch/s390/crypto/crc32be-vx.S
> @@ -32,7 +32,7 @@
>   * process particular chunks of the input data stream in parallel.
>   *
>   * For the CRC-32 variants, the constants are precomputed according to
> - * these defintions:
> + * these definitions:
>   *
>   *	R1 = x4*128+64 mod P(x)
>   *	R2 = x4*128    mod P(x)
> @@ -189,7 +189,7 @@ ENTRY(crc32_be_vgfm_16)
>  	 * Note: To compensate the division by x^32, use the vector unpack
>  	 * instruction to move the leftmost word into the leftmost doubleword
>  	 * of the vector register.  The rightmost doubleword is multiplied
> -	 * with zero to not contribute to the intermedate results.
> +	 * with zero to not contribute to the intermediate results.
>  	 */
> 
>  	/* T1(x) = floor( R(x) / x^32 ) GF2MUL u */
> --


-- 
~Randy

