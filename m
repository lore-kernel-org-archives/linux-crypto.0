From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] crypto_mem_not_equal: add constant-time equality testing
 of memory regions
Date: Thu, 19 Sep 2013 10:37:28 +0200
Message-ID: <523AB7C8.2010108@redhat.com>
References: <5232CDCF.50208@redhat.com> <1379259179-2677-1-git-send-email-james@openvpn.net> <878uyyks0e.fsf@mid.deneb.enyo.de> <5235E77F.1050807@openvpn.net> <5236B9A7.3090001@redhat.com> <52373BA3.9090709@openvpn.net> <5238A860.2010404@redhat.com> <523A41AE.9060105@openvpn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Weimer <fw@deneb.enyo.de>,
	Marcelo Cerri <mhcerri@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au
To: James Yonan <james@openvpn.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab3ISIjZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Sep 2013 04:39:25 -0400
In-Reply-To: <523A41AE.9060105@openvpn.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/19/2013 02:13 AM, James Yonan wrote:
[...]
> We can easily specify -Os in the Makefile rather than depending on #pragma optimize or __attribute__ optimize if they are considered broken.
>
> Re: arch/*/crypto/... asm, not sure it's worth it given the extra effort to develop, test, and maintain asm for all archs.  The two things we care about (constant time and performance) seem readily achievable in C.
>
> Regarding O0 vs. Os, I would tend to prefer Os because it's much faster than O0, but still carries the desirable property that optimizations that increase code size are disabled.  It seems that short-circuit optimizations would be disabled by this, since by definition a short-circuit optimization requires the addition of a compare and branch.

Ok, if we can make sure that this would overwrite global defaults in any circumstances,
then that approach should be fine, imho.

I would suggest that you use the crypto_mem_not_equal() function that you originally had
or that I was proposing, and still allow the possibility for an arch optimized version,
if people want to.

In that way, it can be kept simple and stupid and easy to review, just like all other
util functions such as memcmp etc is implemented in [1].

  [1] http://lingrok.org/xref/linux-net-next/lib/string.c#643
