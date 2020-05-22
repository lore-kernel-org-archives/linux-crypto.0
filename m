Return-Path: <SRS0=VFM7=7E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBA4C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 May 2020 22:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7683120738
	for <linux-crypto@archiver.kernel.org>; Fri, 22 May 2020 22:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590185508;
	bh=mOwJAU1r/D6//NmALGJ6aaEGSLyr181z6TL5Wf0ek5w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Z6i3fkFWFPwFDurOtxfulJsZN/c1U7S9uL9TQxdsH4ihXkRC0g8iLH8O97P+joMVq
	 iZGqMlGae8OtGQ2cxxkmVlv1WrrGjOK5KGWttKIl+YuzUQ77LV3o6wraVMKfaDt68A
	 a8Fbn8We6PMCRZoF+R13/ks7eoE2OJjNAQB5no+o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgEVWLr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 May 2020 18:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgEVWLr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 May 2020 18:11:47 -0400
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2617120738
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2020 22:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590185507;
        bh=mOwJAU1r/D6//NmALGJ6aaEGSLyr181z6TL5Wf0ek5w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NPXuESXVc61ahLr0707l46Zq5YiDkfLjchizDLdMIAKMUl75+lnN/ld/VA3/DeV/z
         vp+xxfxdgTYIGzX433g6vZ0k4DRR1cTF/ydAsdGvPJWiq8tRQPVc8jFw17FjjsyGKm
         olSH3PNbhUoA5M2X/UDuvx4NAul17HxqXZPzULF8=
Received: by mail-io1-f47.google.com with SMTP id f4so13033931iov.11
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2020 15:11:47 -0700 (PDT)
X-Gm-Message-State: AOAM530VIVzQpTFqOVbp53eYpwuJogIxxvAj30eWdbUylkZvju26vgoc
        YEsmfaR9twCGUoJSXCTXLLoRURg3e1U4z1HBuz4=
X-Google-Smtp-Source: ABdhPJxS5RREkjMwK5XieCff4s6bBX3yY5OMaPNbwUG7PyFrqvNz/5QF0zY3ujJagdSP5fWD9ocDqFp9Ffw6Ub8JYXY=
X-Received: by 2002:a05:6638:dc3:: with SMTP id m3mr10039530jaj.98.1590185506589;
 Fri, 22 May 2020 15:11:46 -0700 (PDT)
MIME-Version: 1.0
References: <TU4PR8401MB0544BD5EDA39A5E1E3388940F6B40@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <TU4PR8401MB054452A7CD9FF3A50F994C4DF6B40@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <TU4PR8401MB054452A7CD9FF3A50F994C4DF6B40@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 23 May 2020 00:11:35 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFa3V1o5Djrqa0XV5HvBqLjFvWqnNLRteiZo+dbhy=Tnw@mail.gmail.com>
Message-ID: <CAMj1kXFa3V1o5Djrqa0XV5HvBqLjFvWqnNLRteiZo+dbhy=Tnw@mail.gmail.com>
Subject: Re: Monte Carlo Test (MCT) for AES
To:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>,
        Stephan Mueller <smueller@chronox.de>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+ Stephan)

On Fri, 22 May 2020 at 05:20, Bhat, Jayalakshmi Manjunath
<jayalakshmi.bhat@hp.com> wrote:
>
> Hi All,
>
> We are using libkcapi for CAVS vectors verification on our Linux kernel. Our Linux kernel version is 4.14.  Monte Carlo Test (MCT) for SHA worked fine using libkcapi. We are trying to perform Monte Carlo Test (MCT) for AES using libkcapi.
> We not able to get the result successfully. Is it possible to use libkcapi to achieve AES MCT?
>
> Regards,
> Jayalakshmi
>
