From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.1/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Tue, 10 Oct 2017 22:04:58 +0200
Message-ID: <20171010200458.3gz7akfewdrzkg46@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007184049.jrbxebb4jlciu3hj@pd.tnic>
 <c6ec79f7-5192-8ed3-4df3-260c09ceccb9@amd.com>
 <20171008140019.flvyovgq2xpqdcoq@pd.tnic>
 <7131ad30-6c07-16d5-8cfc-06d446a66dca@amd.com>
 <20171009152130.vo2lpwdvcs4lyb2l@pd.tnic>
 <9bee3ad7-2a2c-137f-1f2f-f6b0d4128474@amd.com>
 <203d7c39-0c14-ceda-a2e4-26f0b1ea198e@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <203d7c39-0c14-ceda-a2e4-26f0b1ea198e@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 10, 2017 at 01:43:22PM -0500, Tom Lendacky wrote:
> Maybe for the very first implementation we could do that and that was what
> was originally done for the CCP.  But as you can see the CCP does not have
> a set register offset between various iterations of the device and it can
> be expected the same will hold true for the PSP.  This just makes future
> changes easier in order to support newer devices.

Well, that's a simple switch-case statement which maps device iteration
to offset.

> I would prefer to keep things separated as they are.  The common code is
> one place and the pci/platform specific code resides in unique files. For
> sp-pci.c, it can be excluded from compilation if CONFIG_PCI is not defined
> vs. adding #ifdefs into sp-dev.c or sp.c.  The code is working nicely and,
> at least to me, seems easily maintainable this way.

But you do see that you're doing a bunch of unnecessary things during
probing. And all those different devices: SP, CCP, PSP, TEE and whatnot,
they're just too granulary and it is a bunch of registration code and
one compilation unit calling into the other for no good reason. Or at
least I don't see it.

> If we really want to avoid the extra calls during probing, etc.
> then we can take a closer look afterwards and determine what is the
> best approach taking into account the CCP and some of the other PSP
> functionality that is coming.

And that coming functionality won't make things easier - you'll most
likely have more things wanting to talk to more other things. But ok,
your call. Just note that changing things later is always harder.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
