Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCC4C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Oct 2022 12:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiJFMKZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Oct 2022 08:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiJFMKY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Oct 2022 08:10:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F3F9AFF9
        for <linux-crypto@vger.kernel.org>; Thu,  6 Oct 2022 05:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01F57618DE
        for <linux-crypto@vger.kernel.org>; Thu,  6 Oct 2022 12:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A7BC433D6
        for <linux-crypto@vger.kernel.org>; Thu,  6 Oct 2022 12:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665058218;
        bh=IXhJ5XogSi9qj7u2IIqiItBdADkkyp6EP2CCBybC9M0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Q8J9cG+vo0zUfJT1IHldp/fWCv0xygnFot2PqU3gssqTf2QhCH0PkvwMpQtl0/ZFB
         hKGxDvRFLVt2P8og5aXfY1/BPnaQsvlbUBu1MKwkhev0PlFGlLbjhlVyWzpU2+hJ3y
         XxtjAsRgp5PcX84mx/mXJBP96TsJhPzq1vYa1XonfNG+FSMa08U0031LvT1RpHT74a
         CTpKVGrE1eWvlM8NmjP96be5SIMX1p33HgBStGODCJu0O43TQU4jcFIZPkTKX8dO/B
         aHyXqazjAFmk18DMvGJ3ort/6x5V4SVItOpYweVTO8PhWvMYkiDiUMTgjODmol9XOo
         8gehZHWZrpXsA==
Received: by mail-lf1-f53.google.com with SMTP id 10so2396693lfy.5
        for <linux-crypto@vger.kernel.org>; Thu, 06 Oct 2022 05:10:18 -0700 (PDT)
X-Gm-Message-State: ACrzQf3Ua5MW6IbwE+gMD9ekacWGC8TJNKIty9y8fJsn5DJVgJpCQPMD
        FhiSzvavgw9d1M6PqI58ea9WA0gnPQ3FzTQZukE=
X-Google-Smtp-Source: AMsMyM5OCPE0seMnbKT5qLc6EWTM2X4v7FM0l75Dhxo81IKOcVmDjsKeqyTIlsOVa/x15h+mgbe06ayVG2HjwlkCIWk=
X-Received: by 2002:a05:6512:1047:b0:4a2:4d33:8d68 with SMTP id
 c7-20020a056512104700b004a24d338d68mr1621271lfb.122.1665058216423; Thu, 06
 Oct 2022 05:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <c6fb9b25-a4b6-2e4a-2dd1-63adda055a49@amd.com> <CAMj1kXF2sfsXhE9dq5b77nnzHEZHkMa+b2VUCCw7gtRL6mEwEw@mail.gmail.com>
 <CAMj1kXGzKO8=F2RzFBObPYb7J-hSj-esHJ8oCC-1fsV-B028EQ@mail.gmail.com>
 <a9ea7eac-0fa4-63dd-42ad-87109c8fe0e4@amd.com> <CAMj1kXHDbnNWb23eXMie1hQaDmX3nR2261eKXbMPW-c9sWRSsg@mail.gmail.com>
 <c71529ed-5937-b50f-4804-566b03748fac@amd.com>
In-Reply-To: <c71529ed-5937-b50f-4804-566b03748fac@amd.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 6 Oct 2022 14:10:05 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHY=Fds2yAQPuXcjt9wLyoOx1=EuXUnCXNd1WC7_iC0tg@mail.gmail.com>
Message-ID: <CAMj1kXHY=Fds2yAQPuXcjt9wLyoOx1=EuXUnCXNd1WC7_iC0tg@mail.gmail.com>
Subject: Re: Early init for few crypto modules for Secure Guests
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>, ketanch@iitk.ac.in
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 6 Oct 2022 at 13:50, Nikunj A. Dadhania <nikunj@amd.com> wrote:
>
>
>
> On 04/10/22 22:47, Ard Biesheuvel wrote:
> > On Tue, 4 Oct 2022 at 11:51, Nikunj A. Dadhania <nikunj@amd.com> wrote:
> >>
> >>> AES in GCM mode seems like a
> >>> thing that we might be able to add to the crypto library API without
> >>> much hassle (which already has a minimal implementation of AES)
> >>
> >> That will be great !
> >>
> >
> > Try this branch and see if it works for you
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=libgcm
>
> Thanks Ard, I had to make few changes to the api to get it working for my usecase.

Excellent

> The ghash is store/retrieved from the AUTHTAG field of message header as per
> "Table 97. Message Header Format" in the SNP ABI document:
> https://www.amd.com/system/files/TechDocs/56860.pdf
>
> Below are the changes I had made in my tree.
>
> ---
>
> diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h
> index bab85df6df7a..838d1b4e25c3 100644
> --- a/include/crypto/gcm.h
> +++ b/include/crypto/gcm.h
> @@ -74,9 +74,11 @@ int gcm_setkey(struct gcm_ctx *ctx, const u8 *key,
>                unsigned int keysize, unsigned int authsize);
>
>  void gcm_encrypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
> -                int src_len, const u8 *assoc, int assoc_len, const u8 *iv);
> +                int src_len, const u8 *assoc, int assoc_len, const u8 *iv,
> +                u8 *authtag);
>
>  int gcm_decrypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
> -               int src_len, const u8 *assoc, int assoc_len, const u8 *iv);
> +               int src_len, const u8 *assoc, int assoc_len, const u8 *iv,
> +               u8 *authtag);

This should really be 'const u8 *authtag'. Which means that the
encrypt/decrypt path should be split somewhat differently, i.e.,
something like

void gcm_encrypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
                 int crypt_len, const u8 *assoc, int assoc_len,
                 const u8 iv[GCM_AES_IV_SIZE], u8 *authtag)
{
        gcm_crypt(ctx, dst, src, crypt_len, assoc, assoc_len, iv, authtag,
                  true);
}

int gcm_decrypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
                int crypt_len, const u8 *assoc, int assoc_len,
                const u8 iv[GCM_AES_IV_SIZE], const u8 *authtag)
{
        u8 tagbuf[AES_BLOCK_SIZE];

        gcm_crypt(ctx, dst, src, crypt_len - ctx->authsize, assoc, assoc_len,
                  iv, tagbuf, false);
        if (crypto_memneq(authtag, tagbuf, ctx->authsize)) {
                memzero_explicit(tagbuf, sizeof(tagbuf));
                return -EBADMSG;
        }
        return 0;
}

I've updated my branch with these (and some other changes). Now we
just need  to add some comment blocks to describe the API.
