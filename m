Return-Path: <SRS0=65YJ=CK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016A2C43461
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 16:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA9BA204EC
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 16:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598976519;
	bh=fWrHbDpixoGiNMokx+c0s+a95RJOrS/HMZuR8hI9j2w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=NtE9L6VEuwoD1kRcwBAYKho3qaznaDmLn5KDhvjfEUjwfkr7qBzo7VFDG/aBz2Tiz
	 VpxiwSq7N1qKP2vlZncPHUjdwr2/GoU7D+eZdyD57fCWt7d5+iSe1rCWCG8YLGZPIr
	 r6bDGZFuhKoJV/IwjI3s6+dpw15CATKZVv9+KuV8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgIAQIY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Sep 2020 12:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbgIAPjV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Sep 2020 11:39:21 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A970021655
        for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2020 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974759;
        bh=fWrHbDpixoGiNMokx+c0s+a95RJOrS/HMZuR8hI9j2w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NRLPYqIDXUUwpZrCWAsXMmEbly0QsHbyQvZ09WT4ybYcPad0h8B0IV2TZ7SpqQJFq
         d7f/r+sQPfUoBtZuFBJaszPOTNXEhqabjvLdIAn+bd0Di9xo4QpUmoesgwWDSZ1aFb
         SQt7af0EhIZ9+t9WpbTHtT2NmN4snwpIpURC1z/4=
Received: by mail-ot1-f43.google.com with SMTP id g10so1529405otq.9
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2020 08:39:19 -0700 (PDT)
X-Gm-Message-State: AOAM530mNFScjpTBpiMVObtOZl+1NqQawSfQ2cGxFyOt1wVPebPMQuZu
        YmAEZRvnVvgOBUYHuxtJLsmG7Z+EARjAX7SR560=
X-Google-Smtp-Source: ABdhPJzvVIzcNjNyo19bMtPEHoSEd2H6JyiWh1RvJArw7LBGoSxXr9xdvnrTATxIu411Hk7tycjjG5/sKtrF/9z2UpM=
X-Received: by 2002:a9d:5189:: with SMTP id y9mr1957607otg.77.1598974758695;
 Tue, 01 Sep 2020 08:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200827173058.94519-1-ubizjak@gmail.com>
In-Reply-To: <20200827173058.94519-1-ubizjak@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 1 Sep 2020 18:39:06 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHChRSxAgMNPpHoT-Z2CFoVQOgtmpK6tCboe1G06xuF_w@mail.gmail.com>
Message-ID: <CAMj1kXHChRSxAgMNPpHoT-Z2CFoVQOgtmpK6tCboe1G06xuF_w@mail.gmail.com>
Subject: Re: [PATCH] crypto/x86: Use XORL r32,32 in curve25519-x86_64.c
To:     Uros Bizjak <ubizjak@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+ Jason)

