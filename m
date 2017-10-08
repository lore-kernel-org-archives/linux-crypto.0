From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.1/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Sun, 8 Oct 2017 16:00:20 +0200
Message-ID: <20171008140019.flvyovgq2xpqdcoq@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007184049.jrbxebb4jlciu3hj@pd.tnic>
 <c6ec79f7-5192-8ed3-4df3-260c09ceccb9@amd.com>
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
In-Reply-To: <c6ec79f7-5192-8ed3-4df3-260c09ceccb9@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 08, 2017 at 08:30:47AM -0500, Brijesh Singh wrote:
> During the device probe, sev_ops_init() will be called for every device
> instance which claims to support the SEV.  One of the device will be
> 'master' but we don't the master until we probe all the instances. Hence
> the probe for all SEV devices must return success.

I still am wondering whether that design with multiple devices - master
and non-master devices is optimal. Why isn't the security processor a
single driver which provides the whole functionality, PSP including? Why
do you need all that register and unregister glue and get_master bla if
you can simply put the whole thing in a single module?

And the fact that you need a global variable to mark that you've
registered the misc device should already tell you that something's
not optimal. Because if you had a single driver, it will go, detect
the whole functionality, initialize it, register services and be done
with it. No registering of devices, no finding of masters, no global
variables, no unnecessary glue.

IOW, in this diagram:

         +--- CCP
         |
AMD-SP --|
         |            +--- SEV
         |            |
         +---- PSP ---*
                      |
                      +---- TEE

why isn't the whole PSP functionality part of drivers/crypto/ccp/sp-dev.c ?

That driver is almost barebones minimal thing. You can very well add the
PSP/SEV stuff in there and if there's an *actual* reason to carve pieces
out, only then to do so, not to split it now unnecessarily and make your
life complicated for no reason.

Or am I missing some obvious and important reason?

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
