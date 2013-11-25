From: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
Subject: Re: [PATCH] crypto: more robust crypto_memneq
Date: Mon, 25 Nov 2013 20:00:46 -0200
Message-ID: <5293C88E.9000203@cesarb.eti.br>
References: <1385327535-27991-1-git-send-email-cesarb@cesarb.eti.br> <529373C7.10201@openvpn.net> <52937A51.6070603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Florian Weimer <fw@deneb.enyo.de>, linux-kernel@vger.kernel.org
To: Daniel Borkmann <dborkman@redhat.com>,
	James Yonan <james@openvpn.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hm1479-39.locaweb.com.br ([201.76.49.220]:35074 "EHLO
	hm1479-39.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3KYWcZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Nov 2013 17:32:25 -0500
In-Reply-To: <52937A51.6070603@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Em 25-11-2013 14:26, Daniel Borkmann escreveu:
> On 11/25/2013 04:59 PM, James Yonan wrote:
>> This approach using __asm__ ("" : "=r" (var) : "0" (var)) to try to
>> prevent compiler optimizations of var is interesting.
>>
>> I like the fact that it's finer-grained than -Os and doesn't preclude
>> inlining.
>
> Agreed. This looks much better than the Makefile workaround. Do we have
> a hard guarantee that in future, this will not be detected and optimized
> away by the compiler?

That guarantee is something only the compiler people can give you. But 
given that RELOC_HIDE will break if that ever changes, and there are 
other constructs depending on the optimization-blocking behavior of 
inline assembly (like the many kinds of barriers in the kernel), I am 
not worried about that.

-- 
Cesar Eduardo Barros
cesarb@cesarb.eti.br
