From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.6/31] crypto: ccp: Implement SEV_PDH_GEN
 ioctl command
Date: Thu, 12 Oct 2017 22:23:33 +0200
Message-ID: <20171012202333.zaqqcn2ktev33uyz@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-6-brijesh.singh@amd.com>
 <20171012184810.klt6tctvlgbnuc4m@pd.tnic>
 <d4be8769-405e-d607-7bd9-ecfe3a48f646@amd.com>
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
Received: from mx2.suse.de ([195.135.220.15]:49824 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752767AbdJLUXk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 16:23:40 -0400
Content-Disposition: inline
In-Reply-To: <d4be8769-405e-d607-7bd9-ecfe3a48f646@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 12, 2017 at 03:21:04PM -0500, Brijesh Singh wrote:
> We need to follow the platform state machine logic defined in SEV spec
> section 5.1.2. The PEK_GEN can not be issued when platform is in WORKING
> state because the command actually re-generate the identity of the
> platform itself (in other words re-generate the Platform Endorsement
> Key). Whereas, the PDH_GEN command is used for re-generating Platform
> Diffie-Hellman Key which can be changed while the guest is running.

I see.

So the proposition to carve out and split the platform *init commands
might come in handy here too...

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
