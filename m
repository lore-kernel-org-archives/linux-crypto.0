Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA6AC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Dec 2022 14:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiLTOcY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Dec 2022 09:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbiLTObt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Dec 2022 09:31:49 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E236186F2
        for <linux-crypto@vger.kernel.org>; Tue, 20 Dec 2022 06:31:48 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-144bd860fdbso15633139fac.0
        for <linux-crypto@vger.kernel.org>; Tue, 20 Dec 2022 06:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T/NCsYKC04yFcK1fgm0juUVbSixz96HJYgI6+8cFKck=;
        b=aW5RhtAsBkNvIR682pacJYjMBchjsl6CBpgm1GNt+MoU0xR7oZIbXklJVEhSA5imlQ
         5u50ol+9QlNXecXRFfrW9BlWpiEgwr54V46RQJ7vPMFVZN8nUM7UL5cjfEyDNsEd6TlT
         I+s90R9sBzg5F4fXqzDg5UVxzzA1ZnYyjdfck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T/NCsYKC04yFcK1fgm0juUVbSixz96HJYgI6+8cFKck=;
        b=PkPnlJA/puNC7ha3ICdgq7NZM10HgUpLA2dvKGVtxr1sL2aoWnarlx1lxuc7exDd1j
         Oz22LzE9s9/Dp+xpjaRUDPrOq3Z7zF5xnf1lOiD9xqQjtwvk0kEKIuuVwwaR/Lk5ZM+e
         zKvG6vDhlNqtqVMKlWRbmaRJYFpTiqIS4JBRTlZ4T2wE5DIXXNsHsZO46S/KeFm7IEBO
         xb9LmX2SvOlk4U5cL2pJQDwRBX7BftXOiNSIDBYEJf9qOprSC0dZLE+145wPqwUPOLPR
         4wWeUdCFXAprluQBJtmbqrN1U30AxkV48ob9rYFUawcfVitnoZfex9XbFPjTD7ZO8CjO
         TUnA==
X-Gm-Message-State: AFqh2krDrCqvuIEH7v/0X024UDh8QkluEHgwEerv5BzNScXSVsBE/kYx
        LcUZ2zdOwYOYEG5HTXw6EIMqrn994d6pJH2N
X-Google-Smtp-Source: AMrXdXvCGC8Lwz4ZidrigRm+68t0OxztqsfJk95yqxvf4z/5dAbsrRS7qPAvwnNB4qT4Qi0wGJNJDg==
X-Received: by 2002:a05:6870:75cc:b0:14b:b6de:5039 with SMTP id de12-20020a05687075cc00b0014bb6de5039mr8780658oab.57.1671546707702;
        Tue, 20 Dec 2022 06:31:47 -0800 (PST)
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com. [209.85.222.182])
        by smtp.gmail.com with ESMTPSA id i6-20020a05620a248600b006fc2f74ad12sm9086145qkn.92.2022.12.20.06.31.46
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 06:31:46 -0800 (PST)
Received: by mail-qk1-f182.google.com with SMTP id a25so5315423qkl.12
        for <linux-crypto@vger.kernel.org>; Tue, 20 Dec 2022 06:31:46 -0800 (PST)
X-Received: by 2002:ac8:4988:0:b0:3a7:ef7b:6aa5 with SMTP id
 f8-20020ac84988000000b003a7ef7b6aa5mr8424356qtq.436.1671546695878; Tue, 20
 Dec 2022 06:31:35 -0800 (PST)
MIME-Version: 1.0
References: <20221219153525.632521981@infradead.org> <20221219154119.154045458@infradead.org>
 <Y6DEfQXymYVgL3oJ@boqun-archlinux> <Y6GXoO4qmH9OIZ5Q@hirez.programming.kicks-ass.net>
In-Reply-To: <Y6GXoO4qmH9OIZ5Q@hirez.programming.kicks-ass.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 20 Dec 2022 08:31:19 -0600
X-Gmail-Original-Message-ID: <CAHk-=wi493ukLwziiqofe=WCSfUU8Qa+LK0mp_GrGWKV3NnTpQ@mail.gmail.com>
Message-ID: <CAHk-=wi493ukLwziiqofe=WCSfUU8Qa+LK0mp_GrGWKV3NnTpQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 05/12] arch: Introduce arch_{,try_}_cmpxchg128{,_local}()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Boqun Feng <boqun.feng@gmail.com>, corbet@lwn.net, will@kernel.org,
        mark.rutland@arm.com, catalin.marinas@arm.com, dennis@kernel.org,
        tj@kernel.org, cl@linux.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, Herbert Xu <herbert@gondor.apana.org.au>,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, joro@8bytes.org, suravee.suthikulpanit@amd.com,
        robin.murphy@arm.com, dwmw2@infradead.org,
        baolu.lu@linux.intel.com, Arnd Bergmann <arnd@arndb.de>,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        Andrew Morton <akpm@linux-foundation.org>, vbabka@suse.cz,
        roman.gushchin@linux.dev, 42.hyeyoo@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux.dev,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 20, 2022 at 5:09 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, Dec 19, 2022 at 12:07:25PM -0800, Boqun Feng wrote:
> >
> > I wonder whether we should use "(*(u128 *)ptr)" instead of "(*(unsigned
> > long *) ptr)"? Because compilers may think only 64bit value pointed by
> > "ptr" gets modified, and they are allowed to do "useful" optimization.
>
> In this I've copied the existing cmpxchg_double() code; I'll have to let
> the arch folks speak here, I've no clue.

It does sound like the right thing to do. I doubt it ends up making a
difference in practice, but yes, the asm doesn't have a memory
clobber, so the input/output types should be the right ones for the
compiler to not possibly do something odd and cache the part that it
doesn't see as being accessed.

              Linus
