Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB576C2D0C2
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 14:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7518D21835
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 14:38:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZP9G0htX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbgACOiM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Jan 2020 09:38:12 -0500
Received: from mail-qk1-f182.google.com ([209.85.222.182]:36189 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbgACOiM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Jan 2020 09:38:12 -0500
Received: by mail-qk1-f182.google.com with SMTP id a203so34247788qkc.3
        for <linux-crypto@vger.kernel.org>; Fri, 03 Jan 2020 06:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vevwVm8lg+5OCh2+rEmRWvOe9hK3MNOQnmIUXBHghLg=;
        b=ZP9G0htX41CHYkVtUDLFI/G76FnynZzdNsZTM8KfAAfrXZhFueqV14qv/qc398wSS4
         q0iLUWLsst5oLOASvpzqycBAoOAQez4yLnXe8ZlsV6+ws+1LbHQaohnB1ulU1SshD5B9
         GLSQs6awJxX4kQO7hnMvXwhIl131+0eLOMESqSYqc77HSTLUlctPszo23ySoNEhxy45H
         8xw0hRLpTn9ccqffR/fQowqFj1/o716vptRaS3RX5b0bs99r3eXPIbbydbPsvHRH7xR9
         yxcgZO1Ds014i6rVOF5gl4t7mnfDQeVyWkGUw/JXjQ+VCSMP45vKY1JHGn0NB667dH+Z
         u7tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vevwVm8lg+5OCh2+rEmRWvOe9hK3MNOQnmIUXBHghLg=;
        b=T2hGiYkRhoyrdOabAR1YXImWBftghCZILtT5nZzlMd6XilbbmPwOmnr/NXLca0mh5v
         kCQsjfCMlV8AMD33rhVg0bl3cYMjaJ4INBnTkLiK85zVOjt/QUp1CqbKEYcpUgFssMAp
         vjwdmz093p82+kUl8VuOTYWVxS9qpw5X4uskR6gVrTw5+/sACAcG14w8YYt0in+RNrms
         LnY+CkZUtX8bds9eOvLqhswwhROOi0NAMV3cYA9Zq3OTAUdvLGtSmOAH49Kmr0YGDRm8
         F4ZUnZVg9/u0h2kib56OAjRtDQ/R/tWXVpCZ47lA5QvKFCPQlZCEo2mBJToOTVcngj2A
         L7xQ==
X-Gm-Message-State: APjAAAX3P55P2IiQhdD46l8MF46mmICD3eFMBHd8BB88RtTW7IlC+EjD
        Z1+JTtSIl9WpzATOIXSMNKUEMczip4BEy61dDZ0=
X-Google-Smtp-Source: APXvYqziBH9iuzvk0OWdC7OfIUHwVSNg2H0X4VZaj29nBXChe0SC89Y9cdaZDN3wPsfqSsK3ZvAzD1qqLdfwQxGYrhA=
X-Received: by 2002:a05:620a:16bb:: with SMTP id s27mr74910529qkj.368.1578062291323;
 Fri, 03 Jan 2020 06:38:11 -0800 (PST)
MIME-Version: 1.0
References: <20191220190218.28884-1-cotequeiroz@gmail.com> <CAKv+Gu9ZXCK41xOavw+2KEhhsZq9BFH6mxXKPNomzB6q+DP_FQ@mail.gmail.com>
 <CAPxccB2LGANG8DcmF4nwUDOzDzf2RHX4S-4w9z6TcO9csu4xSw@mail.gmail.com> <CAKv+Gu9fUs_xOZgUw5smrJf7+jrovkPL+1fF4fRcNhRieYSwhA@mail.gmail.com>
In-Reply-To: <CAKv+Gu9fUs_xOZgUw5smrJf7+jrovkPL+1fF4fRcNhRieYSwhA@mail.gmail.com>
From:   Eneas Queiroz <cotequeiroz@gmail.com>
Date:   Fri, 3 Jan 2020 11:37:45 -0300
Message-ID: <CAPxccB2w0_hmeChtSF-CUZ=dFm9srbQChhrL55fEvAH8nU-wCQ@mail.gmail.com>
Subject: Re: QCE hw-crypto DMA issues
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 3, 2020 at 11:33 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On Thu, 2 Jan 2020 at 22:09, Eneas Queiroz <cotequeiroz@gmail.com> wrote:
> >>
> >> Non-cache coherent DMA involves cache invalidation on inbound data. So
> >> if both the device and the CPU write to the same cacheline while the
> >> buffer is mapped for DMA from device to memory, one of the updates
> >> gets lost.
> >
> >
> >  Can you give me any pointers/examples of how I can make this work?
> >
>
> You could have a look at commit ed527b13d800dd515a9e6c582f0a73eca65b2e1b

Thanks, I'll check it out.
