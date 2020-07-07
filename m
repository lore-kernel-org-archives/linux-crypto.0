Return-Path: <SRS0=MSze=AS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B071BC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jul 2020 16:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EF5E20738
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jul 2020 16:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgGGQCS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jul 2020 12:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727793AbgGGQCQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jul 2020 12:02:16 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 447E920674;
        Tue,  7 Jul 2020 16:02:14 +0000 (UTC)
Date:   Tue, 7 Jul 2020 12:02:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Haren Myneni <haren@us.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Tal Gilboa <talgi@mellanox.com>, kunit-dev@googlegroups.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v2 2/2] kbuild: trace functions in subdirectories of
 lib/
Message-ID: <20200707120212.7010fa4f@oasis.local.home>
In-Reply-To: <20200707092117.963394-2-masahiroy@kernel.org>
References: <20200707092117.963394-1-masahiroy@kernel.org>
        <20200707092117.963394-2-masahiroy@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue,  7 Jul 2020 18:21:17 +0900
Masahiro Yamada <masahiroy@kernel.org> wrote:

>   ccflags-remove-$(CONFIG_FUNCTION_TRACER) += $(CC_FLAGS_FTRACE)
> 
> exists here in sub-directories of lib/ to keep the behavior of
> commit 2464a609ded0 ("ftrace: do not trace library functions").
> 
> Since that commit, not only the objects in lib/ but also the ones in
> the sub-directories are excluded from ftrace (although the commit
> description did not explicitly mention this).
> 
> However, most of library functions in sub-directories are not so hot.
> Re-add them to ftrace.

I'm OK with this change, but note, it wasn't just the hot path that I
disabled ftrace on lib for, but some of these calls are done very early
at boot up. It may have been PowerPC that I was stumbling over. The
issue is that they would call mcount before the kernel was mapped
properly, and the system would crash.

My PowerPC box no longer boots so I can't test this anymore. But a lot
has changed since 2008, and all this may very well be OK.

-- Steve
