Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B26BC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 16:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3FCC21738
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 16:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="m1WiCliO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbfHEQyr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 12:54:47 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38041 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbfHEQyr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 12:54:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id y15so39955253pfn.5
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 09:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/bwTUWzlU15HZ3M3k+xzvMhkRem/kSeFzTKEw/QWQzc=;
        b=m1WiCliOfPATXps4NT1o26440TW93JM6y2lFBOkkl4UhZIoKRcjxYe4kOb96Wn9q6h
         fU92SqEpY3M+gulqXCmLPdu25VQ+vkJE7VEF5ROpGC+I6ihwkw8VdifqIJstsIdfw+4y
         F5XWa5mRp29t7u8AwCOBpgh3ewJl+iyP0XbLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/bwTUWzlU15HZ3M3k+xzvMhkRem/kSeFzTKEw/QWQzc=;
        b=S4wlE4DVwp8DiwlLjvo6A9U2JNwtttO40lBYJOdPu8AtfDSgspiVkc6dlKl0eDqzeg
         5WBxfVyT0j6mBTZh3qJV5MYQCjM4LFAx0CdXSFuxMHBj0HLIc9pwVTa3jNlKBKYYYX3m
         iyIyyEpT10mR41J+d4cafaWRo7tU9zpdtLCTstgB5gsePh1MibVTU00NVR6bJxioDr7K
         5eXa7/XwxoyqOcIlgLPuuiVoyRhhWQlU+o3Og/3ptgO3jHI5o42PmEp3A//VTlYVE2Xg
         IbRcs6jiy4+Goe0j8wompXBvMwMbo2oUeVv6z97mK1wfGLABuLkiZ3igKhKDqKiRv3OF
         fcvw==
X-Gm-Message-State: APjAAAUrh0+4MmWGdsYFsEcEuLHCr7xiQG+HSo/I+7HFYp2C2dvg+atw
        0033Yoqk2Z5pDoAcgTZxOIgiLPbTXxs=
X-Google-Smtp-Source: APXvYqw41x1+VlUG+f6ebMnURHbQ6wfQ/1Cp9FeJ/wPnnO1VWKcg8M+qfvWaeC6+kSoRPCXxLawOSw==
X-Received: by 2002:aa7:82da:: with SMTP id f26mr74409261pfn.82.1565024086360;
        Mon, 05 Aug 2019 09:54:46 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p1sm90317138pff.74.2019.08.05.09.54.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Aug 2019 09:54:45 -0700 (PDT)
Date:   Mon, 5 Aug 2019 09:54:44 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Garnier <thgarnie@chromium.org>,
        kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 01/11] x86/crypto: Adapt assembly for PIE support
Message-ID: <201908050952.BC1F7C3@keescook>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-2-thgarnie@chromium.org>
 <20190805163202.GD18785@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805163202.GD18785@zn.tnic>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 05, 2019 at 06:32:02PM +0200, Borislav Petkov wrote:
> On Tue, Jul 30, 2019 at 12:12:45PM -0700, Thomas Garnier wrote:
> > Change the assembly code to use only relative references of symbols for the
> > kernel to be PIE compatible.
> > 
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range below 0xffffffff80000000.
> 
> I believe in previous reviews I asked about why this sentence is being
> replicated in every commit message and now it is still in every commit
> message except in 2/11.
> 
> Why do you need it everywhere and not once in the 0th mail?

I think there was some long-ago feedback from someone (Ingo?) about
giving context for the patch so looking at one individually would let
someone know that it was part of a larger series. This is a distant
memory, though. Do you think it should just be dropped in each patch?

-- 
Kees Cook
