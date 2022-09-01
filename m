Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882F7ECAAD3
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Sep 2022 20:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbiIAUJw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 16:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiIAUJv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 16:09:51 -0400
Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [IPv6:2a0b:5c81:1c1::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE86FF68
        for <linux-crypto@vger.kernel.org>; Thu,  1 Sep 2022 13:09:47 -0700 (PDT)
Received: from [10.0.0.10] (87-100-246-149.bb.dnainternet.fi [87.100.246.149])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: jussi.kivilinna)
        by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 07BC31B001B0;
        Thu,  1 Sep 2022 23:09:46 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
        t=1662062986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2on/NE8C06OpB4eHMAfiOhWwijuHFkO+CrLReU7rkKI=;
        b=FcVAOLwwNQ2+TuUelNSQN8e3yUIIOvAP132KNAc/SGVrMOyM5ku8FtVATGYGlPZbRUmMWX
        USQUQc3nqnzRfV7Jj75+ektpEq6xa9lN+j1E5TKSYctPfB5dn6HDLWFBP1riUDnokkikgy
        Q4m7c/CZPRutmeQy4Jkdi3xc8BXv2zxLV8nrtWavypcX6PX92qLb+eTwXAoKrOsTBN0AbL
        rjcitYyolzdGCzPYy8CBwP9aqvg872IbJM1BvFSyztj8RWD+9RFZUGOBuYAHCY55Rekd7b
        KGSXUh/He7dUKOdzqu2QFeD72vuh07+r+w+71GIWhKGZ/SVH5imBYKMeg4sA2A==
Message-ID: <afef1c3a-9a72-9006-da95-d63ec5aece5c@iki.fi>
Date:   Thu, 1 Sep 2022 23:09:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     elliott@hpe.com, hpa@zytor.com, x86@kernel.org,
        davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com, bp@alien8.de,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
References: <20220826053131.24792-1-ap420073@gmail.com>
From:   Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [PATCH v2 0/3] crypto: aria: add ARIA AES-NI/AVX/x86_64
 implementation
In-Reply-To: <20220826053131.24792-1-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=jussi.kivilinna smtp.mailfrom=jussi.kivilinna@iki.fi
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1662062986; a=rsa-sha256;
        cv=none;
        b=WIwGOg2h0/yYGL2ugxZcSE8NyIkT5EduFT1uanlqlaECh5Y+0rX4JJeg8rTq/4FXpKw3wV
        h+XOMcYhvZfboDdG9+8jcsj4GZPmkQtZCwgdEm4r6QG48zYm/FD7yqvIZnWAbkfXNH+ME/
        b6t2tlhiz6Xd4aBnPF4tYKpHHAbAb5CcF9ncFEeGA7UZgiKBDGHRAfGhVMjGKZFC1Tz+66
        i0c+DZajo/xoNJsVUCaHTEc9tf3VOu4o5HT4dCZoQ9s7ad9JmAByizjyFACfL7W85RbAVy
        wisRDekuc5PwS1zKeYgiiTBLEzC8OOrkVvF4zpTnf0I3cj+rWB94ZR7y/HDKzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=lahtoruutu; t=1662062986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2on/NE8C06OpB4eHMAfiOhWwijuHFkO+CrLReU7rkKI=;
        b=sNtM+I3SOgsmscSMeTwtLCwAbmHMbQtNiBpvSN7FTsaM8OkmRcHzIh9UqblECC4UesnyY2
        H4U3kCFAS1QCnMFwOhfk2G/oXhpOC/yl5YiTLHCsdKtpTp/gFi+dyOpNIJR0rL/Wad5PYy
        aRedbFqJAASg3N/wwqt1Vmb1MfsTEvFLQJe3dickeyncJx5ArVNooWdRQ9hTgeig/qBTam
        VSH1lLImBWXlVPtAl0SrpYQBjB0cwYQYuzWvPZ9smCzMhIywWHatjvHl0T9fAyUg1QGSBO
        u9egOIBlSn4aAdjV4qGj9d4anRGIclv3i4ar+MrQ8oRqUeuVigggR2mFiyhcVg==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

