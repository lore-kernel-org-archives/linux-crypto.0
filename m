From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6.1 16/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Tue, 31 Oct 2017 11:39:28 +0100
Message-ID: <20171031103928.nl6v4bps3sajolft@pd.tnic>
References: <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171029204825.18260-1-brijesh.singh@amd.com>
 <20171030172150.3eibiqr44i43zbvd@pd.tnic>
 <1e89d599-b1d2-bb16-92f4-0409ee0a6ea0@amd.com>
 <20171030175708.3w3sfzbtqdvmqs62@pd.tnic>
 <de5d7e77-56d0-8cbc-1dcb-01cf3f0daeb4@amd.com>
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
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <de5d7e77-56d0-8cbc-1dcb-01cf3f0daeb4@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 30, 2017 at 08:29:25PM -0500, Brijesh Singh wrote:
> Okay, Just tried static global with CONFIG_VMAP_STACK=y and I am getting
> wrong physical address with __pa. PSP command fails with error code
> "INVALID_ADDRESS". The same thing works fine with kmalloc() buffer.

Ah, right, module space is vmalloc-ed.

> To avoid repeated k*alloc calls, I could devm_kzalloc() these variable 
> during sev_init() and reuse them when needed.

Yap, something like that.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
