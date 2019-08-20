Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229E6C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 11:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7FE920C01
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 11:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DOrFw9r0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfHTLDQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:03:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44798 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbfHTLDQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 07:03:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so11907106wrf.11
        for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2019 04:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PYetcWjVc7vdSwtXssMSvg418r+8X4MgNhcaW/l2Leo=;
        b=DOrFw9r0hM88VSDUNv4XPUF8FQuOn1Tbru5+f8U0usSQcwdLnstfltZSH0d8/CLFmW
         zsjrLaCUTr36kZ3ZqK7iCs5NCovMAMExkBSaVCCcnDZ3QhRD5ppm5x3py7r20aRfPYLQ
         zD8RCtM0hDkqSHJwbEFRadyQ4WaTLz80AjVBwFExy++q8x8CjfMjOsQ+aPd/at7qoUWL
         kfBIYyKoI+ZPDQySwrjXDAyNvt92RQqpin7+1JSxin+dPz0+H+aKxjit0PbmA5L05deo
         0XNn66WVCUU3GuTb203wcmJD2NwPmIZ/KCc5MVZZq/nOpQGwZ9m8GsFJtvEGpGD6/tth
         E7Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PYetcWjVc7vdSwtXssMSvg418r+8X4MgNhcaW/l2Leo=;
        b=FjULheTx/aTICQGtMgDePHhKDr+vlov8lYrNe9wmRboPWmIRug8MrpNnQGpU4r6Wz5
         lzQCC7oefkfwiQkHFfNQydRDue8AjRBaAm7j5JR6HIOW/2LpRV2btM8Di9Ob8qxPZh//
         XrVH/RXBwIZ7Zxa6bflyORhVcSEk50QF+6I09xlhzasPUhKrgOhRP5Qc+j0bCJUaL3FQ
         6h1EsJRGWBw+e2tc/ExuoZyMTE86w/NeBedJAfy4bdYFdvTN+GvI1/4pIRR/Imxx84UP
         XbI9/BcfH/wTjySCuVO2d+IvHYfuT8IhtVsKLAoH7uSszHzmjeu91jngBRF+ehSyxUb8
         jTrg==
X-Gm-Message-State: APjAAAViKo+f9bQTmc6GoE3q612cZA1nWw9w9YMM58gQpCzjjCpMUFWS
        +8ZOIv0z7KjZ9zzZVDmAmy3MXt519Wl7+i+QSAv52ZswWgwTxQ==
X-Google-Smtp-Source: APXvYqzvZ8hgDgAwzcvz4UxyqiwEffyiB3lMMfCJYWOzWCNzFhIU5+8kaDYYixTIzGlFuczUg/+fNNI/HFx5ihOZ5AI=
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr959362wrx.241.1566298993670;
 Tue, 20 Aug 2019 04:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 20 Aug 2019 14:03:02 +0300
Message-ID: <CAKv+Gu_ZoQ+mfchJMigoy32DtAMbzRU3fOZS4YjBMS-2ZMvebg@mail.gmail.com>
Subject: Re: [PATCH v13 0/6] crypto: switch to crypto API for ESSIV generation
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 19 Aug 2019 at 17:17, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> This series creates an ESSIV template that produces a skcipher or AEAD
> transform based on a tuple of the form '<skcipher>,<shash>' (or '<aead>,<shash>'
> for the AEAD case). It exposes the encapsulated sync or async skcipher/aead by
> passing through all operations, while using the cipher/shash pair to transform
> the input IV into an ESSIV output IV.
>
> Changes since v12:
> - don't use a per-instance shash but only record the cra_driver_name of the
>   shash when instantiating the template, and allocate the shash for each
>   allocated transform instead
> - add back the dm-crypt patch -> as Milan has indicated, his preference would
>   be to queue these changes for v5.4 (with the first patch shared between the
>   cryptodev and md trees on a stable branch based on v5.3-rc1 - if needed,
>   I can provide a signed tag)
>

Actually, since Eric has indicated that he does not want to take the
associated fscrypt change for v5.4 anyway, patch #1 could simply be
routed through the md tree instead, while the others are taken through
cryptodev.
