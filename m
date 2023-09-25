Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78F1CE7A8C
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Sep 2023 06:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjIYG7b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Sep 2023 02:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjIYG73 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2023 02:59:29 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C90A3
        for <linux-crypto@vger.kernel.org>; Sun, 24 Sep 2023 23:59:23 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id 71dfb90a1353d-495d687b138so1755192e0c.3
        for <linux-crypto@vger.kernel.org>; Sun, 24 Sep 2023 23:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1695625162; x=1696229962; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8qEI90LoSzHC7OVIZurF0tjd1Yq1runGQ/mYc0XDOc=;
        b=Vqzbn/Q+sAS971Sf0mtq97YG9LJ8YmaSizP0uS6xzRCripmVmtSEmkJa03caIZC65m
         PtnNizla3o9UyzYEKADbYk8WtA/5nhjFIKZHs7bZ+WXfyhiRfw2LreUR0pLqyTNpoAdo
         XjlaBU1tQ7wsIQR5YtkLL1SOwQz1e8W+ykzZX0cuHSJ3ZPRZuaeyKFed5MxfYHjTLFZ+
         /TWETr6LSTyembbEvq+eqP3hgT614ird0hhcooQqi5n6BvipuCGm9tLTiiEC8PFvBXYV
         xDBr+XN3Y3dW0s2EN62R2ym0/gRfWR10MRSsu/g2GBNSqBUlz79LHlAKC440S0ExoVA+
         gXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695625162; x=1696229962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z8qEI90LoSzHC7OVIZurF0tjd1Yq1runGQ/mYc0XDOc=;
        b=Y29BljnfbSqueJWesPDWjSUo8ZoxUQrPDP6njsO1TgGhFSOk0C4sSSGg1sNBn+Wucm
         dOf1/BuLn4IO8J5NXTPPnqERVykdwNLkp4MgPmIGfvzAJ7kzDQ6FU6FasCtAWW3DHNXL
         9rB2tvTs5Tu5VhJoWoEzyhuiDofuwaAHPvjYBViMU/wUrC0/qS1cE38PW13JvDDKZQBg
         SHtewznkEIA8Glwbc8hFB0IJyYxHCmZTQh6AmfjUvqIhC4ZRsn980EzuKi7Y/j8Prp95
         pXdC45Y3fI3qpci29ZTmXCwwc/bnQPfUuHTuT5xeyD2lgkQuE5zMF7xGrouYSMnP6O4M
         ApKQ==
X-Gm-Message-State: AOJu0YwKlb2AxWkjkt7o2ytp0iCk7J98wPPI2Rz9iulH2jhL0NC5zSFK
        7rTERT6FzdaXmgR3Y5T/sfqB3UQf+QhF3/Jch8FJ9g==
X-Google-Smtp-Source: AGHT+IF/Zg1NsknbtSQpgBwTNUOHG3qhF9RP3mNCyeEXfaFEh7vh3SlLepbzoDFv12Fu/M9ql+IpvbyggHe6hJYXuQw=
X-Received: by 2002:a1f:d546:0:b0:48d:3b80:fba9 with SMTP id
 m67-20020a1fd546000000b0048d3b80fba9mr1691006vkg.11.1695625162450; Sun, 24
 Sep 2023 23:59:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230913153529.32777-1-bartosz.golaszewski@linaro.org> <c574c47e-9ceb-ef83-cc92-cdc6cd4982e5@linaro.org>
In-Reply-To: <c574c47e-9ceb-ef83-cc92-cdc6cd4982e5@linaro.org>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Mon, 25 Sep 2023 08:59:11 +0200
Message-ID: <CAMRc=Md1x1ZVj1pfyGZf+=KULd+eujRnGQ0JM43-jd=cB4mPng@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: crypto: ice: document the sa8775p inline
 crypto engine
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 13, 2023 at 5:56=E2=80=AFPM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 13/09/2023 17:35, Bartosz Golaszewski wrote:
> > Add the compatible string for QCom ICE on sa8775p SoCs.
> >
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > ---
>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>
> Best regards,
> Krzysztof
>

Herbert,

Gentle ping for the binding as Bjorn already picked up the dts part.

Bart
