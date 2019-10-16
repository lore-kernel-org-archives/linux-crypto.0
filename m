Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A67ECE599
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 22:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F26032082C
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 22:51:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=temperror (0-bit key) header.d=lancastr.com header.i=@lancastr.com header.b="R2F1k7i6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405243AbfJPWvQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 18:51:16 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41373 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405066AbfJPWvQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 18:51:16 -0400
Received: by mail-lj1-f193.google.com with SMTP id f5so408910ljg.8
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2019 15:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lancastr.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E3liQLFoSbsjmG+33ZIPfACEfh9vdmjZ+riN7uRiy/A=;
        b=R2F1k7i64irk4BBHUh3KKnNuQMW3neSZbJFbRwSPHzy1U9YrWYQb+B2DvysddUWjJB
         ul+3iVVxr5HW8zKeaNlH6Wff3Zen8nhWonOE31DqNXMgZ1X1tGx6mUrUY2DlaCSp2IpY
         NqjfnG5KAfYy1GF9oHNQne1ZTcmERCh0qjytVebJy4iF6e2F7cTxati8u8SoGnJvn3PJ
         sjGh/3mpIBKKPlDs5B6zWbNqiR9M4oZLrEi67k+6iEQLNg73PMaa/Xon5Ypmp23rfbnZ
         Z/8+DO0pFw65S/LBwcI1N1jTN94BlwH7MzmH0iEb64qiB+pfptvf/TaaD6hqtuaV+dsq
         05kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E3liQLFoSbsjmG+33ZIPfACEfh9vdmjZ+riN7uRiy/A=;
        b=nF5PSmVP9RAmgzF+MQ3Gs94smkrcEPm0WDi3uKalCFVaD2giGyNo7rCnAj9rhryJNC
         xKgaMJESsXjm7IcLpvLLwSFpGKL+Mt8SOtR0926XePEzGZSQWOR2Pz15wzzai9lhzidN
         nLMnksy9pVHemcfvFYFPhThoAG8HUycmMQ61Q4aymgbkxUTZyzJ+b/gwUpPjts1DhWug
         BKNv5MrmjueMeVYhsKjJ0MPPIKxPmN+KEi2HDCjluLDobSN/Kcavv8VQkM6T8ofZX8Qg
         RTSpLJ/oySkpRpQ5naK2sC4zaKovH3i2+0/BD9Ju7J/wvnXARL6YeVPHfLlyQ5FaiLlG
         KhDg==
X-Gm-Message-State: APjAAAXq49zhG+nFubJJ92A8lz9lBizFt8sCAo0KNVwSO/QbTEeyp7PJ
        ZBPnNqNEaIvCMk+6IYVhyQ2MFVr+rcK93NyqJJ6tomNC37M=
X-Google-Smtp-Source: APXvYqzwdbTCOUWtUl2ORol+zjBKwJGS5zKmotMGZGFbAQDLOfbLQ96Z20Kjo/NtK+1VNL3LzxrQD9UITVa4ibXzeaA=
X-Received: by 2002:a2e:957:: with SMTP id 84mr293496ljj.245.1571266274422;
 Wed, 16 Oct 2019 15:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <CALbZx5WSonqQTuPSLDpDkdCfyj76Fht5EXtN2gF9H5=_qeA9rg@mail.gmail.com>
 <12396681.Xx2HXIOQZG@tauon.chronox.de>
In-Reply-To: <12396681.Xx2HXIOQZG@tauon.chronox.de>
From:   Gleb Pomykalov <gleb@lancastr.com>
Date:   Thu, 17 Oct 2019 01:51:02 +0300
Message-ID: <CALbZx5UV=F61-Rtm_WUGutqY5X=3CLF=9x8cTG08K+WboCZYTQ@mail.gmail.com>
Subject: Re: EIP97 kernel failure with af_alg/libaio
To:     Stephan Mueller <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

Please take a look at this repository
https://github.com/glebpom/rust-crypto-api/tree/mediatek-test
The rust code is in examples/test.rs. This is a simple test, which
runs 4 parallel AF_ALG encryptions through libaio with different block
sizes: 4096 and 8192 bytes.
You can build the code for ARMv7 (via docker) by running ./build.sh

Regards,
Gleb

On Mon, Oct 14, 2019 at 8:41 AM Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Sonntag, 13. Oktober 2019, 10:49:07 CEST schrieb Gleb Pomykalov:
>
> Hi Gleb,
>
> > Hello,
> >
> > I'm trying to make EIP97 work on Mediatek mtk7623n (Banana PI R2). The
> > kernel version is 4.14.145. My tests uses af_alg in libaio mode, and
> > encrypts the data. For smaller blocks it works just fine, but if I
> > increase the size I'm getting the kernel error (it fails on 8k block
> > and larger, 4k works fine):
> >
>
> Can you please send the exact invocation sequence? The backtrace initially
> does not hint to any AF_ALG-specific issue.
>
> Ciao
> Stephan
>
>
