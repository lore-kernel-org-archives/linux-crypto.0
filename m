From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/7] x86, boot, LLVM: Use regparm=0 for memcpy and memset
Date: Fri, 17 Mar 2017 13:08:55 +0100
Message-ID: <20170317120855.zwqame63yvy5afhg@hirez.programming.kicks-ass.net>
References: <20170317001520.85223-1-md@google.com>
 <20170317001520.85223-6-md@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Matthias Kaehlcke <mka@chromium.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Michael Davidson <md@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbdCQMJy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2017 08:09:54 -0400
Content-Disposition: inline
In-Reply-To: <20170317001520.85223-6-md@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 16, 2017 at 05:15:18PM -0700, Michael Davidson wrote:
> Use the standard regparm=0 calling convention for memcpy and
> memset when building with clang.
> 
> This is a work around for a long standing clang bug
> (see https://llvm.org/bugs/show_bug.cgi?id=3997) where
> clang always uses the standard regparm=0 calling convention
> for any implcit calls to memcpy and memset that it generates
> (eg for structure assignments and initialization) even if an
> alternate calling convention such as regparm=3 has been specified.

Seriously, fix LLVM already.
