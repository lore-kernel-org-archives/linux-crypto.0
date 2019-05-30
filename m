Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE966C28CC3
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 09:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8380B2522E
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 09:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nC5wH4n7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfE3JQs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 05:16:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49241 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfE3JQr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 05:16:47 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20190530091644epoutp02736118599a6e2251b4784fc6922e6317~jazzRmYul1551915519epoutp02M
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2019 09:16:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20190530091644epoutp02736118599a6e2251b4784fc6922e6317~jazzRmYul1551915519epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559207804;
        bh=McVYQpKiUaxv/paH3JqRdWPw30RiaWGNCyNP7DPucCI=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=nC5wH4n78rIaUUcgBq6DYRpSgYQNc+iR6oRgPz3tqMgmKGir/fX4F+GuDUnotzTVc
         N9O0FXLGpuWkqqDGxYms7yP4SgehzfBBgs8N6FdafZ/E+TIBwMCzk0dmEJqvr3ezca
         G9VX+mRKbAxFyi1QpWoiaDmqGHi+/D3Dqp0CR1GM=
Received: from epsmges5p2new.samsung.com (unknown [182.195.40.198]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20190530091643epcas5p1008816f8f76a0dab210033426317a653~jazxpL5mn1222212222epcas5p1n;
        Thu, 30 May 2019 09:16:43 +0000 (GMT)
X-AuditID: b6c32a4a-973ff70000000fe2-73-5cef9f7b9482
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.55.04066.B7F9FEC5; Thu, 30 May 2019 18:16:43 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH 1/2] zstd: pass pointer rathen than structure to
 functions
Reply-To: v.narang@samsung.com
From:   Vaneet Narang <v.narang@samsung.com>
To:     Maninder Singh <maninder1.s@samsung.com>,
        "terrelln@fb.com" <terrelln@fb.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        AMIT SAHRAWAT <a.sahrawat@samsung.com>,
        PANKAJ MISHRA <pankaj.m@samsung.com>,
        Vaneet Narang <v.narang@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <1557468704-3014-1-git-send-email-maninder1.s@samsung.com>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20190530091327epcms5p11a7725e9c01286b1a7c023737bf4e448@epcms5p1>
Date:   Thu, 30 May 2019 14:43:27 +0530
X-CMS-MailID: 20190530091327epcms5p11a7725e9c01286b1a7c023737bf4e448
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAJsWRmVeSWpSXmKPExsWy7bCmlm71/PcxBv8/slpc3J1qMed8C4vF
        1j2qFt2vZCzOdOda3L/3k8ni8q45bBaH57exWNx7s5XJ4tW/a2wWh07OZXTg9pjdcJHFY8vK
        m0we6w6qekxsfsfuse2AqkffllWMHp83yQWwR+XYZKQmpqQWKaTmJeenZOal2yp5B8c7x5ua
        GRjqGlpamCsp5CXmptoqufgE6Lpl5gCdp6RQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUot
        SMkpMDQq0CtOzC0uzUvXS87PtTI0MDAyBapMyMl43PmAueAuZ8XrmWwNjFs5uxg5OSQETCSu
        3vrE3sXIxSEksJtRYtan56xdjBwcvAKCEn93CIPUCAsESBza2cYKYgsJyEkcv7GbESKuI3Fi
        3hpGkHI2AS2Jjy3hIGERgeVMEruOWIKMZBb4xShxfvU5JohdvBIz2p+yQNjSEtuXbwWbwyng
        LrFj72k2iLioxM3Vb9lh7PfH5jNC2CISrffOMkPYghIPfu4G2yshICOx6604yC4JgW5GiQnn
        lrNCODMYJU71voFqMJc4f3I+mM0r4CuxfO4VsGUsAqoS32/fglrgItE89wrYk8wC2hLLFr5m
        BlnALKApsX6XPkSJrMTUU+uYIEr4JHp/P4H7a8c8GFtJ4tzBnVC/SEg86ZwJdYKHxLvuM0yQ
        cO5jlLh28hDLBEaFWYignoVk8yyEzQsYmVcxSqYWFOempxabFhjlpZYjx+8mRnBq1fLawbjs
        nM8hRgEORiUe3gn572KEWBPLiitzDzFKcDArifD+XA4U4k1JrKxKLcqPLyrNSS0+xGgKDIOJ
        zFKiyfnAtJ9XEm9oamRmZmBpYGpsYWaoJM47ifVqjJBAemJJanZqakFqEUwfEwenVAPj6hWS
        np6iCb/3F3glFHOrnE997q4S6a6RXBDB7GrOVHqttkelYlV/TYXd4qM7j27isjBul/3y8eqT
        mzcv2nj+7r5Z3Ou3/l4r9xKtXZrLD11/k5tiHVlXymS/qc0/w+XKTPfSD5uFYie+aF7PedR5
        anTN0TfR6byt2+Y9TDbc5Fsxoe/2nFtKLMUZiYZazEXFiQC/8OP5wwMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190510061311epcas5p19e9bf3d08319ac99890e03e0bd59e478
References: <1557468704-3014-1-git-send-email-maninder1.s@samsung.com>
        <CGME20190510061311epcas5p19e9bf3d08319ac99890e03e0bd59e478@epcms5p1>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

=5BReminder=5D Any updates ?

> currently=C2=A0params=C2=A0structure=C2=A0is=C2=A0passed=C2=A0in=C2=A0all=
=C2=A0functions,=C2=A0which=C2=A0increases=0D=0A>=20stack=C2=A0usage=C2=A0i=
n=C2=A0all=C2=A0the=C2=A0function=C2=A0and=C2=A0lead=C2=A0to=C2=A0stack=C2=
=A0overflow=C2=A0on=C2=A0target=C2=A0like=0D=0A>=20ARM=C2=A0with=C2=A0kerne=
l=C2=A0stack=C2=A0size=C2=A0of=C2=A08=C2=A0KB=C2=A0so=C2=A0better=C2=A0to=
=C2=A0pass=C2=A0pointer.=0D=0A=C2=A0=0D=0A>=20Checked=C2=A0for=C2=A0ARM:=0D=
=0A=C2=A0=0D=0A=0D=0A>=20(ZSTD_compressContinue_internal)->=C2=A0136=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0->=C2=A088=0D=0A>=20(ZSTD_compressCCtx)=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0->=C2=
=A0192=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0->=C2=A064=0D=0A>=20(zstd_compress)=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0->=C2=A0144=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0->=
=C2=A096=0D=0A=0D=0ARegards,=0D=0AVaneet=20Narang
