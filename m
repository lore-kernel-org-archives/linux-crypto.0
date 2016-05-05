From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: linux/bitops.h
Date: Wed, 04 May 2016 18:27:24 -0700
Message-ID: <CAE41730-CCC7-499C-ABE3-507A204EB74B@zytor.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu> <1462170413-7164-2-git-send-email-tytso@mit.edu> <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com> <20160504174901.GC3901@thunk.org> <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com> <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com> <20160504190723.GD3901@thunk.org> <572A6CDD.10503@av8n.com> <C6DC09E0-98EA-4591-9336-4D2BE1699C2C@zytor.com> <572A724C.6010704@av8n.com> <20160504230638.GO13997@two.firstfloor.org> <CAH8yC8n5rFrFPrdNFXa8fv93k=K1EsPVH5_GVdFAGi7MQ+14Cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: John Denker <jsd@av8n.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
To: noloader@gmail.com, Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:34300 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbcEEB17 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 21:27:59 -0400
In-Reply-To: <CAH8yC8n5rFrFPrdNFXa8fv93k=K1EsPVH5_GVdFAGi7MQ+14Cg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On May 4, 2016 6:20:32 PM PDT, Jeffrey Walton <noloader@gmail.com> wrote:
>On Wed, May 4, 2016 at 7:06 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> On Wed, May 04, 2016 at 03:06:04PM -0700, John Denker wrote:
>>> On 05/04/2016 02:56 PM, H. Peter Anvin wrote:
>>> >> Beware that shifting by an amount >= the number of bits in the
>>> >> word remains Undefined Behavior.
>>>
>>> > This construct has been supported as a rotate since at least gcc2.
>>>
>>> How then should we understand the story told in commit d7e35dfa?
>>> Is the story wrong?
>>
>> I don't think Linux runs on a system where it would make a difference
>> (like a VAX), and also gcc always converts it before it could.
>> Even UBSan should not complain because it runs after the conversion
>> to ROTATE.
>>
>From what I understand, its a limitation in the barrel shifter and the
>way the shift bits are handled.
>
>Linux runs on a great number of devices, so its conceivable (likely?)
>a low-cost board would have hardware limitations that not found in
>modern desktops and servers or VAX.
>
>Jeff

This is a compiler feature, though.  And if icc or clang don't support the idiom they would never have compiled a working kernel.
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
