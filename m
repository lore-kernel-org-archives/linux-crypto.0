Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF3DC0018C
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 19:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B467239FE
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 19:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbgLSTAC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Dec 2020 14:00:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727330AbgLSTAA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Dec 2020 14:00:00 -0500
X-Gm-Message-State: AOAM53233YyWxD3V30idHIGkT9JuC0dq248PivZQadToZe2OIk7Ws5R0
        NDDxgIWvxAI4cZK4sufph8XvVPHFAdbEm7LU1M08Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608404359;
        bh=B4eZS0fBD7ANLQq4VCLFVYSZSIGJI1aDHNTXq9ib300=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gxZP1XPMESkwIdap2FsenIe/y1FPGouFYHQkH3QN7YZ1q4na9ipLAtaqxeLeEyqJt
         U/GGJc+XeA0rhsF1x9nXYSc5K76lWWp23HJnSYfMsd2iTHs2ohKoQWtAvYzRC7115o
         +NhSy1I+RLx8dAroYA544sHsOoCTWigtgl9s02MxLn+8yT2NhsM4YHv0jOLRc88zVu
         SOWK865a8/Suqa7ivItY+1vBnL00fmkZm+96Ko0eEaufBYVkBR8SGhAtKnaCD6HzaG
         cW42EKtr1XcKkrkohY4K9UqtV14znXM0XajNmKzD8hm22023qFbXB7map55bH1mrWJ
         BYHRnl7vCYf0w==
X-Google-Smtp-Source: ABdhPJwSMnLS4j1gMZXFBUmn0p3sEfr+b5TEKCpYtLLiW6htQPSyFqPbrYVUOP28/AGvPZFksWxhJTGEynBEotKoVGs=
X-Received: by 2002:a5d:43c3:: with SMTP id v3mr10389136wrr.184.1608404357517;
 Sat, 19 Dec 2020 10:59:17 -0800 (PST)
MIME-Version: 1.0
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
In-Reply-To: <20201216174146.10446-1-chang.seok.bae@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 19 Dec 2020 10:59:07 -0800
X-Gmail-Original-Message-ID: <CALCETrW+3xW8TfLp84VHFB4K7c3m+jLu+fmku6EOSe+QGJAJxQ@mail.gmail.com>
Message-ID: <CALCETrW+3xW8TfLp84VHFB4K7c3m+jLu+fmku6EOSe+QGJAJxQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] x86: Support Intel Key Locker
To:     "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        Andrew Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>, ning.sun@intel.com,
        kumar.n.dwarakanath@intel.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 16, 2020 at 9:46 AM Chang S. Bae <chang.seok.bae@intel.com> wrote:
>
> Key Locker [1][2] is a new security feature available in new Intel CPUs to
> protect data encryption keys for the Advanced Encryption Standard
> algorithm. The protection limits the amount of time an AES key is exposed
> in memory by sealing a key and referencing it with new AES instructions.

I think some fundamental issues need to be worked out before we can
enable key locker upstream at all.

First, how fast is LOADIWKEY?  Does it depend on the mode?  Is it
credible to context switch the wrapping key?

First, on bare metal, we need to decide whether to use a wrapping key
or a software-provided wrapping key.  Both choices have pros and cons,
and it's not clear to me whether Linux should have a boot-time
parameter, a runtime control, a fixed value, or something else.  If we
use a random key, we need to figure out what to do about S5 and
hibernation.  No matter what we do, we're going to have some issues
with CRIU.

We also need to understand the virtualization situation.  What do we
expect hypervisors to do with Key Locker?  The only obviously
performant way I can see for VMMs to support migration is to use the
same wrapping key fleetwide.  (This is also the only way I can see for
VMMs to manage the wrapping key in a way that a side channel can't
extract it from hypervisor memory.)  But VMMs can't do this without
some degree of cooperation from the guest.  Perhaps we should disable
KL if CPUID.HYPERVISOR is set for now?

It's a shame that the spec seems to have some holes in the key
management mechanisms.  It would be very nice if there was a way to
load IWKey from an SGX enclave, and it would also be nice if there was
a way to load an IWKey that is wrapped by a different key.  Also, for
non-random IWKey values, there doesn't seem to be a way for software
(in an enclave or otherwise) to confirm that it's wrapping an AES key
against a particular wrapping key, which seems to severely limit the
ability to safely provision a new wrapped key at runtime.

--Andy
