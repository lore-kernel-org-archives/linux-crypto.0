Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6777CC47247
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 23:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47953206FA
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 23:19:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jwmVKyJd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgEEXTH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 19:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727989AbgEEXTG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 19:19:06 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82961C061A10
        for <linux-crypto@vger.kernel.org>; Tue,  5 May 2020 16:19:04 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a5so22770pjh.2
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2020 16:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=owNe/yVivLu8lnuA6nUAqNW2cBSryrNQc9w98UalwzM=;
        b=jwmVKyJdB6MEacSVwnKayMATUTmyNqGbKRMm+bb3btHQia+1GSAwm2KFtny0e4Av3a
         wAJHyV835gzEJSNw6NgOeYBkp0Z5ZAlDAwfmiZLl/pUsBJb1wVbRGf46bQn8veiL/pLL
         J84hSCM1nzAMdTR1hMlDvhhKicZuVPeaNoC7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=owNe/yVivLu8lnuA6nUAqNW2cBSryrNQc9w98UalwzM=;
        b=gTaPh9kC/OqN8rwr4IPnl2bakl0DZxRRkGcHfFnPCfilRMa/ECip0pykVBWXFlb9fv
         VRIVHxyt+r7LvL+AqOQrn0ckE9jrXKOKiFW2tPBRu8Q28Nj6UtW4/VgpUSUSb0/H99Zj
         ZcJHVqOFrR6Cj+3H+DT9LVyoVj3mry9yrfBMb6VUT+E9X3IGb18nY65bGIOviixmEUPf
         uMGklOSQmT8UCOrfLuVUwtbIue/aXIhimXeiVJfiB3iC5JP4IE9bg5TEJV9HxxuW2DlH
         5ck1M0RCOkE8z2McQyrGVfmIr+y+ZKe5NZyE6jauFyrlLgIuqYl68w0FVmSr62oBJRyE
         tU+g==
X-Gm-Message-State: AGi0Pua0WAftPG1vy0nNrMhcyYbcacEri4Tk0gTtN75JW1pUL29RZI5E
        W+XBApzZBjOKtPPFe3sDw1PJDw==
X-Google-Smtp-Source: APiQypL1qkYOsLAPE3Ba+P8oJQLR8egLJ8j4FyEfyDo/yQDKyAA2OO5jf92DgLNtlCJnXKDn6CuGkg==
X-Received: by 2002:a17:90a:a484:: with SMTP id z4mr5672933pjp.40.1588720743964;
        Tue, 05 May 2020 16:19:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s123sm71340pfs.170.2020.05.05.16.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 16:19:03 -0700 (PDT)
Date:   Tue, 5 May 2020 16:19:02 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>, George Burgess <gbiv@google.com>
Subject: Re: [PATCH] Kbuild: disable FORTIFY_SOURCE on clang-10
Message-ID: <202005051617.F9B32B5526@keescook>
References: <CAHmME9oMcfY4nwkknwN9c4rB-O7xD4GCAOFPoZCbdnq=034=Vw@mail.gmail.com>
 <20200505215503.691205-1-Jason@zx2c4.com>
 <CAKwvOdk32cDowvrqRPKDRpf2ZiXh=jVnBTmhM-NWD=Ownq9v3w@mail.gmail.com>
 <20200505222540.GA230458@ubuntu-s3-xlarge-x86>
 <CAHmME9qs0iavoBqd_z_7Xibyz7oxY+FRt+sHyy+sBa1wQc66ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qs0iavoBqd_z_7Xibyz7oxY+FRt+sHyy+sBa1wQc66ww@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 05, 2020 at 04:37:38PM -0600, Jason A. Donenfeld wrote:
> On Tue, May 5, 2020 at 4:25 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> > I believe these issues are one in the same. I did a reverse bisect with
> > Arnd's test case and converged on George's first patch:
> >
> > https://github.com/llvm/llvm-project/commit/2dd17ff08165e6118e70f00e22b2c36d2d4e0a9a
> >
> > I think that in lieu of this patch, we should have that patch and its
> > follow-up fix merged into 10.0.1.
> 
> If this is fixed in 10.0.1, do we even need to patch the kernel at
> all? Or can we just leave it be, considering most organizations using
> clang know what they're getting into? I'd personally prefer the
> latter, so that we don't clutter things.

I agree: I'd rather this was fixed in 10.0.1 (but if we do want a
kernel-side work-around for 10.0.0, I would suggest doing the version
check in the Kconfig for FORTIFY_SOURCE instead of in the Makefile,
as that's where these things are supposed to live these days).

(Though as was mentioned, it's likely that FORTIFY_SOURCE isn't working
_at all_ under Clang, so I may still send a patch to depend on !clang
just to avoid surprises until it's fixed, but I haven't had time to
chase down a solution yet.)

-- 
Kees Cook
