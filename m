Return-Path: <SRS0=o+Is=OM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56734C04EBF
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Dec 2018 14:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C7C62082F
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Dec 2018 14:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="P6RgvDhs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C7C62082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbeLCOPA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Dec 2018 09:15:00 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40955 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbeLCOPA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Dec 2018 09:15:00 -0500
Received: by mail-io1-f67.google.com with SMTP id n9so10558854ioh.7
        for <linux-crypto@vger.kernel.org>; Mon, 03 Dec 2018 06:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rOAp832YU39L1SFpsJBacojfl0uFYgFOIfzrHiBHEL8=;
        b=P6RgvDhsluF6FVojEfnCPpcxaRNKpP56V0pIDOdN9dVlz9ms9E+BimPHfna4pRrnAt
         miL8K5FM70ZjrYC5wOa7pdpn3a1ny9D0wjVYqUPR67Imq9CKQnqL+VNMSJTuLYZ0pfNI
         uADB5dNhxBtgt1rvuOQbMiNttleHFwol8kGnM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rOAp832YU39L1SFpsJBacojfl0uFYgFOIfzrHiBHEL8=;
        b=IB/bWYd/LH8QG6QDP9Jo6r6a72z9TYEP6fKlo9uiy3+bS6P4qRZNfrDzjHwvljnVmj
         Srmp9KYxUWrf5qDNrrGgfzl9WLyuR5tc4ENgVPzeWNflrVmfAShTIuLTyYHZN4fl+kgZ
         6jXjUSE9XKTD12ompztb48a5T1P6CT6+zWYP5JflMrI7VbLvbBD9QdAlgycn/sXzK6rN
         HWqGkrMmb2HoP1VJZk7pGi6ov807BIVALVvjDLevE9ALI9awxSH+v3jrP//P5fSgStJW
         zW2MQoIACF2ZVW31+S8njMVFNDRbd3tbjR9VOu55UE4itMxdA5GLTWzbMQw5JoomIizq
         CVKA==
X-Gm-Message-State: AA+aEWbM+ouG/4/7qX2onsCE6+xKH/N8rHGZNhunlOZ7zijDBkvHqc2G
        QYRM2wEQhzALbRvh2KbmjsVCQuV5bBxzLDregj/YXg==
X-Google-Smtp-Source: AFSGD/WJqlvYvi26ifqbde4WmOEZDZbFLslPRv6329u2zpE489n4IlSS1W1jWMX9TX8E6tW7X/PY9VhUwPOzvi9WZUY=
X-Received: by 2002:a5e:cb42:: with SMTP id h2mr7987761iok.60.1543846429531;
 Mon, 03 Dec 2018 06:13:49 -0800 (PST)
MIME-Version: 1.0
References: <20181129230217.158038-1-ebiggers@kernel.org> <20181129230217.158038-4-ebiggers@kernel.org>
 <acad781e9981c49b83b6dfdc8cefed6246df469a.camel@strongswan.org>
In-Reply-To: <acad781e9981c49b83b6dfdc8cefed6246df469a.camel@strongswan.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 3 Dec 2018 15:13:37 +0100
Message-ID:
 <CAKv+Gu89RiDBx35rtGS2uOZ+TwPt6P8UjwpqE17xm7dtMx-nNQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] crypto: x86/chacha20 - limit the
 preemption-disabled section
To:     Martin Willi <martin@strongswan.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181203141337.RxpqkJ-3v754D-Su1uScFZ7BdHjDPT8X9Cl3kg8YQ9k@z>

On Sun, 2 Dec 2018 at 11:47, Martin Willi <martin@strongswan.org> wrote:
>
>
> > To improve responsiveness, disable preemption for each step of the
> > walk (which is at most PAGE_SIZE) rather than for the entire
> > encryption/decryption operation.
>
> It seems that it is not that uncommon for IPsec to get small inputs
> scattered over multiple blocks. Doing FPU context saving for each walk
> step then can slow down things.
>
> An alternative approach could be to re-enable preemption not based on
> the walk steps, but on the amount of bytes processed. This would
> satisfy both users, I guess.
>
> In the long run we probably need a better approach for FPU context
> saving, as this really hurts performance-wise. For IPsec we should find
> a way to avoid the (multiple) per-packet FPU save/restores in softirq
> context, but I guess this requires support from process context
> switching.
>

At Jason's Zinc talk at plumbers, this came up, and apparently someone
is working on this, i.e., to ensure that on x86, the FPU restore only
occurs lazily, when returning to userland rather than every time you
call kernel_fpu_end() [like we do on arm64 as well]

Not sure what the ETA for that work is, though, nor did I get the name
of the guy working on it.
