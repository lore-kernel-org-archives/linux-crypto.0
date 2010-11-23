From: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 1/5] Add general crypto auditing infrastructure
Date: Tue, 23 Nov 2010 13:37:11 -0500
Message-ID: <1290537431.1443.22.camel@localhost.localdomain>
References: <1446795227.263741290536751501.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sgrubb@redhat.com, herbert@gondor.hengli.com.au,
	linux-audit@redhat.com, linux-crypto@vger.kernel.org
To: Miloslav Trmac <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab0KWShV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Nov 2010 13:37:21 -0500
In-Reply-To: <1446795227.263741290536751501.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2010-11-23 at 13:25 -0500, Miloslav Trmac wrote:
> ----- "Eric Paris" <eparis@redhat.com> wrote:
> > On Tue, 2010-11-23 at 13:50 +0100, Miloslav Trma=C4=8D wrote:
> > > Collect audited crypto operations in a list, because a single _ex=
it()
> > > can cause several AF_ALG sockets to be closed, and each needs to =
be
> > > audited.
> > >=20
> > > Add the AUDIT_CRYPTO_OP field so that crypto operations are not
> > audited
> > > by default, but auditing can be enabled using a rule (probably
> > > "-F crypto_op!=3D0").
> >=20
> > Just an implementation question, why a new list instead of finding =
a
> way
> > to reuse struct audit_aux_data?
> This remained in the code from an earlier version where the relative
> order of crypto records was meaningful.  In the current version the
> only difference is that an AUDIT_CRYPTO_OP filter has to traverse
> fewer entries.

It probably won't actually have to traverse extra entries.  We shouldn'=
t
(at least that I can think of) ever have a single syscall which is goin=
g
to have crypto, execve, signal, fcaps, etc. records simultaneously.  In
any case, if you send another round, I'd suggest reuse or aux.

-Eric
