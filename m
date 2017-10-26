From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 26 Oct 2017 19:44:27 +0200
Message-ID: <20171026174427.GB29782@nazgul.tnic>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171023092020.GB19523@nazgul.tnic>
 <f58e72e5-8636-2abb-99e9-c58f462463e7@amd.com>
 <20171026135614.GA12359@nazgul.tnic>
 <9258d8e7-b185-01d2-be92-d7d2820c7eb6@amd.com>
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
Received: from mail.skyhub.de ([5.9.137.197]:50368 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932309AbdJZRo0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 13:44:26 -0400
Content-Disposition: inline
In-Reply-To: <9258d8e7-b185-01d2-be92-d7d2820c7eb6@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 26, 2017 at 11:56:57AM -0500, Brijesh Singh wrote:
> The variable is used as ref counter.

... and it can't be converted to a boolean because...?

> In your previous reply you comments on global semaphore (fw_init_mutex) and
> in response I tried to highlight why we need the global semaphore. Did I
> misunderstood your comment ?

Yes, what happens if you get preempted while holding the mutex? Will the other
process be able to do anything?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
