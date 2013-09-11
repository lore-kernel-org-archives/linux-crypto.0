From: James Yonan <james@openvpn.net>
Subject: Re: [PATCH] crypto_memcmp: add constant-time memcmp
Date: Wed, 11 Sep 2013 11:20:09 -0600
Message-ID: <5230A649.5010703@openvpn.net>
References: <1378838291-7036-1-git-send-email-james@openvpn.net> <522F6BB3.2050308@redhat.com> <20130911121956.GA16462@oc8526070481.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Daniel Borkmann <dborkman@redhat.com>,
	linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
	Florian Weimer <fw@deneb.enyo.de>
To: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from magnetar.openvpn.net ([74.52.27.18]:44789 "EHLO
	magnetar.openvpn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab3IKRVu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Sep 2013 13:21:50 -0400
In-Reply-To: <20130911121956.GA16462@oc8526070481.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/09/2013 12:57, Daniel Borkmann wrote:
> There was a similar patch posted some time ago [1] on lkml, where
> Florian (CC) made a good point in [2] that future compiler optimizations
> could short circuit on this. This issue should probably be addressed in
> such a patch here as well.
>
>  [1] https://lkml.org/lkml/2013/2/10/131
>  [2] https://lkml.org/lkml/2013/2/11/381

On 11/09/2013 06:19, Marcelo Cerri wrote:
> The discussion that Daniel pointed out has another interesting point
> regarding the function name. I don't think it's a good idea to name it
> crypto_memcpy since it doesn't have behavior the same way as strcmp.
>
> Florian suggested in the thread names such crypto_mem_equal, which I
> think fits better here.

Ok, here's another stab at this:

* Changed the name to crypto_mem_not_equal.  The "not_equal" seems to
make more sense because the function returns a nonzero "true" value if
the memory regions are not equal.

* Good point that a smart optimizer might add instructions to
short-circuit the loop if all bits in ret have been set.  One way to
deal with this is to disable optimizations that might increase code
size, since a short-circuit optimization in this case would require
adding instructions.

    #pragma GCC optimize ("Os")

The nice thing about using #pragma is that older versions of gcc that
don't recognize it will simply ignore it, and we can probably presume
that older versions of gcc do not support a short-circuit optimization
if the latest one does not.  I did a quick test using gcc 3.4.6 at -O2,
and did not see any evidence of a short-circuit optimization.

* Improved performance when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is
enabled.  This makes the performance roughly on-par with memcmp.

----------------

#pragma GCC optimize ("Os")

noinline unsigned long crypto_mem_not_equal(const void *a, const void *b, size_t size)
{
	unsigned long ret = 0;

#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
#if BITS_PER_LONG == 64
	while (size >= 8) {
		ret |= *(unsigned long *)a ^ *(unsigned long *)b;
		a += 8;
		b += 8;
		size -= 8;
	}
	if (!size)
		return ret;
#endif /* BITS_PER_LONG == 64 */
	if (sizeof(unsigned int) == 4) {
		while (size >= 4) {
			ret |= *(unsigned int *)a ^ *(unsigned int *)b;
			a += 4;
			b += 4;
			size -= 4;
		}
		if (!size)
			return ret;
	}
#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
	while (size > 0) {
		ret |= *(unsigned char *)a ^ *(unsigned char *)b;
		a += 1;
		b += 1;
		size -= 1;
	}
	return ret;
}

James
