Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C83C3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 08:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96FC1206C2
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 08:18:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cCd14CNN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfHPISw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 04:18:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38876 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfHPISw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 04:18:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so720971wrr.5
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2019 01:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZcH6rMZvfV+AWG20Wz62KwN247zGorzKSm/4I04o3LQ=;
        b=cCd14CNN5mMt9CV6CF8mCUtajynKfYi7A+J1JpHrouYzbBelRZ60UWEeinu8qlzukB
         m1TCcsjifzBHRbiotjwN/6An3iBWNetR/jDBVZeJW8HW+DxTZ7qzzwcJYcaUKWx+PdXA
         ABttoTzZlnWM4MPyQbZiOyX6RapIUtJMwgiC+Kvs0e0m9iTFaQKQ3gUdMaLp7HuoyPUy
         2DREkn+90+ZBbCUN4F2pgwssQlIVThUDn6J9D0YCwymwk5nWsNV6okwyw/mN1jSJeBc/
         cQr23j6de0yJ0xDOobXv3o8/FhAXkeCX1viFXO4NNPIwR5BkxIRLdXtVcaaBKCd+mR7l
         R1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZcH6rMZvfV+AWG20Wz62KwN247zGorzKSm/4I04o3LQ=;
        b=MJXsgXNR8LuxkHF95JjswT08WXBekrd6x0e2pvDhYDnveQpMDg336MbPOrVD9Q9sfP
         5Ud8Dtk/orUYGC9O9lEMSqVfYJ3nMAvJcRXvfeddY5EryNkfeJCvbD14pwitqMMgMokH
         dQasI+JxeGB6+q9rfNxUf7W6f1/GheGh+HHqsYp2QODsbnzLUlAgGBcKyr9kHJd5SFBn
         1aplrbu0eoNc8ApoPn75xZ6rHOFivgyrkHjIN2JiLf7L7XipGQkD0JFE8ymGQcf39ieg
         Yqw6KHpmm5RNCG/UwMnEaS3agCrmRMu0VLQpH/I02WAEvJXqUzi4ZUuLOcwGm/jfCMwi
         zdtg==
X-Gm-Message-State: APjAAAWjJa4XeGIp5bus8r3Q9A3VZydtEmm53oR7Yi9p+UaTKwQS4Zbz
        2+Qu4LnUeDv1cok7d8nS462D1w8VSM4fOG6to6EZvQ==
X-Google-Smtp-Source: APXvYqxeQeZx1iVRlwBZ8rNxXcZKYFGi5/bmoO7bFdHlbPQMPwBFag3R4qGLhble1xA9sPq1K5et96602Yk8vSTI+Nw=
X-Received: by 2002:adf:9222:: with SMTP id 31mr7891179wrj.93.1565943530202;
 Fri, 16 Aug 2019 01:18:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190815192858.28125-1-ard.biesheuvel@linaro.org> <1463bca3-77dc-42be-7624-e8eaf5cfbf32@gmail.com>
In-Reply-To: <1463bca3-77dc-42be-7624-e8eaf5cfbf32@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 16 Aug 2019 11:18:42 +0300
Message-ID: <CAKv+Gu9CtMMAjtjfR=uuB-+x0Lhy8gnme2HhExckW+eVZ8B_Ow@mail.gmail.com>
Subject: Re: [PATCH v12 0/4] crypto: switch to crypto API for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 16 Aug 2019 at 10:29, Milan Broz <gmazyland@gmail.com> wrote:
>
> Hi Ard,
>
> On 15/08/2019 21:28, Ard Biesheuvel wrote:
> > Changes since v10:
> > - Drop patches against fscrypt and dm-crypt - these will be routed via the
> >   respective maintainer trees during the next cycle
>
> I tested the previous dm-crypt patches (I also try to keep them in my kernel.org tree),
> it works and looks fine to me (and I like the final cleanup :)
>
> Once all maintainers are happy with the current state, I think it should go to
> the next release (5.4; IMO both ESSIV API and dm-crypt changes).
> Maybe you could keep sending dm-crypt patches in the end of the series (to help testing it)?
>

OK. But we'll need to coordinate a bit so that the first patch (the
one that introduces the template) is available in both branches,
otherwise ESSIV will be broken in the dm branch until it hits another
branch (-next or mainline) that also contains cryptodev.

As I suggested before, I can easily create a branch based on v5.3-rc1
containing just the first ESSIV patch (once Herbert is happy with it),
and merge that both into cryptodev and dm. That way, both will
continue to work without having too much overlap. Since adding a
template/file that has no users yet is highly unlikely to break
anything, it doesn't even matter which branch gets pulled first.

Any idea about the status of the EBOIV patch?
