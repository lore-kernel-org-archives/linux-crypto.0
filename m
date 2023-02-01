Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E02EC38142
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Feb 2023 06:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjBAGzD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Feb 2023 01:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBAGzC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2023 01:55:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A134D1ABC6;
        Tue, 31 Jan 2023 22:54:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33D52B820E3;
        Wed,  1 Feb 2023 06:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5FDC433D2;
        Wed,  1 Feb 2023 06:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675234459;
        bh=KMtVzKmdPlrQIUHaXY0uBFlMTKi/xJ843BQMk9glniY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wly5c+fZHIaF4HwWcpKHwCgt9WVmBSJXE3Ak9cFw/nW187YoruMo39FTtOPs0TG9J
         j4ygeOopPRZ4NexqPAknlOgEbU38rjyWqpaXUYagHVdcvmwc03Xfr5OfEvcNTam30U
         Qjop95KIdM0NF7+9w0dw01dT7t5ah1pCCACkSWUfHg5uzQh1RoApvMMARtfrabmVB6
         iw3tf5AHTI72H6CQuBqvXmSWxOfPfHfSmzml1IY2WKZdgloZBIBkooK5Qvof4eD+XW
         OBkpUZcjPkSmc23PL82USP8dZZZpPxRoWwRz3gixLmY5up36+F4Zw/5u6sR2S9OwK5
         4J53/kezSfjUw==
Date:   Tue, 31 Jan 2023 22:54:17 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Roxana Bradescu <roxabee@chromium.org>,
        Adam Langley <agl@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] x86: enable Data Operand Independent Timing Mode
Message-ID: <Y9oMmYWzy7mlk3D9@sol.localdomain>
References: <20230125012801.362496-1-ebiggers@kernel.org>
 <14506678-918f-81e1-2c26-2b347ff50701@intel.com>
 <CAG48ez1NaWarARJj5SBdKKTYFO2MbX7xO75Rk0Q2iK8LX4BwFA@mail.gmail.com>
 <394c92e2-a9aa-37e1-7a34-d7569ac844fd@intel.com>
 <CAG48ez0ZK3pMqkto4DTZPNyddYcv8jPHQDNhYoFEPvSRLf80fQ@mail.gmail.com>
 <e37a17c4-8611-6d1d-85ad-fcd04ff285e1@intel.com>
 <Y9MAvhQYlOe4l2BM@gmail.com>
 <8b2771ce-9cfa-54cc-de6b-e80ce7af0a93@intel.com>
 <16e3217b-1561-51ea-7514-014e27240402@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16e3217b-1561-51ea-7514-014e27240402@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 31, 2023 at 02:48:05PM -0800, Dave Hansen wrote:
> We've been talking about this inside Intel.  Suffice to say that DOITM
> was not designed to be turned on all the time.  If software turns it on
> all the time, it won't accomplish what it was designed to do.

Why wouldn't it accomplish what it is designed to do?  Does it not actually
work?

> 
> The _most_ likely thing that's going to happen is that DOITM gets
> redefined to be much more limited in scope.  The current DOITM
> architecture is very broad, but the implementations have much more
> limited effects.  This means that the architecture can probably be
> constrained and still match the hardware that's out there today.  That's
> pure speculation (ha!) on my part.
>
> I think we should hold off on merging any DOITM patches until the dust
> settles.  As far as I know, there is no pressing practical reason to
> apply something urgently.
> 
> Any objections?

Does this mean that Intel will be restoring the data operand independent timing
guarantee of some instructions that have had it removed?  If so, which
instructions will still be left?

Also, given that the DOITM flag can only be set and cleared by the kernel, and
assuming that Linux won't support DOITM in any way yet (as you're recommending),
what should the developers of userspace cryptographic libraries do?  Does Intel
have a list of which instructions *already* have started having data operand
dependent timing on released CPUs, so that the existing security impact can be
assessed and so that developers can avoid using those instructions?

- Eric
