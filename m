From: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 1/5] Add general crypto auditing infrastructure
Date: Tue, 23 Nov 2010 10:12:31 -0500
Message-ID: <1290525151.1443.11.camel@localhost.localdomain>
References: <344091777.216361290516431362.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
	 <1290516635-26601-1-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sgrubb@redhat.com, herbert@gondor.hengli.com.au,
	linux-audit@redhat.com, linux-crypto@vger.kernel.org
To: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab0KWPMl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Nov 2010 10:12:41 -0500
In-Reply-To: <1290516635-26601-1-git-send-email-mitr@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2010-11-23 at 13:50 +0100, Miloslav Trma=C4=8D wrote:
> Collect audited crypto operations in a list, because a single _exit()
> can cause several AF_ALG sockets to be closed, and each needs to be
> audited.
>=20
> Add the AUDIT_CRYPTO_OP field so that crypto operations are not audit=
ed
> by default, but auditing can be enabled using a rule (probably
> "-F crypto_op!=3D0").

Just an implementation question, why a new list instead of finding a wa=
y
to reuse struct audit_aux_data?

-Eric
