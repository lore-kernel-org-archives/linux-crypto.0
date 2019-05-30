Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C65C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 09:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A555125254
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 09:16:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="P07+rVUj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfE3JQv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 05:16:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21561 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbfE3JQu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 05:16:50 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190530091648epoutp042207400fd3a038a4c94afe092d1a2d6e~jaz2XXZLS2731627316epoutp04y
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2019 09:16:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190530091648epoutp042207400fd3a038a4c94afe092d1a2d6e~jaz2XXZLS2731627316epoutp04y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559207808;
        bh=/+wagvowwO5ybjT2UwhBWkybZc/JAXTt0vCjAQj+cw8=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=P07+rVUjsPGNOyyzRGHX+MQaLSAJkJKRjL9nN6Qw4aBwL4hVTwvKA1z4aVoFWuUVa
         wneCO8kWcF+z0D78uCnVIx6lama33ZoZzEricit4Rn0WUB/VdNuGWSDCsv0h9OY8rO
         3kEFE6123ZgD6aUiDEp+jtMapj0Duxh3PAcdgsnI=
Received: from epsmges5p2new.samsung.com (unknown [182.195.40.196]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20190530091646epcas5p47ecd53aaceaff4f4d45b041539478bbd~jaz00cdUG0674706747epcas5p4s;
        Thu, 30 May 2019 09:16:46 +0000 (GMT)
X-AuditID: b6c32a4a-973ff70000000fe2-7b-5cef9f7eadc6
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.55.04066.E7F9FEC5; Thu, 30 May 2019 18:16:46 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH 2/2] zstd: use U16 data type for rankPos
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
In-Reply-To: <1557468839-3388-1-git-send-email-maninder1.s@samsung.com>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20190530091628epcms5p2ea7c6837c3ab3963815585d8b16c7838@epcms5p2>
Date:   Thu, 30 May 2019 14:46:28 +0530
X-CMS-MailID: 20190530091628epcms5p2ea7c6837c3ab3963815585d8b16c7838
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIJsWRmVeSWpSXmKPExsWy7bCmpm7d/PcxBr0PlSwu7k61mHO+hcVi
        6x5Vi+5XMhZnunMt7t/7yWRxedccNovD89tYLO692cpk8erfNTaLQyfnMjpwe8xuuMjisWXl
        TSaPdQdVPSY2v2P32HZA1aNvyypGj8+b5ALYo3JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403N
        DAx1DS0tzJUU8hJzU22VXHwCdN0yc4DOU1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUW
        pOQUGBoV6BUn5haX5qXrJefnWhkaGBiZAlUm5GQsOLCMreAUW8Xe35uYGxjXsXUxcnJICJhI
        LJu4Fsjm4hAS2M0osaFlJ2MXIwcHr4CgxN8dwiA1wgI2Eq92rGUFsYUE5CSO39jNCBHXkTgx
        bw1YOZuAlsTHlnCQsIjAciaJXUcsQUYyC/xilDi/+hwTxC5eiRntT1kgbGmJ7cu3gs3hFHCX
        OLp4C1RcVOLm6rfsMPb7Y/MZIWwRidZ7Z5khbEGJBz93g+2VEJCR2PVWHGSXhEA3o8SEc8tZ
        IZwZjBKnet9ANZhLnD85H8zmFfCVmLv1BNhQFgFViZu7VkMtc5F4uWcV2BHMAtoSyxa+ZgZZ
        wCygKbF+lz5EiazE1FPrmCBK+CR6fz+B+2vHPBhbSeLcwZ3QsJWQeNI5E+oED4lPe38zQcK5
        j1HizumVzBMYFWYhgnoWks2zEDYvYGRexSiZWlCcm55abFpglJdajhzBmxjByVXLawfjsnM+
        hxgFOBiVeHgn5L+LEWJNLCuuzD3EKMHBrCTC+3M5UIg3JbGyKrUoP76oNCe1+BCjKTAMJjJL
        iSbnAxN/Xkm8oamRmZmBpYGpsYWZoZI47yTWqzFCAumJJanZqakFqUUwfUwcnFINjEVfBQQE
        1Zjeu3Hc0Xu9s8PR7brz7HmHZO8dP2+WmmBVZ5Tm5Pfb+zmjk0mme7aQeuCqFf+CjQ0u/VA5
        ZfvqvNPqCT2WnJk81kbu+bweElw/7px6ut9L8VSme2DtzzPNoX4OvF6/ypl6M1jPP47Ktz3J
        9kRB4Uep4/FvJ3n2sJfNk2hWVK5TYinOSDTUYi4qTgQAdPqeGcQDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190510061418epcas5p3679447cedd01f3ec70139f79ac7bcca1
References: <1557468839-3388-1-git-send-email-maninder1.s@samsung.com>
        <CGME20190510061418epcas5p3679447cedd01f3ec70139f79ac7bcca1@epcms5p2>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

=5BReminder=5D Any Comments?

>rankPos=C2=A0structure=C2=A0variables=C2=A0value=C2=A0can=C2=A0not=C2=A0be=
=C2=A0more=C2=A0than=C2=A0512.=0D=0A>So=C2=A0it=C2=A0can=C2=A0easily=C2=A0b=
e=C2=A0declared=C2=A0as=C2=A0U16=C2=A0rather=C2=A0than=C2=A0U32.=0D=0A=C2=
=A0=0D=0A>It=C2=A0will=C2=A0reduce=C2=A0stack=C2=A0usage=C2=A0of=C2=A0HUF_s=
ort=C2=A0from=C2=A0256=C2=A0bytes=C2=A0to=C2=A0128=C2=A0bytes=0D=0A=C2=A0=
=0D=0A>original:=0D=0A>e24ddc01=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0sub=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sp,=C2=A0sp,=C2=A0=23256=C2=A0=C2=A0=
=C2=A0=C2=A0;=C2=A00x100=0D=0A=C2=A0=0D=0A>changed:=0D=0A>e24dd080=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sub=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sp,=
=C2=A0sp,=C2=A0=23128=C2=A0=C2=A0=C2=A0=C2=A0;=C2=A00x80=0D=0A=C2=A0=0D=0AR=
egards,=0D=0AVaneet=20Narang=0D=0A
