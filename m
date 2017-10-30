From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6.1 16/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Mon, 30 Oct 2017 18:57:08 +0100
Message-ID: <20171030175708.3w3sfzbtqdvmqs62@pd.tnic>
References: <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171029204825.18260-1-brijesh.singh@amd.com>
 <20171030172150.3eibiqr44i43zbvd@pd.tnic>
 <1e89d599-b1d2-bb16-92f4-0409ee0a6ea0@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
In-Reply-To: <1e89d599-b1d2-bb16-92f4-0409ee0a6ea0@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 30, 2017 at 12:49:14PM -0500, Brijesh Singh wrote:
> If the buffer is allocated on the stack then there is no guarantee that

static global is not allocated on the stack.

> I can certainly move the allocation outside, but then it may increase the
> code size in other functions. If its not a big deal then I would prefer to
> keep what we have.

Avoiding repeated k*alloc calls is always a good thing. Actually kmalloc-ing 20
bytes each time sounds like it is not worth the calling overhead to me.

> The function is not used by userspace ioctl, its used by kvm drv when it
> launch/terminates the SEV guest.

Just do that directly in the ioctl instead of having a dumb function.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
