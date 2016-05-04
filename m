From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] random: replace non-blocking pool with a Chacha20-based CRNG
Date: Wed, 04 May 2016 14:56:14 -0700
Message-ID: <C6DC09E0-98EA-4591-9336-4D2BE1699C2C@zytor.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu> <1462170413-7164-2-git-send-email-tytso@mit.edu> <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com> <20160504174901.GC3901@thunk.org> <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com> <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com> <20160504190723.GD3901@thunk.org> <572A6CDD.10503@av8n.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
To: John Denker <jsd@av8n.com>, tytso@mit.edu, noloader@gmail.com,
	linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <572A6CDD.10503@av8n.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On May 4, 2016 2:42:53 PM PDT, John Denker <jsd@av8n.com> wrote:
>On 05/04/2016 12:07 PM, tytso@thunk.org wrote:
>
>> it doesn't hit the
>> UB case which Jeffrey was concerned about. 
>
>That should be good enough for present purposes....
>
>However, in the interests of long-term maintainability, I
>would suggest sticking in a comment or assertion saying 
>that ror32(,shift) is never called with shift=0.  This
>can be removed if/when bitops.h is upgraded.
>
>There is a track record of compilers doing Bad Things in
>response to UB code, including some very counterintuitive
>Bad Things.
>
>On Wed, May 04, 2016 at 11:29:57AM -0700, H. Peter Anvin wrote:
>>>
>>> If bitops.h doesn't do the right thing, we need to
>>> fix bitops.h.
>
>Most of the ror and rol functions in linux/bitops.h
>should be considered unsafe, as currently implemented.
>http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/linux/bitops.h?id=04974df8049fc4240d22759a91e035082ccd18b4#n103
>
>I don't see anything in the file that suggests any limits
>on the range of the second argument.  So at best it is an
>undocumented trap for the unwary.  This has demonstrably
>been a problem in the past.  The explanation in the attached
>fix-rol32.diff makes amusing reading.
>
>Of the eight functions
>  ror64, rol64, ror32, rol32, ror16, rol16, ror8, and rol8,
>only one of them can handle shifting by zero, namely rol32.
>It was upgraded on Thu Dec 3 22:04:01 2015; see the attached
>fix-rol32.diff.
>
>I find it very odd that the other seven functions were not
>upgraded.  I suggest the attached fix-others.diff would make
>things more consistent.
>
>Beware that shifting by an amount >= the number of bits in the
>word remains Undefined Behavior.  This should be either documented
>or fixed.  It could be fixed easily enough.

This construct has been supported as a rotate since at least gcc2.
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
