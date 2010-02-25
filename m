From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in
	sha1_update()
Date: Thu, 25 Feb 2010 17:29:16 +0100
Message-ID: <19334.42332.984074.920727@pilspetsen.it.uu.se>
References: <4B8692E3.9030509@gmail.com>
	<19334.40337.651079.440912@pilspetsen.it.uu.se>
	<84144f021002250816o2c2cef0fke484c7e43256dba4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mikael Pettersson <mikpe@it.uu.se>,
	Roel Kluin <roel.kluin@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:55810 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932877Ab0BYQ30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2010 11:29:26 -0500
In-Reply-To: <84144f021002250816o2c2cef0fke484c7e43256dba4@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Pekka Enberg writes:
 > On Thu, Feb 25, 2010 at 5:56 PM, Mikael Pettersson <mikpe@it.uu.se> =
wrote:
 > > I fear that the only portable (across compiler versions) and safe
 > > solution is to invoke an assembly-coded dummy function with protot=
ype
 > >
 > > =A0 =A0 =A0 =A0void use(void *p);
 > >
 > > and rewrite the code above as
 > >
 > > =A0 =A0 =A0 =A0{
 > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u32 temp[...];
 > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0...
 > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(temp, 0, sizeof temp);
 > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0use(temp);
 > > =A0 =A0 =A0 =A0}
 > >
 > > This forces the compiler to consider the buffer live after the
 > > memset, so the memset cannot be eliminated.
 >=20
 > So is there some "do not optimize" GCC magic that we could use for a
 > memzero_secret() helper function?

I guess there's some -fno-builtin-... that might achieve this effect,
but that would disable all memset optimizations, not just those affecti=
ng
sensitive data.

You'd want a function attribute or magic type annotation and apply it
only to the specific cases where it's needed. Alas, I know of no such
attribute or annotation. ('volatile' doesn't work, I tried that.)

Ask on gcc@gcc.gnu.org.
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
