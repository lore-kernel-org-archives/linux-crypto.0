Return-Path: <SRS0=O2m6=RK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7FEC43381
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Mar 2019 07:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A53720675
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Mar 2019 07:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551943847;
	bh=bGuraxaXqIjN5gO7GwTh92jdQgB7IlTY5UNJt+0/ACE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=0Q/+UQmDTDZsmLG2zhDsQo671VceCuF9MsNHFsTJXA/vyG300sp0UIYh1NZ2+HrE2
	 ralWtsOrhLe0EcBxM0cXy2KDBTSji5h+RFzyTxutazQiXLUStMkXah4EgAVvRi8EZ3
	 8QOTGUY+JqZLpeDRm7+TdkB5FsyIE5qLGCzEvDnM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfCGHal (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Mar 2019 02:30:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfCGHal (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Mar 2019 02:30:41 -0500
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FA782146E;
        Thu,  7 Mar 2019 07:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551943840;
        bh=bGuraxaXqIjN5gO7GwTh92jdQgB7IlTY5UNJt+0/ACE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZKHrw+iOUzCkdBWCg3R86SJDVA+niU6CvqwU3LPRMjwDW+OCHMINPwNHbGrTBMs+R
         Ii2CQo7CjCLwp6yxiOsdMrAvUfdoFreQ4zD4RqXaIFtDESrFGgwBu1+3O/ma2Er0Bm
         xaX+/DS5m4W2L6mdhE8bPpNRRbhh4ijtUYeK8ZbA=
Received: by mail-lj1-f176.google.com with SMTP id z20so13292986ljj.10;
        Wed, 06 Mar 2019 23:30:40 -0800 (PST)
X-Gm-Message-State: APjAAAUlrn7smI19kbC/n7AKS1bkReyQzm5Zpbwy5HaPwSi2mxn3yb6D
        de5wRgpl0GnkHnQvRzVMftZttY59/x65cDDl9t4=
X-Google-Smtp-Source: APXvYqxpCSv0w8s10dF/gH4zRA/AqrBf1J/vOoPeb3jIiDlQ1h/wL35XN6tiS9Vyuljhsn/6b0C826ZIob44dbjW6mU=
X-Received: by 2002:a2e:780a:: with SMTP id t10mr4231952ljc.19.1551943838262;
 Wed, 06 Mar 2019 23:30:38 -0800 (PST)
MIME-Version: 1.0
References: <5c80c49b.1c69fb81.605bf.26ea@mx.google.com>
In-Reply-To: <5c80c49b.1c69fb81.605bf.26ea@mx.google.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Thu, 7 Mar 2019 08:30:27 +0100
X-Gmail-Original-Message-ID: <CAJKOXPfVxb+aQnqCePgF4EedH5vPtA3BWhqbTTNAa7pAOOYB_Q@mail.gmail.com>
Message-ID: <CAJKOXPfVxb+aQnqCePgF4EedH5vPtA3BWhqbTTNAa7pAOOYB_Q@mail.gmail.com>
Subject: Re: mainline/master boot bisection: v5.0-4854-g8dcd175bc3d5 on odroid-xu3
To:     "kernelci.org bot" <bot@kernelci.org>
Cc:     tomeu.vizoso@collabora.com, guillaume.tucker@collabora.com,
        broonie@kernel.org, matthew.hart@linaro.org,
        Herbert Xu <herbert@gondor.apana.org.au>, khilman@baylibre.com,
        enric.balletbo@collabora.com,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 7 Mar 2019 at 08:13, kernelci.org bot <bot@kernelci.org> wrote:
>
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> * This automated bisection report was sent to you on the basis  *
> * that you may be involved with the breaking commit it has      *
> * found.  No manual investigation has been done to verify it,   *
> * and the root cause of the problem may be somewhere else.      *
> * Hope this helps!                                              *
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
>
> mainline/master boot bisection: v5.0-4854-g8dcd175bc3d5 on odroid-xu3
>
> Summary:
>   Start:      8dcd175bc3d5 Merge branch 'akpm' (patches from Andrew)
>   Details:    https://kernelci.org/boot/id/5c8052c159b5146b7bfe6018
>   Plain log:  https://storage.kernelci.org//mainline/master/v5.0-4854-g8dcd175bc3d5/arm/exynos_defconfig/gcc-7/lab-collabora/boot-exynos5422-odroidxu3.txt
>   HTML log:   https://storage.kernelci.org//mainline/master/v5.0-4854-g8dcd175bc3d5/arm/exynos_defconfig/gcc-7/lab-collabora/boot-exynos5422-odroidxu3.html
>   Result:     0918f18c7179 crypto: s5p - add AES support for Exynos5433
>
> Checks:
>   revert:     PASS
>   verify:     PASS

Thanks bot!
It is already known and patch is waiting to be applied:
https://patchwork.kernel.org/patch/10835389/

Best regards,
Krzysztof
