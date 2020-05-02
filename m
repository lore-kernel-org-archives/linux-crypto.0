Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE24C3A5A9
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 08:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B57072137B
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 08:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgEBIBk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 04:01:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:50878 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgEBIBj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 04:01:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D9065AC5F;
        Sat,  2 May 2020 08:01:37 +0000 (UTC)
Subject: Re: [PATCH] lib/xxhash: make xxh{32,64}_update() return void
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20200502063423.1052614-1-ebiggers@kernel.org>
From:   Nikolay Borisov <nborisov@suse.com>
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <367527ae-0471-e6be-eab2-c575e7b70564@suse.com>
Date:   Sat, 2 May 2020 11:01:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200502063423.1052614-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2.05.20 г. 9:34 ч., Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The return value of xxh64_update() is pointless and confusing, since an
> error is only returned for input==NULL.  But the callers must ignore
> this error because they might pass input=NULL, length=0.
> 
> Likewise for xxh32_update().
> 
> Just make these functions return void.
> 
> Cc: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> lib/xxhash.c doesn't actually have a maintainer, but probably it makes
> sense to take this through the crypto tree, alongside the other patch I
> sent to return void in lib/crypto/sha256.c.
> 
>  include/linux/xxhash.h |  8 ++------
>  lib/xxhash.c           | 20 ++++++--------------
>  2 files changed, 8 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/xxhash.h b/include/linux/xxhash.h
> index 52b073fea17fe4..e1c469802ebdba 100644
> --- a/include/linux/xxhash.h
> +++ b/include/linux/xxhash.h
> @@ -185,10 +185,8 @@ void xxh32_reset(struct xxh32_state *state, uint32_t seed);
>   * @length: The length of the data to hash.
>   *
>   * After calling xxh32_reset() call xxh32_update() as many times as necessary.
> - *
> - * Return:  Zero on success, otherwise an error code.
>   */
> -int xxh32_update(struct xxh32_state *state, const void *input, size_t length);
> +void xxh32_update(struct xxh32_state *state, const void *input, size_t length);
>  
>  /**
>   * xxh32_digest() - produce the current xxh32 hash
> @@ -218,10 +216,8 @@ void xxh64_reset(struct xxh64_state *state, uint64_t seed);
>   * @length: The length of the data to hash.
>   *
>   * After calling xxh64_reset() call xxh64_update() as many times as necessary.
> - *
> - * Return:  Zero on success, otherwise an error code.
>   */
> -int xxh64_update(struct xxh64_state *state, const void *input, size_t length);
> +void xxh64_update(struct xxh64_state *state, const void *input, size_t length);
>  
>  /**
>   * xxh64_digest() - produce the current xxh64 hash
> diff --git a/lib/xxhash.c b/lib/xxhash.c
> index aa61e2a3802f0a..64bb68a9621ed1 100644
> --- a/lib/xxhash.c
> +++ b/lib/xxhash.c
> @@ -267,21 +267,19 @@ void xxh64_reset(struct xxh64_state *statePtr, const uint64_t seed)
>  }
>  EXPORT_SYMBOL(xxh64_reset);
>  
> -int xxh32_update(struct xxh32_state *state, const void *input, const size_t len)
> +void xxh32_update(struct xxh32_state *state, const void *input,
> +		  const size_t len)
>  {
>  	const uint8_t *p = (const uint8_t *)input;
>  	const uint8_t *const b_end = p + len;
>  
> -	if (input == NULL)
> -		return -EINVAL;
> -

Values calculated based on input are dereferenced further down, wouldn't
that cause crashes in case input is null ?

>  	state->total_len_32 += (uint32_t)len;
>  	state->large_len |= (len >= 16) | (state->total_len_32 >= 16);
>  
>  	if (state->memsize + len < 16) { /* fill in tmp buffer */
>  		memcpy((uint8_t *)(state->mem32) + state->memsize, input, len);
>  		state->memsize += (uint32_t)len;
> -		return 0;
> +		return;
>  	}
>  
>  	if (state->memsize) { /* some data left from previous update */
> @@ -331,8 +329,6 @@ int xxh32_update(struct xxh32_state *state, const void *input, const size_t len)
>  		memcpy(state->mem32, p, (size_t)(b_end-p));
>  		state->memsize = (uint32_t)(b_end-p);
>  	}
> -
> -	return 0;
>  }
>  EXPORT_SYMBOL(xxh32_update);
>  
> @@ -374,20 +370,18 @@ uint32_t xxh32_digest(const struct xxh32_state *state)
>  }
>  EXPORT_SYMBOL(xxh32_digest);
>  
> -int xxh64_update(struct xxh64_state *state, const void *input, const size_t len)
> +void xxh64_update(struct xxh64_state *state, const void *input,
> +		  const size_t len)
>  {
>  	const uint8_t *p = (const uint8_t *)input;
>  	const uint8_t *const b_end = p + len;
>  
> -	if (input == NULL)
> -		return -EINVAL;
> -
>  	state->total_len += len;
>  
>  	if (state->memsize + len < 32) { /* fill in tmp buffer */
>  		memcpy(((uint8_t *)state->mem64) + state->memsize, input, len);
>  		state->memsize += (uint32_t)len;
> -		return 0;
> +		return;
>  	}
>  
>  	if (state->memsize) { /* tmp buffer is full */
> @@ -436,8 +430,6 @@ int xxh64_update(struct xxh64_state *state, const void *input, const size_t len)
>  		memcpy(state->mem64, p, (size_t)(b_end-p));
>  		state->memsize = (uint32_t)(b_end - p);
>  	}
> -
> -	return 0;
>  }
>  EXPORT_SYMBOL(xxh64_update);
>  
> 
