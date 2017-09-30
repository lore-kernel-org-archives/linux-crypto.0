From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v4 05/29] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Sat, 30 Sep 2017 18:11:04 +0200
Message-ID: <20170930161104.452sia6a5y5duyn4@pd.tnic>
References: <20170919204627.3875-1-brijesh.singh@amd.com>
 <20170919204627.3875-6-brijesh.singh@amd.com>
 <20170929151607.zn4lmdkyn25sczfg@pd.tnic>
 <1fc76eee-f25b-cd38-cc8d-0404ec94cf79@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1fc76eee-f25b-cd38-cc8d-0404ec94cf79@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 30, 2017 at 10:55:25AM -0500, Brijesh Singh wrote:
> CRYPTO_DEV_CCP_DD is supported on aarch64 and x86. Whereas the PSP
> interface I am adding is available on x86 only hence its safe to add add
> depend on CPU_SUP_AMD for CRYPTO_DEV_SP_PSP.

I think just from having CRYPTO_DEV_CCP_DD depend on CPU_SUP_AMD ||
ARM64, CRYPTO_DEV_SP_PSP gets almost the same dependency transitively.
But sure, let's make the PSP build only on x86. It should depend on
X86_64, to be precise.

> Yes its very much possible. The SEV FW provides two sets of commands 1)
> platform certificate management and 2) guest management
> 
> The platform certificate management commands is used outside the
> CONFIG_KVM_AMD.

Ok, please state that in the commit message so that it is written down
somewhere.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
