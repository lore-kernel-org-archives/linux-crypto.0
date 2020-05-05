Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF26C47247
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 23:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 332A4206B8
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 23:37:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ua2Y5pt+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgEEXhB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 19:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728717AbgEEXhB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 19:37:01 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD88C061A0F
        for <linux-crypto@vger.kernel.org>; Tue,  5 May 2020 16:37:00 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q24so47855pjd.1
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2020 16:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tV8k3SS2CHeSg6+79pVabsils9K32cepGXeLdcOAQJE=;
        b=Ua2Y5pt+OErrGRBo/BnuHn8XmNGatlMJtl73UVMhbLZg9dIgLiG9H8VPBxyed0B7Xj
         pKmDsX4Rt83fv/4OVyyvTJV9HeDQ4+kLkvr+rptl0op7KRmSeH7EEnl4TthCdLWJj7yy
         JkOXNNPblnEzyNfdhD5kzDOuSmwuup3xkl1ednTKQG2+sWMKdTRE+ozniU56+75e2UpW
         VgN4pKmjV+T/eqdZgP6qye1nvK3c+p+Ai+HpeHNTSIBuDmyBksU9kAkOSB84wBrhhvZi
         ucE3e39d1LJMsPkYyXacggBre/HMsfXKi7/unaDw6t18STqzlf/Ja24RhpdClm7LSL79
         cmTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tV8k3SS2CHeSg6+79pVabsils9K32cepGXeLdcOAQJE=;
        b=TgT6HWevCxM7HL0CbqX6QmW8CY7y0JJpUzGnJ2JU3d/Kqh8ZzCtmcwabsEYxM2yZ+E
         2QVrDTPj/DjKzzYMIMJI1YaIzYfMYoklLT8rZQJH/qnBkAZ2Dd6ET6uVJopgWQT6Hc6E
         s+632yla1Js9xwyNQ6QRHjJMCvN7/GQrDV8ZY99+WEvMhZoL62uzxyttzeYOE+BoT+i+
         zV8ckzHrIvd2YqZORTv9XwcRDDa6aX+dSy4G3j9+6eLMagKs9sHWid21PQQfy/3T6hBJ
         SRwBoDlLIzr4GObp5NhHQWK3ZyvlxppVR1E3le7nrdpgZE+NWwNKAETaWkeRcnZexq/D
         9hRA==
X-Gm-Message-State: AGi0PuaD7mSkSUl2ZlDrSij+tDUaV01KAxnEX4pywUn5890ieOXME6zs
        pnKW4NeATdL52tf9YHT2KN81ik9FLbgr+rj/AxQGVQ==
X-Google-Smtp-Source: APiQypLovBrf/kLoL/BVlwKUEVNCB111jD4tkdcRD9SkmNC5GRRsdT6HJAVxN1k0TY4QYYbCy47f8CCYIzjl3ZA/+OM=
X-Received: by 2002:a17:90a:6488:: with SMTP id h8mr5982493pjj.51.1588721819875;
 Tue, 05 May 2020 16:36:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oMcfY4nwkknwN9c4rB-O7xD4GCAOFPoZCbdnq=034=Vw@mail.gmail.com>
 <20200505215503.691205-1-Jason@zx2c4.com> <CAKwvOdk32cDowvrqRPKDRpf2ZiXh=jVnBTmhM-NWD=Ownq9v3w@mail.gmail.com>
 <20200505222540.GA230458@ubuntu-s3-xlarge-x86> <CAHmME9qs0iavoBqd_z_7Xibyz7oxY+FRt+sHyy+sBa1wQc66ww@mail.gmail.com>
 <202005051617.F9B32B5526@keescook> <CAHmME9q3zFe4e1xnpptJ27zywGqngZK2K7LCVzDSoG__ht=fNA@mail.gmail.com>
In-Reply-To: <CAHmME9q3zFe4e1xnpptJ27zywGqngZK2K7LCVzDSoG__ht=fNA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 5 May 2020 16:36:49 -0700
Message-ID: <CAKwvOdkrS-P_AS1azSCP-DVq_h8Dhb8YiLTfH=9zzEJQphZTcA@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: disable FORTIFY_SOURCE on clang-10
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        George Burgess <gbiv@google.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 5, 2020 at 4:22 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Tue, May 5, 2020 at 5:19 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > (Though as was mentioned, it's likely that FORTIFY_SOURCE isn't working
> > _at all_ under Clang, so I may still send a patch to depend on !clang
> > just to avoid surprises until it's fixed, but I haven't had time to
> > chase down a solution yet.)

Not good.  If it's completely broken, turn it off, and we'll prioritize fixing.

> That might be the most coherent thing to do, at least so that people
> don't get some false sense of mitigation.

Do we have a better test for "this is working as intended" or not
other than excessive stack usage, since that doesn't repro for
clang-9?
-- 
Thanks,
~Nick Desaulniers
