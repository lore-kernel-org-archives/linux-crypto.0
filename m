From: James Yonan <james@openvpn.net>
Subject: Re: [PATCH] crypto_memcmp: add constant-time memcmp
Date: Sun, 15 Sep 2013 09:38:12 -0600
Message-ID: <5235D464.8070303@openvpn.net>
References: <1378838291-7036-1-git-send-email-james@openvpn.net> <522F6BB3.2050308@redhat.com> <20130911121956.GA16462@oc8526070481.ibm.com> <5230A649.5010703@openvpn.net> <5232CDCF.50208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
	Florian Weimer <fw@deneb.enyo.de>
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from magnetar.openvpn.net ([74.52.27.18]:46701 "EHLO
	magnetar.openvpn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab3IOPiX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Sep 2013 11:38:23 -0400
In-Reply-To: <5232CDCF.50208@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 13/09/2013 02:33, Daniel Borkmann wrote:
> On 09/11/2013 07:20 PM, James Yonan wrote:
>> On 10/09/2013 12:57, Daniel Borkmann wrote:
>>> There was a similar patch posted some time ago [1] on lkml, where
>>> Florian (CC) made a good point in [2] that future compiler optimizations
>>> could short circuit on this. This issue should probably be addressed in
>>> such a patch here as well.
>>>
>>>  [1] https://lkml.org/lkml/2013/2/10/131
>>>  [2] https://lkml.org/lkml/2013/2/11/381
>>
>> On 11/09/2013 06:19, Marcelo Cerri wrote:
>>> The discussion that Daniel pointed out has another interesting point
>>> regarding the function name. I don't think it's a good idea to name it
>>> crypto_memcpy since it doesn't have behavior the same way as strcmp.
>>>
>>> Florian suggested in the thread names such crypto_mem_equal, which I
>>> think fits better here.
>>
>> Ok, here's another stab at this:
>>
>> * Changed the name to crypto_mem_not_equal.  The "not_equal" seems to
>> make more sense because the function returns a nonzero "true" value if
>> the memory regions are not equal.
>
> Ok, sounds good.
>
>> * Good point that a smart optimizer might add instructions to
>> short-circuit the loop if all bits in ret have been set.  One way to
>> deal with this is to disable optimizations that might increase code
>> size, since a short-circuit optimization in this case would require
>> adding instructions.
>>
>>     #pragma GCC optimize ("Os")
>>
>> The nice thing about using #pragma is that older versions of gcc that
>> don't recognize it will simply ignore it, and we can probably presume
>> that older versions of gcc do not support a short-circuit optimization
>> if the latest one does not.  I did a quick test using gcc 3.4.6 at -O2,
>> and did not see any evidence of a short-circuit optimization.
>>
>> * Improved performance when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is
>> enabled.  This makes the performance roughly on-par with memcmp.
>
> Hm, why don't we take fixed-size versions of Daniel J Bernstein from NaCl
> library [1], e.g. for comparing hashes?
>
> E.g. for 16 bytes:
>
> int crypto_verify(const unsigned char *x,const unsigned char *y)
> {
>    unsigned int differentbits = 0;
> #define F(i) differentbits |= x[i] ^ y[i];
>    F(0)
>    F(1)
>    F(2)
>    F(3)
>    F(4)
>    F(5)
>    F(6)
>    F(7)
>    F(8)
>    F(9)
>    F(10)
>    F(11)
>    F(12)
>    F(13)
>    F(14)
>    F(15)
>    return (1 & ((differentbits - 1) >> 8)) - 1;
> }
>
> It will return 0 if x[0], x[1], ..., x[15] are the same as y[0], y[1],
> ..., y[15],
> otherwise it returns -1. That's w/o for loops, so probably more
> "compiler-proof" ...
>
>    [1] http://nacl.cr.yp.to/

Ok, I've resubmitted full patch with fast path for size == 16.

James
