Return-Path: <SRS0=cKin=SY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6DAC10F11
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 16:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87AA1214AE
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 16:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eNzNmJNN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbfDVQcC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Apr 2019 12:32:02 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45942 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727447AbfDVQcC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Apr 2019 12:32:02 -0400
Received: by mail-ot1-f67.google.com with SMTP id e5so10084296otk.12;
        Mon, 22 Apr 2019 09:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=mlE711ipAzZnZ4uUckMu0jVt12MIclbzvyQKKaol1D4=;
        b=eNzNmJNNBCGFKPThgNadyxVbppylysiEyfaWeN9ojlN2juq4YQy+bIr+YPV45PVPNf
         HobvZpHlN3P+hTpS2HpuQ8RAycLwwfRZyivf/zWXp9tWpbkiBT8UnZWjceAi8Z/pp1st
         JS8FvZeYIhPy3aVVw+N9KOJUFUxufHxt5OAPup8Ac7U6bfxPp1vTSLP+dsGcBItcG9fc
         ZxcCtxYZRh83o4jbpANOBWJ8zjdpVlPoiUfqc0sfwcRt+5jn/NW9f9vxsU8wSDcV4BxW
         c6M6fWLkdPTuw8mnLIn4+RnBIGzKvBHvYbEBB6tGup8Wld8kNjy865SkouEAzwWddIqb
         F+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=mlE711ipAzZnZ4uUckMu0jVt12MIclbzvyQKKaol1D4=;
        b=kFV6HG0yz/SpqLvtGx4aIO6TOTR3rmi/vlQG3EuB7stMQDtBpzmQxE4bBGtPiUleEE
         vfluoEtRJiJmnzBSzLM+2fWVWJC7ecgAYPobt1KIxgeCVsNHjQbAKU84RliGRwZcNqo9
         qtJA2AxyW2pYhzd+LHYjNPCF1B3pz/X7/1fSruHiWnOytrR953O+whhkwBw4Li78FxNm
         Uy3YLNPXM9Hc77ls39VVfR3c2v7CfZovjC+glsd8uFe+ZzwXSDnDHMACmiTDtgY7QuHG
         P2cwKAdsGF3j+kSDDac+y2WQn4l9W7EUn7S6G0aGRIq6Y0kdytoeJMIlF13zqQkZvT/s
         8Ewg==
X-Gm-Message-State: APjAAAXMhBqPSBKfGGQOqk0ZD+6O6wdVo0vxOw49tBwH1ApsnAsbypB7
        8sygBPQDVXq7hxQzioirXbiXr4gO5t1rvOT66C0=
X-Google-Smtp-Source: APXvYqyM5PtJ36AomDoIftsO27GiMbhD/NF6u3Of8YiRHzpWg1P5IYifTQYwuEpmqB32d2OpPm3pA7311IN9CXnnXWw=
X-Received: by 2002:a05:6830:14f:: with SMTP id j15mr12292375otp.278.1555950721751;
 Mon, 22 Apr 2019 09:32:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4a:d14a:0:0:0:0:0 with HTTP; Mon, 22 Apr 2019 09:32:01
 -0700 (PDT)
In-Reply-To: <20190422131849.8548320693@mail.kernel.org>
References: <4d8f4f483feb713126bbdb789b095936819d9804.1555932334.git.chunkeey@gmail.com>
 <20190422131849.8548320693@mail.kernel.org>
From:   Christian Lamparter <chunkeey@gmail.com>
Date:   Mon, 22 Apr 2019 18:32:01 +0200
Message-ID: <CAAd0S9D_29dG-70h-5C+F+h7QVppDKsa4rWDjRSR6ynBUss3+Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] crypto4xx: fix cfb and ofb "overran dst buffer" issues
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/22/19, Sasha Levin <sashal@kernel.org> wrote:
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.0.9, v4.19.36, v4.14.113,
> v4.9.170, v4.4.178, v3.18.138.
>
> v5.0.9: Build OK!
> v4.19.36: Build OK!
> v4.14.113: Failed to apply! Possible dependencies:
[...]
>     f2a13e7cba9e ("crypto: crypto4xx - enable AES RFC3686, ECB, CFB and OFB
> offloads")
>
>
> How should we proceed with this patch?
>
Same as with the aes-ctr fix. I guess, I should have added

Fixes: f2a13e7cba9e ("crypto: crypto4xx - enable AES RFC3686, ECB, CFB
and OFB offloads")

Regards,
Christian
