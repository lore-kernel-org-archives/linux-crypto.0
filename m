Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80AC3C32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 08:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57125206A3
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 08:50:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bc7NcOiJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfGaIuZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 04:50:25 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35956 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfGaIuZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 04:50:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so68798276wrs.3
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jul 2019 01:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NwsVvn8wa45bBL0kmpXm8dE+dK3L/asxmBE1PcKU6TI=;
        b=Bc7NcOiJ5ur5yWb8Vm1EekyHADoSSZ4yQYMor9UK1cjaU5nrLpgp0SmtmLXSWoCPEN
         oiRopDXzheg2qnqg1lVm22qMA/cI2erdJbrdYbrVe17W0y9dIu+Ih2t/Ld1BE+guR+Ki
         aIz8ZqRujPKICvzrT05iXLF7sRshRT+8Oc+BH25l24EKgl1B7WN8uDQuGsaoEWzbHBsI
         gFimbd+shhkf9k9zlgB6v/lUSa4eYsxuPTXBSu6uP3mcrG8UOYtWrUvbmSkr/TRMBDtq
         hAeJNzNuvqslO+6Od+YCCQSnMgShnD95JykVdPMvoRy075nos6fgDhqcH7qQxQKrmNWL
         sipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NwsVvn8wa45bBL0kmpXm8dE+dK3L/asxmBE1PcKU6TI=;
        b=ftircBaGxjapHtQ8Wqw+1C3v+FMopautfsrtKDKr1jxqt8gIrGEuCKKKqYZUwqLWv1
         yvV3YuLfrdQya88SdmfvNH80rRgYRc9uTqSz3PLlsEvY6PO4b7OjPeydTqdpLwuBU3lV
         HfOXdY223uuPIkUp6ScjdkzNIL9djuYAAQtAlYD9jcJec+9Gj6PzqmXomDiz8d84WT4X
         WJe6VuA3Xt8W+HHKVbte/kMogebPU3eJisTNMdyReWcCLL4FBIAAe+jAQOf1XqTuMMzY
         Rm7PtpgH49GuChDcRCsOyFAR7YjnZli9OezU9+EMlnG0WOaKh22tQK2Qsh8OR6tjDXeL
         xbdA==
X-Gm-Message-State: APjAAAXo65c4HLOYui8EmGFUY8u54hqcou3oD68X2vClX3Arp1ETPMqr
        H9XL9yBDnnXRGeKZZKvhDl0gFMya58WUSWe+BzZHfg==
X-Google-Smtp-Source: APXvYqzdMl1kziBM4CxJXiGSgYq/6b+CB7ylpvJ4dhXM4kEs2n2F5RQ+y+S2b/osFdyjAZvY3q7a+1Pd5rp4RjJGFwE=
X-Received: by 2002:a5d:46cf:: with SMTP id g15mr137884595wrs.93.1564563022820;
 Wed, 31 Jul 2019 01:50:22 -0700 (PDT)
MIME-Version: 1.0
References: <1564482824-26581-1-git-send-email-iuliana.prodan@nxp.com>
 <1564482824-26581-3-git-send-email-iuliana.prodan@nxp.com>
 <CAKv+Gu_VEEZFPpJfv2JbB02vhmc_1_wpxNDBHf__pv-t7BvN0A@mail.gmail.com> <VI1PR04MB4445AABC9062673BD4FA3CEF8CDF0@VI1PR04MB4445.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB4445AABC9062673BD4FA3CEF8CDF0@VI1PR04MB4445.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 31 Jul 2019 11:50:11 +0300
Message-ID: <CAKv+Gu8KcL_Q_C+euZ9DOT7VEX68CJZJLrT8hxeCiiiEkxQ=jQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: aes - helper function to validate key
 length for AES algorithms
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 31 Jul 2019 at 11:35, Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>
> On 7/31/2019 8:33 AM, Ard Biesheuvel wrote:
> > On Tue, 30 Jul 2019 at 13:33, Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
> >>
> >> Add inline helper function to check key length for AES algorithms.
> >> The key can be 128, 192 or 256 bits size.
> >> This function is used in the generic aes implementation.
> >>
> >> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> >> ---
> >>   include/crypto/aes.h | 17 +++++++++++++++++
> >>   lib/crypto/aes.c     |  8 ++++----
> >>   2 files changed, 21 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/include/crypto/aes.h b/include/crypto/aes.h
> >> index 8e0f4cf..8ee07a8 100644
> >> --- a/include/crypto/aes.h
> >> +++ b/include/crypto/aes.h
> >> @@ -31,6 +31,23 @@ struct crypto_aes_ctx {
> >>   extern const u32 crypto_ft_tab[4][256] ____cacheline_aligned;
> >>   extern const u32 crypto_it_tab[4][256] ____cacheline_aligned;
> >>
> >> +/*
> >> + * validate key length for AES algorithms
> >> + */
> >> +static inline int crypto_aes_check_keylen(unsigned int keylen)
> >
> > Please rename this to aes_check_keylen()
> >
> I just renamed it to crypto_, the first version was check_aes_keylen
> - see https://patchwork.kernel.org/patch/11058869/.
> I think is better to keep the helper functions with crypto_, as most of
> these type of functions, in crypto, have this prefix.
>

The AES library consists of

aes_encrypt
aes_decrypt
aes_expandkey

and has no dependencies on the crypto API, which is why I omitted the
crypto_ prefix from the identifiers. Please do the same for this
function.
.


> >> +{
> >> +       switch (keylen) {
> >> +       case AES_KEYSIZE_128:
> >> +       case AES_KEYSIZE_192:
> >> +       case AES_KEYSIZE_256:
> >> +               break;
> >> +       default:
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       return 0;
> >> +}
> >> +
> >>   int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
> >>                  unsigned int key_len);
> >>
> >> diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> >> index 4e100af..3407b01 100644
> >> --- a/lib/crypto/aes.c
> >> +++ b/lib/crypto/aes.c
> >> @@ -187,11 +187,11 @@ int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
> >>   {
> >>          u32 kwords = key_len / sizeof(u32);
> >>          u32 rc, i, j;
> >> +       int err;
> >>
> >> -       if (key_len != AES_KEYSIZE_128 &&
> >> -           key_len != AES_KEYSIZE_192 &&
> >> -           key_len != AES_KEYSIZE_256)
> >> -               return -EINVAL;
> >> +       err = crypto_aes_check_keylen(key_len);
> >> +       if (err)
> >> +               return err;
> >>
> >>          ctx->key_length = key_len;
> >>
> >> --
> >> 2.1.0
> >>
> >
>
