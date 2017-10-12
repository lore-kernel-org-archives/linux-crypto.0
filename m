From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.5/31] crypto: ccp: Implement SEV_PEK_GEN
 ioctl command
Date: Thu, 12 Oct 2017 22:21:52 +0200
Message-ID: <20171012202152.dzlzka7vmojcxu6q@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-5-brijesh.singh@amd.com>
 <20171012182844.kjv5zab7o6fwwwdk@pd.tnic>
 <e2a67da0-5442-f9d6-6390-bfbb0a352639@amd.com>
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
In-Reply-To: <e2a67da0-5442-f9d6-6390-bfbb0a352639@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 12, 2017 at 03:11:07PM -0500, Brijesh Singh wrote:
> Lets  consider this scenario
> 1- platform is in uninit state, we transition it to INIT
> 2- PEK_GEN command failed
> 3- since we have transitioned the platform in INIT state hence we must
> call the shutdown otherwise we will leave the system in wrong state. The
> shutdown command will most probably succeed and we will look the ret value

Sure but what do you do if the main command, i.e., PEK_GEN succeeds but
the shutdown command fails?

You probably should carve out the whole shutdown order in separate
functions. I mean, the sequences do repeat in a couple of functions so
you could do:

ioctl:

	case <CMD>:

		init_platform()
		do_main_cmd()
		shutdown_platform()
	break;

and this way you have everything nicely separated and retvals properly
tracked...

Hmmm?

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
