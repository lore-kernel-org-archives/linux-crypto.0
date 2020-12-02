Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC61C64E8A
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Dec 2020 08:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBBE12222C
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Dec 2020 08:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgLBIad (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Dec 2020 03:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbgLBIac (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Dec 2020 03:30:32 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E3AC0613D6
        for <linux-crypto@vger.kernel.org>; Wed,  2 Dec 2020 00:29:52 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id e81so888487ybc.1
        for <linux-crypto@vger.kernel.org>; Wed, 02 Dec 2020 00:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S+qYG3f+zkwp5W/+x0WfTqqNUJfNcCEhpNZcMzYMnsY=;
        b=1v+K7cxNdsM5r6lIlQtQF4rJhEM6uT11PQgaGVGaGCfOagZM6VPXQMwB+CZMPNbWoV
         cScaOl7YBf7RIJPnEzr5octgEyLpyydS05Ney6eWczb9b1tpJK7yrrhrC+2C3DBDw57t
         jDL2WGJW9H9XqtGmjcMfVIpTX/BEpylKN765Ght5RfXOw2wsPpQb2WLCzVrjKJxSoHqx
         dVO6kbvy24FFfaF+MfgmoNx/G0JKwVKo0q+mfDwYHNtIMdpqy6aGNI4P8Y4XlGwM3irG
         veGHBYLlFHCR0rLVgG5sg8Hx9Ph6ARVf3eE5AsM2gRv4mH37Eta8BpAGdUfqOeJqagFI
         kpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S+qYG3f+zkwp5W/+x0WfTqqNUJfNcCEhpNZcMzYMnsY=;
        b=EJPE6RZXkdyzLBxkhATM6PdsLhUpVG8cXppN2c+EThnHfXRK54xWsdA2ApGDCykjJQ
         ALREpiIaDAmOrMLt2wY9DwiLpnyIQKRx8fUQxt4mMP9ZtikADHlcUv/PIYZFV+lPwM6Q
         lcVfwlKIT600mWx0T1G/VwzDgZZo+kIuUToFyp4Qr6LO+Ai4VUVFEYd6ATirvVs6ihvl
         JuL6iI3smWdxrXzkcJXYyaFidCJ4LNI2GMX40a70y1BihXNfsDtuJltCAJvXNh1eCjcK
         B08F45GwdXuUY1Efj768Kf/O/5VYBxAb8huGpM+uWmV8oYEgD2GXcPLAnuK8KF/YrL+Z
         QoMA==
X-Gm-Message-State: AOAM533LBR+5UrAfFljoK3wwnOgGt1faHNLtBR0rFyQlrEgIG/lHm2QO
        ETn+TEpndOn4TipT2Efd/8yYVLp4jUiLsxjtm629yg==
X-Google-Smtp-Source: ABdhPJwV3FBwA2qFAdWGwaboQeEdSyY6bd0OBIdiWDaYOWd2f5VfmP8Cw4XzNOSvkR+6seDUsZ9PNk8W4ihWppS45Gs=
X-Received: by 2002:a25:45:: with SMTP id 66mr2335941yba.81.1606897791936;
 Wed, 02 Dec 2020 00:29:51 -0800 (PST)
MIME-Version: 1.0
References: <20201029100546.28686-1-gilad@benyossef.com>
In-Reply-To: <20201029100546.28686-1-gilad@benyossef.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 2 Dec 2020 10:29:40 +0200
Message-ID: <CAOtvUMcGMTp78XnZ+zK=s3_-MtvDVrUV0PJeG9MWUOJSpAw5=g@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] crypto: switch to crypto API for EBOIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Milan Broz <gmazyland@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Thu, Oct 29, 2020 at 12:05 PM Gilad Ben-Yossef <gilad@benyossef.com> wro=
te:
>
>
> This series creates an EBOIV template that produces a skcipher
> transform which passes through all operations to the skcipher, while
> using the same skcipher and key to encrypt the input IV, which is
> assumed to be a sector offset, although this is not enforced.

I hope I didn't miss anything, but it seems I didn't get an ACK, NACK
or request of changes to the latest iteration.

Any feedback is very much welcome.

Thanks,
Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
