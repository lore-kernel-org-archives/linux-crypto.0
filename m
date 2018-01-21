From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [RFT PATCH] crypto: arm64 - implement SM3 secure hash using
 special instructions
Date: Sun, 21 Jan 2018 15:09:41 +0200
Message-ID: <CAOtvUMeVWzTQh1BM0eoFQLB3aHA2TH078C-zCMHsDRQzf6DRoQ@mail.gmail.com>
References: <20180116082922.19465-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, steve.capper@arm.com,
        catalin.marinas@arm.com, will.deacon@arm.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:43887 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbeAUNJm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jan 2018 08:09:42 -0500
Received: by mail-ot0-f172.google.com with SMTP id p36so5251491otd.10
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jan 2018 05:09:42 -0800 (PST)
In-Reply-To: <20180116082922.19465-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 16, 2018 at 10:29 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> Implement the Chinese SM3 secure hash algorithm using the new
> special instructions that have been introduced as an optional
> extension in ARMv8.2.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---

Looks good to me.

Reviewed-by: Gilad Ben-Yossef <gilad@benyossef.com>


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
