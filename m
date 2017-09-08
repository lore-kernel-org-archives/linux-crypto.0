From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part2 PATCH v3 02/26] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Fri, 8 Sep 2017 10:22:31 +0200
Message-ID: <20170908082231.k2sv65nemmpnyad6@pd.tnic>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-3-brijesh.singh@amd.com>
 <20170907142737.g4aot7xatyopdfwp@pd.tnic>
 <9de7139f-676e-e671-13a1-cbc5170cc816@amd.com>
 <54fe8467-0fba-d4a8-84d4-ecd62299a53b@amd.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54fe8467-0fba-d4a8-84d4-ecd62299a53b@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 07, 2017 at 06:15:55PM -0500, Gary R Hook wrote:
> I would prefer that we not shorten this. The prior incarnation,
> ccp_alloc_struct(), has/had been around for a while. And there are a
> number of similarly named allocation functions in the driver that we
> like to keep sorted. If anything, it should be more explanatory, IMO.

Well, looks like an AMD practice:

$ git grep --name-only alloc_struct
drivers/crypto/ccp/ccp-dev.c
drivers/crypto/ccp/ccp-dev.h
drivers/crypto/ccp/psp-dev.c
drivers/crypto/ccp/sev-dev.c
drivers/crypto/ccp/sp-dev.c
drivers/crypto/ccp/sp-dev.h
drivers/crypto/ccp/sp-pci.c
drivers/crypto/ccp/sp-platform.c
drivers/gpu/drm/amd/amdkfd/kfd_dbgmgr.c
drivers/gpu/drm/amd/amdkfd/kfd_priv.h
drivers/gpu/drm/amd/amdkfd/kfd_topology.c

But whatever, if you like it more that way... :)

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
