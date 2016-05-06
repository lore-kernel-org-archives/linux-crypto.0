From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: linux/bitops.h
Date: Fri, 06 May 2016 13:30:22 -0700
Message-ID: <16E41E50-DAA8-4F7F-B4D3-92E26C8E0DBE@zytor.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu> <1462170413-7164-2-git-send-email-tytso@mit.edu> <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com> <20160504174901.GC3901@thunk.org> <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com> <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com> <20160504190723.GD3901@thunk.org> <572A6CDD.10503@av8n.com> <C6DC09E0-98EA-4591-9336-4D2BE1699C2C@zytor.com> <572A724C.6010704@av8n.com> <572A9437.4020208@zytor.com> <572CF971.9060100@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>, John Denker <jsd@av8n.com>,
	tytso@mit.edu, noloader@gmail.com, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:33442 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758397AbcEFUas (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 May 2016 16:30:48 -0400
In-Reply-To: <572CF971.9060100@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On May 6, 2016 1:07:13 PM PDT, Sasha Levin <sasha.levin@oracle.com> wrote:
>On 05/04/2016 08:30 PM, H. Peter Anvin wrote:
>> On 05/04/16 15:06, John Denker wrote:
>>> On 05/04/2016 02:56 PM, H. Peter Anvin wrote:
>>>>> Beware that shifting by an amount >= the number of bits in the
>>>>> word remains Undefined Behavior.
>>>
>>>> This construct has been supported as a rotate since at least gcc2.
>>>
>>> How then should we understand the story told in commit d7e35dfa?
>>> Is the story wrong?
>>>
>>> At the very least, something inconsistent is going on.  There
>>> are 8 functions.  Why did d7e35dfa change one of them but
>>> not the other 7?
>> 
>> Yes. d7e35dfa is baloney IMNSHO.  All it does is produce worse code,
>and the description even says so.
>
>No, the description says that it produces worse code for *really
>really* ancient
>GCC versions.
>
>> As I said, gcc has treated the former code as idiomatic since gcc 2,
>so that support is beyond ancient.
>
>Because something works in a specific way on one compiler isn't a
>reason to
>ignore this noncompliance with the standard.
>
>
>Thanks,
>Sasha

When the compiler in question is our flagship target and our reference compiler, then yes, it matters.
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
