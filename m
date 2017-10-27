From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Fri, 27 Oct 2017 15:25:24 -0500
Message-ID: <0f039ac4-a9c4-9920-4fb9-b1c5eadf3128@amd.com>
References: <20171023092020.GB19523@nazgul.tnic>
 <f58e72e5-8636-2abb-99e9-c58f462463e7@amd.com>
 <20171026135614.GA12359@nazgul.tnic>
 <9258d8e7-b185-01d2-be92-d7d2820c7eb6@amd.com>
 <20171026174427.GB29782@nazgul.tnic>
 <bc7254d3-a2d9-e3fd-02a4-164d5e4fb545@amd.com>
 <20171026201322.GA32181@nazgul.tnic>
 <89f4ec21-e31e-18f2-27c5-946c38cd128d@amd.com>
 <20171027075650.GA1276@nazgul.tnic>
 <323f3862-b326-e6b4-015f-6d923d7c700f@amd.com>
 <20171027201554.GH12039@nazgul.tnic>
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
In-Reply-To: <20171027201554.GH12039@nazgul.tnic>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/27/17 3:15 PM, Borislav Petkov wrote:
> On Fri, Oct 27, 2017 at 06:28:38AM -0500, Brijesh Singh wrote:
>> ... User can retry the command sometime later when nobody else is
>> using the PSP.
> That still doesn't prevent you from doing two things:
>
> * make that fw_init_count a proper kref instead of your homegrown thing

OK, I can use kref in next patch.

>
> * do not preemptively execute commands on the PSP if you can't possibly
> know what the next command is going to be - instead, just put it in the
> required state only when you really have to. I.e., don't do all that
> unnecessary INIT -> CMD -> SHUTDOWN game for no reason.

Yep, we are doing state transition only when we really need to. At least
so far I have tried to avoid making any unnecessary state transitions.

> Thx.
>
