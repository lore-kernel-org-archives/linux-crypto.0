From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.1/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Wed, 11 Oct 2017 16:19:49 +0200
Message-ID: <20171011141949.z4blmu5wy5sooq4p@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007184049.jrbxebb4jlciu3hj@pd.tnic>
 <c6ec79f7-5192-8ed3-4df3-260c09ceccb9@amd.com>
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
Received: from mx2.suse.de ([195.135.220.15]:49504 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751386AbdJKOT5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2017 10:19:57 -0400
Content-Disposition: inline
In-Reply-To: <c6ec79f7-5192-8ed3-4df3-260c09ceccb9@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 08, 2017 at 08:30:47AM -0500, Brijesh Singh wrote:
> Basically we need some variable which is outside the per-device
> structure so that we don't end up creating multiple /dev/sev nodes. If
> needed, I think we can remove 'has_sev_fops' variable from struct
> psp_device if we decide to dynamic alloc 'struct miscdevice sev_misc' in
> struct psp_device. The 'has_sev_fops' is  mainly used in sev_exit(). If
> we decide to dynamic alloc sev_misc then in  sev_exit() we can use
> psp->sev_misc != NULL instead of psp->has_sev_ops.

Yap, that sounds better than an explicit variable.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
