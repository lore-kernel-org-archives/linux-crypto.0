Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F3EC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 09:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 142BB20658
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 09:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594199657;
	bh=W4RJ8TnjM8EKXNimT6kcgKzCLFvLavsfK6Fdl3wz5EM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Xe4Zsrysh2yt+5agkmi4EHn/+/K1HOY+WGYNEYFOsk9q0PQzEt4P4FILMJMS68/mA
	 l+jAQzHLOuzsMgrnHM+huJXrAbkpPPkGS2vARP4ysHgL7nwHws248NlLuEywa/lhym
	 EzoQ5K9NvhLpSvJgb+ml8E/pWdMBWgxLdl/5ubYw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgGHJOQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 05:14:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgGHJOQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 05:14:16 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4E6320658
        for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2020 09:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594199655;
        bh=W4RJ8TnjM8EKXNimT6kcgKzCLFvLavsfK6Fdl3wz5EM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VD+sMg03q04U0Q7nFsNixWNcWDz334HYJVnAB1Ev0o8A0x5k888MosSO5NlgVtjB7
         Vva7r2KjAEc/Th0tdyaLSjbzoVJuIdQdt0lebnBzraicL1j1yNEiPL++GdneJh9M6q
         fy+14Uug11J1tLURdUXj8GM90UdpaFASj+cXtqf0=
Received: by mail-oi1-f169.google.com with SMTP id x83so29687052oif.10
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2020 02:14:15 -0700 (PDT)
X-Gm-Message-State: AOAM533oxJnENcQ0kauZoraYynZUnVE3BWO7NerGembp/xZrcfCAS9oj
        BaDzN373V/yon4HjHOI3uTyADgJlrr04k4yuEWY=
X-Google-Smtp-Source: ABdhPJw2KTHHhr/RISP9HeDyaUr7mWvMz6qwwQpHJZQiVHaMm49di7nhB/WjLn9RXqcyvwtPLEBCLN96e8EHkeHwBQw=
X-Received: by 2002:aca:f257:: with SMTP id q84mr6654032oih.174.1594199655141;
 Wed, 08 Jul 2020 02:14:15 -0700 (PDT)
MIME-Version: 1.0
References: <CY4PR0401MB3652172E295BA60CBDED9EE8C3670@CY4PR0401MB3652.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR0401MB3652172E295BA60CBDED9EE8C3670@CY4PR0401MB3652.namprd04.prod.outlook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 8 Jul 2020 12:14:04 +0300
X-Gmail-Original-Message-ID: <CAMj1kXFGPkpaKy9NunG0sefv3bc+ETDu6H2T8RcQaKAk+tTMJg@mail.gmail.com>
Message-ID: <CAMj1kXFGPkpaKy9NunG0sefv3bc+ETDu6H2T8RcQaKAk+tTMJg@mail.gmail.com>
Subject: Re: question regarding crypto driver DMA issue
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 8 Jul 2020 at 11:56, Van Leeuwen, Pascal <pvanleeuwen@rambus.com> wrote:
>
> Hi,
>
> I have a question on behalf of a customer of ours trying to use the inside-secure crypto
> API driver. They are experiencing issues with result data not arriving in the result buffer.
> This seems to have something to do with not being able to DMA to said buffer, as they
> can workaround the issue by explicitly allocating a DMA buffer on the fly and copying
> data from there to the original destination.
>
> The problem I have is that I do not have access to their hardware and the driver seems
> to work just fine on any hardware  (both x64 and ARM64) I have available here, so I
> have to approach this purely theoretically ...
>
> For the situation where this problem is occuring, the actual buffers are stored inside
> the ahash_req structure. So my question is: is there any reason why this structure may
> not be DMA-able on some systems? (as I have a hunch that may be the problem ...)
>

If DMA is non-coherent, and the ahash_req structure is also modified
by the CPU while it is mapped for DMA, you are likely to get a
conflict.

It should help if you align the DMA-able fields sufficiently, and make
sure you never touch them while they are mapped for writing by the
device.
