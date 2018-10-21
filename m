Return-Path: <SRS0=JV5w=NB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9491DECDE3D
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Oct 2018 07:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5134E2083E
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Oct 2018 07:06:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="eKp3eOxG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5134E2083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbeJUPT4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Oct 2018 11:19:56 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33179 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbeJUPT4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Oct 2018 11:19:56 -0400
Received: by mail-io1-f68.google.com with SMTP id l25-v6so25292507ioj.0
        for <linux-crypto@vger.kernel.org>; Sun, 21 Oct 2018 00:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=r4VS93VhB/UOSbbAmLyIacF91vGMy19jQUd7a0H9ZVk=;
        b=eKp3eOxGcbt2i7zQZNlZ9+avvXiUPpBxopjlKOnMy7FnCh9c1SKjkVUQTRZEQgy28s
         4cIPfJ+44xP7fEuYLchdZaJFm/KSLf8Jf4fmFPpKVc6FpUlN3N39Xu+uirV8Qz8ylfOh
         ysjth8NRLdiiHPgJ05Rs+MsqdjKedQaAiKtRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=r4VS93VhB/UOSbbAmLyIacF91vGMy19jQUd7a0H9ZVk=;
        b=Ei6UWIZSduRb1W0ELVT8uhSixjHWXGvne6nKyDWISha12rr8zZT9kL3pUFPfJdleGI
         CVdAsz4AvXNCUh2/VDxdCZvkeQvaiB9BCy/JKELw/jG5BaDMGlRInHOtWzys6bX1mnt6
         AhXGzUJGQgGDsqmII8/B3o+kOucyFiSFH1TitR0Rx76EapY2lil/ivctZjDLY0PhFIv5
         X+/2jVIfz4+brO4gb+EQZIlKeOydipRaklnwu625TzOCO1fhGstupCQE0t5JlfOVbBBj
         zTFm5mVX0P8rEpvxTEhSPXCsX5+N2H+dRh5GyvEGLowXCmgws+PlHqmtNCYAzqo7LVny
         Qgbw==
X-Gm-Message-State: AGRZ1gInXONbG4/wF+bmumnBtQYiUNVwNHBpUBm6sm2GjmAGdQlwpFYK
        Rkr+CWKhxbEhQlE6BkoHvh6R41AE4+B1n4QvenSq0w==
X-Google-Smtp-Source: AJdET5ccQUVZxuMTXl9zkx0VgoX/5/Xyg4SOb8PZdHZEj5eJz0IiLT1W1XPM2txw6s9SNGKsYeeDoT7kw9OQS3dtUxc=
X-Received: by 2002:a6b:3787:: with SMTP id e129-v6mr6559143ioa.60.1540105595370;
 Sun, 21 Oct 2018 00:06:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Sun, 21 Oct 2018 00:06:34
 -0700 (PDT)
In-Reply-To: <20181019230153.28201-2-dbaryshkov@gmail.com>
References: <20181019230153.28201-1-dbaryshkov@gmail.com> <20181019230153.28201-2-dbaryshkov@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 21 Oct 2018 09:06:34 +0200
Message-ID:
 <CAKv+Gu9LykOBz2wF1EdpAxbsukM0d7Vzt1UO=iJH=7+1AVNUaQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: testmgr: add AES-CFB tests
To:     Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181021070634.oyu-P2iobSHFLLGJiG4bWQH-_FFnNzKTMjQdXwHoVhw@z>

(+ James)

