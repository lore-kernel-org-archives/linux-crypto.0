From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.4/31] crypto: ccp: Implement
 SEV_PLATFORM_STATUS ioctl command
Date: Wed, 11 Oct 2017 22:04:44 +0200
Message-ID: <20171011200444.3njniblsvxn2vhl6@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-4-brijesh.singh@amd.com>
 <20171011170205.qpu677qiqe4ludwm@pd.tnic>
 <c75e2be7-117f-299b-2c83-7160f78cba7e@amd.com>
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
In-Reply-To: <c75e2be7-117f-299b-2c83-7160f78cba7e@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 11, 2017 at 02:49:55PM -0500, Brijesh Singh wrote:
> This is OK for now. But in future if FW steals another bit from reserved1
> field to expose a new flag then 'owner' name will no longer be valid. If you
> don't to use bit field then we have to use some generic name instead of
> naming the field as 'owner'. Please note that its not just userspace, KVM
> driver also uses the same fields and it may also need to know which bit
> position to use.

So what is this field called in the spec?

> This is a tricky one. The 32-bit are packed as:
> 
> BIT0 - config.es
> BIT1-23: reserved
> BIT24-31: build

Is that what the firmware gives?

Then it is easy:

	<firmware_field_name> &= GENMASK(23, 1);

and then userspace can pick apart bit 0 and bit24-31.

Just use one raw struct which the firmware gives you and the rest is
done by the sw. Like clearing reserved fields before copying to user.

You don't want to be updating that struct layout later: think of old
qemu with new kernel and all those different configurations.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
