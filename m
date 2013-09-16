From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] crypto_mem_not_equal: add constant-time equality testing
 of memory regions
Date: Mon, 16 Sep 2013 09:56:23 +0200
Message-ID: <5236B9A7.3090001@redhat.com>
References: <5232CDCF.50208@redhat.com> <1379259179-2677-1-git-send-email-james@openvpn.net> <878uyyks0e.fsf@mid.deneb.enyo.de> <5235E77F.1050807@openvpn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Weimer <fw@deneb.enyo.de>,
	Marcelo Cerri <mhcerri@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au
To: James Yonan <james@openvpn.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab3IPH4i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Sep 2013 03:56:38 -0400
In-Reply-To: <5235E77F.1050807@openvpn.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/15/2013 06:59 PM, James Yonan wrote:
> On 15/09/2013 09:45, Florian Weimer wrote:
>> * James Yonan:
>>
>>> + * Constant-time equality testing of memory regions.
>>> + * Returns 0 when data is equal, non-zero otherwise.
>>> + * Fast path if size == 16.
>>> + */
>>> +noinline unsigned long crypto_mem_not_equal(const void *a, const void *b, size_t size)
>>
>> I think this should really return unsigned or int, to reduce the risk
>> that the upper bytes are truncated because the caller uses an
>> inappropriate type, resulting in a bogus zero result.  Reducing the
>> value to 0/1 probably doesn't hurt performance too much.  It also
>> doesn't encode any information about the location of the difference in
>> the result value, which helps if that ever leaks.
>
> The problem with returning 0/1 within the function body of crypto_mem_not_equal is that it makes it easier for the compiler to introduce a short-circuit optimization.
>
> It might be better to move the test where the result is compared against 0 into an inline function:
>
> noinline unsigned long __crypto_mem_not_equal(const void *a, const void *b, size_t size);
>
> static inline int crypto_mem_not_equal(const void *a, const void *b, size_t size) {
>      return __crypto_mem_not_equal(a, b, size) != 0UL ? 1 : 0;
> }
>
> This hides the fact that we are only interested in a boolean result from the compiler when it's compiling crypto_mem_not_equal.c, but also ensures type safety when users test the return value.  It's also likely to have little or no performance impact.

Well, the code snippet I've provided from NaCl [1] is not really "fast-path"
as you say, but rather to prevent the compiler from doing such optimizations
by having a transformation of the "accumulated" bits into 0 and 1 as an end
result (likely to prevent a short circuit), plus it has static size, so no
loops applied here that could screw up.

Variable size could be done under arch/ in asm, and if not available, that
just falls back to normal memcmp that is being transformed into a same return
value. By that, all other archs could easily migrate afterwards. What do you
think?

  [1] http://www.spinics.net/lists/linux-crypto/msg09558.html
