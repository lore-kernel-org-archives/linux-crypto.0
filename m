From: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 20:53:34 -0300
Message-ID: <550A0FFE.9070805@cesarb.eti.br>
References: <20150318095345.GA12923@zoho.com> <550972A7.9030100@iogearbox.net> <1426691374.2212055.242060697.4DDF89CA@webmail.messagingengine.com> <4937031.1sk5yglzr8@tauon> <20150318171402.GB24195@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Daniel Borkmann <daniel@iogearbox.net>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: mancha <mancha1@zoho.com>, Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hm1481-41.locaweb.com.br ([189.126.112.4]:57591 "EHLO
	hm1481-41.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbbCSAIq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 20:08:46 -0400
In-Reply-To: <20150318171402.GB24195@zoho.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18-03-2015 14:14, mancha wrote:
> On Wed, Mar 18, 2015 at 05:02:01PM +0100, Stephan Mueller wrote:
>> Am Mittwoch, 18. M=C3=A4rz 2015, 16:09:34 schrieb Hannes Frederic So=
wa:
>>> Seems like just using barrier() is the best and easiest option.
>
> However, if the idea is to use barrier() instead of OPTIMIZER_HIDE_VA=
R()
> in crypto_memneq() as well, then patch 0002 is the one to use. Please
> review and keep in mind my analysis was limited to memzero_explicit()=
=2E
>
> Cesar, were there reasons you didn't use the gcc version of barrier()
> for crypto_memneq()?

Yes. Two reasons.

Take a look at how barrier() is defined:

#define barrier() __asm__ __volatile__("": : :"memory")

It tells gcc that the dummy assembly "instruction" touches memory (so=20
the compiler can't assume anything about the memory), and that nothing=20
should be moved from before to after the barrier and vice versa.

It mentions nothing about registers. Therefore, as far as I know gcc ca=
n=20
assume that the dummy "instruction" touches no integer registers (or=20
restores their values). I can imagine a sufficiently perverse compiler=20
using that fact to introduce timing-dependent computations. For=20
instance, it could load the values using more than one register and=20
combine them at the end, after the barriers; there, it could exit early=
=20
in case one of the registers is all-ones. My definition of=20
OPTIMIZER_HIDE_VAR introduces a data dependency to prevent that:

#define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=3Dr" (var) : "0" (var))

The second reason is that barrier() is too strong. For crypto_memneq,=20
only the or-chain is critical; the order or width of the loads makes no=
=20
difference. The compiler could, if it wishes, do all the loads and xors=
=20
first and do the or-chain at the end, or whenever it can see a pipeline=
=20
bubble; it doesn't matter as long as it does *all* the "or" operations,=
=20
in sequence.

I would be comfortable with a stronger OPTIMIZER_HIDE_VAR (adding=20
"memory" or volatile), even though it could limit optimization=20
opportunities, but I wouldn't be comfortable with a weaker=20
OPTIMIZER_HIDE_VAR (removing the data dependency), unless the gcc and=20
clang guys promise that our definition of barrier() will always prevent=
=20
undesired optimization of register-only operations.

There was a third reason for the exact definition of OPTIMIZER_HIDE_VAR=
:=20
it was copied from RELOC_HIDE, which is a longstanding "hide this=20
variable from gcc" operation, and thus known to work as expected.

--=20
Cesar Eduardo Barros
cesarb@cesarb.eti.br
