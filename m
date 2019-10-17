Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CF3ECE58E
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 13:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E67B2089C
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 13:45:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="1OfbHiT7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388251AbfJQNpT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 09:45:19 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:37953 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbfJQNpT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 09:45:19 -0400
Received: by mail-vk1-f193.google.com with SMTP id s72so524463vkh.5
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 06:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E9JRpqDRkPMUC3+aonRkZFzyK81vqG5e+9EBDc49zoo=;
        b=1OfbHiT7rFbrOfxLC/nWPhMZV0WyIHl8sY0pwDov5iRPW9VQJKmo7d1gO+/XuXO93F
         sfkXTIt+TjUMghTZva2+Mb1fiaHFidiHAIb9x0dykURPXGqSXRFBjBbPGwG6Yizd9W4d
         WdDZ/IsOuQcDe0Wh9hxujW0j1BR49lXSA/qhQljzdtX6lN2ST7iD5wIiL/0/HHRJB0On
         6v2dC+uqsVdY6n698CPnfP05Jlpyk7Jaz1hUKWQUKGie0bbFckvTaAyrQp5moLVFJzTK
         NxAD7N57GhCjUe/98PZWQNej4VA8DcfHWSzctlAIgr934vL+mWDd+2odA9OPK41RkfgL
         nxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E9JRpqDRkPMUC3+aonRkZFzyK81vqG5e+9EBDc49zoo=;
        b=o+frJ3E3/kJSpi1aSxvE05aTnbcsl7nwlvi47QQfxx1bLjxDrskwUtSRx1HmaHysyG
         hjbUaV/Kin2FZGaJ9BvFa+aWQfyvDNKfX3SFpAbLNAhqobdVx3iGMF4uFymwnN6iTkRZ
         BsUMoN6jiA67RZhvt4tEOVmIn8vj3NPciBe4cGSMQW2P4SFnlxfAo6pxYxws1DOIgLIr
         /hJnV4Q+4s+8ktLzwgJRb2GPqiaX5UY+6edbWiibOgkjUr6E6K1vLQKjqdy3szjuSuOr
         miH9ocS3tYQ9MbM+py7qfGNCdYOoVfsqdCCG+JpVC3I/P04JvEZIi9Yv9LVlp2UWOIPv
         eMIg==
X-Gm-Message-State: APjAAAWR+Pz/wfpOsb2iUTEzPuofNvytX8VLRH/U0MWrFblfJlOa/WW9
        3XmzlLk14Cgccw8EC1J57Gbi5IuASLjXNuZhSRV3Iw==
X-Google-Smtp-Source: APXvYqya0eEZHB/do9ZUv3epLwOSxkimqKmRu/dMGl7ux5XwbxNK/SrTPyNprrsFp8UymnGJhbk5ZnOofhZ2ZVtknPY=
X-Received: by 2002:a1f:9712:: with SMTP id z18mr1984419vkd.22.1571319918076;
 Thu, 17 Oct 2019 06:45:18 -0700 (PDT)
MIME-Version: 1.0
References: <1569833361-47224-1-git-send-email-tiantao6@huawei.com>
In-Reply-To: <1569833361-47224-1-git-send-email-tiantao6@huawei.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 17 Oct 2019 16:45:06 +0300
Message-ID: <CAOtvUMeX1F5+g-jg2vUWaTQX8KHdmtAcb2-r4oVaUwfFYJbmsg@mail.gmail.com>
Subject: Re: [PATCH] crypto: fix comparison of unsigned expression warnings
To:     Tian Tao <tiantao6@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 30, 2019 at 11:52 AM Tian Tao <tiantao6@huawei.com> wrote:
>
> This patch fixes the following warnings:
> drivers/crypto/ccree/cc_aead.c:630:5-12: WARNING: Unsigned expression
> compared with zero: seq_len > 0

Thank you very much for the patch. Please accept my apologies that it
took me some time to respond.

I'm sorry, but I don't think this is the right solution here:

seq_len here can never get a negative value so the warning is a false one.

Having said that, I suspect it would be better code to:
1. change hmac_setkey() return type to unsigned int as well, as it
doesn't ever return a negative number.
2. change the predicate in the if statement the warning mentions to
seq_len !=3D 0.

That would be a clearer code and possibly will also silence the false warni=
ng

So NACK for this one but I would accept a patch doing he above if you send =
one.

Thanks again for taking the time to do this.

Gilad

>
> Signed-off-by: Tian Tao <tiantao6@huawei.com>
> ---
>  drivers/crypto/ccree/cc_aead.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aea=
d.c
> index d3e8faa..b19291d 100644
> --- a/drivers/crypto/ccree/cc_aead.c
> +++ b/drivers/crypto/ccree/cc_aead.c
> @@ -546,7 +546,7 @@ static int cc_aead_setkey(struct crypto_aead *tfm, co=
nst u8 *key,
>         struct cc_aead_ctx *ctx =3D crypto_aead_ctx(tfm);
>         struct cc_crypto_req cc_req =3D {};
>         struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
> -       unsigned int seq_len =3D 0;
> +       int seq_len =3D 0;
>         struct device *dev =3D drvdata_to_dev(ctx->drvdata);
>         const u8 *enckey, *authkey;
>         int rc;
> --
> 2.7.4
>


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
