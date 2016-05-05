From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: better patch for linux/bitops.h
Date: Wed, 4 May 2016 23:35:14 -0700
Message-ID: <572AE9A2.20609@zytor.com>
References: <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
 <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
 <20160504190723.GD3901@thunk.org> <572A6CDD.10503@av8n.com>
 <572A6F1C.2080708@av8n.com>
 <CAH8yC8kZDfw+6Ctog-C7Jb57rLnagAFMNwNfGH_dwa9fs=5h1Q@mail.gmail.com>
 <28624BFC-7C63-4F38-9F67-7CBFB0C6499B@zytor.com>
 <CAH8yC8ndyLipAdu5=vmyJ3eHYBS-mxQsRF2q2G2EuOfQxTpM7g@mail.gmail.com>
 <0015E1DE-DFF9-4CCE-805E-7AC286021BED@zytor.com>
 <CAH8yC8mbW5yTwbKN7_RMNVnTiKmtP0u3_2+tKV=-L4BZ6miGVw@mail.gmail.com>
 <20160505035028.GD10776@thunk.org>
 <CAH8yC8n974Z=mvXPsLiZqYPkVjBqtR=nqYQ-jJo194ECmWkofA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: noloader@gmail.com, "Theodore Ts'o" <tytso@mit.edu>,
	John Denker <jsd@av8n.com>, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:39794 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbcEEGfv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 02:35:51 -0400
In-Reply-To: <CAH8yC8n974Z=mvXPsLiZqYPkVjBqtR=nqYQ-jJo194ECmWkofA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/04/16 21:03, Jeffrey Walton wrote:
> On Wed, May 4, 2016 at 11:50 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> ...
>> But instead of arguing over what works and doesn't, let's just create
>> the the test set and just try it on a wide range of compilers and
>> architectures, hmmm?
>
> What are the requirements? Here's a short list:
>
>    * No undefined behavior
>      - important because the compiler writers use the C standard
>    * Compiles to native "rotate IMMEDIATE" if the rotate amount is a
> "constant expression" and the machine provides it
>      - translates to a native rotate instruction if available
>      - "rotate IMM" can be 3 times faster than "rotate REG"
>      - do any architectures *not* provide a rotate?
>    * Compiles to native "rotate REGISTER" if the rotate is variable and
> the machine provides it
>      - do any architectures *not* provide a rotate?
>    * Constant time
>      - important to high-integrity code
>      - Non-security code paths probably don't care
>
> Maybe the first thing to do is provide a different rotates for the
> constant-time requirement when its in effect?
>

The disagreement here is the priority between these points.  In my very 
strong opinion, "no undefined behavior" per the C standard is way less 
important than the others; what matters is what gcc and the other 
compilers we care about do.  The kernel relies on various versions of 
C-standard-undefined behavior *all over the place*; for one thing 
sizeof(void *) == sizeof(size_t) == sizeof(unsigned long)!! but they are 
well-defined in the subcontext we care about.

(And no, not all architectures provide a rotate instruction.)

	-hpa