On 26.8.2022 8.31, Taehee Yoo wrote:
> The purpose of this patchset is to support the implementation of ARIA-AVX.
> Many of the ideas in this implementation are from Camellia-avx,
> especially byte slicing.
> Like Camellia, ARIA also uses a 16way strategy.
> 
> ARIA cipher algorithm is similar to AES.
> There are four s-boxes in the ARIA spec and the first and second s-boxes
> are the same as AES's s-boxes.
> Almost functions are based on aria-generic code except for s-box related
> function.
> The aria-avx doesn't implement the key expanding function.
> it only support encrypt() and decrypt().
> 
> Encryption and Decryption logic is actually the same but it should use
> separated keys(encryption key and decryption key).
> En/Decryption steps are like below:
> 1. Add-Round-Key
> 2. S-box.
> 3. Diffusion Layer.
> 
> There is no special thing in the Add-Round-Key step.
> 
> There are some notable things in s-box step.
> Like Camellia, it doesn't use a lookup table, instead, it uses aes-ni.
> 
> To calculate the first s-box, it just uses the aesenclast and then
> inverts shift_row. No more process is needed for this job because the
> first s-box is the same as the AES encryption s-box.
> 
> To calculate a second s-box(invert of s1), it just uses the aesdeclast
> and then inverts shift_row. No more process is needed for this job
> because the second s-box is the same as the AES decryption s-box.
> 
> To calculate a third and fourth s-boxes, it uses the aesenclast,
> then inverts shift_row, and affine transformation.
> 
> The aria-generic implementation is based on a 32-bit implementation,
> not an 8-bit implementation.
> The aria-avx Diffusion Layer implementation is based on aria-generic
> implementation because 8-bit implementation is not fit for parallel
> implementation but 32-bit is fit for this.
> 
> The first patch in this series is to export functions for aria-avx.
> The aria-avx uses existing functions in the aria-generic code.
> The second patch is to implement aria-avx.
> The last patch is to add async test for aria.
> 
> Benchmarks:
> The tcrypt is used.
> cpu: i3-12100

This CPU also supports Galois Field New Instructions (GFNI) which are
even better suited for accelerating ciphers that use same building
blocks as AES. For example, I've recently implemented camellia using
GFNI for libgcrypt [1].

I quickly hacked GFNI to your implementation and it gives nice extra
bit of performance (~55% faster on Intel tiger-lake). Here's GFNI
version of 'aria_sbox_8way', that I used:

/////////////////////////////////////////////////////////
#define aria_sbox_8way(x0, x1, x2, x3,                  \
                        x4, x5, x6, x7,                  \
                        t0, t1, t2, t3,                  \
                        t4, t5, t6, t7)                  \
         vpbroadcastq .Ltf_s2_bitmatrix, t0;             \
         vpbroadcastq .Ltf_inv_bitmatrix, t1;            \
         vpbroadcastq .Ltf_id_bitmatrix, t2;             \
         vpbroadcastq .Ltf_aff_bitmatrix, t3;            \
         vpbroadcastq .Ltf_x2_bitmatrix, t4;             \
         vgf2p8affineinvqb $(tf_s2_const), t0, x1, x1;   \
         vgf2p8affineinvqb $(tf_s2_const), t0, x5, x5;   \
         vgf2p8affineqb $(tf_inv_const), t1, x2, x2;     \
         vgf2p8affineqb $(tf_inv_const), t1, x6, x6;     \
         vgf2p8affineinvqb $0, t2, x2, x2;               \
         vgf2p8affineinvqb $0, t2, x6, x6;               \
         vgf2p8affineinvqb $(tf_aff_const), t3, x0, x0;  \
         vgf2p8affineinvqb $(tf_aff_const), t3, x4, x4;  \
         vgf2p8affineqb $(tf_x2_const), t4, x3, x3;      \
         vgf2p8affineqb $(tf_x2_const), t4, x7, x7;      \
         vgf2p8affineinvqb $0, t2, x3, x3;               \
         vgf2p8affineinvqb $0, t2, x7, x7;

#define BV8(a0,a1,a2,a3,a4,a5,a6,a7) \
         ( (((a0) & 1) << 0) | \
           (((a1) & 1) << 1) | \
           (((a2) & 1) << 2) | \
           (((a3) & 1) << 3) | \
           (((a4) & 1) << 4) | \
           (((a5) & 1) << 5) | \
           (((a6) & 1) << 6) | \
           (((a7) & 1) << 7) )

