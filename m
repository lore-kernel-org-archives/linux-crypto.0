From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Fri, 27 Oct 2017 23:49:49 +0200
Message-ID: <20171027214949.ixzairu5ueh4to4e@pd.tnic>
References: <20171026174427.GB29782@nazgul.tnic>
 <bc7254d3-a2d9-e3fd-02a4-164d5e4fb545@amd.com>
 <20171026201322.GA32181@nazgul.tnic>
 <89f4ec21-e31e-18f2-27c5-946c38cd128d@amd.com>
 <20171027075650.GA1276@nazgul.tnic>
 <323f3862-b326-e6b4-015f-6d923d7c700f@amd.com>
 <20171027201554.GH12039@nazgul.tnic>
 <0f039ac4-a9c4-9920-4fb9-b1c5eadf3128@amd.com>
 <20171027202707.olhzx453cnkbhy62@pd.tnic>
 <a7b8859b-6537-5ce0-b0d8-bd5932c64251@amd.com>
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
In-Reply-To: <a7b8859b-6537-5ce0-b0d8-bd5932c64251@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 27, 2017 at 04:28:31PM -0500, Brijesh Singh wrote:
> This will fail because PEK_GEN require the platform in INIT state and
> nobody has done the state transition from INIT -> UINIT.

Huh, FW is in INIT state and PEK_GEN wants it to be in INIT state. Typo?

Aaanyway, I don't like this whole notion of prematurely and predictively
executing commands on the PSP if it is not needed. So how about
executing only those commands which put the FW in the required state and
then executing the actual command?

I.e., if a command needs to be executed in UINIT state, you put the PSP
in that state before executing that command. If the command needs to be
in INIT state, you put the PSP in INIT state first and so on...

For convenience, you could carry the current PSP state in some struct
psp_dev member or whatever and query it before running the respective
commands.

Hmmm?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
