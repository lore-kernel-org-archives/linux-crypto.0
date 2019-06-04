Return-Path: <SRS0=6z3H=UD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D82AC282CE
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 12:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 034F523E30
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 12:30:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fHogesG7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfFDMaO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jun 2019 08:30:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54965 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbfFDMaN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jun 2019 08:30:13 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190604123011epoutp04d0c3feadd387aece3934269972470c93~k-rHzsUwr2241722417epoutp04H
        for <linux-crypto@vger.kernel.org>; Tue,  4 Jun 2019 12:30:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190604123011epoutp04d0c3feadd387aece3934269972470c93~k-rHzsUwr2241722417epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559651411;
        bh=kmF2T/PAVQuwoEHZhBFuwtSSbS8VE1iD9MRWghRfsFI=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=fHogesG76Rr5mXCpPSTuODgzvXKaBhhXyZNchRiFvFcbt6o8WJsbCrnAIC2qAuwvZ
         6ao9uUmoNdbk2kd6gvI5SDvgOJcXz42453ViJuZzf7i/TUH9GJ+fv2xMPMuE37BX5N
         aCxEYjoYXPxLruUW5sJ6rS600pKQkK5Rqe6V0PME=
Received: from epsmges5p1new.samsung.com (unknown [182.195.40.195]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20190604123008epcas5p26455592843801a04196d8fd161f1400e~k-rFRwsi40160501605epcas5p2D;
        Tue,  4 Jun 2019 12:30:08 +0000 (GMT)
X-AuditID: b6c32a49-5b7ff70000000fe7-f9-5cf66450b68f
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        90.8C.04071.05466FC5; Tue,  4 Jun 2019 21:30:08 +0900 (KST)
Mime-Version: 1.0
Subject: RE:(2) [PATCH 0/4] zstd: reduce stack usage
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
In-Reply-To: <20190603144912.34e1414376e07c7b1af53205@linux-foundation.org>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20190604120623epcms5p3fc13e98047e7b44d6da144425213b4fe@epcms5p3>
Date:   Tue, 04 Jun 2019 17:36:23 +0530
X-CMS-MailID: 20190604120623epcms5p3fc13e98047e7b44d6da144425213b4fe
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJJsWRmVeSWpSXmKPExsWy7bCmhm5AyrcYg2NrpSwu7k61mLN+DZvF
        nPMtLBZb96hadL+SsZh9/zGLxZnuXIv7934yWVzeNYfN4vD8NhaLe2+2MlkcOjmX0YHHY3bD
        RRaPLStvMnmsO6jqse2AqseJGb9ZPL6susbs0bdlFaPH501yARxROTYZqYkpqUUKqXnJ+SmZ
        eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIcqKZQl5pQChQISi4uV9O1sivJL
        S1IVMvKLS2yVUgtScgoMjQr0ihNzi0vz0vWS83OtDA0MjEyBKhNyMnYd3MtWsIWtYu6yj4wN
        jFNZuxg5OCQETCTeP7fsYuTiEBLYzSjRfuIWG0icV0BQ4u8O4S5GTg5hoJIVm88ygdhCAnIS
        x2/sZoSI60icmLeGEaScTUBL4mNLOIgpIhApcWuVOshEZoHPzBLtZz6BlUsI8ErMaH/KAmFL
        S2xfvhUszingLbFu62uouKjEzdVv2WHs98fmQ/WKSLTeO8sMYQtKPPi5mxHiehmJXW/FQXZJ
        CHQzSkw4t5wVwpnBKHGq9w1Ug7nE+ZPzwWxeAV+Je49ngC1jEVCV+HPwMCtEjYvE5Y+vwRYz
        C2hLLFv4mhlkAbOApsT6XfoQJbISU0+tY4Io4ZPo/f2ECeavHfNgbCWJcwd3skHYEhJPOmdC
        neAh8WTrSkZIMJ9nlFh06Aj7BEaFWYiQnoVk8yyEzQsYmVcxSqYWFOempxabFhjmpZYjR+8m
        RnCy1fLcwTjrnM8hRgEORiUe3hnx32KEWBPLiitzDzFKcDArifAm3v4SI8SbklhZlVqUH19U
        mpNafIjRFBgGE5mlRJPzgZkgryTe0NTIzMzA0sDU2MLMUEmcdxLr1RghgfTEktTs1NSC1CKY
        PiYOTqkGRomzCvYV6s/DTxoneDdOK+Y8VsWfr7WjqWH33MBdc0Qs4ryP781/H8iXPs9LVWzO
        qZLLS2ed0sn8m/HZy//xRO7ykKTyp07xBroqN9kF3nSunN7/JOzJu6MfzCq4lr+Yue6k29kJ
        avfMom+pzpxbvf2VlIGO4v/CHVNnfi+euE/24p/7P5o7nyixFGckGmoxFxUnAgA5QNF2zAMA
        AA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190603090227epcas5p348327061a3facbb9dfcf662bf2bc196e
References: <20190603144912.34e1414376e07c7b1af53205@linux-foundation.org>
        <1559552526-4317-1-git-send-email-maninder1.s@samsung.com>
        <CGME20190603090227epcas5p348327061a3facbb9dfcf662bf2bc196e@epcms5p3>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andrew,

>> This patch set reduces stack usage for zstd code, because target like AR=
M has
>> limited 8KB kernel stack, which is getting overflowed due to hight stack=
 usage
>> of zstd code with call flow like:
=20
>That's rather bad behaviour.  I assume the patchset actually fixes this?

Yes, patchset tries to reduce around 300 bytes of stack usage of zstd compr=
ession path.=20
We faced high stack usage issue on switching compression algo from LZO/LZ4 =
to zstd algo.
zstd compression uses around 1200 bytes of stack which is huge as compared=
=20
to LZO/LZ4 which uses negligible stack (< 200 bytes).

=20
>I think I'll schedule the patchset for 5.2-rcX so that zstd is actually
>usable on arm in 5.2.  Does that sound OK?=C2=A0=0D=0AOK=0D=0A=0D=0ARegard=
s,=0D=0AVaneet=20Narang=0D=0A
