From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 16/38] crypto: ccp: Implement SEV_PEK_GEN ioctl
 command
Date: Mon, 23 Oct 2017 14:32:23 +0200
Message-ID: <20171023123223.GA24208@nazgul.tnic>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-17-brijesh.singh@amd.com>
 <20171023093240.GC19523@nazgul.tnic>
 <ad140f6b-4e9d-7044-5e45-0c434511cb1a@amd.com>
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
In-Reply-To: <ad140f6b-4e9d-7044-5e45-0c434511cb1a@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 23, 2017 at 07:15:30AM -0500, Brijesh Singh wrote:
> I am not sure if I am able to understand your feedback. The
> sev_platform_shutdown() is called unconditionally.

How's that:

If sev_do_cmd() fails and sev_do_cmd(SEV_CMD_SHUTDOWN, ...) in
sev_platform_shutdown() fails, then the first ret from sev_do_cmd() is
gone.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
