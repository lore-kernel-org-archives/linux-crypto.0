From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.2 12.2/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 12 Oct 2017 23:41:20 +0200
Message-ID: <20171012214120.upn2set2gichsejq@pd.tnic>
References: <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171011165030.115696-1-brijesh.singh@amd.com>
 <20171012140816.6siefvahj6ww7uzf@pd.tnic>
 <622585ce-c575-29ff-0484-404b7cf684fc@amd.com>
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
In-Reply-To: <622585ce-c575-29ff-0484-404b7cf684fc@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 12, 2017 at 04:11:18PM -0500, Brijesh Singh wrote:
> The sev_exit() will be called for all the psp_device instance. we need
> to set psp_misc_dev = NULL after deregistering the device.
> 
> if (psp_misc_dev) {
>   misc_deregister(psp_misc_dev);
>    psp_misc_dev = NULL;

Right, except we assign that misc device to every psp device:

	psp->sev_misc = psp_misc_dev;

so the question now is, how do you want this to work: the misc device
should be destroyed after the last psp device is destroyed or how?

Because after the first:

	psp_misc_dev = NULL;

the respective psp->sev_misc will still keep references to that device
but the device itself will be already deregistered. And that sounds
strange.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
