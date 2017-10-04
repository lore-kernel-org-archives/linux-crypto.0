From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 Patch v4.2] crypto: ccp: Add Platform Security Processor
 (PSP) device support
Date: Wed, 4 Oct 2017 11:15:53 +0200
Message-ID: <20171004091553.n4judraxqbravx6v@pd.tnic>
References: <20170919204627.3875-6-brijesh.singh@amd.com>
 <20171002164344.12750-1-brijesh.singh@amd.com>
 <nycvar.YSQ.7.76.1710041202020.19122@wniryva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: P J P <ppandit@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <nycvar.YSQ.7.76.1710041202020.19122@wniryva>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 04, 2017 at 12:06:42PM +0530, P J P wrote:
> Needs to kfree(sp->psp_data) before setting to NULL.

Not if it is allocated with devm_kzalloc().

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
