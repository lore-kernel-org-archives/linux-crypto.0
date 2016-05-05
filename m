From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: better patch for linux/bitops.h
Date: Thu, 5 May 2016 15:22:27 -0700
Message-ID: <51c83476-24bc-14b7-8d35-c4a754a235ec@zytor.com>
References: <20160504190723.GD3901@thunk.org> <572A6CDD.10503@av8n.com>
 <572A6F1C.2080708@av8n.com>
 <CAH8yC8kZDfw+6Ctog-C7Jb57rLnagAFMNwNfGH_dwa9fs=5h1Q@mail.gmail.com>
 <28624BFC-7C63-4F38-9F67-7CBFB0C6499B@zytor.com>
 <CAH8yC8ndyLipAdu5=vmyJ3eHYBS-mxQsRF2q2G2EuOfQxTpM7g@mail.gmail.com>
 <0015E1DE-DFF9-4CCE-805E-7AC286021BED@zytor.com>
 <CAH8yC8mbW5yTwbKN7_RMNVnTiKmtP0u3_2+tKV=-L4BZ6miGVw@mail.gmail.com>
 <20160505035028.GD10776@thunk.org>
 <CACXcFmmk=DZMVqgZAOm1Lf3LP76By50af8NnPquRA8sF2Vgk0w@mail.gmail.com>
 <20160505221809.GC17625@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, Sandy Harris <sandyinchina@gmail.com>,
	Jeffrey Walton <noloader@gmail.com>,
	John Denker <jsd@av8n.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Jason Cooper <cryptography@lakedaemon.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160505221809.GC17625@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/05/2016 03:18 PM, tytso@mit.edu wrote:
> On Thu, May 05, 2016 at 05:34:50PM -0400, Sandy Harris wrote:
>>
>> I completely fail to see why tests or compiler versions should be
>> part of the discussion. The C standard says the behaviour in
>> certain cases is undefined, so a standard-compliant compiler
>> can generate more-or-less any code there.
>>
> 
>> As long as any of portability, reliability or security are among our
>> goals, any code that can give undefined behaviour should be
>> considered problematic.
> 
> Because compilers have been known not necessarily to obey the specs,
> and/or interpret the specs in way that not everyone agrees with.  It's
> also the case that we are *already* disabling certain C optimizations
> which are technically allowed by the spec, but which kernel
> programmers consider insane (e.g., strict aliasing).
> 
> And of course, memzero_explicit() which crypto people understand is
> necessary, is something that technically compilers are allowed to
> optimize according to the spec.  So trying to write secure kernel code
> which will work on arbitrary compilers may well be impossible.
> 
> And which is also why people have said (mostly in jest), "A
> sufficiently advanced compiler is indistinguishable from an
> adversary."  (I assume people will agree that optimizing away a memset
> needed to clear secrets from memory would be considered adversarial,
> at the very least!)
> 
> So this is why I tend to take a much more pragmatic viewpoint on
> things.  Sure, it makes sense to pay attention to what the C standard
> writers are trying to do to us; but if we need to suppress certain
> optimizations to write sane kernel code --- I'm ok with that.  And
> this is why using a trust-but-verify on a specific set of compilers
> and ranges of compiler versions is a really good idea....
> 

In theory, theory and practice should agree, but in practice, practice
is what counts.  I fully agree we should get rid of UD behavior where
doing so is practical, but not at the cost of breaking real-life
compilers, expecially not gcc, and to a lesser but still very real
extent icc and clang.

I would also agree that we should push the gcc developers to add to the
manual C-standard-UD behavior which are well-defined under the
gnu89/gnu99/gnu11 C dialects.

	-hpa