On Thu, 27 Aug 2020 at 20:31, Uros Bizjak <ubizjak@gmail.com> wrote:
>
> x86_64 zero extends 32bit operations, so for 64bit operands,
> XORL r32,r32 is functionally equal to XORL r64,r64, but avoids
> a REX prefix byte when legacy registers are used.
>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>  arch/x86/crypto/curve25519-x86_64.c | 68 ++++++++++++++---------------
>  1 file changed, 34 insertions(+), 34 deletions(-)
>
> diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
> index 8acbb6584a37..a9edb6f8a0ba 100644
> --- a/arch/x86/crypto/curve25519-x86_64.c
> +++ b/arch/x86/crypto/curve25519-x86_64.c
> @@ -45,11 +45,11 @@ static inline u64 add_scalar(u64 *out, const u64 *f1, u64 f2)
>
>         asm volatile(
>                 /* Clear registers to propagate the carry bit */
> -               "  xor %%r8, %%r8;"
> -               "  xor %%r9, %%r9;"
> -               "  xor %%r10, %%r10;"
> -               "  xor %%r11, %%r11;"
> -               "  xor %1, %1;"
> +               "  xor %%r8d, %%r8d;"
> +               "  xor %%r9d, %%r9d;"
> +               "  xor %%r10d, %%r10d;"
> +               "  xor %%r11d, %%r11d;"
> +               "  xor %k1, %k1;"
>
>                 /* Begin addition chain */
>                 "  addq 0(%3), %0;"
> @@ -93,7 +93,7 @@ static inline void fadd(u64 *out, const u64 *f1, const u64 *f2)
>                 "  cmovc %0, %%rax;"
>
>                 /* Step 2: Add carry*38 to the original sum */
> -               "  xor %%rcx, %%rcx;"
> +               "  xor %%ecx, %%ecx;"
>                 "  add %%rax, %%r8;"
>                 "  adcx %%rcx, %%r9;"
>                 "  movq %%r9, 8(%1);"
> @@ -165,28 +165,28 @@ static inline void fmul(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
>
>                 /* Compute src1[0] * src2 */
>                 "  movq 0(%1), %%rdx;"
> -               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"     "  movq %%r8, 0(%0);"
> +               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  movq %%r8, 0(%0);"
>                 "  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  movq %%r10, 8(%0);"
>                 "  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"
>                 "  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  mov $0, %%rax;"
>                                                    "  adox %%rdx, %%rax;"
>                 /* Compute src1[1] * src2 */
>                 "  movq 8(%1), %%rdx;"
> -               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"     "  adcxq 8(%0), %%r8;"    "  movq %%r8, 8(%0);"
> +               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 8(%0), %%r8;"    "  movq %%r8, 8(%0);"
>                 "  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 16(%0);"
>                 "  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
>                 "  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
>                                                    "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
>                 /* Compute src1[2] * src2 */
>                 "  movq 16(%1), %%rdx;"
> -               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"    "  adcxq 16(%0), %%r8;"    "  movq %%r8, 16(%0);"
> +               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 16(%0), %%r8;"   "  movq %%r8, 16(%0);"
>                 "  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 24(%0);"
>                 "  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
>                 "  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
>                                                    "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
>                 /* Compute src1[3] * src2 */
>                 "  movq 24(%1), %%rdx;"
> -               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"    "  adcxq 24(%0), %%r8;"    "  movq %%r8, 24(%0);"
> +               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 24(%0), %%r8;"   "  movq %%r8, 24(%0);"
>                 "  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 32(%0);"
>                 "  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  movq %%rbx, 40(%0);"    "  mov $0, %%r8;"
>                 "  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  movq %%r14, 48(%0);"    "  mov $0, %%rax;"
> @@ -200,7 +200,7 @@ static inline void fmul(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
>                 /* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
>                 "  mov $38, %%rdx;"
>                 "  mulxq 32(%1), %%r8, %%r13;"
> -               "  xor %3, %3;"
> +               "  xor %k3, %k3;"
>                 "  adoxq 0(%1), %%r8;"
>                 "  mulxq 40(%1), %%r9, %%rbx;"
>                 "  adcx %%r13, %%r9;"
> @@ -246,28 +246,28 @@ static inline void fmul2(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
>
>                 /* Compute src1[0] * src2 */
>                 "  movq 0(%1), %%rdx;"
> -               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"     "  movq %%r8, 0(%0);"
> +               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  movq %%r8, 0(%0);"
>                 "  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  movq %%r10, 8(%0);"
>                 "  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"
>                 "  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  mov $0, %%rax;"
>                                                    "  adox %%rdx, %%rax;"
>                 /* Compute src1[1] * src2 */
>                 "  movq 8(%1), %%rdx;"
> -               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"     "  adcxq 8(%0), %%r8;"    "  movq %%r8, 8(%0);"
> +               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 8(%0), %%r8;"    "  movq %%r8, 8(%0);"
>                 "  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 16(%0);"
>                 "  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
>                 "  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
>                                                    "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
>                 /* Compute src1[2] * src2 */
>                 "  movq 16(%1), %%rdx;"
> -               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"    "  adcxq 16(%0), %%r8;"    "  movq %%r8, 16(%0);"
> +               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 16(%0), %%r8;"   "  movq %%r8, 16(%0);"
>                 "  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 24(%0);"
>                 "  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
>                 "  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
>                                                    "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
>                 /* Compute src1[3] * src2 */
>                 "  movq 24(%1), %%rdx;"
> -               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"    "  adcxq 24(%0), %%r8;"    "  movq %%r8, 24(%0);"
> +               "  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 24(%0), %%r8;"   "  movq %%r8, 24(%0);"
>                 "  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 32(%0);"
>                 "  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  movq %%rbx, 40(%0);"    "  mov $0, %%r8;"
>                 "  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  movq %%r14, 48(%0);"    "  mov $0, %%rax;"
> @@ -277,29 +277,29 @@ static inline void fmul2(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
>
>                 /* Compute src1[0] * src2 */
>                 "  movq 32(%1), %%rdx;"
> -               "  mulxq 32(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"     "  movq %%r8, 64(%0);"
> -               "  mulxq 40(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  movq %%r10, 72(%0);"
> +               "  mulxq 32(%3), %%r8, %%r9;"      "  xor %%r10d, %%r10d;"   "  movq %%r8, 64(%0);"
> +               "  mulxq 40(%3), %%r10, %%r11;"    "  adox %%r9, %%r10;"     "  movq %%r10, 72(%0);"
>                 "  mulxq 48(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"
>                 "  mulxq 56(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  mov $0, %%rax;"
>                                                    "  adox %%rdx, %%rax;"
>                 /* Compute src1[1] * src2 */
>                 "  movq 40(%1), %%rdx;"
> -               "  mulxq 32(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"     "  adcxq 72(%0), %%r8;"    "  movq %%r8, 72(%0);"
> -               "  mulxq 40(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 80(%0);"
> +               "  mulxq 32(%3), %%r8, %%r9;"      "  xor %%r10d, %%r10d;"   "  adcxq 72(%0), %%r8;"   "  movq %%r8, 72(%0);"
> +               "  mulxq 40(%3), %%r10, %%r11;"    "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 80(%0);"
>                 "  mulxq 48(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
>                 "  mulxq 56(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
>                                                    "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
>                 /* Compute src1[2] * src2 */
>                 "  movq 48(%1), %%rdx;"
> -               "  mulxq 32(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"    "  adcxq 80(%0), %%r8;"    "  movq %%r8, 80(%0);"
> -               "  mulxq 40(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 88(%0);"
> +               "  mulxq 32(%3), %%r8, %%r9;"      "  xor %%r10d, %%r10d;"   "  adcxq 80(%0), %%r8;"   "  movq %%r8, 80(%0);"
> +               "  mulxq 40(%3), %%r10, %%r11;"    "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 88(%0);"
>                 "  mulxq 48(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
>                 "  mulxq 56(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
>                                                    "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
>                 /* Compute src1[3] * src2 */
>                 "  movq 56(%1), %%rdx;"
> -               "  mulxq 32(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"    "  adcxq 88(%0), %%r8;"    "  movq %%r8, 88(%0);"
> -               "  mulxq 40(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 96(%0);"
> +               "  mulxq 32(%3), %%r8, %%r9;"      "  xor %%r10d, %%r10d;"   "  adcxq 88(%0), %%r8;"   "  movq %%r8, 88(%0);"
> +               "  mulxq 40(%3), %%r10, %%r11;"    "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 96(%0);"
>                 "  mulxq 48(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  movq %%rbx, 104(%0);"    "  mov $0, %%r8;"
>                 "  mulxq 56(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  movq %%r14, 112(%0);"    "  mov $0, %%rax;"
>                                                    "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"     "  movq %%rax, 120(%0);"
> @@ -312,7 +312,7 @@ static inline void fmul2(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
>                 /* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
>                 "  mov $38, %%rdx;"
>                 "  mulxq 32(%1), %%r8, %%r13;"
> -               "  xor %3, %3;"
> +               "  xor %k3, %k3;"
>                 "  adoxq 0(%1), %%r8;"
>                 "  mulxq 40(%1), %%r9, %%rbx;"
>                 "  adcx %%r13, %%r9;"
> @@ -345,7 +345,7 @@ static inline void fmul2(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
>                 /* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
>                 "  mov $38, %%rdx;"
>                 "  mulxq 96(%1), %%r8, %%r13;"
> -               "  xor %3, %3;"
> +               "  xor %k3, %k3;"
>                 "  adoxq 64(%1), %%r8;"
>                 "  mulxq 104(%1), %%r9, %%rbx;"
>                 "  adcx %%r13, %%r9;"
> @@ -516,7 +516,7 @@ static inline void fsqr(u64 *out, const u64 *f, u64 *tmp)
>
>                 /* Step 1: Compute all partial products */
>                 "  movq 0(%1), %%rdx;"                                       /* f[0] */
> -               "  mulxq 8(%1), %%r8, %%r14;"      "  xor %%r15, %%r15;"     /* f[1]*f[0] */
> +               "  mulxq 8(%1), %%r8, %%r14;"      "  xor %%r15d, %%r15d;"   /* f[1]*f[0] */
>                 "  mulxq 16(%1), %%r9, %%r10;"     "  adcx %%r14, %%r9;"     /* f[2]*f[0] */
>                 "  mulxq 24(%1), %%rax, %%rcx;"    "  adcx %%rax, %%r10;"    /* f[3]*f[0] */
>                 "  movq 24(%1), %%rdx;"                                      /* f[3] */
> @@ -526,7 +526,7 @@ static inline void fsqr(u64 *out, const u64 *f, u64 *tmp)
>                 "  mulxq 16(%1), %%rax, %%rcx;"    "  mov $0, %%r14;"        /* f[2]*f[1] */
>
>                 /* Step 2: Compute two parallel carry chains */
> -               "  xor %%r15, %%r15;"
> +               "  xor %%r15d, %%r15d;"
>                 "  adox %%rax, %%r10;"
>                 "  adcx %%r8, %%r8;"
>                 "  adox %%rcx, %%r11;"
> @@ -563,7 +563,7 @@ static inline void fsqr(u64 *out, const u64 *f, u64 *tmp)
>                 /* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
>                 "  mov $38, %%rdx;"
>                 "  mulxq 32(%1), %%r8, %%r13;"
> -               "  xor %%rcx, %%rcx;"
> +               "  xor %%ecx, %%ecx;"
>                 "  adoxq 0(%1), %%r8;"
>                 "  mulxq 40(%1), %%r9, %%rbx;"
>                 "  adcx %%r13, %%r9;"
> @@ -607,7 +607,7 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
>         asm volatile(
>                 /* Step 1: Compute all partial products */
>                 "  movq 0(%1), %%rdx;"                                       /* f[0] */
> -               "  mulxq 8(%1), %%r8, %%r14;"      "  xor %%r15, %%r15;"     /* f[1]*f[0] */
> +               "  mulxq 8(%1), %%r8, %%r14;"      "  xor %%r15d, %%r15d;"   /* f[1]*f[0] */
>                 "  mulxq 16(%1), %%r9, %%r10;"     "  adcx %%r14, %%r9;"     /* f[2]*f[0] */
>                 "  mulxq 24(%1), %%rax, %%rcx;"    "  adcx %%rax, %%r10;"    /* f[3]*f[0] */
>                 "  movq 24(%1), %%rdx;"                                      /* f[3] */
> @@ -617,7 +617,7 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
>                 "  mulxq 16(%1), %%rax, %%rcx;"    "  mov $0, %%r14;"        /* f[2]*f[1] */
>
>                 /* Step 2: Compute two parallel carry chains */
> -               "  xor %%r15, %%r15;"
> +               "  xor %%r15d, %%r15d;"
>                 "  adox %%rax, %%r10;"
>                 "  adcx %%r8, %%r8;"
>                 "  adox %%rcx, %%r11;"
> @@ -647,7 +647,7 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
>
>                 /* Step 1: Compute all partial products */
>                 "  movq 32(%1), %%rdx;"                                       /* f[0] */
> -               "  mulxq 40(%1), %%r8, %%r14;"      "  xor %%r15, %%r15;"     /* f[1]*f[0] */
> +               "  mulxq 40(%1), %%r8, %%r14;"     "  xor %%r15d, %%r15d;"   /* f[1]*f[0] */
>                 "  mulxq 48(%1), %%r9, %%r10;"     "  adcx %%r14, %%r9;"     /* f[2]*f[0] */
>                 "  mulxq 56(%1), %%rax, %%rcx;"    "  adcx %%rax, %%r10;"    /* f[3]*f[0] */
>                 "  movq 56(%1), %%rdx;"                                      /* f[3] */
> @@ -657,7 +657,7 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
>                 "  mulxq 48(%1), %%rax, %%rcx;"    "  mov $0, %%r14;"        /* f[2]*f[1] */
>
>                 /* Step 2: Compute two parallel carry chains */
> -               "  xor %%r15, %%r15;"
> +               "  xor %%r15d, %%r15d;"
>                 "  adox %%rax, %%r10;"
>                 "  adcx %%r8, %%r8;"
>                 "  adox %%rcx, %%r11;"
> @@ -692,7 +692,7 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
>                 /* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
>                 "  mov $38, %%rdx;"
>                 "  mulxq 32(%1), %%r8, %%r13;"
> -               "  xor %%rcx, %%rcx;"
> +               "  xor %%ecx, %%ecx;"
>                 "  adoxq 0(%1), %%r8;"
>                 "  mulxq 40(%1), %%r9, %%rbx;"
>                 "  adcx %%r13, %%r9;"
> @@ -725,7 +725,7 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
>                 /* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
>                 "  mov $38, %%rdx;"
>                 "  mulxq 96(%1), %%r8, %%r13;"
> -               "  xor %%rcx, %%rcx;"
> +               "  xor %%ecx, %%ecx;"
>                 "  adoxq 64(%1), %%r8;"
>                 "  mulxq 104(%1), %%r9, %%rbx;"
>                 "  adcx %%r13, %%r9;"
> --
> 2.26.2
>
