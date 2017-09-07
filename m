From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part2 PATCH v3 02/26] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Thu, 7 Sep 2017 12:34:16 +0200
Message-ID: <20170907103416.zie7aeammnapk6kr@pd.tnic>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-3-brijesh.singh@amd.com>
 <20170906170029.bvpii7e7x3fglhwt@pd.tnic>
 <e32a7c0b-5985-e600-6ac2-f6ce48ad530d@amd.com>
 <20170906204606.f34esvg464ynsrjn@pd.tnic>
 <58daec6d-4c37-ff7f-1473-8ec64f0a9f3a@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?XCJSYWRpbSBLcsSNbcOhxZlcIg==?= <rkrcmar@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42248 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754048AbdIGKea (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2017 06:34:30 -0400
Content-Disposition: inline
In-Reply-To: <58daec6d-4c37-ff7f-1473-8ec64f0a9f3a@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 06, 2017 at 04:26:52PM -0500, Gary R Hook wrote:
> They were included in a pull request (for 4.14) from Herbert, dated Monday.

Right. I rebased the SEV pile ontop of latest upstream and now it applies much
better:

checking file drivers/crypto/ccp/Kconfig
Hunk #1 succeeded at 32 (offset 1 line).
checking file drivers/crypto/ccp/Makefile
checking file drivers/crypto/ccp/psp-dev.c
checking file drivers/crypto/ccp/psp-dev.h
checking file drivers/crypto/ccp/sp-dev.c
Hunk #3 succeeded at 225 (offset 1 line).
Hunk #4 FAILED at 243.
1 out of 4 hunks FAILED
checking file drivers/crypto/ccp/sp-dev.h
Hunk #1 succeeded at 42 with fuzz 2 (offset 1 line).
Hunk #2 succeeded at 75 (offset 1 line).
Hunk #3 succeeded at 114 (offset 1 line).
Hunk #4 succeeded at 143 (offset 1 line).
checking file drivers/crypto/ccp/sp-pci.c

The failed hunk is due to #ifdef CONFIG_PM guards but that's trivial to fix.

Thanks.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
