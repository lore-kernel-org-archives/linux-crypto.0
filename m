Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA173C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 03:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A993960F8F
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 03:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbhIQDUL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Sep 2021 23:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243788AbhIQDUK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Sep 2021 23:20:10 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8707C061764
        for <linux-crypto@vger.kernel.org>; Thu, 16 Sep 2021 20:18:48 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id b21-20020a1c8015000000b003049690d882so8821342wmd.5
        for <linux-crypto@vger.kernel.org>; Thu, 16 Sep 2021 20:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=zdfyt/hLZ2i3pvJHRp19DGRqMiKpceYGmEPLD062Jes=;
        b=drgKXrBhdxjDhyoE+5eVrQpd3lVzHMFJK/D6cZmxVxCNzDSkTR3RqnmCECx+cqBxyw
         RZC2XjqWRZFs6CjyumeR3I1atOnCIJbzrMGIXvPEff+3PhsxxUKsI+gqvbuPUP1pVdzA
         yBl8pcIlzTxQDel9r8XWOEcPDtJ+a7jyIzPTx2YLRz4wFwuPNOeypZZGcR6I+hSr58+H
         /StZIJ8iLl22ksIQ/QVSa/E5N2wi2IdwiXpbHc2LoxL5hbJ8TkXLiRpJuYwXZSrtYd7p
         ZgYCUmDLMsjDoVnZTckhoWrWfxCYuOGao2mRJ/KrDhmMQV6NrfS2162MfbFNcAREciai
         bkLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=zdfyt/hLZ2i3pvJHRp19DGRqMiKpceYGmEPLD062Jes=;
        b=gTjo6rbL4H9W0xRcDxSD/q0fQzUaW3DOcr+ela2ZB9zgqKMarXAFhLMihAeboFjVop
         TYe5/Mj35Fj0ZX0g06SSAj0/894uAHNVfDzPkhq3IBZ0S6bJZkbwe33s2iG3dTyOUsgT
         /pYDVkZ/qAFevVy42hOSh0N+2+8zO1g1saokWwsZJn4swMZEMPJ0b8NKwslOd9TKvQCI
         7cJVOx9zRF9wiAoXE5O7OhIsRzmM9dQ78776ji9Vjl+QIJWtYfuGWg8Dq6Y/Klrp678g
         WD1KKe+9MhJtgjHakCB/fR7Uj8P2rh19anLZOrXcBnNO/L9b1yaTuDGoIesQcDWhcT8O
         Lnxw==
X-Gm-Message-State: AOAM533C0+gTggYF5tMoiT/iX+bXER5qRoaWG9N5AfiWDrr8mMGjgxn2
        PhCXANi0VyFAQGF1z0CnHCUjNvH+c5BxZ1Bka1gQHp2gVdc=
X-Google-Smtp-Source: ABdhPJzh4x5PJgP8q0Lz5hKSnPgcDMfWIiq+iBrCbkwgI9O4crjWWEsob9JCOdkr5+C/2A5B6vduCMiWLVfEF/J7n1E=
X-Received: by 2002:a1c:f314:: with SMTP id q20mr12558522wmq.154.1631848727295;
 Thu, 16 Sep 2021 20:18:47 -0700 (PDT)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Fri, 17 Sep 2021 11:18:35 +0800
Message-ID: <CACXcFm=-E_wnDdRPztKJwDo8hvt6ENf84D90iFUXReuw2s0kuQ@mail.gmail.com>
Subject: [RFC] random: add new pseudorandom number generator
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Cryptography <cryptography@metzdowd.com>,
        "Ted Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I have a PRNG that I want to use within the Linux random(4) driver. It
looks remarkably strong to me, but analysis from others is needed.

(The spinlocks here are a kluge for out-of-kernel testing.)

/*************************************************************************
* use xtea to create a pseudorandom 64-bit output
*
* xtea is fast & uses little storage
* See https://en.wikipedia.org/wiki/XTEA and papers it links
*
* tea is the original block cipher, Tiny Encryption Algorithm
* xtea is an improved version preventing some published attacks
* both are in linux/crypto/tea.c
*************************************************************************/

