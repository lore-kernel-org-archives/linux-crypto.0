Return-Path: <SRS0=xTm+=2J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA08C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 16:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 927F824672
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 16:40:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XYNY/1ju"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfLSQkm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Dec 2019 11:40:42 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42499 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfLSQkm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Dec 2019 11:40:42 -0500
Received: by mail-ed1-f67.google.com with SMTP id e10so5505656edv.9
        for <linux-crypto@vger.kernel.org>; Thu, 19 Dec 2019 08:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q6MJKY5kaJhdcPD2Yij+K4j3QBznO/FzqxPRwZHg2tA=;
        b=XYNY/1juioQpuXWDwItjvluLKzqTb1s+LUDJh70eT+FynV6pmhNjrfR8rKpTN0Y4Vq
         95LNMIm35iIung4zroafpJpZMFHIQW6gyl0nMe0sXzlo0Usj/osB8dJgXFazZDihbiKk
         TXHN/eqPdNOFXyC7+ATLgVoMdiY/9k9+NozPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q6MJKY5kaJhdcPD2Yij+K4j3QBznO/FzqxPRwZHg2tA=;
        b=XPS591GQX3xGwmFiJDnCcSGD9Qy2an0Knq6BqG8HMBZR7uW0OD+h1wi2tkMve7OzS9
         QAf/ChNcuJTWw+6DIDnFtPVy6yYiwBT+X/lAEUH0p8npY5FwfK3bBqHHkC3A/mNNspjG
         zzmgFhXv26X9XxwU/ycCfEd8Qv9Q8Td3vdUslhP2+PvZLFXoX2afOW7t3wAF1+oqqFsL
         Wiq55dj55Ihw7lUhl3dsidUFBaQt2H3zhQ7bUopcjCSDLdqCchPDRkxT3ZcprHyWZiQE
         dCrBlAPue+6rjcCA+HmgsRwkF4pb6G0HvyfDFG4UAZ2FbBTyGtKHFLOYti2Tp3w9Y/Cs
         5IbA==
X-Gm-Message-State: APjAAAXCA/AbTmhkAYCL/zmn/Gv9TSFiv+/oiJHPrmiAmaGy9p7AXRXu
        Ku/+aPpY4y2n3ahJyME+F0qjNBfGrqI=
X-Google-Smtp-Source: APXvYqzodbtPMd6NjiAXGLKNXCMumnzShFXAz7M0aaH7A1/tOZactiJO5/WHt+WfsDnJ0zu9hwg0Ig==
X-Received: by 2002:a50:e387:: with SMTP id b7mr10200146edm.43.1576773640736;
        Thu, 19 Dec 2019 08:40:40 -0800 (PST)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id j21sm510435eds.8.2019.12.19.08.40.40
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 08:40:40 -0800 (PST)
Received: by mail-wr1-f54.google.com with SMTP id b6so6693849wrq.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Dec 2019 08:40:40 -0800 (PST)
X-Received: by 2002:adf:ee92:: with SMTP id b18mr10865736wro.281.1576773336863;
 Thu, 19 Dec 2019 08:35:36 -0800 (PST)
MIME-Version: 1.0
References: <20191205000957.112719-1-thgarnie@chromium.org> <20191219133452.GM2827@hirez.programming.kicks-ass.net>
In-Reply-To: <20191219133452.GM2827@hirez.programming.kicks-ass.net>
From:   Thomas Garnier <thgarnie@chromium.org>
Date:   Thu, 19 Dec 2019 08:35:25 -0800
X-Gmail-Original-Message-ID: <CAJcbSZEubkFN0BLugoBm8fsPrNWxfFCDytC3nYUepr74dQFS=w@mail.gmail.com>
Message-ID: <CAJcbSZEubkFN0BLugoBm8fsPrNWxfFCDytC3nYUepr74dQFS=w@mail.gmail.com>
Subject: Re: [PATCH v10 00/11] x86: PIE support to extend KASLR randomization
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Will Deacon <will@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 19, 2019 at 5:35 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Dec 04, 2019 at 04:09:37PM -0800, Thomas Garnier wrote:
> > Minor changes based on feedback and rebase from v9.
> >
> > Splitting the previous serie in two. This part contains assembly code
> > changes required for PIE but without any direct dependencies with the
> > rest of the patchset.
>
> ISTR suggestion you add an objtool pass that verifies there are no
> absolute text references left. Otherwise we'll forever be chasing that
> last one..

Correct, I have a reference in the changelog saying I will tackle in
the next patchset because we still have non-pie references in other
places but the fix is a bit more complex (for exemple per-cpu) and not
included in this phase. I will add a better explanation in the next
message for patch v11.
