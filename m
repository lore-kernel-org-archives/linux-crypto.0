From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part2 PATCH v3 03/26] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) device support
Date: Tue, 12 Sep 2017 18:29:04 +0200
Message-ID: <20170912162904.32qkgjx7ry2id6c3@pd.tnic>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-4-brijesh.singh@amd.com>
 <20170912140249.f26w5xedbrqu52i4@pd.tnic>
 <855be17c-382e-4e7d-7300-ca19cc50c625@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?XCJSYWRpbSBLcsSNbcOhxZlcIg==?= <rkrcmar@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <855be17c-382e-4e7d-7300-ca19cc50c625@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 12, 2017 at 10:32:13AM -0500, Brijesh Singh wrote:
> The debug statement is very helpful during development, it gives me the full
> view of what command we send to PSP, data dump of command buffer before and
> after the request completion.  e.g when dyndbg is enabled the output looks like
> this:

I'm sure it is all very helpful but you have a bunch of code which is
always built-in and useful only to developers. Which means it could
be behind #ifdef DEBUG at least and disabled on production systems.
You don't have to do it immediately but once the stuff goes up and
everything stabilizes, you could ifdef it out... Something to think
about later, I'd say.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
