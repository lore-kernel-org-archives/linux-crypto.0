From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Fri, 27 Oct 2017 22:27:07 +0200
Message-ID: <20171027202707.olhzx453cnkbhy62@pd.tnic>
References: <20171026135614.GA12359@nazgul.tnic>
 <9258d8e7-b185-01d2-be92-d7d2820c7eb6@amd.com>
 <20171026174427.GB29782@nazgul.tnic>
 <bc7254d3-a2d9-e3fd-02a4-164d5e4fb545@amd.com>
 <20171026201322.GA32181@nazgul.tnic>
 <89f4ec21-e31e-18f2-27c5-946c38cd128d@amd.com>
 <20171027075650.GA1276@nazgul.tnic>
 <323f3862-b326-e6b4-015f-6d923d7c700f@amd.com>
 <20171027201554.GH12039@nazgul.tnic>
 <0f039ac4-a9c4-9920-4fb9-b1c5eadf3128@amd.com>
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
In-Reply-To: <0f039ac4-a9c4-9920-4fb9-b1c5eadf3128@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 27, 2017 at 03:25:24PM -0500, Brijesh Singh wrote:
> Yep, we are doing state transition only when we really need to. At least
> so far I have tried to avoid making any unnecessary state transitions.

So change all those which do INIT -> CMD -> SHUTDOWN to do only the
command as the INIT state is the default state, AFAIU it.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
