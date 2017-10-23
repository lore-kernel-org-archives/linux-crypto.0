From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 16/38] crypto: ccp: Implement SEV_PEK_GEN ioctl
 command
Date: Mon, 23 Oct 2017 08:32:57 -0500
Message-ID: <66c9f41e-868e-0d14-aaec-0858753c86d4@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-17-brijesh.singh@amd.com>
 <20171023093240.GC19523@nazgul.tnic>
 <ad140f6b-4e9d-7044-5e45-0c434511cb1a@amd.com>
 <20171023123223.GA24208@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171023123223.GA24208@nazgul.tnic>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/23/17 7:32 AM, Borislav Petkov wrote:
> On Mon, Oct 23, 2017 at 07:15:30AM -0500, Brijesh Singh wrote:
>> I am not sure if I am able to understand your feedback. The
>> sev_platform_shutdown() is called unconditionally.
> How's that:
>
> If sev_do_cmd() fails and sev_do_cmd(SEV_CMD_SHUTDOWN, ...) in
> sev_platform_shutdown() fails, then the first ret from sev_do_cmd() is
> gone.

If both the command fails then we return status from the last command.
IIRC, in my previous patches I was returning status from sev_do_cmd()
instead of sev_platform_shutdown() but based on our previous
communication I thought you asked to return the status from the last
failed command. Did I miss understood ?

-Brijesh
