Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6044C77B7A
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jun 2023 20:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbjFBUEC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 16:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbjFBUEB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 16:04:01 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA001AB
        for <linux-crypto@vger.kernel.org>; Fri,  2 Jun 2023 13:03:59 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-51491b87565so3614202a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jun 2023 13:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685736238; x=1688328238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8pqo3OfJjzReA0YZCNQePZ3Xh5QPxALpix/U4edhgSI=;
        b=Im4MapHypRY5jX8xgqTbxFcbXBshMfGfNrYImvTx0oZWVgtn07XTkOrZXLhSID6rDy
         H8wqJ3khM6dSpP43+z9jsTZCFMX66+PCnt/sBXd/G3B9Q7DxWkQH6lVeNCDBqiqHTVX/
         i/kaBd+QoBGqexycB7GHMd59wxPcrn6LGlTmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685736238; x=1688328238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8pqo3OfJjzReA0YZCNQePZ3Xh5QPxALpix/U4edhgSI=;
        b=ke8WAzR4g+8yvXM1Nw7EtEJCk7XCcAxSaNZr2V1Ba3idG1lyOLUMO3Hu6cEgZ0PjOF
         HB4e3ujAyiaIKRz5tpLikYp7A0EpOJKgAPxzKCT1tW5/eT2X8Goz7c6if3wekXwCWz6R
         mGZ2o7DME4iZ3ojrr6vWxjVpWnxkGMMHMpX78ffqxODlUCgKpvP6stiXmRHoIl+0o6ND
         JszCOWdazWS/sWZeURvySHDVRvfOdhtDmaSg+NyHflafuPqievk8aCr3JwQdGAYs3KMa
         eEr5fWdC9zd9d954Hnd0pctHsQql3rgnBdeYUD/O25drmyUaOa4+VBbRQmJh4FsMs5x0
         WApA==
X-Gm-Message-State: AC+VfDxlnsylaEvMejMZFdsqGGiMXStxKyCM9WD8nyi2kVaF+Z1dUT2W
        kiJ9ns56Rp443/r64MRZF2/jIVxKLUADWs8Rdxp1mh8t
X-Google-Smtp-Source: ACHHUZ7MXYTI1eNtazsvYx+eM53hSfFt2zxPPakEc3OwBiBTya+Jr0JooVqJdxBVf1/8J+is1X7gQQ==
X-Received: by 2002:a17:907:97c3:b0:974:b15:fcda with SMTP id js3-20020a17090797c300b009740b15fcdamr13822828ejc.54.1685736238311;
        Fri, 02 Jun 2023 13:03:58 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id e2-20020a1709062c0200b0094e7d196aa4sm1103297ejh.160.2023.06.02.13.03.57
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 13:03:58 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-97458c97333so222439966b.2
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jun 2023 13:03:57 -0700 (PDT)
X-Received: by 2002:a05:6402:b10:b0:514:9b60:ea65 with SMTP id
 bm16-20020a0564020b1000b005149b60ea65mr2665357edb.16.1685735862382; Fri, 02
 Jun 2023 12:57:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230531130833.635651916@infradead.org> <20230531132323.722039569@infradead.org>
 <70a69deb-7ad4-45b2-8e13-34955594a7ce@app.fastmail.com> <20230601101409.GS4253@hirez.programming.kicks-ass.net>
 <14c50e58-fecc-e96a-ee73-39ef4e4617c7@gmx.de> <CAHk-=whL65CLuy9D9gyO608acM5WLWo_ggAMP1cGu2XvyC0-hA@mail.gmail.com>
 <20230602143912.GI620383@hirez.programming.kicks-ass.net> <E333E35E-5F9C-441C-B75A-082F19D37978@zytor.com>
 <20230602191014.GA695361@hirez.programming.kicks-ass.net> <B432FCD8-2ED7-42B1-BC3B-34F277A1CD9F@zytor.com>
 <20230602194021.GB695361@hirez.programming.kicks-ass.net>
In-Reply-To: <20230602194021.GB695361@hirez.programming.kicks-ass.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 2 Jun 2023 15:57:25 -0400
X-Gmail-Original-Message-ID: <CAHk-=wi4q=_+vQkOM0LRY7SfsH+D1-9DOSBABAzXrZwWxmJR+g@mail.gmail.com>
Message-ID: <CAHk-=wi4q=_+vQkOM0LRY7SfsH+D1-9DOSBABAzXrZwWxmJR+g@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] parisc/percpu: Work around the lack of __SIZEOF_INT128__
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Helge Deller <deller@gmx.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, dennis@kernel.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        Heiko Carstens <hca@linux.ibm.com>, gor@linux.ibm.com,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        borntraeger@linux.ibm.com, Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, suravee.suthikulpanit@amd.com,
        Robin Murphy <robin.murphy@arm.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, iommu@lists.linux.dev,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-parisc@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>,
        Sam James <sam@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 2, 2023 at 3:40=E2=80=AFPM Peter Zijlstra <peterz@infradead.org=
> wrote:
>
> "With 64bit builds depending on __SIZEOF_INT128__ to detect the
> presence of __int128 raise the parisc minimum compiler version to
> gcc-11.0.0."
>
> better?

I'd just say "64-bit targets need the __int128 type, which for pa-risc
means raising the minimum gcc version to 11".

The __SIZEOF_INT128__ part isn't the important part. That's just the sympto=
m.

               Linus
