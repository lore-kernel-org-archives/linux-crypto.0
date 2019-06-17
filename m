Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1864AC31E58
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 09:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE53620820
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 09:24:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fLsvWmEG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfFQJYp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 05:24:45 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38757 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728105AbfFQJYn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 05:24:43 -0400
Received: by mail-io1-f67.google.com with SMTP id d12so11667182iod.5
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 02:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zIqikUxxUkznt/nPhZHSPquXqmCjr0iAh/jFh9d8P3A=;
        b=fLsvWmEGUkcftWJR9NozAsTm7Mo72HiPUuzSfhlKYGihIuydPz99+gbl4pOBPFGByl
         5CIEpGGJJQNDSYPn0PzRtpPQdNDaJidhuYmvMJ/qGYxqEfY75Ezgbf7dY+eDXGIi/ZT4
         j1+zcJYVZnCg87OeiZ34VLfHtpO9w63q8EK1sfhoSH9VoZD7yjbChUCDRgZsvl0hhxVX
         8mVAzAd/n8cw3ugcUssXJybA9+gInlaL9G+E1+j7TXyz0lAyz/+7aiTCD/vvXBZw9zl1
         bw8N6Y2lGCJ2qPBrnrH3K52Sdi6Jl3gZsF5b80N2DmKrM8/CWHDEk6w4hYqV2GgZPAOG
         KzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zIqikUxxUkznt/nPhZHSPquXqmCjr0iAh/jFh9d8P3A=;
        b=maS42f0f5lja9Z+eyDBDgvQ+h6Tc8EKq897p5GN74a6YgV7l3hWUy3UuRxsJBs9qHM
         MQlodnYrVurYsuYU3ieyWphfBm67wLdZgeZY2GB4X37h96rXYD9Mt329eN0NQWmJU/fk
         1JigrxkQVTPHE7dXr2Les+U/fKLiS3xIEV+qETvmmdxcAxLhanrojzhw3DynlPOI+CO4
         yQ0f762tNd25zoSqwz8hUViAGnA/ef32V/XtdviXf4Sh4aI/e6wMrKdjELMYNiNHYVrv
         UGeKXj2wjl8AbtzYKcRkTASkgZD9YgEj9YbnLUL3rXVOIFBzSpLg/l3YMINJ8PxHMIir
         mTKw==
X-Gm-Message-State: APjAAAXXKyZhwTCXAmWaFOo2Lco92SpuOfhluFn7l4wXKyBa0VKFiCAH
        weYO+qtNOo7xTzoA1sY8Mzlu1OlW+Szcani9NTW0Dw==
X-Google-Smtp-Source: APXvYqxU96w28abtHE8iCpMU+y7SrZIpL//Bw34gn+u4ZU8wsAw3pX+V1uOspSgWJpQNL5A2E/SEDtf0TJoK9q0SimM=
X-Received: by 2002:a5d:9456:: with SMTP id x22mr868694ior.71.1560763482317;
 Mon, 17 Jun 2019 02:24:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain> <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
 <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com> <20190617092012.gk7wrazxh7bwfmjk@gondor.apana.org.au>
In-Reply-To: <20190617092012.gk7wrazxh7bwfmjk@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 17 Jun 2019 11:24:31 +0200
Message-ID: <CAKv+Gu_34nOAcTBJPi7cR2W7w-1c27ofgoDaXZtuZh8qaaQJSQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 17 Jun 2019 at 11:20, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Jun 17, 2019 at 11:15:01AM +0200, Ard Biesheuvel wrote:
> >
> > Ah yes, thanks for reminding me. There was some debate in the past
> > about this, but I don't remember the details.
>
> I think there were some controversy regarding whether the resulting
> code lived in drivers/md or crypto.  I think as long as drivers/md
> is the only user of the said code then having it in drivers/md should
> be fine.
>
> However, if we end up using/reusing the same code for others such as
> fs/crypto then it might make more sense to have them in crypto.
>

Agreed. We could more easily test it in isolation and ensure parity
between different implementations, especially now that we have Eric's
improved testing framework that tests against generic implementations.
