From: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: [PATCH] Export symbol ksize()
Date: Fri, 13 Feb 2009 11:57:52 -0500
Message-ID: <f73f7ab80902130857x2acd13afk3e704f4ad64333a7@mail.gmail.com>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
	 <20090212230934.GA21609@gondor.apana.org.au>
	 <1234481821.3152.27.camel@calx>
	 <200902140020.45522.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Christoph Lameter <cl@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:24436 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbZBMQ5y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Feb 2009 11:57:54 -0500
In-Reply-To: <200902140020.45522.nickpiggin@yahoo.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 13, 2009 at 8:20 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Friday 13 February 2009 10:37:01 Matt Mackall wrote:
>> On Fri, 2009-02-13 at 07:09 +0800, Herbert Xu wrote:
>> > On Fri, Feb 13, 2009 at 12:10:45AM +1100, Nick Piggin wrote:
>> > > I would be interested to know how that goes. You always have this
>> > > circular issue that if a little more space helps significantly, then
>> > > maybe it is a good idea to explicitly ask for those bytes. Of course
>> > > that larger allocation is also likely to have some slack bytes.
>> >
>> > Well, the thing is we don't know apriori whether we need the
>> > extra space.  The idea is to use the extra space if available
>> > to avoid reallocation when we hit things like IPsec.
>>
>> I'm not entirely convinced by this argument. If you're concerned about
>> space rather than performance, then you want an allocator that doesn't
>> waste space in the first place and you don't try to do "sub-allocations"
>> by hand. If you're concerned about performance, you instead optimize
>> your allocator to be as fast as possible and again avoid conditional
>> branches for sub-allocations.
>
> Well, my earlier reasoning is no longer so clear cut if eg. there
> are common cases where no extra space is required, but rare cases
> where extra space might be a big win if it eg avoids extra
> alloc, copy, free or something.
>
> Because even with performance oriented allocators, there is a non-zero
> cost to explicitly asking for more memory -- queues tend to get smaller
> at larger object sizes, and page allocation orders can increase. So if
> it is very uncommon to need extra space you don't want to burden the
> common case with it.

My concern would be that such extra-space reuse would be a very
non-obvious performance hit if allocation patterns changed slightly.
If being able to use the extra space really is a noticeable "big win"
for the rare case, then minor changes to the memory allocator could
dramatically impact performance in a totally nondeterministic way.  If
the change isn't performance-significant in the grand scheme of
things, then the use of ksize() would just be code obfuscation.  On
the other hand if it *is* performance-significant, it should be
redesigned to be able to guarantee that the space is available when it
is needed.

Cheers,
Kyle Moffett
