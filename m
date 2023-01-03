Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 776EDC4708E
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Jan 2023 20:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjACUWH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Jan 2023 15:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbjACUVy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2023 15:21:54 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A13D10B7E
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 12:21:53 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id v2so17159666ioe.4
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2023 12:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HTnuIAJdCSnqOgUCfI1VegmgFYxeW1ngR0BDNyHkGf0=;
        b=DokQ/BEIgEpL/ia17Z2x8+os3L6Iix7X3VYwgY2oWHbqXrXltMNtHkuxWFNC0TiQoL
         cBgZVKREYRgoskXuojqZ3A1XLXXW46nqyABZQqesu1jY6qAYwaNx5oLjtODVhfjUliU3
         eVndN+o81O0zIOd96+Ti2/uGI99RMfL7MdUR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HTnuIAJdCSnqOgUCfI1VegmgFYxeW1ngR0BDNyHkGf0=;
        b=JY79X0VXZULw3xmzK82PMvNpfrPQc7jTbkEd1rBwB9oB1SRAPcBL5AkPk6rZjVg53p
         WM9w+eOqSh/v1cyMvtQuLfhC9bLnNqLA3zYZB8yxwjhnIddQxtUHph2H38NndTDttQqa
         o7l2J6tbw4+k8sCZSPHBCjl+S7jKIpvPyFGnQhbk78Ac/EzbEqJsgelcaROWnqQetRDW
         d3cVVCTssLeqrMg+UcCx0ttv+pIslcBaBJtWqKPG9XPC8cykKZIUGMhnta9K4N/7RUyC
         U7A9eexiRnWyeARVcHKt0zFjNQDTCJ6cUr3qrtRYHLiMGTC0WeSjzeTGUC529ByrGp+h
         FOJg==
X-Gm-Message-State: AFqh2koetdJLwway3tAWPSy9ARi7f3LKPmEEFNRlXg9tUWy2SnxA2re/
        uVtzjMBZ1o7O0Avk+uQjeV/HdKN41pSWRMxU
X-Google-Smtp-Source: AMrXdXvT96dVMT5//WGjDHA8n+gF0ZMkuzWSogxmSvg1ui7eJN3E0s4aAunmioRR0iqXiaYuHp1yhg==
X-Received: by 2002:a5e:c80a:0:b0:6e3:f1da:fe9a with SMTP id y10-20020a5ec80a000000b006e3f1dafe9amr30457554iol.18.1672777312247;
        Tue, 03 Jan 2023 12:21:52 -0800 (PST)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com. [209.85.166.52])
        by smtp.gmail.com with ESMTPSA id m30-20020a02a15e000000b0038a6ee3c07bsm10431837jah.62.2023.01.03.12.21.51
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 12:21:51 -0800 (PST)
Received: by mail-io1-f52.google.com with SMTP id 3so17156240iou.12
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2023 12:21:51 -0800 (PST)
X-Received: by 2002:ae9:ef49:0:b0:6fe:d4a6:dcef with SMTP id
 d70-20020ae9ef49000000b006fed4a6dcefmr2045085qkg.594.1672776973189; Tue, 03
 Jan 2023 12:16:13 -0800 (PST)
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com> <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com> <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <Y7SJ+/axonTK0Fir@zx2c4.com>
In-Reply-To: <Y7SJ+/axonTK0Fir@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 3 Jan 2023 12:15:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
Message-ID: <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        tglx@linutronix.de, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
        Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 3, 2023 at 12:03 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> That buffering cannot be done safely currently

.. again, this is "your semantics" (the (b) in my humbug list), not
necessarily reality for anybody else.

I'm NAK'ing making invasive changes to the VM for something this
specialized. I really believe that the people who have this issue are
*so* few and far between that they can deal with the VM forking and
reseeding issues quite well on their own.

            Linus
