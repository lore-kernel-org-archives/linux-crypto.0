Return-Path: <SRS0=QZ1D=WG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6133BC32751
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Aug 2019 06:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25946217F4
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Aug 2019 06:05:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RBt+tojv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbfHJGFo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Aug 2019 02:05:44 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:36938 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfHJGFn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Aug 2019 02:05:43 -0400
Received: by mail-wm1-f46.google.com with SMTP id z23so7355060wmf.2
        for <linux-crypto@vger.kernel.org>; Fri, 09 Aug 2019 23:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Lgoei1OiaGivHZGPM1QdgwH3pKrZ+eW6K5UWSbL7nI=;
        b=RBt+tojvDGJEjPV2Ey34J393omMn9w6d1GE4FSq1vtmsisW3ryU5uDVBZ5L/mvwTmm
         9g/d97F08muCk/zm9TirCNeCKsfsgzp1QQgCI3g+LRzMRk1RgYjg5Kx9nIdc6iLtktx+
         D7f34gqILCt/Nn0GORodxDk7GPYJQKOC2XGyvDtQQem3bT0Khllq6B36i9VDhJNGoe2A
         zYiMI1+jA/9ZpnZUy9WKiYTouwd/syOlN8AQuVe0K5RH5oEJfJvcVsKuOdtaKtwiUKuA
         OIGdv/bZk9Wj07XOesBLXu+AF4jIhyhisObAiWT7bHLcZDQFrP5G8zmxv6qLO55FwvZs
         YvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Lgoei1OiaGivHZGPM1QdgwH3pKrZ+eW6K5UWSbL7nI=;
        b=Y9JWvd3MJH+h8blNP+2GoRqq4+z6WFpE6zxxqa3EDi16NGh0L+SxVLT3pFPwcKGbZw
         Ojnd4dolj8QripwOhDOre7Fw+Jh8/a4nUfWyAqWeYc0+Er9kNZvE1PJT54jGT8jfqmi8
         ZvmO5/KMWdgHfl/yv1Xjg+Pzdc3OyI4J/ZA4kZxMC6tayyE/1OHxgv5RekfnVeImQ039
         NLB1012LUkN6GE5HJmU4TOIV28Vn9aMmsHEmrH2ziVsAQ03fouTL/uwUVkOyYDD7ITst
         aKfLuBtSS8ZJHxMM7vK07l2rszsRxoABx+ysMMb7R6KxTawK3MA8Fblq02w8O6l8HZlU
         o7wA==
X-Gm-Message-State: APjAAAU2GBE8pZHyREV7w148RU79mGsNyLG5T1MCbpQib1JIGC9xpo86
        cFa1QdHS9AcEIXKAcutLmV/pPHGfIR7niw7kVCe/Hg==
X-Google-Smtp-Source: APXvYqwrQIruM5mQK9WXR7QoQ9e4W712LoJdaG06s6tYH8ZzdEBZ1e/0vBlCDWgmXB2Or5JyBvxPOCsOWtzhncbSO3g=
X-Received: by 2002:a05:600c:20c1:: with SMTP id y1mr15217982wmm.10.1565417141418;
 Fri, 09 Aug 2019 23:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <1565245094-8584-1-git-send-email-pvanleeuwen@verimatrix.com>
 <CAKv+Gu_r+iF=gWk_sMesKSyxSZB5Z5pC6jNQmi8uf+0cY7K-6g@mail.gmail.com>
 <CH2PR20MB296824F38C44E32D8C82D0B8CAD70@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAKv+Gu_uzt-cQF9ZPuM=4zot7UTogifWk3Pjr7Rcz1QWnqKaog@mail.gmail.com>
 <MN2PR20MB297393DA81B7FFE9C1B904DBCAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-vT2tf-UEyxMSE2kRsWEYy+ab6T+37pF23jy_0+M-z2Q@mail.gmail.com> <1353558c-ea2f-b94b-a570-4ca8f3a653ee@gmail.com>
In-Reply-To: <1353558c-ea2f-b94b-a570-4ca8f3a653ee@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 10 Aug 2019 09:05:30 +0300
Message-ID: <CAKv+Gu_EEZqYkXE9tj6n-KE3y4T_rAAS9-BGsdfWEg_sGCKHOQ@mail.gmail.com>
Subject: Re: [PATCHv2] crypto: xts - Add support for Cipher Text Stealing
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 8 Aug 2019 at 16:11, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 08/08/2019 12:37, Ard Biesheuvel wrote:
> >>> True. Which is another historical mistake imo, since XTS is only
> >>> specified for AES, but I digress ... :-)
> >>>
> >> Yes, I was also surprised by the use of XTS with other blockciphers.
> >> It sort of violates the don't roll your own crypto paradigm ...
> >> (although some might argue that XTS is supposed to be secure if the
> >> underlying blockcipher is, regardless of what that cipher actually is)
> >>
> >
> > That doesn't really matter. What matters is that nobody took a careful
> > look whether XTS combined with other ciphers is a good idea before
> > throwing it out into the world.
>
> Couldn't resist, but tell that to TrueCrypt authors (if you know them :)
>
> They used XTS for other AES candidates (Serpent, Twofish, also in
> chained modes together).
>
> Older versions used LRW mode, doing the same.
> Even implementing LRW over Blowfish that has 8-byte block size, so you
> need GF(2^64) operations - that is luckily not implemented in Linux kernel
> crypto API :-)
>
> VeraCrypt continued the tradition, adding the Camellia and
> Kuznyetchik (actually discussed GOST standard) to the XTS mix.
>
> But without sarcasm, I do want to support this for users,
> we can map (but not create) such images in cryptsetup, and it is partially
> reason I want dm-crypt to be fully configurable...
>

The cat is already out of the bag, so we're stuck with it in any case.
But going forward, I'd like to apply a bit more sanity to which
combinations of modes we support, which is why I was skeptical about
eboiv potentially being used by authenc(hmac(crc32),lrw(blowfish))
while it is only intended for use with cbc(aes).
