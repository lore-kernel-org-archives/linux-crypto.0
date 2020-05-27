Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E18C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 12:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4B16208B6
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 12:08:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lXR1DDPL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbgE0MIw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 08:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387849AbgE0MIq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 08:08:46 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03B7C08C5C2;
        Wed, 27 May 2020 05:08:45 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id h4so2800117wmb.4;
        Wed, 27 May 2020 05:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KSPP+QqMImfHhwneJyxdTK+m/mWOF1LBHIEu32FlwNM=;
        b=lXR1DDPLC4j54d7i3HvGLucspXjPrWIgYC37+qVsv+Yet05CVbTBTpoitY2h8DRNV8
         e4tgtRP2hV2jbuhDcLHAiTXtmZs2AXI71HiyxqSaK5OCDSfAYGoLBTAnuDFhs4cyD4hf
         KU01q4wDZkX3kyofC5oeiKZZfNJQ11IT/3icg2MlAClsX5tGhmWqQNaP4r+8zcOtFiga
         aBDbLvSwYnf6BHOrOgXcF+GFXZWYoO4SoxgL5eLuFgfKDEp4YM2qRL/lmKjtGVknTicw
         vMCwFPFeOlOa7x/bQk2NvLGpJj6mSCv8tCYULAehXcPjbeke62V5eKFGtokWoNW/+Cmn
         oZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KSPP+QqMImfHhwneJyxdTK+m/mWOF1LBHIEu32FlwNM=;
        b=s5r6LbBkFvE2MwjOu/nARReJhkg8q71nmQm+uNpTGMFZNYFpkhYxEuNAP2rkwfdrTv
         bquVUU2RASrfph3/hCjBQUqJ+NJgY+fFYY1HDnyv/mSxid9lp9YsY80eWbJdlmNsRnNn
         A3dxGQoZZ5GyA/etErG0V0F13YaoSMfhfTrJ9TrK6+SrQKTuvpotymeSq7rC1ZplL6BO
         DpkVh3lHp13L/jsGhfgIEOwDjUU8512/4uPqPbXq+JkT/DHkwC8bgl/L6PMkx9117ZsS
         bq3RbldepedWr+E8C5QHACKPCISsWJ6Hvut1j9pH70Z11jKua3ylhjO56omjUcirVDrT
         jlSg==
X-Gm-Message-State: AOAM531IzkZtlwFB3zM+de5e+akKj7DV1meLTZD5ZegsiSfHERjfvFas
        hynTlBA9X7uUeE6pDij22KJT7mAJGp7ITW8Tsge70w==
X-Google-Smtp-Source: ABdhPJwhsWUOmQb0xFnKD3NeUS3BuEnt2AXm56FDwKy0wV647o0vzA1MpsLmMBCoGzrfWZgfGXq796sUPO39nJ56Tnw=
X-Received: by 2002:a1c:dc05:: with SMTP id t5mr4214043wmg.112.1590581324183;
 Wed, 27 May 2020 05:08:44 -0700 (PDT)
MIME-Version: 1.0
References: <CANpvso4V67SBKn9+SXc+H=r-H-up+GWt77K4jH5HJx9k+sR+hA@mail.gmail.com>
In-Reply-To: <CANpvso4V67SBKn9+SXc+H=r-H-up+GWt77K4jH5HJx9k+sR+hA@mail.gmail.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Wed, 27 May 2020 20:08:03 +0800
Message-ID: <CACXcFmkzvvXc+Zi5MBe4_oOtiukczQG+RJjDjcwtAvBbkxGTRA@mail.gmail.com>
Subject: Re: Looking for an open-source thesis idea
To:     Eric Curtin <ericcurtin17@gmail.com>
Cc:     Kernel development list <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Curtin <ericcurtin17@gmail.com> wrote:

> Hope I'm not bothering you. I'm looking for a masters thesis idea, ...

Here's a report claiming 70% of security bugs involve memory errors.
https://www.zdnet.com/article/chrome-70-of-all-security-bugs-are-memory-safety-issues/
Build a tool to find or fix those?

Another report I saw on Slashdot recently said lots of web vulnerabilities
were due to problems in widely used open source libraries.
