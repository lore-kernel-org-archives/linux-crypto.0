From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 26 Oct 2017 15:56:14 +0200
Message-ID: <20171026135614.GA12359@nazgul.tnic>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171023092020.GB19523@nazgul.tnic>
 <f58e72e5-8636-2abb-99e9-c58f462463e7@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f58e72e5-8636-2abb-99e9-c58f462463e7@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 23, 2017 at 02:57:04PM -0500, Brijesh Singh wrote:
> Calling PLATFORM_GET_STATUS is not required, we can manage the state through
> a simple ref count variable. Issuing PSP commands will always be much more
> expensive compare to accessing a protected global variable.

What does "protected" mean here?

In any case, that variable can be a simple bool as you use it as such.

> I would prefer to avoid invoking PSP command if possible.
> Additionally, the global semaphore is still needed to serialize
> the sev_platform_init() and sev_platform_shutdown() from multiple
> processes. e.g If process "A" calls sev_platform_init() and if it gets
> preempted due to whatever reason then we don't want another process
> to issue the shutdown command while process "A" is in middle of
> sev_platform_init().

How? You're holding fw_init_mutex.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
