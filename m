From: John Denker <jsd@av8n.com>
Subject: Re: [PATCH 1/3] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Wed, 4 May 2016 14:42:53 -0700
Message-ID: <572A6CDD.10503@av8n.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
 <1462170413-7164-2-git-send-email-tytso@mit.edu>
 <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
 <20160504174901.GC3901@thunk.org>
 <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
 <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
 <20160504190723.GD3901@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030203050009080206060105"
To: tytso@mit.edu, "H. Peter Anvin" <hpa@zytor.com>,
	noloader@gmail.com, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cloud.av8n.com ([174.136.99.130]:51307 "EHLO cloud.av8n.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbcEDVtg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 17:49:36 -0400
In-Reply-To: <20160504190723.GD3901@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030203050009080206060105
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 05/04/2016 12:07 PM, tytso@thunk.org wrote:

> it doesn't hit the
> UB case which Jeffrey was concerned about. 

That should be good enough for present purposes....

However, in the interests of long-term maintainability, I
would suggest sticking in a comment or assertion saying 
that ror32(,shift) is never called with shift=0.  This
can be removed if/when bitops.h is upgraded.

There is a track record of compilers doing Bad Things in
response to UB code, including some very counterintuitive
Bad Things.

On Wed, May 04, 2016 at 11:29:57AM -0700, H. Peter Anvin wrote:
>>
>> If bitops.h doesn't do the right thing, we need to
>> fix bitops.h.

Most of the ror and rol functions in linux/bitops.h
should be considered unsafe, as currently implemented.
   http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/linux/bitops.h?id=04974df8049fc4240d22759a91e035082ccd18b4#n103

I don't see anything in the file that suggests any limits
on the range of the second argument.  So at best it is an
undocumented trap for the unwary.  This has demonstrably
been a problem in the past.  The explanation in the attached
fix-rol32.diff makes amusing reading.

Of the eight functions
  ror64, rol64, ror32, rol32, ror16, rol16, ror8, and rol8,
only one of them can handle shifting by zero, namely rol32.
It was upgraded on Thu Dec 3 22:04:01 2015; see the attached
fix-rol32.diff.

I find it very odd that the other seven functions were not
upgraded.  I suggest the attached fix-others.diff would make
things more consistent.

Beware that shifting by an amount >= the number of bits in the
word remains Undefined Behavior.  This should be either documented
or fixed.  It could be fixed easily enough.

--------------030203050009080206060105
Content-Type: text/x-patch;
 name="fix-rol32.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix-rol32.diff"

commit d7e35dfa2531b53618b9e6edcd8752ce988ac555
Author: Sasha Levin <sasha.levin@oracle.com>
Date:   Thu Dec 3 22:04:01 2015 -0500

    bitops.h: correctly handle rol32 with 0 byte shift
    
    ROL on a 32 bit integer with a shift of 32 or more is undefined and the
    result is arch-dependent. Avoid this by handling the trivial case of
    roling by 0 correctly.
    
    The trivial solution of checking if shift is 0 breaks gcc's detection
    of this code as a ROL instruction, which is unacceptable.
    
    This bug was reported and fixed in GCC
    (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=57157):
    
    	The standard rotate idiom,
    
    	  (x << n) | (x >> (32 - n))
    
    	is recognized by gcc (for concreteness, I discuss only the case that x
    	is an uint32_t here).
    
    	However, this is portable C only for n in the range 0 < n < 32. For n
    	== 0, we get x >> 32 which gives undefined behaviour according to the
    	C standard (6.5.7, Bitwise shift operators). To portably support n ==
    	0, one has to write the rotate as something like
    
    	  (x << n) | (x >> ((-n) & 31))
    
    	And this is apparently not recognized by gcc.
    
    Note that this is broken on older GCCs and will result in slower ROL.
    
    Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 2b8ed12..defeaac 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -107,7 +107,7 @@ static inline __u64 ror64(__u64 word, unsigned int shift)
  */
 static inline __u32 rol32(__u32 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (32 - shift));
+	return (word << shift) | (word >> ((-shift) & 31));
 }
 
 /**

--------------030203050009080206060105
Content-Type: text/x-patch;
 name="fix-others.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix-others.diff"

commit 03b97eeb5401ede1e1d7b6fbf6a9575db8d0efa6
Author: John Denker <jsd@av8n.com>
Date:   Wed May 4 13:55:51 2016 -0700

    Make ror64, rol64, ror32, ror16, rol16, ror8, and rol8
    consistent with rol32 in their handling of shifting by a zero amount.
    
    Same overall rationale as in d7e35dfa, just more consistently applied.
    
    Beware that shifting by an amount >= the number of bits in the
    word remains Undefined Behavior.  This should be either documented
    or fixed.  It could be fixed easily enough.

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index defeaac..97096b4 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -87,7 +87,7 @@ static __always_inline unsigned long hweight_long(unsigned long w)
  */
 static inline __u64 rol64(__u64 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (64 - shift));
+	return (word << shift) | (word >> ((-shift) & 64));
 }
 
 /**
@@ -97,7 +97,7 @@ static inline __u64 rol64(__u64 word, unsigned int shift)
  */
 static inline __u64 ror64(__u64 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (64 - shift));
+	return (word >> shift) | (word << ((-shift) & 64));
 }
 
 /**
@@ -117,7 +117,7 @@ static inline __u32 rol32(__u32 word, unsigned int shift)
  */
 static inline __u32 ror32(__u32 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (32 - shift));
+	return (word >> shift) | (word << ((-shift) & 31));
 }
 
 /**
@@ -127,7 +127,7 @@ static inline __u32 ror32(__u32 word, unsigned int shift)
  */
 static inline __u16 rol16(__u16 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (16 - shift));
+	return (word << shift) | (word >> ((-shift) & 16));
 }
 
 /**
@@ -137,7 +137,7 @@ static inline __u16 rol16(__u16 word, unsigned int shift)
  */
 static inline __u16 ror16(__u16 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (16 - shift));
+	return (word >> shift) | (word << ((-shift) & 16));
 }
 
 /**
@@ -147,7 +147,7 @@ static inline __u16 ror16(__u16 word, unsigned int shift)
  */
 static inline __u8 rol8(__u8 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (8 - shift));
+	return (word << shift) | (word >> ((-shift) & 8));
 }
 
 /**
@@ -157,7 +157,7 @@ static inline __u8 rol8(__u8 word, unsigned int shift)
  */
 static inline __u8 ror8(__u8 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (8 - shift));
+	return (word >> shift) | (word << ((-shift) & 8));
 }
 
 /**

--------------030203050009080206060105--
