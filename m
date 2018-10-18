Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2B2ECDE42
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Oct 2018 04:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D97A121473
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Oct 2018 04:01:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="UD8809FA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D97A121473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbeJRMA2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Oct 2018 08:00:28 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45184 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbeJRMA2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 08:00:28 -0400
Received: by mail-io1-f68.google.com with SMTP id e12-v6so20149474iok.12
        for <linux-crypto@vger.kernel.org>; Wed, 17 Oct 2018 21:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=yRPENfkl3nY2eOKYI3TDwIKnn8BsA7FsZd3fs1MUw7g=;
        b=UD8809FA5XhaP7YvKIt+ehmswlJwWDfrbDkWL5IhL5mXRq+NE2DA+/oZClrvPuavMq
         zh3lJuVwMJTWV/z5RMYNCDNpcK8sZGBRO1LEQibXUOsNjQARexAIa+PgZd4t9rpovAGv
         ToeTzHl3V0LX5wosJEKvdiWt+XwonXxO8zg0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=yRPENfkl3nY2eOKYI3TDwIKnn8BsA7FsZd3fs1MUw7g=;
        b=MRb8c0mCyAd78qOeOZxNGpM13J1vE6RjQ+YPqe8+zHXg2UU89e4QSy2hvt4RqpRq4I
         m2s6uCmBE3g6NCfiCyOmERRNp9CO9pRyYDPqZDjSss+G1S/tFPn3x0rs1afy2EH2iVwY
         jKdSpGLB/yXBdEFIilHkcwt9m00kn1JGCTqr4NVnifUeXCH8SK01vBpBKegOJkP3HoqO
         CS+X9sjTHqsjqTRcA9rhrRK+IDOUWbpyeZfbS0XmgZ6O51A9fLW1b1j2wBS8y6OyeOMq
         qUap/TvjnO3mUltyUmatfDe2oMgVejvWsW7iu/MBqYNdgFDYyHOrNY0mqKqIbqnRUfka
         azmg==
X-Gm-Message-State: ABuFfojqm9zK/HAsD+Il2pNtng1rBX+HGgjDrJ1gOfzY2Wa8VkwrdYf5
        5ZZT0AM4c+HBpnFu5/9JCMJD2rjufNfyKQNB3hlWNQ==
X-Google-Smtp-Source: ACcGV63d+RVIv8mdR0jh46tZ4Snf2xUYcBVd/9VlX842p17hxs++Vk8ENA99v2F3qiwFFO060UHh9x42cswsabyC89U=
X-Received: by 2002:a6b:be83:: with SMTP id o125-v6mr19195603iof.173.1539835292768;
 Wed, 17 Oct 2018 21:01:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Wed, 17 Oct 2018 21:01:32
 -0700 (PDT)
In-Reply-To: <20181017061813.32751-2-ebiggers@kernel.org>
References: <20181017061813.32751-1-ebiggers@kernel.org> <20181017061813.32751-2-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 18 Oct 2018 12:01:32 +0800
Message-ID:
 <CAKv+Gu9+HnHSrWgybG9rBxmdR_90EbLX187T5eMNKDzHr3Gr1Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] crypto: aes_ti - disable interrupts while
 accessing S-box
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181018040132.VyqPDQ7TmB2Kk_LU3LDZneoeJrmnW8zdr0Q-b5Ldi0I@z>

Hi Eric,

On 17 October 2018 at 14:18, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> In the "aes-fixed-time" AES implementation, disable interrupts while
> accessing the S-box, in order to make cache-timing attacks more
> difficult.  Previously it was possible for the CPU to be interrupted
> while the S-box was loaded into L1 cache, potentially evicting the
> cachelines and causing later table lookups to be time-variant.
>
> In tests I did on x86 and ARM, this doesn't affect performance
> significantly.  Responsiveness is potentially a concern, but interrupts
> are only disabled for a single AES block.
>
> Note that even after this change, the implementation still isn't
> necessarily guaranteed to be constant-time; see
> https://cr.yp.to/antiforgery/cachetiming-20050414.pdf for a discussion
> of the many difficulties involved in writing truly constant-time AES
> software.  But it's valuable to make such attacks more difficult.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks for taking a look. Could we add something to the Kconfig blurb
that mentions that it runs the algorithm witn interrupts disabled? In
any case,

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>


> ---
>  crypto/aes_ti.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/crypto/aes_ti.c b/crypto/aes_ti.c
> index 03023b2290e8..1ff9785b30f5 100644
> --- a/crypto/aes_ti.c
> +++ b/crypto/aes_ti.c
> @@ -269,6 +269,7 @@ static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>         const u32 *rkp = ctx->key_enc + 4;
>         int rounds = 6 + ctx->key_length / 4;
>         u32 st0[4], st1[4];
> +       unsigned long flags;
>         int round;
>
>         st0[0] = ctx->key_enc[0] ^ get_unaligned_le32(in);
> @@ -276,6 +277,12 @@ static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>         st0[2] = ctx->key_enc[2] ^ get_unaligned_le32(in + 8);
>         st0[3] = ctx->key_enc[3] ^ get_unaligned_le32(in + 12);
>
> +       /*
> +        * Temporarily disable interrupts to avoid races where cachelines are
> +        * evicted when the CPU is interrupted to do something else.
> +        */
> +       local_irq_save(flags);
> +
>         st0[0] ^= __aesti_sbox[ 0] ^ __aesti_sbox[128];
>         st0[1] ^= __aesti_sbox[32] ^ __aesti_sbox[160];
>         st0[2] ^= __aesti_sbox[64] ^ __aesti_sbox[192];
> @@ -300,6 +307,8 @@ static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>         put_unaligned_le32(subshift(st1, 1) ^ rkp[5], out + 4);
>         put_unaligned_le32(subshift(st1, 2) ^ rkp[6], out + 8);
>         put_unaligned_le32(subshift(st1, 3) ^ rkp[7], out + 12);
> +
> +       local_irq_restore(flags);
>  }
>
>  static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> @@ -308,6 +317,7 @@ static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>         const u32 *rkp = ctx->key_dec + 4;
>         int rounds = 6 + ctx->key_length / 4;
>         u32 st0[4], st1[4];
> +       unsigned long flags;
>         int round;
>
>         st0[0] = ctx->key_dec[0] ^ get_unaligned_le32(in);
> @@ -315,6 +325,12 @@ static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>         st0[2] = ctx->key_dec[2] ^ get_unaligned_le32(in + 8);
>         st0[3] = ctx->key_dec[3] ^ get_unaligned_le32(in + 12);
>
> +       /*
> +        * Temporarily disable interrupts to avoid races where cachelines are
> +        * evicted when the CPU is interrupted to do something else.
> +        */
> +       local_irq_save(flags);
> +
>         st0[0] ^= __aesti_inv_sbox[ 0] ^ __aesti_inv_sbox[128];
>         st0[1] ^= __aesti_inv_sbox[32] ^ __aesti_inv_sbox[160];
>         st0[2] ^= __aesti_inv_sbox[64] ^ __aesti_inv_sbox[192];
> @@ -339,6 +355,8 @@ static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>         put_unaligned_le32(inv_subshift(st1, 1) ^ rkp[5], out + 4);
>         put_unaligned_le32(inv_subshift(st1, 2) ^ rkp[6], out + 8);
>         put_unaligned_le32(inv_subshift(st1, 3) ^ rkp[7], out + 12);
> +
> +       local_irq_restore(flags);
>  }
>
>  static struct crypto_alg aes_alg = {
> --
> 2.19.1
>
