Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 606D3C433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 06:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F59461184
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 06:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhDIGRc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Apr 2021 02:17:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhDIGRc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Apr 2021 02:17:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EFC3610C7;
        Fri,  9 Apr 2021 06:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617949039;
        bh=ZEJJhmgjC5Eg3EOw06g2jb8DMvcegJrGzOGlCle7wP0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=g4p+PAy+7U+4moIv2pzpYrgTdVshiE6lFCy0jvSVtRB8EPrWNXxI2k9rsl9nkLDKh
         YOX+SAIOeRvQdKA5NBX44bkl9rcv8ZD+1xo2jQmBTOjOCbmAFXu+NYQPHfTsB46LRU
         hp48lE++sD01PV+eOvNaRBnIbhAyv8Tfo0jKViaDRKFJNd3Xb/1CPAxZ/wSs9MSQVr
         r1OkXyAWBUN3UeSrX1ZkTUNNJ3EwZH7gnRavw0w4KE5mKRG1fCyEnoWh+NHKYSqNH5
         ngJ4Kqf1RPm3ezihaF/rudXPgns+L6laFyDmfTnWXT8TAVOfXDXc05RfvdzqQGlbqY
         W6oy8B6pxLSHA==
Received: by mail-ej1-f54.google.com with SMTP id mh7so6799172ejb.12;
        Thu, 08 Apr 2021 23:17:19 -0700 (PDT)
X-Gm-Message-State: AOAM533bm7yuDcZHa7176Op5X9KGY7xubMHy19AaLKZzjYZY62VH6oGB
        fpwSpkvNabdtiZIETjm1GybWZqUUlBvd15fWopE=
X-Google-Smtp-Source: ABdhPJyfRTfGDzgh6Vumf1v7fEKAjrm2z419xA+lglxNzsMMa6/b4ddGd0W+nMtloueR5Lpy+rKUvkERDsuMPCjbka8=
X-Received: by 2002:a17:907:76f6:: with SMTP id kg22mr14940767ejc.385.1617949038301;
 Thu, 08 Apr 2021 23:17:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210409061125.214255-1-yeweihua4@huawei.com>
In-Reply-To: <20210409061125.214255-1-yeweihua4@huawei.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Fri, 9 Apr 2021 08:17:06 +0200
X-Gmail-Original-Message-ID: <CAJKOXPfvg1o1kTqm7=E6BmXe06=SwE413fqz=VDHnAGcfMW0ow@mail.gmail.com>
Message-ID: <CAJKOXPfvg1o1kTqm7=E6BmXe06=SwE413fqz=VDHnAGcfMW0ow@mail.gmail.com>
Subject: Re: [PATCH -next] hwrng: exynos - fix PM reference leak in exynos_trng_probe()
To:     Ye Weihua <yeweihua4@huawei.com>
Cc:     l.stelmach@samsung.com, mpm@selenic.com,
        herbert@gondor.apana.org.au,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yangjihong1@huawei.com, zhangjinhao2@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 9 Apr 2021 at 08:11, Ye Weihua <yeweihua4@huawei.com> wrote:
>
> pm_runtime_get_sync will increment pm usage counter even it failed.
> Forgetting to putting operation will result in reference leak here.
> Fix it by replacing it with pm_runtime_resume_and_get to keep usage
> counter balanced.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Weihua <yeweihua4@huawei.com>

Hi,

The same Lukasz' comment applies here as for Qinglang's patch from
November 2020 - resume also needs fix up.

Best regards,
Krzysztof
