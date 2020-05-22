Return-Path: <SRS0=VFM7=7E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3DAC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 22 May 2020 20:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C8420679
	for <linux-crypto@archiver.kernel.org>; Fri, 22 May 2020 20:52:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tb1Zx8Nc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbgEVUwg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 May 2020 16:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731000AbgEVUwf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 May 2020 16:52:35 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2B2C061A0E;
        Fri, 22 May 2020 13:52:35 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id f13so9657156edr.13;
        Fri, 22 May 2020 13:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=cBclgUTXsLGRG9ZQiUwy614cZmM/CIXANVYpiy+ZpwE=;
        b=tb1Zx8Nc0uuaWQ4HzD2r6n1Junj+PJDoUnATBXtkgqPAwtHXj9Bv736ikAcR5qkJhe
         Wtr2jqsWOFPLnJT3UcbnJZ1u4N7PgbOi/VXMpUga8OHASTjpqK/s0WZTyQ3IPcDMVA3F
         e8VUCOfCZH2zxAVMXFCs3PEKte2eQB/FLk0tKMRaPsdvOcJdXPJ/sA4MpdRdkg6NsLPY
         C8xA7SsegSBb2V/rm6vm5jPI9IYgiqysObIDZshx0y5LY1nFfNLPy7fzJ75RvWeCZ1Wl
         9eGHE1VOq91QwQHwvA2kjhJHdmYJngb0fpNa0fo+TNPp0lfbjPrBvKDq5WF3gIta2POL
         olKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cBclgUTXsLGRG9ZQiUwy614cZmM/CIXANVYpiy+ZpwE=;
        b=LJlNNvUEnz+YFGLtVVNhBk+1fcmGBpdXtjG5ARW9IEqOz3LflmX4yunZ2akuXo0ydP
         M4vnJWjHDnV10Z4eXdGKEyJWT8linKxkPAT8V2HXlo3wVRcUYvuHXWzmtNpT/Zbj22a8
         A4XeR6UkP/syLPAWP/GUIcynRRnhvlO11fGFhEukOpBfmd+WkRQm+hc0kcOuSyuOQXi7
         AstGIUAOGGT5XDFFPym0FFixDS7zNzlsMGeXlDLz3LYM6Q4YLoyfAEzu29hs+mkwDwgp
         gGTPNlNZPP2gcM/z8sChRtcivsjYsWVeDTygKQOwbifiBrQoFBNUtgh6ytDjWozHAnc4
         t87g==
X-Gm-Message-State: AOAM533BKm8Z6ubJKVNj+0uc4hsoAEhh5S8ZNbA5OO5pQapY0IaHyWVL
        w1WCHpqoXwzXJ0VJFBL//Hm8JfnahtgarCvaW7WdyvT8HwI=
X-Google-Smtp-Source: ABdhPJy2N17Q/kQKuC+HXfWhtUuJCWoYec2u8tETHEwNUNH93nqVT0U4TxVZL0U/02AqHgKJSr2qqjMsWdTgVvVUkhg=
X-Received: by 2002:aa7:d98c:: with SMTP id u12mr4600429eds.85.1590180753797;
 Fri, 22 May 2020 13:52:33 -0700 (PDT)
MIME-Version: 1.0
From:   Eric Curtin <ericcurtin17@gmail.com>
Date:   Fri, 22 May 2020 21:52:22 +0100
Message-ID: <CANpvso4V67SBKn9+SXc+H=r-H-up+GWt77K4jH5HJx9k+sR+hA@mail.gmail.com>
Subject: Looking for an open-source thesis idea
To:     Kernel development list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Guys,

Hope I'm not bothering you. I'm looking for a masters thesis idea, and
if possible doing one related to open source software (of course I
have the option of tying it in to the Powermax kernel I work on also
with Dell). One idea that sprung to mind is, I'm really liking this
new QUIC (UDP) protocol as an alternative to TCP over TLS. And with
the growth of new modern secure protocols like Wireguard. I was
wondering, would it be an idea to do a monolithic secure TCP protocol
(as an alternative to TCP over TLS) as a small thesis project or is it
as hard as the guys at Google make is sound?

"Because TCP is implemented in operating system kernels, and middlebox
firmware, making significant changes to TCP is next to impossible."

I'm open to any other suggestions also for my thesis :)

The middlebox firmware sounds like it could be the issue I guess.
