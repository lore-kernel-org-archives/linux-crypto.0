Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1571C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Oct 2021 05:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83D3561216
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Oct 2021 05:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhJDFfa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Oct 2021 01:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbhJDFfa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Oct 2021 01:35:30 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB04C0613EC
        for <linux-crypto@vger.kernel.org>; Sun,  3 Oct 2021 22:33:41 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id y23so27303859lfb.0
        for <linux-crypto@vger.kernel.org>; Sun, 03 Oct 2021 22:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=niftyegg-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NqZ5Y2KWwNabsZme/d/92tejIqwZfCXdjfMhdeUDTPg=;
        b=0SukpRsKyEJDsUEh4Ca3pzoAfAflgQV3h3SqUIq3kWTGwvZMdagPja09OnvFc7wKH+
         u5zsFufCYZx/Ga8NsewxBlyZsDJBIxhj3/UpZl+KPUjEsVgL2GiwZf9a4sqHTIy0uoaj
         qEJ0Ke0nzJFTJkQ1ucy6J78Sv6REN+axUq5hoKbItMLiKpwcAiSZ6e6cQEPTOXH2HoWy
         Ev+MJrl/qmxi3oIoqwcb6K0VmUWD8s091AqoCJnVD7bugbOiEsmIywaLzZr5pdHYwaTa
         PAp03LQx5FdJ4Dh1JdGPaaYl+DD5TglPtx6UhCCwrQU+wLpkRxc4XmFVSDFUpKg0wgO/
         rCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NqZ5Y2KWwNabsZme/d/92tejIqwZfCXdjfMhdeUDTPg=;
        b=3qGdHWDI/EdcmxK1FxYqlJfGr6I2c6/k8937AE5DNa1c++IU6YSKB6I40QnT3OeYVQ
         oqu8okQvj2tkJbFEMaTpEJn34kO+czHkggYqlESemweA9Qgbhv4F5nmisy4s7hUnpj6w
         g1eei84Tlp733oepSB4wF86G1bj3u1j6fc7YFlPjK4qidTKT8Ck7dDa2SBsY3Ltuv3xd
         gvPt2sHyycOI/14qRyxbycM8QNWoUI47ZLJv96Hk/RAGU1gMRKnKBqUMzwZ9Y4EQ9Scy
         3KyCz4p0sHABNo0IE/Z8je0kQFoiShCajNEKz3ZdCrgMTE8bZ+B4Ehz49cIlz5u+EXj/
         qIsA==
X-Gm-Message-State: AOAM530HDswWs0E+RZs59hny14Lf9PMfE0oNq3uWl8TiPaf2MENZEe+a
        4nsA97x8VOTOr2pZJww/al+TGoa7zWZ/+BcNSuuxGaMhzcI=
X-Google-Smtp-Source: ABdhPJxcP5jMXSnU4/IBtH4ATgfxoMrIhYIzSvsPO+aUNCRBNY83+/e7ukURaWvCdnBmaIr3RbCWFYvzhSm0vv2entE=
X-Received: by 2002:a05:6512:acb:: with SMTP id n11mr12535626lfu.222.1633325620150;
 Sun, 03 Oct 2021 22:33:40 -0700 (PDT)
MIME-Version: 1.0
References: <CACXcFm=-E_wnDdRPztKJwDo8hvt6ENf84D90iFUXReuw2s0kuQ@mail.gmail.com>
In-Reply-To: <CACXcFm=-E_wnDdRPztKJwDo8hvt6ENf84D90iFUXReuw2s0kuQ@mail.gmail.com>
From:   Tom Mitchell <mitch@niftyegg.com>
Date:   Sun, 3 Oct 2021 22:33:04 -0700
Message-ID: <CAAMy4UTgnpO9dv3hLzB_DWYfC-OAx6SYactSjL_J8oDJ76XfhA@mail.gmail.com>
Subject: Re: [Cryptography] [RFC] random: add new pseudorandom number generator
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Cryptography <cryptography@metzdowd.com>,
        "Ted Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 17, 2021 at 8:31 AM Sandy Harris <sandyinchina@gmail.com> wrote:
>
> I have a PRNG that I want to use within the Linux random(4) driver. It
> looks remarkably strong to me, but analysis from others is needed.

How do you plan to get this into the Linux community for testing?
In a cluster of machines a PRNG kernel update and verification process
seems tedious and difficult to tidy up after a problem is found or
suspected.

First benchmark it.
If it slows the system down without advantage it will not be welcome
except as an optional service and device.
Spinlocks ... hmmm... now I need to look at how the kernel can ignore
or not need them?




-- 

          T o m    M i t c h e l l  (on NiftyEgg[.]com )
