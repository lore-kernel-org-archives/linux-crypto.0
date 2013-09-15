From: James Yonan <james@openvpn.net>
Subject: Re: [PATCH] crypto_mem_not_equal: add constant-time equality testing
 of memory regions
Date: Sun, 15 Sep 2013 10:59:43 -0600
Message-ID: <5235E77F.1050807@openvpn.net>
References: <5232CDCF.50208@redhat.com> <1379259179-2677-1-git-send-email-james@openvpn.net> <878uyyks0e.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Daniel Borkmann <dborkman@redhat.com>,
	Marcelo Cerri <mhcerri@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au
To: Florian Weimer <fw@deneb.enyo.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from magnetar.openvpn.net ([74.52.27.18]:46738 "EHLO
	magnetar.openvpn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab3IOQ7y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Sep 2013 12:59:54 -0400
In-Reply-To: <878uyyks0e.fsf@mid.deneb.enyo.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 15/09/2013 09:45, Florian Weimer wrote:
> * James Yonan:
>
>> + * Constant-time equality testing of memory regions.
>> + * Returns 0 when data is equal, non-zero otherwise.
>> + * Fast path if size == 16.
>> + */
>> +noinline unsigned long crypto_mem_not_equal(const void *a, const void *b, size_t size)
>
> I think this should really return unsigned or int, to reduce the risk
> that the upper bytes are truncated because the caller uses an
> inappropriate type, resulting in a bogus zero result.  Reducing the
> value to 0/1 probably doesn't hurt performance too much.  It also
> doesn't encode any information about the location of the difference in
> the result value, which helps if that ever leaks.

The problem with returning 0/1 within the function body of 
crypto_mem_not_equal is that it makes it easier for the compiler to 
introduce a short-circuit optimization.

It might be better to move the test where the result is compared against 
0 into an inline function:

noinline unsigned long __crypto_mem_not_equal(const void *a, const void 
*b, size_t size);

static inline int crypto_mem_not_equal(const void *a, const void *b, 
size_t size) {
	return __crypto_mem_not_equal(a, b, size) != 0UL ? 1 : 0;
}

This hides the fact that we are only interested in a boolean result from 
the compiler when it's compiling crypto_mem_not_equal.c, but also 
ensures type safety when users test the return value.  It's also likely 
to have little or no performance impact.

James
