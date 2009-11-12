From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/7] crypto: testmgr: fix warning
Date: Thu, 12 Nov 2009 08:43:32 +0800
Message-ID: <20091112004332.GA777@gondor.apana.org.au>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com> <1255906474-25091-4-git-send-email-felipe.contreras@gmail.com> <alpine.LSU.2.00.0910191551030.8582@wotan.suse.de> <4ADC707E.2040802@redhat.com> <4ADC71C4.3020805@redhat.com> <94a0d4530911111632w4767b704v887629dcf0f2b0e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jarod Wilson <jarod@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	linux-crypto@vger.kernel.org
To: Felipe Contreras <felipe.contreras@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759833AbZKLAnp@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94a0d4530911111632w4767b704v887629dcf0f2b0e1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 12, 2009 at 02:32:10AM +0200, Felipe Contreras wrote:
> On Mon, Oct 19, 2009 at 4:03 PM, Jarod Wilson <jarod@redhat.com> wrot=
e:
> > So yeah, I rescind my claim that initializing err to 0 is incorrect=
, I think
> > that's just fine.
>=20
> So is this acked? Who will merge it?

It's already in cryptodev-2.6:

commit fa4ef8a6af4745bbf3a25789bc7d4f14a3a6d803
Author: Felipe Contreras <felipe.contreras@gmail.com>
Date:   Tue Oct 27 19:04:42 2009 +0800

    crypto: testmgr - Fix warning

    crypto/testmgr.c: In function =E2=80=98test_cprng=E2=80=99:
    crypto/testmgr.c:1204: warning: =E2=80=98err=E2=80=99 may be used u=
ninitialized in this function

    Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

Cheers,
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
