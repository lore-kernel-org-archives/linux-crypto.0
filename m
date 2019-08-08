Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 444DBC0650F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 16:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D2A02173E
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 16:31:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Kdfhd7YG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733261AbfHHQbC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 12:31:02 -0400
Received: from mout.gmx.net ([212.227.17.21]:52759 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732572AbfHHQbC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 12:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565281848;
        bh=ApY7OZPSYwzixgHZnbsMvFQ1c+7KmwYp4ibokGDQPh4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Kdfhd7YGh3LIvz4hPEOX6zAQ1r/wM53Yye7YIAnwn49DgvyUrpnEDHHA7a0dNNpuw
         7bUA/2RugqnopbUbQH21LRlY2UWNXpr4TvNI5QyPa0LglyxyMvA+Jd+W/sW34A+r6Z
         MJmBpq/bH5F9tf6tYrkXnOUvekRw3is5cQz76AuA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([109.90.233.87]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M4s0t-1hvTvr3Eal-00206Y; Thu, 08
 Aug 2019 18:30:48 +0200
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     linux-doc@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: crypto: crypto_engine: Fix Sphinx warning
Date:   Thu,  8 Aug 2019 18:30:11 +0200
Message-Id: <20190808163011.13468-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:iRrUwdnP6UvZOFNMPugqv13gYNrjJql3ZF1wCToYefNJiQOaI/Z
 da64eNBOGz2H03FO3AGcefCkMag6RiR7WTkuc4/AR9wKVZu9c+4fbW04xeX3PIso4KRqoU+
 4RW8ZQ+18NmJncFaKOAw5XW/xrPEGMmmPlBQ8ZdJ3Bj2d3i+GJqMT8Ab31jIolpsKlt7FuE
 W6h+HQuk7DEN+dctwXY5g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:as0rovH/+bE=:074+Rmgq//F8ZdwCFeKe8F
 S2ZMJCvbRWH79yiEDQyEW52pixkoTeKJS1NBsUH3gmUNWgk/Arrum4LHoFdcOusM5r1WtN6Ef
 7QL5tIEBNiXjQqyngJP/JUJAC099m0SMFbjJ6r93jpNi32abX/10piHXp2UWtW74W3syk9pv0
 f6URGyZmSGGmugKapb9sMf6u9EA7i7K4ty5OIzI6XMl/aqreiHFvhoAwva4wUuPz2Ox3QHWsP
 pcRC9AKzRFLQvVyW2jGg5epu4UfOHnc7Lp8MjU8j/JCLvQ1DS6gKwh8F9upbJ+w59npi2Jzwn
 cGg8yprpvEffVY+lZeAzkaa0KmcBOxbvxuutTstzpr5M4m9qPldXXVeSBaTnh9J4WWKjZx5/F
 QAKvFK66Uai6eq20FFOOW0RySdUa0hu1fL2VEz7mrDhiRSJbqC62SbUTExmU8sderCklmo4FO
 vTeE4dRfiZ5fXo4rd0Rz5R135Cv+EQrAbRwnjL0tBjd6LVHdzlEbWVCfIDRtSZI+RDwiobAZf
 NK3C/CrljCmP2hCyWmX0y/sJrPu2YnK7JJMxUwOR9NqH8kQ/zJ8FB+/pJO3IUiYQps+PO6j7p
 gAzXni4PGMPYjAU9VqM91RwxwCmjrwxb7m0WJe12FE/ZO/N+kPF2SmgbLa2Ar3GqCG3Lo4Swg
 +zb/2yuCaiFCB88RK5dFmBlg4idjM+tVeb3Iqc36Vmly+fFl4mJOrB3OVWDglyyEw8BBLO185
 NpTMC2RnC4cM6l9CzaRxWVhiOTuKgl1n/23545uJwiCzhELniVOnl8Lkn3QArdo1hH+lBUry0
 5brgRhVTIfzDtv2c81lTTfuA+iDGjj/vsTDPRHq01jD4k2maUhmx6MytKRdq5B5aY8gEEosW8
 h4XIxZn1NE6dfvdc1gpbM2i3k1onmVYTrg7BIeSs7lAQAhq6A6D6AVIMCWAPkmkJFT06e5mG0
 AaY77pzKc3rUK/dwJ22wTlDEAnY4O+AlAkTTx9douVUi9BXngta+KW84NJEd3O5/K/T/4AzZm
 mZBSxWEHCwEKIPm8b2fRM0sb3+nkSH+qdwQSYAwE42mMktmVE8UtHMKzyu7bHcXQTpIzNGRUb
 YcOcBxcKcm4ucPcYXB4SJBjzMZf2MK6N2rAw0V1LzQauNtAXdR1dOb5amv5K2L7aj7xI2VGxa
 S6iuA=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fixes the following Sphinx warning:

Documentation/crypto/crypto_engine.rst:2:
  WARNING: Explicit markup ends without a blank line; unexpected unindent.

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 Documentation/crypto/crypto_engine.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/crypto/crypto_engine.rst b/Documentation/crypto=
/crypto_engine.rst
index 236c674d6897..3baa23c2cd08 100644
=2D-- a/Documentation/crypto/crypto_engine.rst
+++ b/Documentation/crypto/crypto_engine.rst
@@ -1,4 +1,5 @@
 .. SPDX-License-Identifier: GPL-2.0
+
 Crypto Engine
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

=2D-
2.20.1

