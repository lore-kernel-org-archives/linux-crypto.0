Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE0CC05027
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 19:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjBBTji (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 14:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjBBTjh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 14:39:37 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCBE79F39
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 11:39:33 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id br9so4557642lfb.4
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 11:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JmnIaySd7zoAM6xF2ibXT8yo+UTOpvQnMVr9b5O/7+w=;
        b=ca1h9KkMFNsKgO7Ao0NeYlaifxp7NzGcaaakgNFyQLMxBSXDHTcSanf/uonLuKRR18
         lO7gVsm341hb9Nhg1BLsB8gPuvWRYHLOlq9HV87cUF6Vj8wjTPtsHShRpe/Vd30GyM78
         DjJAMh6ZqNcvDd+rLB79O+fNMlUiqjmmCA6so=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JmnIaySd7zoAM6xF2ibXT8yo+UTOpvQnMVr9b5O/7+w=;
        b=vExMnHOukafj8gSy2FHovvzf0yxCjDtC/l/OQ79AaMLbonUCKNzYYEqF6JKfBqj2yk
         ajoayOAYpi0P2XCY9y98o8QmBMPlevXErY54bjjcA+voOqN4ZNR5qgxk86fh3ETlfhp/
         Q4YnJXznYhYWzKfmIcPGEqXqYxnKXSBis9C1AxQP5BwslV9w2jq5hgefbh/i19kScYWy
         zSBcgqAU8n2XdBA0KN0dxG508vG/6id6XNs7QQBDURC7BIptldwZ9+my6R+/EaeTDdog
         pIUbVRQ4e+dxtl+6TfGdbg18LqCQevENf4e7uT2R6wRc1wmlgrQk763mtFBpts9laHyP
         QFpQ==
X-Gm-Message-State: AO0yUKViCpYV1cpj6jef7fvkozJPTHq5V9xAXi8w19zxIvT9I5Ab7gC7
        uupB5DL5z6QLkd04dqRA141K835N4iGfsYad438=
X-Google-Smtp-Source: AK7set8A+AIzr1N09oSb1SROU4T4LbP6g2sdDk6akzGOGkhbXoJmg74DA1cdKiAKkZ9Rj/656DLndg==
X-Received: by 2002:a19:6902:0:b0:4cc:93e9:df8e with SMTP id e2-20020a196902000000b004cc93e9df8emr1994877lfc.33.1675366771279;
        Thu, 02 Feb 2023 11:39:31 -0800 (PST)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id h11-20020a19700b000000b004d39af98b04sm25386lfc.19.2023.02.02.11.39.30
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 11:39:30 -0800 (PST)
Received: by mail-lf1-f47.google.com with SMTP id bp15so4503849lfb.13
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 11:39:30 -0800 (PST)
X-Received: by 2002:a17:906:f109:b0:882:e1b7:a90b with SMTP id
 gv9-20020a170906f10900b00882e1b7a90bmr2112186ejb.187.1675366759217; Thu, 02
 Feb 2023 11:39:19 -0800 (PST)
MIME-Version: 1.0
References: <20230202145030.223740842@infradead.org>
In-Reply-To: <20230202145030.223740842@infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Feb 2023 11:39:02 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiF6y7CwR1P5_73aK2f=x=RZjwgh3sgeO3Mczv4XcDc8g@mail.gmail.com>
Message-ID: <CAHk-=wiF6y7CwR1P5_73aK2f=x=RZjwgh3sgeO3Mczv4XcDc8g@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] Introduce cmpxchg128() -- aka. the demise of cmpxchg_double()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     corbet@lwn.net, will@kernel.org, boqun.feng@gmail.com,
        mark.rutland@arm.com, catalin.marinas@arm.com, dennis@kernel.org,
        tj@kernel.org, cl@linux.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, joro@8bytes.org, suravee.suthikulpanit@amd.com,
        robin.murphy@arm.com, dwmw2@infradead.org,
        baolu.lu@linux.intel.com, Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        Andrew Morton <akpm@linux-foundation.org>, vbabka@suse.cz,
        roman.gushchin@linux.dev, 42.hyeyoo@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org,
        iommu@lists.linux.dev, linux-arch@vger.kernel.org,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 2, 2023 at 7:29 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
>  - fixed up the inline asm to use 'u128 *' mem argument so the compiler knows
>    how wide the modification is.
>  - reworked the percpu thing to use union based type-punning instead of
>    _Generic() based casts.

Looks lovely to me. This removed all my concerns (except for the
testing one, but all the patches looked nice and clean to me, so
clearly it must be perfect).

                Linus
