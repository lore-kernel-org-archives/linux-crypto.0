From: John Denker <jsd@av8n.com>
Subject: Re: better patch for linux/bitops.h
Date: Wed, 4 May 2016 14:52:28 -0700
Message-ID: <572A6F1C.2080708@av8n.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
 <1462170413-7164-2-git-send-email-tytso@mit.edu>
 <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com>
 <20160504174901.GC3901@thunk.org>
 <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
 <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
 <20160504190723.GD3901@thunk.org> <572A6CDD.10503@av8n.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010204000507020209040900"
To: tytso@mit.edu, "H. Peter Anvin" <hpa@zytor.com>,
	noloader@gmail.com, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cloud.av8n.com ([174.136.99.130]:51334 "EHLO cloud.av8n.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbcEDVw3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 17:52:29 -0400
In-Reply-To: <572A6CDD.10503@av8n.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010204000507020209040900
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 05/04/2016 02:42 PM, I wrote:

> I find it very odd that the other seven functions were not
> upgraded. I suggest the attached fix-others.diff would make
> things more consistent.

Here's a replacement patch.
Same idea, less brain damage.
Sorry for the confusion.


--------------010204000507020209040900
Content-Type: text/x-patch;
 name="fix-others.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix-others.diff"

commit ba83b16d8430ee6104aa1feeed4ff7a82b02747a
Author: John Denker <jsd@av8n.com>
Date:   Wed May 4 13:55:51 2016 -0700

    Make ror64, rol64, ror32, ror16, rol16, ror8, and rol8
    consistent with rol32 in their handling of shifting by a zero amount.
    
    Same overall rationale as in d7e35dfa, just more consistently applied.
    
    Beware that shifting by an amount >= the number of bits in the
    word remains Undefined Behavior.  This should be either documented
    or fixed.  It could be fixed easily enough.

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index defeaac..90f389b 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -87,7 +87,7 @@ static __always_inline unsigned long hweight_long(unsigned long w)
  */
 static inline __u64 rol64(__u64 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (64 - shift));
+	return (word << shift) | (word >> ((-shift) & 63));
 }
 
 /**
@@ -97,7 +97,7 @@ static inline __u64 rol64(__u64 word, unsigned int shift)
  */
 static inline __u64 ror64(__u64 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (64 - shift));
+	return (word >> shift) | (word << ((-shift) & 63));
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
+	return (word << shift) | (word >> ((-shift) & 15));
 }
 
 /**
@@ -137,7 +137,7 @@ static inline __u16 rol16(__u16 word, unsigned int shift)
  */
 static inline __u16 ror16(__u16 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (16 - shift));
+	return (word >> shift) | (word << ((-shift) & 15));
 }
 
 /**
@@ -147,7 +147,7 @@ static inline __u16 ror16(__u16 word, unsigned int shift)
  */
 static inline __u8 rol8(__u8 word, unsigned int shift)
 {
-	return (word << shift) | (word >> (8 - shift));
+	return (word << shift) | (word >> ((-shift) & 7));
 }
 
 /**
@@ -157,7 +157,7 @@ static inline __u8 rol8(__u8 word, unsigned int shift)
  */
 static inline __u8 ror8(__u8 word, unsigned int shift)
 {
-	return (word >> shift) | (word << (8 - shift));
+	return (word >> shift) | (word << ((-shift) & 7));
 }
 
 /**

--------------010204000507020209040900--
