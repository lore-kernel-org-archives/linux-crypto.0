Return-Path: <SRS0=Hj06=BI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2734C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 06:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC5EB20786
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 06:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596002826;
	bh=uuiZim+ifxA6Ag2XeK5X/HpYvVpSxfo8nFLbSaKmMQg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=uh7QTrDqSYs+cdSP9HmZLumWeasONMHcS8CApvNWpJlmazxYBuxe3RGY9Pzi0luJs
	 OPTTq45zztgver/t5g5qtOFAn+hjqXoVlrzd0Vu5NcQmPj4X/bBkyMm18ibrLv2pbn
	 RTs+yJCwAUp+JQ3SvslDV8p1J1u1HdoQ1u9aWiL8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgG2GHG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jul 2020 02:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgG2GHF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jul 2020 02:07:05 -0400
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DBEF206D4
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2020 06:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596002825;
        bh=uuiZim+ifxA6Ag2XeK5X/HpYvVpSxfo8nFLbSaKmMQg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oi5XLH4+ThyyvJjHpSHzQM1Nt3svCEO8J/kcQ6ACSfPpxiOZ1pj0aNQXMP7zW2Tns
         iVQU63f0XpIQrfSPJsWFCJ4spd4DAMRMz5iI97IpY2H5QlUsDQlmjnrTNINTltNkjS
         drEzDtJszfN4rUf6EHRHuYhE/KFOxnMMFECQ6MJg=
Received: by mail-oi1-f182.google.com with SMTP id v13so3147948oiv.13
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 23:07:05 -0700 (PDT)
X-Gm-Message-State: AOAM533ZESJ32bmj0VT/GlXFsDqEaLY0WC+tpkG0XgpYDzOaN4cCHqYq
        0zJEOXtxr5jtjUYDEy5JgHRP9tk4oRWYs8zV+aE=
X-Google-Smtp-Source: ABdhPJy4dhxK5cPnkDu4BaYNLFZ/Odt+IdYKgXrR/MMXOuhJZvJv5OT4p4Kgta5NNQXE7tBWB4zsyjhkDGMK9hxt3zY=
X-Received: by 2002:aca:afd0:: with SMTP id y199mr3524069oie.47.1596002824606;
 Tue, 28 Jul 2020 23:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <2a55b661-512b-9479-9fff-0f2e2a581765@candelatech.com>
In-Reply-To: <2a55b661-512b-9479-9fff-0f2e2a581765@candelatech.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 29 Jul 2020 09:06:53 +0300
X-Gmail-Original-Message-ID: <CAMj1kXFwPPDfm1hvW+LgnfuPO-wfguTZ0NcLyeyesGeBcuDKGQ@mail.gmail.com>
Message-ID: <CAMj1kXFwPPDfm1hvW+LgnfuPO-wfguTZ0NcLyeyesGeBcuDKGQ@mail.gmail.com>
Subject: Re: Help getting aesni crypto patch upstream
To:     Ben Greear <greearb@candelatech.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 29 Jul 2020 at 01:03, Ben Greear <greearb@candelatech.com> wrote:
>
> Hello,
>
> As part of my wifi test tool, I need to do decrypt AES on the CPU, and the only way this
> performs well is to use aesni.  I've been using a patch for years that does this, but
> recently somewhere between 5.4 and 5.7, the API I've been using has been removed.
>
> Would anyone be interested in getting this support upstream?  I'd be happy to pay for
> the effort.
>
> Here is the patch in question:
>
> https://github.com/greearb/linux-ct-5.7/blob/master/wip/0001-crypto-aesni-add-ccm-aes-algorithm-implementation.patch
>
> Please keep me in CC, I'm not subscribed to this list.
>

Hi Ben,

Recently, the x86 FPU handling was improved to remove the overhead of
preserving/restoring of the register state, so the issue that this
patch fixes may no longer exist. Did you try?

In any case, according to the commit log on that patch, the problem is
in the MAC generation, so it might be better to add a cbcmac(aes)
implementation only, and not duplicate all the CCM boilerplate.