#define BM8X8(l0,l1,l2,l3,l4,l5,l6,l7) \
         ( ((l7) << (0 * 8)) | \
           ((l6) << (1 * 8)) | \
           ((l5) << (2 * 8)) | \
           ((l4) << (3 * 8)) | \
           ((l3) << (4 * 8)) | \
           ((l2) << (5 * 8)) | \
           ((l1) << (6 * 8)) | \
           ((l0) << (7 * 8)) )

/* AES affine: */
#define tf_aff_const BV8(1, 1, 0, 0, 0, 1, 1, 0)
.Ltf_aff_bitmatrix:
         .quad BM8X8(BV8(1, 0, 0, 0, 1, 1, 1, 1),
                     BV8(1, 1, 0, 0, 0, 1, 1, 1),
                     BV8(1, 1, 1, 0, 0, 0, 1, 1),
                     BV8(1, 1, 1, 1, 0, 0, 0, 1),
                     BV8(1, 1, 1, 1, 1, 0, 0, 0),
                     BV8(0, 1, 1, 1, 1, 1, 0, 0),
                     BV8(0, 0, 1, 1, 1, 1, 1, 0),
                     BV8(0, 0, 0, 1, 1, 1, 1, 1))

/* AES inverse affine: */
#define tf_inv_const BV8(1, 0, 1, 0, 0, 0, 0, 0)
.Ltf_inv_bitmatrix:
         .quad BM8X8(BV8(0, 0, 1, 0, 0, 1, 0, 1),
                     BV8(1, 0, 0, 1, 0, 0, 1, 0),
                     BV8(0, 1, 0, 0, 1, 0, 0, 1),
                     BV8(1, 0, 1, 0, 0, 1, 0, 0),
                     BV8(0, 1, 0, 1, 0, 0, 1, 0),
                     BV8(0, 0, 1, 0, 1, 0, 0, 1),
                     BV8(1, 0, 0, 1, 0, 1, 0, 0),
                     BV8(0, 1, 0, 0, 1, 0, 1, 0))

/* S2: */
#define tf_s2_const BV8(0, 1, 0, 0, 0, 1, 1, 1)
.Ltf_s2_bitmatrix:
         .quad BM8X8(BV8(0, 1, 0, 1, 0, 1, 1, 1),
                     BV8(0, 0, 1, 1, 1, 1, 1, 1),
                     BV8(1, 1, 1, 0, 1, 1, 0, 1),
                     BV8(1, 1, 0, 0, 0, 0, 1, 1),
                     BV8(0, 1, 0, 0, 0, 0, 1, 1),
                     BV8(1, 1, 0, 0, 1, 1, 1, 0),
                     BV8(0, 1, 1, 0, 0, 0, 1, 1),
                     BV8(1, 1, 1, 1, 0, 1, 1, 0))

/* X2: */
#define tf_x2_const BV8(0, 0, 1, 1, 0, 1, 0, 0)
.Ltf_x2_bitmatrix:
         .quad BM8X8(BV8(0, 0, 0, 1, 1, 0, 0, 0),
                     BV8(0, 0, 1, 0, 0, 1, 1, 0),
                     BV8(0, 0, 0, 0, 1, 0, 1, 0),
                     BV8(1, 1, 1, 0, 0, 0, 1, 1),
                     BV8(1, 1, 1, 0, 1, 1, 0, 0),
                     BV8(0, 1, 1, 0, 1, 0, 1, 1),
                     BV8(1, 0, 1, 1, 1, 1, 0, 1),
                     BV8(1, 0, 0, 1, 0, 0, 1, 1))

/* Identity matrix: */
.Ltf_id_bitmatrix:
         .quad BM8X8(BV8(1, 0, 0, 0, 0, 0, 0, 0),
                     BV8(0, 1, 0, 0, 0, 0, 0, 0),
                     BV8(0, 0, 1, 0, 0, 0, 0, 0),
                     BV8(0, 0, 0, 1, 0, 0, 0, 0),
                     BV8(0, 0, 0, 0, 1, 0, 0, 0),
                     BV8(0, 0, 0, 0, 0, 1, 0, 0),
                     BV8(0, 0, 0, 0, 0, 0, 1, 0),
                     BV8(0, 0, 0, 0, 0, 0, 0, 1))
/////////////////////////////////////////////////////////

GFNI also allows easy use of 256-bit vector registers so
there is way to get additional 2x speed increase (but
requires doubling number of parallel processed blocks).

-Jussi

[1] https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=blob;f=cipher/camellia-aesni-avx2-amd64.h#l80
