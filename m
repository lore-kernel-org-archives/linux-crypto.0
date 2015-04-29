From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH crypto-2.6] lib: make memzero_explicit more robust against
 dead store elimination
Date: Thu, 30 Apr 2015 01:43:07 +0200
Message-ID: <55416C8B.1070909@iogearbox.net>
References: <85dfdd23d98412a183546e2e7659a6a2bed1fca8.1430230786.git.daniel@iogearbox.net> <20150429130816.GA8526@zoho.com> <5540E42F.70607@iogearbox.net> <20150429145400.GA12861@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Mark Charlebois <charlebm@gmail.com>,
	Behan Webster <behanw@converseincode.com>
To: mancha security <mancha1@zoho.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:36204 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbbD2XnX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Apr 2015 19:43:23 -0400
In-Reply-To: <20150429145400.GA12861@zoho.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/29/2015 04:54 PM, mancha security wrote:
> On Wed, Apr 29, 2015 at 04:01:19PM +0200, Daniel Borkmann wrote:
>> On 04/29/2015 03:08 PM, mancha security wrote:
>> ...
>>> By the way, has anyone been able to verify that __memory_barrier
>>> provides DSE protection under various optimizations? Unfortunately, I
>>> don't have ready access to ICC at the moment or I'd test it myself.
>>
>> Never used icc, but it looks like it's free for open source projects;
>> I can give it a try, but in case you're faster than I am, feel free
>> to post results here.
>
> Time permitting, I'll try setting this up and post my results.

So I finally got the download link and an eval license for icc, and
after needing to download gigbytes of bloat for the suite, I could
finally start to experiment a bit.

So __GNUC__ and __INTEL_COMPILER is definitely defined by icc, __ECC
not in my case, so that part is as expected for the kernel header
includes.

With barrier_data(), I could observe insns for an inlined memset()
being emitted in the disassembly, same with barrier(), same with
__memory_barrier(). In fact, even if I only use ...

static inline void memzero_explicit(void *s, size_t count)
{
   memset(s, 0, count);
}

int main(void)
{
   char buff[20];
   memzero_explicit(buff, sizeof(buff));
   return 0;
}

... icc will emit memset instrinsic insns (did you notice that as
well?) when using various optimization levels. Using f.e. -Ofast
-ffreestanding resp. -fno-builtin-memset will emit a function call,
presumably, icc is then not allowed to make any assumptions, so given
the previous result, then would then be expected.

So, crafting a stupid example:

static inline void
dumb_memset(char *s, unsigned char c, size_t n)
{
         int i;

         for (i = 0; i < n; i++)
                 s[i] = c;
}

static inline void memzero_explicit(void *s, size_t count)
{
   dumb_memset(s, 0, count);
   <barrier-variant>
}

int main(void)
{
   char buff[20];
   memzero_explicit(buff, sizeof(buff));
   return 0;
}

With no barrier at all, icc optimizes all that away (using -Ofast),
with barrier_data() it inlines and emits additional mov* insns!
Just using barrier() or __memory_barrier(), we end up with the same
case as with clang, that is, it gets optimized away. So, barrier_data()
seems to be better here as well.

Cheers,
Daniel
