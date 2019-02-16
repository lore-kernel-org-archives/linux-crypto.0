Return-Path: <SRS0=wTi7=QX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED4AC43381
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Feb 2019 09:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80DFE222E3
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Feb 2019 09:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550310784;
	bh=j2a8KespGTwvO+Rs0azlboLr55i+jm7tQzrYbDD5J38=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=dtB7r1tdJ/jO+JInc/8r4rCrJ4doLt2kCxzQI4zyKGOuM43ycRsj575pKb9h3ectk
	 L4kcGAmEhJL3XYsDY5GY8H4WAZqix4pcN6s8mebwnv0GEprxadq6LWRXi5UKeBoiNB
	 f7geNZ3sKkmLL8yLv9XjpXhA/Mw5wwyoNJgu3rl0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfBPJxE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Feb 2019 04:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbfBPJxD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Feb 2019 04:53:03 -0500
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7711A222E5;
        Sat, 16 Feb 2019 09:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550310782;
        bh=j2a8KespGTwvO+Rs0azlboLr55i+jm7tQzrYbDD5J38=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fsL51TJyanaomSf5FD3+juSdc++gg5G66lCDJubLy2YlkA/+tYamkzfKtSw2fR3Uv
         pfvjhbtGqtUmczs960M5TIzrgmCGJtjQYwbVtFvGGiKTQgHztsc23asDwodeIJ8dw3
         tX1zwQ2vuogSzyMA2LT1IGIEL4H+eUFti56J7UUA=
Received: by mail-lf1-f45.google.com with SMTP id h10so8738576lfc.12;
        Sat, 16 Feb 2019 01:53:02 -0800 (PST)
X-Gm-Message-State: AHQUAubHsdqk7Ucyks6t+pQtASygM0joI/i/4Cvri3VEgqZV4Ey3zBqF
        sJNDFl9OG3jMu64sf+x33KT8hPgeiMwRS77/urc=
X-Google-Smtp-Source: AHgI3IaedFfdZLjqiHV/fchiWjipROr7s1n+k4NovfdkqgSb395sSBnbQZPC+v98uk8HXS/tvEk1c5XYB4JplhN4nBo=
X-Received: by 2002:ac2:4194:: with SMTP id z20mr7872896lfh.74.1550310780566;
 Sat, 16 Feb 2019 01:53:00 -0800 (PST)
MIME-Version: 1.0
References: <20190215185058.GB12909@gmail.com>
In-Reply-To: <20190215185058.GB12909@gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Sat, 16 Feb 2019 10:52:49 +0100
X-Gmail-Original-Message-ID: <CAJKOXPfU5JVU1Z9hBf-9cfDvaq3825su12jYv=Qf3K4nCQox=w@mail.gmail.com>
Message-ID: <CAJKOXPfU5JVU1Z9hBf-9cfDvaq3825su12jYv=Qf3K4nCQox=w@mail.gmail.com>
Subject: Re: [Bug] s5p-sss crypto driver doesn't set next AES-CBC IV
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Manszewski <c.manszewski@samsung.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 15 Feb 2019 at 19:51, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Hello,
>
> The AES-CBC implementation in the s5p-sss crypto driver is failing the improved
> crypto self-tests I currently have out for review.  The improved tests check
> that all CBC implementations update the IV buffer to be the last ciphertext
> block.  This has always been required so that requests can be chained, but
> unfortunately it wasn't tested for by the self-tests until now.
>
> See the boot logs for Exynos platforms from the KernelCI job here:
> https://kernelci.org/boot/all/job/ardb/branch/for-kernelci/kernel/v5.0-rc1-149-g64c945c018af/
>
> alg: skcipher: cbc-aes-s5p encryption test failed (wrong output IV) on test vector 0, cfg=\"in-place\"
> 00000000: 3d af ba 42 9d 9e b4 30 b4 22 da 80 2c 9f ac 41
>
> You can reproduce by pulling from
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> branch "iv-out-testing", unsetting CONFIG_CRYPTO_MANAGER_DISABLE_TESTS,
> setting CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, rebooting and checking dmesg.
>
> (CRYPTO_MANAGER_EXTRA_TESTS is probably unneeded for this, but you might as well
> use it.  Also you can optionally revert the last patch, which makes crypto
> self-test failures cause a kernel panic for testing purposes.  It's possible
> that ctr-aes-s5p is failing too but it was just never gotten to...)
>
> The patch series is also available on the linux-crypto mailing list:
> https://patchwork.kernel.org/cover/10811951/
>
> Note that I don't have this hardware myself, so if it turns out that no one is
> interested in fixing this anytime soon I'll instead have to propose disabling
> these algorithm(s) until they can be fixed.

Thanks for the report. I'll take a look. I have the HW so I think I
will be able to reproduce it easily.

Best regards,
Krzysztof
