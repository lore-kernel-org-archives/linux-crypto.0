From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v4.1 07/29] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Wed, 4 Oct 2017 13:09:24 +0200
Message-ID: <20171004110923.onuz7uavcbao4nbn@pd.tnic>
References: <20170919204627.3875-8-brijesh.singh@amd.co>
 <20171002204831.5947-1-brijesh.singh@amd.com>
 <nycvar.YSQ.7.76.1710041221390.19122@wniryva>
 <20171004092152.4lmjlsqrg25dgaxu@pd.tnic>
 <nycvar.YSQ.7.76.1710041515170.22210@wniryva>
 <20171004100749.433dzszyea3oqcpn@pd.tnic>
 <nycvar.YSQ.7.76.1710041551490.23099@wniryva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: P J P <ppandit@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <nycvar.YSQ.7.76.1710041551490.23099@wniryva>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 04, 2017 at 04:12:37PM +0530, P J P wrote:
>   Quick glance would work if it is readable. Currently it is not if
> one is viewing it in 80 cols screen/window. They do that. Writing
> return on the same line does not add specific value IMO.

Then you'll have to scroll to the right like you have to do for the
gazillion other places where the 80 cols rule is overridden for
readability or string grepping or other reasons.

Or you should widen your windows.

> Up to you; I pointed it out as 80 columns rule makes sense to me.

It is up to the crypto maintainer in the end.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
