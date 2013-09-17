From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] crypto_mem_not_equal: add constant-time equality testing
 of memory regions
Date: Tue, 17 Sep 2013 21:07:12 +0200
Message-ID: <5238A860.2010404@redhat.com>
References: <5232CDCF.50208@redhat.com> <1379259179-2677-1-git-send-email-james@openvpn.net> <878uyyks0e.fsf@mid.deneb.enyo.de> <5235E77F.1050807@openvpn.net> <5236B9A7.3090001@redhat.com> <52373BA3.9090709@openvpn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Weimer <fw@deneb.enyo.de>,
	Marcelo Cerri <mhcerri@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au
To: James Yonan <james@openvpn.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab3IQTHk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Sep 2013 15:07:40 -0400
In-Reply-To: <52373BA3.9090709@openvpn.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/16/2013 07:10 PM, James Yonan wrote:
> On 16/09/2013 01:56, Daniel Borkmann wrote:
>> On 09/15/2013 06:59 PM, James Yonan wrote:
>>> On 15/09/2013 09:45, Florian Weimer wrote:
>>>> * James Yonan:
>>>>
>>>>> + * Constant-time equality testing of memory regions.
>>>>> + * Returns 0 when data is equal, non-zero otherwise.
>>>>> + * Fast path if size == 16.
>>>>> + */
>>>>> +noinline unsigned long crypto_mem_not_equal(const void *a, const
>>>>> void *b, size_t size)
>>>>
>>>> I think this should really return unsigned or int, to reduce the risk
>>>> that the upper bytes are truncated because the caller uses an
>>>> inappropriate type, resulting in a bogus zero result.  Reducing the
>>>> value to 0/1 probably doesn't hurt performance too much.  It also
>>>> doesn't encode any information about the location of the difference in
>>>> the result value, which helps if that ever leaks.
>>>
>>> The problem with returning 0/1 within the function body of
>>> crypto_mem_not_equal is that it makes it easier for the compiler to
>>> introduce a short-circuit optimization.
>>>
>>> It might be better to move the test where the result is compared
>>> against 0 into an inline function:
>>>
>>> noinline unsigned long __crypto_mem_not_equal(const void *a, const
>>> void *b, size_t size);
>>>
>>> static inline int crypto_mem_not_equal(const void *a, const void *b,
>>> size_t size) {
>>>      return __crypto_mem_not_equal(a, b, size) != 0UL ? 1 : 0;
>>> }
>>>
>>> This hides the fact that we are only interested in a boolean result
>>> from the compiler when it's compiling crypto_mem_not_equal.c, but also
>>> ensures type safety when users test the return value.  It's also
>>> likely to have little or no performance impact.
>>
>> Well, the code snippet I've provided from NaCl [1] is not really
>> "fast-path"
>> as you say, but rather to prevent the compiler from doing such
>> optimizations
>> by having a transformation of the "accumulated" bits into 0 and 1 as an end
>> result (likely to prevent a short circuit), plus it has static size, so no
>> loops applied here that could screw up.
>>
>> Variable size could be done under arch/ in asm, and if not available, that
>> just falls back to normal memcmp that is being transformed into a same
>> return
>> value. By that, all other archs could easily migrate afterwards. What do
>> you
>> think?
>>
>>   [1] http://www.spinics.net/lists/linux-crypto/msg09558.html
>
> I'm not sure that the differentbits -> 0/-1 transform in NaCl really buys us anything because
 > we don't care very much about making the final test of differentbits != 0 constant-time.  An
 > attacker already knows whether the test succeeded or failed -- we care more about making the
 > failure cases constant-time.
>
> To do this, we need to make sure that the compiler doesn't insert one or more early instructions
 > to compare differentbits with 0xFF and then bypass the rest of the F(n) lines because it knows
 > then that the value of differentbits cannot be changed by subsequent F(n) lines.  It seems that
 > all of the approaches that use |= to build up the differentbits value suffer from this problem.
>
> My proposed solution is rather than trying to outsmart the compiler with code that resists
 > optimization, why not just turn optimization off directly with #pragma GCC optimize.  Or better
 > yet, use an optimization setting that provides reasonable speed without introducing potential
 > short-circuit optimizations.
>
> By optimizing for size ("Os"), the compiler will need to turn off optimizations that add code
 > for a possible speed benefit, and the kind of short-circuit optimizations that we are trying to
 > avoid fall precisely into this class -- they add an instruction to check if the OR accumulator has
 > all of its bits set, then if so, do an early exit.  So by using Os, we still benefit from
 > optimizations that increase speed but don't increase code size.

While I was looking a bit further into this, I thought using an attribute like this might be a
more clean variant ...

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 92669cd..2505b1b 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -351,6 +351,11 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
   */
  #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))

+/* Tell GCC to turn off optimization for a particular function. */
+#ifndef __do_not_optimize
+#define __do_not_optimize      __attribute__((optimize("O0")))
+#endif
+
  /* Ignore/forbid kprobes attach on very low level functions marked by this attribute: */
  #ifdef CONFIG_KPROBES
  # define __kprobes     __attribute__((__section__(".kprobes.text")))

... however, then I found on the GCC developer mailing list [1]: That said, I consider the
optimize attribute code seriously broken and unmaintained (but sometimes useful for debugging -
and only that). [...] Does "#pragma Gcc optimize" work more reliably? No, it uses the same
mechanism internally. [...] And if these options are so broken, should they be marked as such
in the manual? [...] Probably yes.

Therefore, I still need to ask ... what about the option of an arch/*/crypto/... asm
implementation? This still seems safer for something that crucial, imho.

> Once we eliminate the possibility of short-circuit optimizations, then it's much more straightforward
 > to make the function fast (e.g. by comparing 64-bits at a time) and flexible (by handling arbitrary
 > size).  My current implementation of crypto_mem_not_equal does both.

  [1] http://gcc.gnu.org/ml/gcc/2012-07/msg00211.html
