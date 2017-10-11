From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.4/31] crypto: ccp: Implement
 SEV_PLATFORM_STATUS ioctl command
Date: Wed, 11 Oct 2017 22:54:07 +0200
Message-ID: <20171011205407.qky5tr2jmjttse7g@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-4-brijesh.singh@amd.com>
 <20171011170205.qpu677qiqe4ludwm@pd.tnic>
 <c75e2be7-117f-299b-2c83-7160f78cba7e@amd.com>
 <20171011200444.3njniblsvxn2vhl6@pd.tnic>
 <cd9e71bc-5187-fc88-ad80-4aa171370af6@amd.com>
 <20171011202836.d3ur3ndrnea25ywi@pd.tnic>
 <e3da0e38-b6e6-2db0-3adf-205f99c68808@amd.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33561 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752862AbdJKUyN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2017 16:54:13 -0400
Content-Disposition: inline
In-Reply-To: <e3da0e38-b6e6-2db0-3adf-205f99c68808@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 11, 2017 at 03:45:00PM -0500, Brijesh Singh wrote:
> OK, if userspace is going to pick bits apart then how about this:
> 
>  struct sev_data_status {
>          u8 api_major;                           /* Out */
>          u8 api_minor;                           /* Out */
>          u8 state;                               /* Out */
>          u32 flags;                              /* Out */
>          u8 build;                               /* Out */

I guess. Except the spec marks those as 31:24 and belonging to the dword
starting at offset 4 and you've made "build" a separate u8 and the dword
starts at offset 3. I mean, not a big deal, I think you can change the
spec for a change :-)

Because it looks like the 4 bytes starting at offset 3 really are meant
for miscellaneous bits. And then CONFIG.ES could've been bit 1 of the
byte at offset 3. Oh well...

> Please let me know if you are okay with my above structure.

But yeah, in the end of the day it probably doesn't matter a whole lot.
The spec just counts those in 32-bit quantities.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