On 20 October 2018 at 01:01, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:
> Add AES128/192/256-CFB testvectors from NIST SP800-38A.
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> ---
>  crypto/tcrypt.c  |  5 ++++
>  crypto/testmgr.c |  7 +++++
>  crypto/testmgr.h | 76 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 88 insertions(+)
>
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index bdde95e8d369..a6315827d240 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -1733,6 +1733,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>                 ret += tcrypt_test("xts(aes)");
>                 ret += tcrypt_test("ctr(aes)");
>                 ret += tcrypt_test("rfc3686(ctr(aes))");
> +               ret += tcrypt_test("cfb(aes)");
>                 break;
>
>         case 11:
> @@ -2059,6 +2060,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>                                 speed_template_16_24_32);
>                 test_cipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
>                                 speed_template_16_24_32);
> +               test_cipher_speed("cfb(aes)", ENCRYPT, sec, NULL, 0,
> +                               speed_template_16_24_32);
> +               test_cipher_speed("cfb(aes)", DECRYPT, sec, NULL, 0,
> +                               speed_template_16_24_32);
>                 break;
>
>         case 201:
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index a1d42245082a..016d61c419fc 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -2684,6 +2684,13 @@ static const struct alg_test_desc alg_test_descs[] = {
>                                 .dec = __VECS(aes_ccm_dec_tv_template)
>                         }
>                 }
> +       }, {
> +               .alg = "cfb(aes)",
> +               .test = alg_test_skcipher,
> +               .fips_allowed = 1,
> +               .suite = {
> +                       .cipher = __VECS(aes_cfb_tv_template)
> +               },
>         }, {
>                 .alg = "chacha20",
>                 .test = alg_test_skcipher,
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 173111c70746..19b6d184c8fb 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -12081,6 +12081,82 @@ static const struct cipher_testvec aes_cbc_tv_template[] = {
>         },
>  };
>
> +static const struct cipher_testvec aes_cfb_tv_template[] = {
> +       { /* From NIST SP800-38A */
> +               .key    = "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
> +                         "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
> +               .klen   = 16,
> +               .iv     = "\x00\x01\x02\x03\x04\x05\x06\x07"
> +                         "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
> +               .ptext  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
> +                         "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
> +                         "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
> +                         "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
> +                         "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
> +                         "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
> +                         "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
> +                         "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
> +               .ctext  = "\x3b\x3f\xd9\x2e\xb7\x2d\xad\x20"
> +                         "\x33\x34\x49\xf8\xe8\x3c\xfb\x4a"
> +                         "\xc8\xa6\x45\x37\xa0\xb3\xa9\x3f"
> +                         "\xcd\xe3\xcd\xad\x9f\x1c\xe5\x8b"
> +                         "\x26\x75\x1f\x67\xa3\xcb\xb1\x40"
> +                         "\xb1\x80\x8c\xf1\x87\xa4\xf4\xdf"
> +                         "\xc0\x4b\x05\x35\x7c\x5d\x1c\x0e"
> +                         "\xea\xc4\xc6\x6f\x9f\xf7\xf2\xe6",
> +               .len    = 64,
> +       }, {
> +               .key    = "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
> +                         "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
> +                         "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
> +               .klen   = 24,
> +               .iv     = "\x00\x01\x02\x03\x04\x05\x06\x07"
> +                         "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
> +               .ptext  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
> +                         "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
> +                         "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
> +                         "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
> +                         "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
> +                         "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
> +                         "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
> +                         "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
> +               .ctext  = "\xcd\xc8\x0d\x6f\xdd\xf1\x8c\xab"
> +                         "\x34\xc2\x59\x09\xc9\x9a\x41\x74"
> +                         "\x67\xce\x7f\x7f\x81\x17\x36\x21"
> +                         "\x96\x1a\x2b\x70\x17\x1d\x3d\x7a"
> +                         "\x2e\x1e\x8a\x1d\xd5\x9b\x88\xb1"
> +                         "\xc8\xe6\x0f\xed\x1e\xfa\xc4\xc9"
> +                         "\xc0\x5f\x9f\x9c\xa9\x83\x4f\xa0"
> +                         "\x42\xae\x8f\xba\x58\x4b\x09\xff",
> +               .len    = 64,
> +       }, {
> +               .key    = "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
> +                         "\x2b\x73\xae\xf0\x85\x7d\x77\x81"
> +                         "\x1f\x35\x2c\x07\x3b\x61\x08\xd7"
> +                         "\x2d\x98\x10\xa3\x09\x14\xdf\xf4",
> +               .klen   = 32,
> +               .iv     = "\x00\x01\x02\x03\x04\x05\x06\x07"
> +                         "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
> +               .ptext  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
> +                         "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
> +                         "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
> +                         "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
> +                         "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
> +                         "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
> +                         "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
> +                         "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
> +               .ctext  = "\xdc\x7e\x84\xbf\xda\x79\x16\x4b"
> +                         "\x7e\xcd\x84\x86\x98\x5d\x38\x60"
> +                         "\x39\xff\xed\x14\x3b\x28\xb1\xc8"
> +                         "\x32\x11\x3c\x63\x31\xe5\x40\x7b"
> +                         "\xdf\x10\x13\x24\x15\xe5\x4b\x92"
> +                         "\xa1\x3e\xd0\xa8\x26\x7a\xe2\xf9"
> +                         "\x75\xa3\x85\x74\x1a\xb9\xce\xf8"
> +                         "\x20\x31\x62\x3d\x55\xb1\xe4\x71",
> +               .len    = 64,
> +       },
> +};
> +
>  static const struct aead_testvec hmac_md5_ecb_cipher_null_enc_tv_template[] = {
>         { /* Input data from RFC 2410 Case 1 */
>  #ifdef __LITTLE_ENDIAN
> --
> 2.19.1
>
