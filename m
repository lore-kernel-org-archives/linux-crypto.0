From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 16/38] crypto: ccp: Implement SEV_PEK_GEN ioctl
 command
Date: Mon, 23 Oct 2017 16:10:32 +0200
Message-ID: <20171023141032.GC3044@nazgul.tnic>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-17-brijesh.singh@amd.com>
 <20171023093240.GC19523@nazgul.tnic>
 <ad140f6b-4e9d-7044-5e45-0c434511cb1a@amd.com>
 <20171023123223.GA24208@nazgul.tnic>
 <66c9f41e-868e-0d14-aaec-0858753c86d4@amd.com>
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
In-Reply-To: <66c9f41e-868e-0d14-aaec-0858753c86d4@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 23, 2017 at 08:32:57AM -0500, Brijesh Singh wrote:
> If both the command fails then we return status from the last command.
> IIRC, in my previous patches I was returning status from sev_do_cmd()
> instead of sev_platform_shutdown() but based on our previous
> communication I thought you asked to return the status from the last
> failed command. Did I miss understood ?

So my problem is that it looks strange that you save an error value from
sev_do_cmd() but you don't look at it. And as I said in the other mail,
you should either ignore it and say so in a comment why it is OK to
ignore it or handle it but not overwrite it without looking at it.

Does that make more sense?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
