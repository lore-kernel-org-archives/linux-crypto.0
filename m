From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 26 Oct 2017 22:13:22 +0200
Message-ID: <20171026201322.GA32181@nazgul.tnic>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171023092020.GB19523@nazgul.tnic>
 <f58e72e5-8636-2abb-99e9-c58f462463e7@amd.com>
 <20171026135614.GA12359@nazgul.tnic>
 <9258d8e7-b185-01d2-be92-d7d2820c7eb6@amd.com>
 <20171026174427.GB29782@nazgul.tnic>
 <bc7254d3-a2d9-e3fd-02a4-164d5e4fb545@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bc7254d3-a2d9-e3fd-02a4-164d5e4fb545@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 26, 2017 at 02:26:15PM -0500, Brijesh Singh wrote:
> SHUTDOWN command unconditionally transitions a platform to uninitialized
> state. The command does not care how many processes are actively using the
> PSP. We don't want to shutdown the firmware while other process is still
> using it.

So why do you have to init and shutdown the PSP each time you execute a
command? Why isn't the PSP initialized, *exactly* *once* at driver init
and shut down, also exactly once at driver exit?

> If other process tries to issue the sev_platform_init/shutdown() then they
> have to wait.

Exactly, and not what you said earlier:

"If process "A" calls sev_platform_init() and if it gets preempted due
to whatever reason then we don't want another process to issue the
shutdown command while process "A" is in middle of sev_platform_init()."

IOW, if your critical regions are protected properly by a mutex, nothing
like the above will happen.

But what you're trying to explain to me is that the fw_init_count is
going to prevent a premature shutdown when it is > 1. But that's not
what I meant...

Anyway, see my question above.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
