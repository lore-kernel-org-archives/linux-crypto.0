From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part2 PATCH v3 02/26] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Wed, 6 Sep 2017 22:46:06 +0200
Message-ID: <20170906204606.f34esvg464ynsrjn@pd.tnic>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-3-brijesh.singh@amd.com>
 <20170906170029.bvpii7e7x3fglhwt@pd.tnic>
 <e32a7c0b-5985-e600-6ac2-f6ce48ad530d@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?XCJSYWRpbSBLcsSNbcOhxZlcIg==?= <rkrcmar@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42465 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752584AbdIFUq3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2017 16:46:29 -0400
Content-Disposition: inline
In-Reply-To: <e32a7c0b-5985-e600-6ac2-f6ce48ad530d@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 06, 2017 at 03:38:38PM -0500, Brijesh Singh wrote:
> This bit of my struggle -- tip/master is not in sync with cryptodev-2.6 [1].

Aaha.

> In order to expand the CCP driver we need the following commits from the
> cryptodev-2.6
> 
> 57de3aefb73f crypto: ccp - remove ccp_present() check from device initialize
> d0ebbc0c407a crypto: ccp - rename ccp driver initialize files as sp device
> f4d18d656f88 crypto: ccp - Abstract interrupt registeration
> 720419f01832 crypto: ccp - Introduce the AMD Secure Processor device
> 970e8303cb8d crypto: ccp - Use devres interface to allocate PCI/iomap and cleanup
> 
> I cherry-picked these patches into tip/master before starting the SEV work.
> 
> Since these patches were already reviewed and accepted hence I did not include it
> in my RFC series. I am not sure what is best way to handle it. Should I include
> these patches in the series ? or just mention them in cover letter ? I am looking
> for suggestions on how to best communicate it. thanks

Right, so I'm assuming those will go upstream this merge window, no?

Because if so, the rest of your patches will apply, once Linus merges
them. I guess for the purposes of reviewing, I can cherrypick them too.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
