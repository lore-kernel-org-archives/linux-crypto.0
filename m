Return-Path: <SRS0=fE7s=RX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA5CC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Mar 2019 08:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75B0E21841
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Mar 2019 08:41:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D3cCxiYi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfCTIlI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Mar 2019 04:41:08 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42524 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfCTIlH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Mar 2019 04:41:07 -0400
Received: by mail-lf1-f67.google.com with SMTP id p1so1199827lfk.9
        for <linux-crypto@vger.kernel.org>; Wed, 20 Mar 2019 01:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=avaSil1GRyz0VCmDiB3yq1bjN6KNstBnhCuDZzSeAzY=;
        b=D3cCxiYix+3mzjRCPgsu3d6dyD6/CSsKCwHvXHzfljCPhv4av1wj1eHU5qIon/cBjA
         G3xD3ZOmlhTV4H60VeDtF+t/GTJan8xZ3vTJ3b9ufP1ZDzsgZDqMfvL/h6w/cGEC7maH
         JihSXGbaAagP3HtgmEE8VHVEvG3MTKi6g1PN2TjL9AyWqhhKCmcbs6+rQYfKB6w8znBc
         G7lJcQdKvzLMZ23X883xtBZ98iM67rIzq98OFKEn9XmFkcQUVZ97bNnwf/1hjzsgCoVc
         XHgOIIVQfRyHK3nRKoOXxMWPreHojbsMmKVRf9ZtHWiHizOM3sZDCwwpKvq2V10ry6z8
         0jHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=avaSil1GRyz0VCmDiB3yq1bjN6KNstBnhCuDZzSeAzY=;
        b=VnJaml+icwXCoyEM8zCkUerypqHJJArgp7TcrAqgKBi4hCdh2U0w7vFhk4yc/pimx0
         g/HusipXe3DUkiWxHKLdAoD0dAbCjgfHaWC/gOtE2NB+8BFVpxtW8o3KZmrgfKY4+fj4
         m7nbNmUkzwOK2L9omfUWOXKyedsMJ6M2ca8nAmjLVYDxa/R7EjcFXWstxVHkrTjVzHXg
         1zS0JUjD+XHDT6oOgVZSDg0K8mV/xdp0ttSagNdJzc1YJErk0fCyVaiXNxI8WRKD93Sr
         oCWcYnChs/p1V/oznVVWDsesTumI97Ivm6mhQEmgcEf2nlW55/l4okTZWf1uol8DJRxl
         Oy6Q==
X-Gm-Message-State: APjAAAVvlcpLX0z6fRPwNCQ0DG8DmHwiipdiJA/FQNpq2ORo8Xffv1AV
        5ajwTawTspEPJ6vHKVlLlZwlx+NEqX7omaosFn8=
X-Google-Smtp-Source: APXvYqyat5nQ8HlqQH7JKCWkZ/vTgXz//OfnE7K2GSLkdO96ucUAPRXfvtcIgkR15XdMa366h/P0QJ2s32OTRlkKOI8=
X-Received: by 2002:ac2:530a:: with SMTP id c10mr13687465lfh.45.1553071265755;
 Wed, 20 Mar 2019 01:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190315020901.16509-1-dja@axtens.net>
In-Reply-To: <20190315020901.16509-1-dja@axtens.net>
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Wed, 20 Mar 2019 09:40:54 +0100
Message-ID: <CAAUqJDs8kCc5CbFpf_oV_v1HOiLYd1TYyx_KATt8e3fbrJG_Nw@mail.gmail.com>
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
To:     Daniel Axtens <dja@axtens.net>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        leitao@debian.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Daniel,

pi 15. 3. 2019 o 3:09 Daniel Axtens <dja@axtens.net> nap=C3=ADsal(a):
> The original assembly imported from OpenSSL has two copy-paste
> errors in handling CTR mode. When dealing with a 2 or 3 block tail,
> the code branches to the CBC decryption exit path, rather than to
> the CTR exit path.
>
> This leads to corruption of the IV, which leads to subsequent blocks
> being corrupted.
>
> This can be detected with libkcapi test suite, which is available at
> https://github.com/smuellerDD/libkcapi
>
> Reported-by: Ondrej Mosn=C3=A1=C4=8Dek <omosnacek@gmail.com>
> Fixes: 5c380d623ed3 ("crypto: vmx - Add support for VMS instructions by A=
SM")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Axtens <dja@axtens.net>

Thank you for looking into this and for posting the patch(es)! I
tested the patch yesterday and I can confirm that it makes the
libkcapi tests/reproducer pass.

Assuming you will want to cover the other failures from the new
testmgr tests by a separate patch:

Tested-by: Ondrej Mosnacek <omosnacek@gmail.com>

> ---
>  drivers/crypto/vmx/aesp8-ppc.pl | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-p=
pc.pl
> index d6a9f63d65ba..de78282b8f44 100644
> --- a/drivers/crypto/vmx/aesp8-ppc.pl
> +++ b/drivers/crypto/vmx/aesp8-ppc.pl
> @@ -1854,7 +1854,7 @@ Lctr32_enc8x_three:
>         stvx_u          $out1,$x10,$out
>         stvx_u          $out2,$x20,$out
>         addi            $out,$out,0x30
> -       b               Lcbc_dec8x_done
> +       b               Lctr32_enc8x_done
>
>  .align 5
>  Lctr32_enc8x_two:
> @@ -1866,7 +1866,7 @@ Lctr32_enc8x_two:
>         stvx_u          $out0,$x00,$out
>         stvx_u          $out1,$x10,$out
>         addi            $out,$out,0x20
> -       b               Lcbc_dec8x_done
> +       b               Lctr32_enc8x_done
>
>  .align 5
>  Lctr32_enc8x_one:
> --
> 2.19.1
>
