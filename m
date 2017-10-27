From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Fri, 27 Oct 2017 09:56:50 +0200
Message-ID: <20171027075650.GA1276@nazgul.tnic>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171023092020.GB19523@nazgul.tnic>
 <f58e72e5-8636-2abb-99e9-c58f462463e7@amd.com>
 <20171026135614.GA12359@nazgul.tnic>
 <9258d8e7-b185-01d2-be92-d7d2820c7eb6@amd.com>
 <20171026174427.GB29782@nazgul.tnic>
 <bc7254d3-a2d9-e3fd-02a4-164d5e4fb545@amd.com>
 <20171026201322.GA32181@nazgul.tnic>
 <89f4ec21-e31e-18f2-27c5-946c38cd128d@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.skyhub.de ([5.9.137.197]:44970 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751158AbdJ0H4s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2017 03:56:48 -0400
Content-Disposition: inline
In-Reply-To: <89f4ec21-e31e-18f2-27c5-946c38cd128d@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 26, 2017 at 03:59:32PM -0500, Brijesh Singh wrote:
> we can workaround #1 by adding some hooks in sp_pci_init() to invoke the PSP
> initialization routines after pci_register_driver() is done but #2 can get
> painful because it will require us calling the SHUTDOWN outside the
> sp_pci_exit() code flow.

Ok, do that and init the PSP master and then put the device in UNINIT
state only in the functions which execute those commands which need the
device to be in UNINIT state, e.g., wrap the SEV_CMD_FACTORY_RESET glue
in a command function which does put the device in the UNINIT state as a
first step.

Then, when that function is done, put the device in the mode which the
other commands would expect it to be in, e.g., INIT state.

This way you'll simplify the whole command flow considerably and won't
have to "toggle" the device each time and will save yourself a lot of
time on command execution.

Thx.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