static spinlock_t xtea_lock;

/*
 * The initialisations here may not be needed, but they are
 * more-or-less free and can do no harm.
 * constants taken from SHA-512
 */
static u64 tea_mask = 0x7137449123ef65cd ;
static u64 tea_counter = 0xb5c0fbcfec4d3b2f ;
/*
 * 128-bit key
 * cipher itself uses 32-bit operations
 * but rekeying uses 64-bit
 */
static u64 tea_key64[2] = {0x0fc19dc68b8cd5b5, 0xe9b5dba58189dbbc} ;
static u32 *tea_key = (u32 *) &tea_key64[0] ;

/*
 * simplified version of code fron crypto/tea.c
 * xtea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 *
 * does not use struct
 * does no endianess conversions
 * no *src or *dst, encrypt a 64-bit block in place
 */
#define XTEA_ROUNDS        32
#define XTEA_DELTA        0x9e3779b9

static void xtea_block(u64 *x)
{
    u32 i, y, z, sum, *p ;
        p = (u32 *) x ;

    y = p[0] ;
    z = p[1] ;
    for( i = 0, sum = 0 ; i < XTEA_ROUNDS ; i++ ) {
        y += ((z << 4 ^ z >> 5) + z) ^ (sum + tea_key[sum&3]);
        sum += XTEA_DELTA;
        z += ((y << 4 ^ y >> 5) + y) ^ (sum + tea_key[sum>>11 &3]);
    }
    p[0] = y ;
    p[1] = z ;
}

/*
 * For counter mode see RFC 4086 section 6.2.1
 * Add a constant instead of just incrementing
 * to change more bits
 *
 * Even and Mansour proved proved a lower bound
 * for an XOR-permutation-XOR sequence.
 * S. Even, Y. Mansour, Asiacrypt 1991
 * A Construction of a Cipher From a Single Pseudorandom Permutation
 *
 * For an n-bit cipher and D known or chosen plaintexts,
 * time T to break it is bounded by DT >= 2^n.
 *
 * This applies even if the enemy knows the permutation,
 * for a block cipher even if he or she knows the key.
 * All the proof requires is that the permutation be
 * nonlinear.
 *
 * Here the main calling function changes the key a bit
 * on every iteration and updates key, mask and counter
 * after TEA_REKEY iterations, so any possible D for
 * the same key, mask and counter sequence is small.
 *
 * With TEA_REKEY = 127 ~= 2^7, for each sequence of
 * 127 outputs between rekeyings the enemy needs
 * time T > 2^57
 *
 * Assuming proper keying and that the enemy cannot
 * peek into the running kernel, this can be
 * considered effectively unbreakable, even if
 * xtea itself were found to be weak.
 */
#define COUNTER_DELTA 0x240ca1cc77ac9c65

static u64 xtea_counter()
{
        u64 x ;
        x = tea_counter ^ tea_mask ;
        xtea_block(&x) ;
        x ^= tea_mask ;
        tea_counter += COUNTER_DELTA ;
        return x ;
}

/*
 * Interval for full rekey can be moderately long
 * because there is incremental key change as well
 */
#define TEA_REKEY   127
static int xtea_iterations = 0 ;

static void get_xtea_long(u64 *out)
{
        int a ;
        int flag = 0 ;

        spin_lock(&xtea_lock) ;
        if (xtea_iterations >= TEA_REKEY)
                xtea_iterations = 0 ;
        if (xtea_iterations == 0)
                flag = 1 ;
        spin_unlock(&xtea_lock) ;

        if (flag)
                xtea_rekey() ;

        spin_lock(&xtea_lock) ;
        a = xtea_iterations & 3 ;
        tea_key[a] += rol32(tea_key[(a+1)&3], 5) ;
        *out = xtea_counter() ;
        xtea_iterations++ ;
        spin_unlock(&xtea_lock) ;
}
