Return-Path: <SRS0=6z3H=UD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF45C282CE
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 13:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E23C2251C
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 13:33:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="q+llcIgm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfFDNdV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jun 2019 09:33:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14395 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbfFDNdV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jun 2019 09:33:21 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190604133318epoutp04a83719748429dd02fd9db9d31b415d53~lAiO-ihlq0515305153epoutp044
        for <linux-crypto@vger.kernel.org>; Tue,  4 Jun 2019 13:33:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190604133318epoutp04a83719748429dd02fd9db9d31b415d53~lAiO-ihlq0515305153epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559655198;
        bh=1aLsXVY/wr2CuW5Tk9MkhyWV/LeW13egcTyA8RW2iMM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=q+llcIgmIE+nKyEDth0vGJXSKXjwIqcmCCtAk3njiGlG1Zcjo+KbhmDs46qiWA1Ip
         VFw9TC0LpBOkTs1G52XMVguAPaPl4nJmo4zCxHitr5uK/SJ9H6HhAydGQGAJQyO8xh
         ltM9eRTLDnk/uBBAFpTwycgde84/r1BGFStb8chY=
Received: from epsmges5p1new.samsung.com (unknown [182.195.40.193]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20190604133316epcas5p3b088c59033d7fd46263f8507907a9ba2~lAiM63HyX2076420764epcas5p3r;
        Tue,  4 Jun 2019 13:33:16 +0000 (GMT)
X-AuditID: b6c32a49-5b7ff70000000fe7-3f-5cf6731c2aaf
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AF.03.04071.C1376FC5; Tue,  4 Jun 2019 22:33:16 +0900 (KST)
Mime-Version: 1.0
Subject: RE:(2) [PATCH 1/4] zstd: pass pointer rathen than structure to
 functions
Reply-To: v.narang@samsung.com
From:   Vaneet Narang <v.narang@samsung.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Maninder Singh <maninder1.s@samsung.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "joe@perches.com" <joe@perches.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        AMIT SAHRAWAT <a.sahrawat@samsung.com>,
        PANKAJ MISHRA <pankaj.m@samsung.com>,
        Vaneet Narang <v.narang@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20190603144132.7611b8fe3cf6928d8391a24a@linux-foundation.org>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20190604131935epcms5p1c4a375fca57e4df5d233fd2769a3c2be@epcms5p1>
Date:   Tue, 04 Jun 2019 18:49:35 +0530
X-CMS-MailID: 20190604131935epcms5p1c4a375fca57e4df5d233fd2769a3c2be
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBJsWRmVeSWpSXmKPExsWy7bCmpq5M8bcYg/u/eS0u7k61mLN+DZvF
        nPMtLBZb96hadL+SsZh9/zGLxZnuXIv7934yWVzeNYfN4vD8NhaLe2+2MlkcOjmX0YHHY3bD
        RRaPLStvMnmsO6jqse2AqseJGb9ZPL6susbs0bdlFaPH501yARxROTYZqYkpqUUKqXnJ+SmZ
        eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIcqKZQl5pQChQISi4uV9O1sivJL
        S1IVMvKLS2yVUgtScgoMjQr0ihNzi0vz0vWS83OtDA0MjEyBKhNyMq73XmYpaGet6Pq2ia2B
        8RNLFyMnh4SAiUTnhtesXYxcHEICuxkllh9eC+RwcPAKCEr83SEMYgoLBEvM/5MBUi4kICdx
        /MZuRhBbWEBH4sS8NYwgJWwCWhIfW8JBTBGBSIlbq9RBBjILfGaWaD/ziRFiE6/EjPanUFul
        JbYv3woW5xTwlri5bi87RFxU4ubqt3D2+2PzoXpFJFrvnWWGsAUlHvzcDbZWQkBGYtdbcZBd
        EgLdjBITzi1nhXBmMEqc6n0D1WAucf7kfDCbV8BXYtGaq0wgNouAqsSLx+fZIQa5SPx+Vg4S
        ZhbQlli28DUzSJhZQFNi/S59iCmyElNPrWOCKOGT6P39hAnmrR3zYGwliXMHd7JB2BISTzpn
        Ql3gIfFobRs0kHuYJI5MPc08gVFhFiKcZyHZPAth8wJG5lWMkqkFxbnpqcWmBYZ5qeXIsbuJ
        EZxqtTx3MM4653OIUYCDUYmHd0b8txgh1sSy4srcQ4wSHMxKIryJt7/ECPGmJFZWpRblxxeV
        5qQWH2I0BQbBRGYp0eR8YB7IK4k3NDUyMzOwNDA1tjAzVBLnncR6NUZIID2xJDU7NbUgtQim
        j4mDU6qBMXaV5hbHVOMPv5IOpYrc6VrwflfeDQ1btS8C1Wde/uK6qSF/56lU9cHVV158Kn1s
        c36hcEQ/h0XvFZl5r86svsQjvO6hktDe2yeln4rFF27vNF0YVMap8POD7MWAzZZB2w8YTMvb
        dLZxsZOWecOU+xPXPSnYY65gzJMRE2S0JPq+yukN+36vF1ViKc5INNRiLipOBACEjAf6ywMA
        AA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190603090232epcas5p1630d0584e8a1aa9495edc819605664fc
References: <20190603144132.7611b8fe3cf6928d8391a24a@linux-foundation.org>
        <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
        <1559552526-4317-2-git-send-email-maninder1.s@samsung.com>
        <CGME20190603090232epcas5p1630d0584e8a1aa9495edc819605664fc@epcms5p1>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andrew,
=C2=A0=0D=0A>But=C2=A0struct=C2=A0ZSTD_CCtx_s.params=C2=A0is=C2=A0still=C2=
=A0a=C2=A0copied=C2=A0structure.=C2=A0=C2=A0Could=C2=A0we=0D=0A>make=C2=A0i=
t=C2=A0=60const=C2=A0ZSTD_parameters=C2=A0*params'?=C2=A0=C2=A0Probably=C2=
=A0not,=C2=A0due=C2=A0to=C2=A0lifetime=0D=0A>issues?=0D=0A=0D=0AZSTD=20main=
tains=20its=20own=20ctxt.=20Yes=20we=20can=20avoid=20storing=20pointers=20o=
f=20other=20modules=0D=0Abecause=20of=20lifetime=20issues.=20We=20should=20=
keep=20ZSTD_CCtx_s.params=20as=20structure=20instead=20of=20pointer.=0D=0A=
=0D=0A=0D=0AThanks=20&=20Regards,=0D=0AVaneet=20Narang=20=0D=0A=0D=0A=C2=A0=
=0D=0A=C2=A0
