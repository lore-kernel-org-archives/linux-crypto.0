From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.2 12.2/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Fri, 13 Oct 2017 00:22:02 +0200
Message-ID: <20171012222202.qvso6kyvetbt4oco@pd.tnic>
References: <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171011165030.115696-1-brijesh.singh@amd.com>
 <20171012140816.6siefvahj6ww7uzf@pd.tnic>
 <622585ce-c575-29ff-0484-404b7cf684fc@amd.com>
 <20171012214120.upn2set2gichsejq@pd.tnic>
 <69a807a3-770a-662d-9cf0-25fad035a323@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56879 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755857AbdJLWWQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 18:22:16 -0400
Content-Disposition: inline
In-Reply-To: <69a807a3-770a-662d-9cf0-25fad035a323@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 12, 2017 at 04:52:32PM -0500, Brijesh Singh wrote:
> See my above comment, I think the simplest solution is remove psp->sev_misc

Ok, so far so good.

But now you still need to track which is the last psp device and to call
misc_deregister() only when the last device exits. Because if you do
that for the first psp device as it is now, all the following devices
will see a deregistered misc device. And I don't think we want that.

You probably could do something with reference counting: Documentation/kref.txt
to track that and have the last device deregister the misc device.

Or have the "enclosing" sp-dev deregister the misc device when it is
exiting and when it is sure that there are no more psp devices...

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
