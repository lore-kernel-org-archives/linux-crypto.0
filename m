From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 1/5] Add general crypto auditing infrastructure
Date: Tue, 23 Nov 2010 13:25:51 -0500 (EST)
Message-ID: <1446795227.263741290536751501.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <1290525151.1443.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sgrubb@redhat.com, herbert@gondor.hengli.com.au,
	linux-audit@redhat.com, linux-crypto@vger.kernel.org
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:47359 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0KWSZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Nov 2010 13:25:55 -0500
In-Reply-To: <1290525151.1443.11.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Eric Paris" <eparis@redhat.com> wrote:
> On Tue, 2010-11-23 at 13:50 +0100, Miloslav Trma=C4=8D wrote:
> > Collect audited crypto operations in a list, because a single _exit=
()
> > can cause several AF_ALG sockets to be closed, and each needs to be
> > audited.
> >=20
> > Add the AUDIT_CRYPTO_OP field so that crypto operations are not
> audited
> > by default, but auditing can be enabled using a rule (probably
> > "-F crypto_op!=3D0").
>=20
> Just an implementation question, why a new list instead of finding a =
way
> to reuse struct audit_aux_data?
This remained in the code from an earlier version where the relative or=
der of crypto records was meaningful.  In the current version the only =
difference is that an AUDIT_CRYPTO_OP filter has to traverse fewer entr=
ies.

Thanks for pointing this out, I'll drop the list.
    Mirek
