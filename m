Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78171C05027
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 20:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbjBJUvo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Feb 2023 15:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbjBJUvn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2023 15:51:43 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A197F82C
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 12:51:41 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ud5so18984566ejc.4
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 12:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s2Azvxdn84xto/x8V66pxCf76GAuLOkrFIRsWg8lS4s=;
        b=CExvujm0mDZb5b8Q0YyIk4qMEt2KO+XrVyPAus7CXHhyvaiDKton8DMFVNJsqauRlU
         nI1nneBrMPjQD5z0K9+CdqJYNcj8cP+aS9E0t7rQMDVkDPH9lCTi56TrRMFd1OP/EM6c
         8oYMudVstq0I+TSzaRmEBx/yV05z10/f7jbHs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s2Azvxdn84xto/x8V66pxCf76GAuLOkrFIRsWg8lS4s=;
        b=76/NQGqMFCvSsEK5rlZCIhBIACEl3GuxM7f8akBAshwj2gyND1A4NHlF31nNxJHjVq
         +9tPLuvxcyNcm4azlM42asvQCxyTADa1EUIRmjBATmoivtW+QtPVSs+gge1BeltCN1hJ
         a7ynkgljLXq1fA+MvZBzqkbA93sb7SHuLhFEOGX7fA1KMyyQDzoUr1x67xradNjbKc6y
         Gj+4pDrdEPoN4vMwauwsSBa8G5yEawryWA7S8m1oL9UyFdF+ezRPWqbFRJz1SgPe822W
         CjEcECl2Zcd30EcpZZvUvl+HiV7Nk32C016CV+Wah0N+tPYLpkC4m8HpmdDGKEEHhSVT
         7QNg==
X-Gm-Message-State: AO0yUKXspkkQluhAL+h7f5deT+Lxk7l+TAfRTj6JkDS2fNXer4uZKoZI
        R7Ob8ATvb0P527Ag5+HfOu6HggyWrpI+r0g+VfA=
X-Google-Smtp-Source: AK7set97fvk4QYjck2yalEk4p63KiBd4rcUFEAHWfqo+25M+QAkvhenpsYTfkkscxmsSKNO5pp2Exg==
X-Received: by 2002:a17:906:57d6:b0:86f:fbcf:f30a with SMTP id u22-20020a17090657d600b0086ffbcff30amr18683247ejr.58.1676062299175;
        Fri, 10 Feb 2023 12:51:39 -0800 (PST)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id hf27-20020a1709072c5b00b0088cdb05f1d5sm2887022ejc.113.2023.02.10.12.51.38
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 12:51:38 -0800 (PST)
Received: by mail-ej1-f52.google.com with SMTP id gr7so18956205ejb.5
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 12:51:38 -0800 (PST)
X-Received: by 2002:a17:906:d217:b0:877:747e:f076 with SMTP id
 w23-20020a170906d21700b00877747ef076mr1548367ejz.0.1676062298057; Fri, 10 Feb
 2023 12:51:38 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <f6c6d42e-337a-bbab-0d36-cfcc915d26c6@samba.org> <CAHk-=widtNT9y-9uGMnAgyR0kzyo0XjTkExSMoGpbZgeU=+vng@mail.gmail.com>
 <CAHk-=whprvcY=KRh15uqtmVqR2rL-H1yN6RaswHiWPsGHDqsSQ@mail.gmail.com> <6858a9bd-a8aa-3eaa-979d-83e1743ce85e@samba.org>
In-Reply-To: <6858a9bd-a8aa-3eaa-979d-83e1743ce85e@samba.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Feb 2023 12:51:21 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi=JeuB3aDX4yej=9SE-J6RR9LG28eRVfntkoQCPpHNpw@mail.gmail.com>
Message-ID: <CAHk-=wi=JeuB3aDX4yej=9SE-J6RR9LG28eRVfntkoQCPpHNpw@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Stefan Metzmacher <metze@samba.org>
Cc:     David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 10, 2023 at 12:45 PM Stefan Metzmacher <metze@samba.org> wrote:
>
> I guess it would be easy to pass a flag (maybe SPLICE_F_FORCE_COPY)
> down to generic_file_splice_read() and let it create dedicated pages
> and use memcpy() from the page cache to the dedicated pages.

I really think you'd be much better off passing it off to the
*destination*, not the source.

The destination knows whether it needs to copy or not, and in the case
of at least networking, already has the copy option.

The destination might also already know whether it can use the data
synchronously, so that there isn't even any issue with "data may
change later".

In contrast, the source has no clue. It just knows "I'm a page cache
page". It would have to always copy.

               Linus
