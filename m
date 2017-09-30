From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] crypto: ccp: Build the AMD secure processor driver only
 with AMD CPU support
Date: Sat, 30 Sep 2017 17:53:20 +0200
Message-ID: <20170930155320.3lcm5hgdttuvyrv3@pd.tnic>
References: <20170929151607.zn4lmdkyn25sczfg@pd.tnic>
 <20170929162322.47553-1-brijesh.singh@amd.com>
 <20170930083054.eeblfi65qpz2xop7@pd.tnic>
 <97fbfa26-48df-419d-cd41-1a34e6c5eff3@amd.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <97fbfa26-48df-419d-cd41-1a34e6c5eff3@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 30, 2017 at 09:06:26AM -0500, Brijesh Singh wrote:
> > diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> > index 627f3e61dcac..f58a6521270b 100644
> > --- a/drivers/crypto/ccp/Kconfig
> > +++ b/drivers/crypto/ccp/Kconfig
> > @@ -1,5 +1,6 @@
> >  config CRYPTO_DEV_CCP_DD
> >  	tristate "Secure Processor device driver"
> > +	depends on CPU_SUP_AMD
> 
> Please note that ccp.ko is built on both x86 and aarch64 (AMD Seattle)
> architectures. I have not looked into details but I thought CPU_SUP_AMD
> is x64 specific config. I will look into it and verify that we don't
> break AMD Seattle platform builds.

Ah, then I guess that line needs to be:

	depends on CPU_SUP_AMD || ARM64

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
