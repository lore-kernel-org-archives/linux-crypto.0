From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.4/31] crypto: ccp: Implement
 SEV_PLATFORM_STATUS ioctl command
Date: Wed, 11 Oct 2017 22:28:36 +0200
Message-ID: <20171011202836.d3ur3ndrnea25ywi@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-4-brijesh.singh@amd.com>
 <20171011170205.qpu677qiqe4ludwm@pd.tnic>
 <c75e2be7-117f-299b-2c83-7160f78cba7e@amd.com>
 <20171011200444.3njniblsvxn2vhl6@pd.tnic>
 <cd9e71bc-5187-fc88-ad80-4aa171370af6@amd.com>
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
In-Reply-To: <cd9e71bc-5187-fc88-ad80-4aa171370af6@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 11, 2017 at 03:10:49PM -0500, Brijesh Singh wrote:
> The current 'struct sev_data_status' matches with the firmware names and the
> bit fields. Only thing I did was the fields with no name is called as
> "reservedX"

Ok, I see it. So what you actually wanna do is:

struct sev_data_status {
        u8 api_major;                           /* Out */
        u8 api_minor;                           /* Out */
        u8 state;                               /* Out */
        u8 flags;                               /* Out */
        u32 config;                             /* Out */
        u32 guest_count;                        /* Out */
} __packed;

as this is exactly what the firwmare gives you. Theoretically, you
could've also done:

struct sev_data_status {
	u64 first_qword;
	u32 second_dword;
};

but you have the fields mostly defined already and that would be too
confusing.

What I mean is, once you've gotten the command buffer, then you can pick
fields apart in software.

	owner	  = status.flags & 1;
	config_es = status.config & 1;
	build	  = (status.config >> 24) & 0xff;

This way, if new fields get added, you don't have to change the struct
definitions - *especially* if they're visible to userspace - and users
of that struct can be extended to understand the new fields.

And before you copy the struct to userspace, you can simply clear out
the reserved fields as nothing should rely on them having a particular
value, because, well, they're reserved, doh.

Makes sense?

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
