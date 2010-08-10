From: "Loc Ho" <lho@apm.com>
Subject: RE: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 11:39:38 -0700
Message-ID: <027401cb38bb$64b6c310$2e244930$@com>
References: <15765372.157161281465237985.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com> <620451703.157241281465255300.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "'Neil Horman'" <nhorman@tuxdriver.com>,
	"'Herbert Xu'" <herbert@gondor.hengli.com.au>,
	"'Nikos Mavrogiannopoulos'" <n.mavrogiannopoulos@gmail.com>,
	<linux-crypto@vger.kernel.org>, "'Linda Wang'" <lwang@redhat.com>,
	"'Steve Grubb'" <sgrubb@redhat.com>,
	"'Neil Horman'" <nhorman@redhat.com>
To: "'Miloslav Trmac'" <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:41800 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932504Ab0HJSjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 14:39:42 -0400
Received: by pwj2 with SMTP id 2so2735798pwj.40
        for <linux-crypto@vger.kernel.org>; Tue, 10 Aug 2010 11:39:42 -0700 (PDT)
In-Reply-To: <620451703.157241281465255300.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Content-Language: en-us
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> 1. This CrytoDev (user space) interface needs to support multiple
> operations at once

I think this would be naturally solved by providing the async interface=
=2E
[Loc Ho]
Async only support a single operation at a time. HW are quite fast. The=
 ability to submit multiple payload for a single OS call improve in per=
formance. The software overhead with the submission alone can be more t=
han a single encrypt/decrypt/hashing operation.

-Loc

CONFIDENTIALITY NOTICE: This e-mail message, including any attachments,=
=20
is for the sole use of the intended recipient(s) and contains informati=
on=A0
that is confidential and proprietary to AppliedMicro Corporation or its=
 subsidiaries.=20
It is to be used solely for the purpose of furthering the parties' busi=
ness relationship.=20
All unauthorized review, use, disclosure or distribution is prohibited.=
=20
If you are not the intended recipient, please contact the sender by rep=
ly e-mail=20
and destroy all copies of the original message.
=0D
