Return-Path: <SRS0=HNf+=6C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CCFC38A2C
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Apr 2020 10:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5599121D7E
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Apr 2020 10:21:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.com header.i=@cs.com header.b="UpPyuQ05"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgDRKVx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Apr 2020 06:21:53 -0400
Received: from sonic313-42.consmr.mail.bf2.yahoo.com ([74.6.133.216]:42549
        "EHLO sonic313-42.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgDRKVw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Apr 2020 06:21:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.com; s=a2048; t=1587205268; bh=CKfzb7eIuNco3koZ7Y2NU7Q5Dcsl/mvu6zCyT2Vk+tM=; h=From:Subject:Date:To:References:From:Subject; b=UpPyuQ050AGg2uJjFvu/615n9NTZxEkIpkgE2moPKl9ocu9+0X3B+SGPeD/rXN8fiMRpGY72Jc9A5NpB07zJ+6D8gBRsGdOYXyarX5gAWKP6gCcDu3ebt4Emzpa6dptrnrvd2D2OVFLgkXpmCt5zitpK5zfJRYwuEZHb/CgT13IdKSBCMfPGvc97qDaLVc7PVseXls/ihNsOiIY4EXSrp/x0zrdTmzul0ykrnS/+5oKS6oDfvTF2bY9e8zVPx3q7bkwuBRJFLHBGr+PIUHza8sz9ykDCGucFLo28kq3sSuF0sFlqSviG6uWu2mdIWRm7XzBXTCaycWXeV0xmApqejg==
X-YMail-OSG: ZP68mSIVM1nN4FTC2OlGQTD96zW7g9dv3U70mCYQWt1cvgyvZv2SNy3GiGfUDmz
 Z9ln8BK8Kw5MPkPLapjCfWHjkfxhy9C7H2tvHR7CSmkRZy_mHP0KcvuDfkqu2oIVdk404yCZ32rb
 ThcNDSAVWCzuxXgI1nLu56v.5tZLLXFOw.K3ni_SBB9qcR84f1pcRofffh1T9NznHqUer9yQFnhA
 Y3m1bp2Yd_PVIJtQXehu.2___e7mQp2i0hT7VotYSjkhlKdUq4uWgUtwxTG9.5WOEfHiSeJWL9Jj
 uUqZUd9qMRqN_XoSO5zRH871levP51bPdJBQasG.9e405Na8Nli_o0Hd9qp0XsDrGMtC43klx068
 NOSpWH7aA9B7o089ggNC2jj1hIRFx3G0pLWxnCfNRrhY67YZUS6CjEY7u4kmPJ4P3tPj2tz0VZI_
 VxNGxidqMxSdpi4vZ9ajiksqk5q_D0ybIurEys.FUAO4oC_lCdJF9ms8JtRyIsIlDMXkl0MOzF3F
 8JNGKKbCutUZVqgbY3HyDMY9jGn7aTee8sqrGkJDTeOcHEpJC248qdQeKemd4YNVsdeSHE6UryRV
 N0eh0QuVlc.wY5MkRfazWYGItKEfqM.bvCRXx4.J99u0l61zcwAkfNZ6nZlaMTBSca0Y1Lh4AMGU
 Abgb7oG6gkqYvQtOKt2ezy4V9O.nvzF6QxQsB5szcIHYnZ6d3eoSsAeUDT54He9yYP7NqbdaSNDq
 kl8ERmRiFWPeUjXutJm49cJxNaVHlS3PZycsZC2F.OsMKp1OKMbz9SCEmXyCIsMW3PNxRXa1FGoK
 9oLOBQvuegBbdh4CxCr2sYvk3ZLKKWdKQR335Ns1pTn9NVQWKmWgjVQXVmK5FnMLDjsiFD6CnZJj
 bYuaCveS0uXyWKCPSvW_rRcPbHvMkdNp52uvbdnjVUnteSkgSJsszNbyU6BQoXi2EqjK5yoeZFKN
 ITjHTBAG6dsEY0_sXbIjNCf6T9nRNPlFPT2MyfzoSmE4XIxtqXNbV76Wgo4BAzd841aaHiloGu8P
 7_0HdDgK4NNerQUwzcIfZhphCSvlQOTNrbacbehV6Q4j0USO84QG8SXr.AQr2pplBeQYt3Pm6KiU
 5Fxrfnz_xWUL8pImReqip6OoMi90wPf7Zvpw5JfTn8gIYAmlkWI6zmn6CecCS5m_Aov1mQCVRw6g
 zmmaZuoQRUesdk7lB3PrnKP0dnvLKRDZxDpvcB88eTiwzUBPqqB3ikEb3lSuDuhZY0yDAkC174xL
 i2XORBHACfNj4gGsPOg2zqB43jBRJS.UJnNenvaBsXnECTLGsO1LzLKwjXUCrFSOC4j40sdBTCYi
 z_a0DGvXhJJeraSUF0IXu_F_3Yeq8heDAOKb8IrWBsGDsKB_zZHNKQFzyifiID9jXVxqb87MgtW0
 UStsqpTqzkCuD
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.bf2.yahoo.com with HTTP; Sat, 18 Apr 2020 10:21:08 +0000
Received: by smtp428.mail.sg3.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 1947ab8000c7ff7a9349a49dabf40a9d;
          Sat, 18 Apr 2020 10:19:06 +0000 (UTC)
From:   R W van Schagen <vschagen@cs.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Question: IPSEC ping fails with new crypto driver how to debug?
Message-Id: <BF4F5F95-4D34-48F4-9CD7-242D858806DC@cs.com>
Date:   Sat, 18 Apr 2020 18:19:04 +0800
To:     linux-crypto@vger.kernel.org
X-Mailer: Apple Mail (2.3608.80.23.2.2)
References: <BF4F5F95-4D34-48F4-9CD7-242D858806DC.ref@cs.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

My crypto driver (under development) is passing all the extended test =
manager test (I=E2=80=99m on Kernel v5.4.31).

For debugging purposes I can either only register =E2=80=9Ccbc(aes)=E2=80=9D=
 or the full =E2=80=9Cauthenc(hmac(256), cbc(aes))=E2=80=9D.

For testing purposes I am only using two simple =E2=80=9Cip xfrm =
state=E2=80=9D and =E2=80=9Cip xfrm policy=E2=80=9D plus additional =
=E2=80=9Cip route=E2=80=9D.
Without my driver the tunnel works as expected using the generic in-tree =
software modules.

Whit the driver installed before setting up the tunnel the self-tests =
are run. (No test for =E2=80=9Cechainiv(authenc=E2=80=A6=E2=80=9D)
So incase I am only using the =E2=80=9Ccbc(aes)=E2=80=9D the =
authenc(hham(sha256-generic), eip-cbc-aes) is created and tested (pass). =
The echainiv(authenc=E2=80=A6) is also created.

Even though all the extended tests were successful I can=E2=80=99t ping =
from my device.

I=E2=80=99m getting =E2=80=9Cping: send to: Out of memory=E2=80=9D.=20

Pinging to the device works as expected. However: if I=E2=80=99m adding =
a =E2=80=9Csize=E2=80=9D to the ping, it starts works:

=E2=80=9Cping 10.0.0.2 -s1411=E2=80=9D works without any problem. =
Anything less than 1411 fails =E2=80=9Cout of memory=E2=80=9D??

I did hex_dumps of the source and destination scatterlists and well as =
the IV, authentication TAG. They look the same for both and =E2=80=9Cinbou=
nd - ping=E2=80=9D and an =E2=80=9Coutbound - ping=E2=80=9D, with the =
exception that the encrypt/decrypt calls are reversed (obviously). This =
also shows that the tunnel works otherwise I would get anything into the =
driver.
=E2=80=9Cip -s x s=E2=80=9D also confirms that packets are being send =
and received.

Again all else the same, except the driver not loaded, it works, so =
firewall or routing problems can be eliminated.

Any suggestions where to start looking for the =E2=80=9Cbug=E2=80=9D in =
my driver?=
