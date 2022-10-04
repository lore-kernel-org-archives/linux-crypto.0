Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73020C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Oct 2022 06:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiJDGBt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Oct 2022 02:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiJDGBs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2022 02:01:48 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD0F2BE02
        for <linux-crypto@vger.kernel.org>; Mon,  3 Oct 2022 23:01:47 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 83so5303173pfw.10
        for <linux-crypto@vger.kernel.org>; Mon, 03 Oct 2022 23:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=yhBE8ky6JXjzMCHzZGCNLefRcYUGIpi2tDfsjuB0jYA=;
        b=c0t4sd8UaqdmVI1WSc3vaJJfIs1ThMfxRKfrASZhmWkvCM6mEsuP5iyGXs50kEOr51
         Jwo5y09afobNwM9b9xWqB5YQUGfA6kAJyOepL95eWUuZfVc4BGZ/FrXfqz4OA/da9egy
         xXlYSVXUH061io3zp8UB/L7hXzEawfrzUcvJAxDXWU8YGBOiVtcZ/AZMMCuoFYCsMzXu
         KCX4/rbpeiDvCoufY1mATmQCA84G7R/+g8rM//FBfK//34ZsZtbvFs2244PMaX55bc0Z
         x93IEXh9opkZU0iyj4riUai399Z1miSEoTuwUs++mYFFI6CROTgCErgyDGth9qAidDFf
         pgzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yhBE8ky6JXjzMCHzZGCNLefRcYUGIpi2tDfsjuB0jYA=;
        b=y7g+FSdH+c4pXuyUdCwgzX+SAO40wUmRYUKLCQjOTAqjZ7BSEEkGqam7ffk/Yxpi7s
         bqcbhcXIkqI+qCVYOxpRZeWPW3vi9L4BDBz4/yGK+lGy2K/3846e2w8PFmTlrWfgG5Bx
         xHS2epLFYJdZKwq4eTpwZwoLu3+W0VIqnAKdLSFJjyCqkWHP3XEWRLvJ6YuJdCdk5gk+
         cJRuhIt5sWxzRpZ0U5L7p08Zl7U+KhZ+//v152kFf3lcSPwhLrgp4FI7TsKvMHfpwiK7
         QHbtkkyZU0kUIW0esFl51dkesT1dIxIk2zUID22oRSD2zzsFpigu1d9KoCgG8xNyHq4m
         YIvg==
X-Gm-Message-State: ACrzQf0I64iuxLGyHwLp7Kz90vGb6xsibuUREm7S71WsHkxHM3mpm5TQ
        IfaG5AUMNtkEXI+j7DgTlTw=
X-Google-Smtp-Source: AMsMyM7QQF9rer2u6ECDVOC238SQjcSSEVbWKx1V4+iM/r+w3k/HaEspzibI5Ua9qIuw1Voftn9UzQ==
X-Received: by 2002:a62:64cd:0:b0:55f:9b3f:6619 with SMTP id y196-20020a6264cd000000b0055f9b3f6619mr14646863pfb.86.1664863306808;
        Mon, 03 Oct 2022 23:01:46 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id je12-20020a170903264c00b00176d347e9a7sm8167217plb.233.2022.10.03.23.01.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 23:01:45 -0700 (PDT)
Message-ID: <f7c52ed1-8061-8147-f676-86190118cc56@gmail.com>
Date:   Tue, 4 Oct 2022 15:01:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] crypto: x86: Do not acquire fpu context for too long
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        ardb@kernel.org, ebiggers@google.com
References: <20221004044912.24770-1-ap420073@gmail.com>
 <Yzu8Kd2botr3eegj@gondor.apana.org.au>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <Yzu8Kd2botr3eegj@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,
Thanks a lot for your review!

On 10/4/22 13:52, Herbert Xu wrote:
 > On Tue, Oct 04, 2022 at 04:49:12AM +0000, Taehee Yoo wrote:
 >>
 >>   #define ECB_WALK_START(req, bsize, fpu_blocks) do {			\
 >>   	void *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));	\
 >> +	unsigned int walked_bytes = 0;					\
 >>   	const int __bsize = (bsize);					\
 >>   	struct skcipher_walk walk;					\
 >> -	int err = skcipher_walk_virt(&walk, (req), false);		\
 >> +	int err;							\
 >> +									\
 >> +	err = skcipher_walk_virt(&walk, (req), false);			\
 >>   	while (walk.nbytes > 0) {					\
 >> -		unsigned int nbytes = walk.nbytes;			\
 >> -		bool do_fpu = (fpu_blocks) != -1 &&			\
 >> -			      nbytes >= (fpu_blocks) * __bsize;		\
 >>   		const u8 *src = walk.src.virt.addr;			\
 >> -		u8 *dst = walk.dst.virt.addr;				\
 >>   		u8 __maybe_unused buf[(bsize)];				\
 >> -		if (do_fpu) kernel_fpu_begin()
 >> +		u8 *dst = walk.dst.virt.addr;				\
 >> +		unsigned int nbytes;					\
 >> +		bool do_fpu;						\
 >> +									\
 >> +		if (walk.nbytes - walked_bytes > ECB_CBC_WALK_MAX) {	\
 >> +			nbytes = ECB_CBC_WALK_MAX;			\
 >> +			walked_bytes += ECB_CBC_WALK_MAX;		\
 >> +		} else {						\
 >> +			nbytes = walk.nbytes - walked_bytes;		\
 >> +			walked_bytes = walk.nbytes;			\
 >> +		}							\
 >> +									\
 >> +		do_fpu = (fpu_blocks) != -1 &&				\
 >> +			 nbytes >= (fpu_blocks) * __bsize;		\
 >> +		if (do_fpu)						\
 >> +			kernel_fpu_begin()
 >>
 >>   #define CBC_WALK_START(req, bsize, fpu_blocks)				\
 >>   	ECB_WALK_START(req, bsize, fpu_blocks)
 >> @@ -65,8 +81,12 @@
 >>   } while (0)
 >>
 >>   #define ECB_WALK_END()							\
 >> -		if (do_fpu) kernel_fpu_end();				\
 >> +		if (do_fpu)						\
 >> +			kernel_fpu_end();				\
 >> +		if (walked_bytes < walk.nbytes)				\
 >> +			continue;					\
 >>   		err = skcipher_walk_done(&walk, nbytes);		\
 >> +		walked_bytes = 0;					\
 >>   	}								\
 >>   	return err;							\
 >>   } while (0)
 >
 > skcipher_walk_* is supposed to return at most a page.  Why is this
 > necessary?
 >
 > Cheers,

I referred to below link.
https://lore.kernel.org/all/MW5PR84MB18426EBBA3303770A8BC0BDFAB759@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM/

Sorry for that I didn't check that skcipher_walk_* returns only under 4K 
sizes.
So, I thought fpu context would be too long.
But, I just checked the skcipher_walk_*, and it's right, it returns 
under 4K sizes.
So, there are no problems as you mentioned.

Thank you so much!
Taehee Yoo
