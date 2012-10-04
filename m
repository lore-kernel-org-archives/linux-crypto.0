From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH -next] asymmetric keys: fix printk format warning
Date: Thu, 04 Oct 2012 12:48:27 +0930
Message-ID: <874nma3oxo.fsf@rustcorp.com.au>
References: <20121003173007.c322d79c31676b9494a6bfd5@canb.auug.org.au> <506CC48E.2020303@xenotime.net> <20121004090806.70274213735de74211f4334d@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Randy Dunlap <rdunlap@xenotime.net>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20121004090806.70274213735de74211f4334d@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> [Lets also cc Rusty who committed the patch ...]
>
> On Wed, 03 Oct 2012 16:04:46 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
>>
>> From: Randy Dunlap <rdunlap@xenotime.net>
>> 
>> Fix printk format warning in x509_cert_parser.c:
>> 
>> crypto/asymmetric_keys/x509_cert_parser.c: In function 'x509_note_OID':
>> crypto/asymmetric_keys/x509_cert_parser.c:113:3: warning: format '%zu' expects type 'size_t', but argument 2 has type 'long unsigned int'
>> 
>> Builds cleanly on i386 and x86_64.

Thanks, applied.

Rusty.
