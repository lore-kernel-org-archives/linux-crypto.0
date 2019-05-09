Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D2BC04AB1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 17:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20A3F21783
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 17:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557424707;
	bh=YiJk2tcPpKphUTjpD3Gqc+Ugt+DTuVzY4k6rDbHx4ik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hCwmHrBy75We7+t62BtD+p03Li9FrAoUfRCVIJDmu+2aLq3V2QJNlQNK4T0z3sT9b
	 Gay+kiHLcXDhPNVcOauT1paUWfjiGti6Yqn+ppCUwWT/2vau7V9N75w/3PfRePULmi
	 EGo+pU1naHe/mbQu2RbFSnJJQeL8D5vMta4dRZFk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbfEIR60 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 May 2019 13:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfEIR6Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 May 2019 13:58:25 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A1B72085A;
        Thu,  9 May 2019 17:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557424705;
        bh=YiJk2tcPpKphUTjpD3Gqc+Ugt+DTuVzY4k6rDbHx4ik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kLhYb3t9rHIfD5eNfgXKr9ZSLJTKa3rk6SclZMQQB3lM2zCM0vL9nE4oAc1cajvTV
         PJ8k9vHRyJn24LkV6GhhVH3FNf/EoPLmMsykM3aksm+WQ9MuKJy3W8ZxLRyaW0DF4Q
         7ScecLU+GXWKWbA+r+6GIzaspWZSDKK3nTgstZ0Y=
Date:   Thu, 9 May 2019 10:58:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Joao Moreira <jmoreira@suse.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Message-ID: <20190509175822.GB12602@gmail.com>
References: <20190507161321.34611-1-keescook@chromium.org>
 <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain>
 <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
 <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
 <20190509020439.GB693@sol.localdomain>
 <20190509153828.GA261205@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509153828.GA261205@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 09, 2019 at 08:38:28AM -0700, Sami Tolvanen wrote:
> On Wed, May 08, 2019 at 07:04:40PM -0700, Eric Biggers wrote:
> > And I also asked whether indirect calls to asm code are even allowed
> > with CFI. IIRC, the AOSP kernels have been patched to remove them from
> > arm64
> 
> At least with clang, indirect calls to stand-alone assembly functions
> trip CFI checks, which is why Android kernels use static inline stubs
> to convert these to direct calls instead.
> 
> Sami

Thanks Sami.  Is there any way to annotate assembly functions such that they
work directly with CFI?  Otherwise, we need the wrapper functions.

Kees and Joao, it would be helpful if you'd explain this in the patchset.

- Eric
