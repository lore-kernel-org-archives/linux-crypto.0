From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH crypto-2.6] crypto: ccp: add timeout support in the SEV
 command
Date: Tue, 11 Sep 2018 15:53:25 +0200
Message-ID: <20180911135325.GI12094@zn.tnic>
References: <1534367485-4386-1-git-send-email-brijesh.singh@amd.com>
 <1534367485-4386-2-git-send-email-brijesh.singh@amd.com>
 <20180904081151.GC32615@zn.tnic>
 <e327fa7f-2d4d-2181-c3f4-607faf16c9b5@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        Gary Hook <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e327fa7f-2d4d-2181-c3f4-607faf16c9b5@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 10, 2018 at 02:06:57PM -0500, Brijesh Singh wrote:
> Nothing prevent user from supplying a bogus number. The main question
> is, clamp with what number ?

So you definitely want to forbid too large timeouts - that wouldn't make
any sense anyway. And too small either, because a too small timeout
would make a potentially functioning fw broken.

> IMO, if user is overriding the default timeout number then its possible
> that user is dealing with a buggy firmware which does not work with
> default timeout and silently clamping the value will not help them.

No one said "silently" - you simply say:

	"Correcting PSP	"Correcting PSP probe timeout to X seconds."

when loading the driver so that the user is aware that the value she
entered might not be an optimal one.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
