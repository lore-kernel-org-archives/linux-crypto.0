Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B94C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Dec 2022 16:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiLVQmS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Dec 2022 11:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiLVQmO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2022 11:42:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA17D27DEE
        for <linux-crypto@vger.kernel.org>; Thu, 22 Dec 2022 08:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671727292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hMRqi31Tqol4IzcTAzBEdalwd4Hn1qAFrUhcqZ6OmAI=;
        b=FM43rFyMqmnOhK0f9bgyiydjDZwwrtT17PhRnYQFzwwiNK0SrUb8EL5hbD6Lt4oC71lewq
        bItdWP23a15Ij8/kCBKV/G0ZiwqPMoA7jSKBdO5F6+e9BGkdYYPDgxw2Vim38yNwFACRD7
        KVi4LfRgXhyBcRBrw+XwU3a2ZUOdRv8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-197--kG9X0jtP3ejVE7htviNCw-1; Thu, 22 Dec 2022 11:41:30 -0500
X-MC-Unique: -kG9X0jtP3ejVE7htviNCw-1
Received: by mail-qv1-f72.google.com with SMTP id u15-20020a0cec8f000000b004c704e015f7so1191521qvo.1
        for <linux-crypto@vger.kernel.org>; Thu, 22 Dec 2022 08:41:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hMRqi31Tqol4IzcTAzBEdalwd4Hn1qAFrUhcqZ6OmAI=;
        b=ml9Mwhu0W7dQd/ityIIpLyv10nDjL2/3zysTUsjnUodghI4E6rRXZAGdhzez91kpdo
         kEA8ora8m+X6Ckt5skG908rIklesr7Pho4AeE9n57Py9OWnROJ3fhp8/zjxNkqMf8FmV
         CiGbzm2bEhnDQm5Yw6UhqPCIE02pZgjsj33G1ixpnzDrv8OYlt3LtVH4bZ90DOUmQde4
         kNrXsYtxGJLasq/LwkNhFZyJrkghNLvg3CMphkP+WEDdXFp7Y2pwr19BGUUZ3RFX9lKM
         dhDZSsI0+RF0pgob0312xOEvga/oE1NiKD70zbfzmUuWczRXApuKnnG7rP5S1mAtsRto
         SY+w==
X-Gm-Message-State: AFqh2kqDiOfHqjgNKq2yyAJBD939o8NILnxpMCNPClRwZIgJdykJw3aQ
        vMkhwy/LGlrOv1wxj6Tb6cM1HknAxbGEnvCAfh3YiktymMQIOKUFqIWP4GSNQQA7S7zqBqu89xO
        b0kep/eqiWltM6ov4fiOlyU+7EoTWjpnk8d7aWDXA
X-Received: by 2002:a05:622a:5a85:b0:3ab:6bd6:d3bb with SMTP id fz5-20020a05622a5a8500b003ab6bd6d3bbmr32428qtb.6.1671727290156;
        Thu, 22 Dec 2022 08:41:30 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtU2c1hlxcX3Ck+PUFWKZ3UCy5nPMxNKtznQaBCbs9iknGz+DTooceAgmQTuj3jd6OqthXsh+GlwW9480/ta3M=
X-Received: by 2002:a05:622a:5a85:b0:3ab:6bd6:d3bb with SMTP id
 fz5-20020a05622a5a8500b003ab6bd6d3bbmr32425qtb.6.1671727289960; Thu, 22 Dec
 2022 08:41:29 -0800 (PST)
MIME-Version: 1.0
References: <20221221224111.19254-1-vdronov@redhat.com> <20221221224111.19254-3-vdronov@redhat.com>
 <Y6OXuT95MlkNanSR@sol.localdomain>
In-Reply-To: <Y6OXuT95MlkNanSR@sol.localdomain>
From:   Vladis Dronov <vdronov@redhat.com>
Date:   Thu, 22 Dec 2022 17:41:18 +0100
Message-ID: <CAMusb+QuNN9bgWSFZnd_VVVie7uBdBOsn=Z+_k5RLv5F1QtPqQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] crypto: xts - drop xts_check_key()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net, nstange@suse.de,
        elliott@hpe.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, smueller@chronox.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Thu, Dec 22, 2022 at 12:33 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Dec 21, 2022 at 11:41:07PM +0100, Vladis Dronov wrote:
> ...skip...
> > -     /* ensure that the AES and tweak key are not identical */
> > +     /* ensure that the AES and tweak key are not identical
> > +      * when in FIPS mode or the FORBID_WEAK_KEYS flag is set.
> > +      */
> >       if ((fips_enabled || (crypto_skcipher_get_flags(tfm) &
> >                             CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) &&
> >           !crypto_memneq(key, key + (keylen / 2), keylen / 2))
>
> Please use the kernel style for block comments:
>
>         /*
>          * Ensure that the AES and tweak key are not identical when in FIPS mode
>          * or the FORBID_WEAK_KEYS flag is set.
>          */

Thanks Eric, I will wait a bit for more review notes and I will resend
the patchset.

Best regards,
Vladis

