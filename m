Return-Path: <SRS0=kAoH=D5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F380C55179
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Oct 2020 16:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BA29241A3
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Oct 2020 16:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896819AbgJVQUj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Oct 2020 12:20:39 -0400
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:59308 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2896796AbgJVQUj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Oct 2020 12:20:39 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 5284912EE;
        Thu, 22 Oct 2020 16:20:38 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: juice98_4f032d527252
X-Filterd-Recvd-Size: 2328
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Thu, 22 Oct 2020 16:20:35 +0000 (UTC)
Message-ID: <133aa0c8c5e2cbc862df109200b982e89046dbc0.camel@perches.com>
Subject: Re: [PATCH -next] treewide: Remove stringification from __alias
 macro definition
From:   Joe Perches <joe@perches.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Date:   Thu, 22 Oct 2020 09:20:34 -0700
In-Reply-To: <20201022073307.GP2628@hirez.programming.kicks-ass.net>
References: <e9b1ba517f06b81bd24e54c84f5e44d81c27c566.camel@perches.com>
         <20201022073307.GP2628@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2020-10-22 at 09:33 +0200, Peter Zijlstra wrote:
> On Wed, Oct 21, 2020 at 11:58:25AM -0700, Joe Perches wrote:
> > Like the __section macro, the __alias macro uses
> > macro # stringification to create quotes around
> > the section name used in the __attribute__.
> > 
> > Remove the stringification and add quotes or a
> > stringification to the uses instead.
> 
> There's a complete lack of rationale for this change.

I'll eventually post V2.
I'm waiting to see if there are more comments.

As I wrote in reply to Ard:

https://lore.kernel.org/lkml/1cecfbfc853b2e71a96ab58661037c28a2f9280e.camel@perches.com/

Using quotes in __section caused/causes differences
between clang and gcc.

https://lkml.org/lkml/2020/9/29/2187

Using common styles for details like this is good.

