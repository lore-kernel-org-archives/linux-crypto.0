Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96301C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Mar 2022 23:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiCKX3x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Mar 2022 18:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiCKX3w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Mar 2022 18:29:52 -0500
X-Greylist: delayed 93 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Mar 2022 15:28:47 PST
Received: from o19837159x89.outbound-mail.sendgrid.net (o19837159x89.outbound-mail.sendgrid.net [198.37.159.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACBC1AAA65
        for <linux-crypto@vger.kernel.org>; Fri, 11 Mar 2022 15:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tres.co.jp;
        h=content-transfer-encoding:content-type:from:mime-version:subject:to;
        s=s1; bh=mYMEhvLMrLA7uygFEBqXVAha8fwTCHJoLUUyL4sYsDo=;
        b=o0PC1W+XP+5yGFlq3i79z8QI/h31hTOOYoJ8rmNnfQ3SMcfjv7y65ajZNvipSJ5Ow8b+
        Hp5emrZ4/1QWhfrX2FFosf33KfbhcXLYSHhXxUWYt0qpdGth/11kOBYjhcGrxyMixwEtXP
        2fV/VPbqXCVLhN2mvBhsPeV7BE2EhT0bb8hwbIK6y2YgD1PtjsXTJSDYV0aqfeNXoGGLEj
        OAYyHo4lSkksxgI4O5oVy50dLWjNQgkb//BmPyVOpbsWx8GD+0dao+hhOL1ZhjijBl+f6+
        BH9BMbm0et2FgKVPx+uDN6qpyfSuHVR3AgWyKrtaNvNEOoXz5VKniciBLiYARitQ==
Received: by filterdrecv-7bc86b958d-qcsnw with SMTP id filterdrecv-7bc86b958d-qcsnw-1-622BDAD1-43
        2022-03-11 23:27:13.624045402 +0000 UTC m=+16506413.294265826
Received: from MTgxNTEzNTY (unknown)
        by geopod-ismtpd-canary-0 (SG)
        with HTTP
        id zXPfMPaAQjCxgrzeJuikNQ
        Fri, 11 Mar 2022 23:27:13.396 +0000 (UTC)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf-8
Date:   Fri, 11 Mar 2022 23:27:13 +0000 (UTC)
From:   =?utf-8?b?44CQ6YCB5L+h5bCC55So44CRbm8tcmVwbHlAdHJlcy5jby5qcA==?= 
        <no-reply@tres.co.jp>
Mime-Version: 1.0
Message-ID: <zXPfMPaAQjCxgrzeJuikNQ@geopod-ismtpd-canary-0>
Subject: =?UTF-8?B?44CQVFJFU+OAkeOBiuWVj+OBhOWQiOOCj+OBm+OCkuWPl+OBkeS7mOOBkeOBvuOBl+OBnw==?=
X-Mailer: WPMailSMTP/Mailer/sendgrid 2.6.0
X-SG-EID: =?us-ascii?Q?mbBpBq1obyJMazypp4v+k9oZ6bnydDi1RYk94DJ725CCnFtnobcd+IG6chm9uc?=
 =?us-ascii?Q?AryvLBAQkLsaMZ5ujgyQ6v+vtkJvdLG1M6sOTFK?=
 =?us-ascii?Q?deJFfTwPeGJEpLAM0=2F05Z=2FChQ95LRVJ9Mn6DQKO?=
 =?us-ascii?Q?2tFdi1psTsaKCutrX6dKxfuzZ4KnxTOL7GXOwSN?=
 =?us-ascii?Q?Wur1503G8Bt5bDxXGr8lWh2AYoXlrYFsQStCx1P?=
 =?us-ascii?Q?iv02zvQwqpq+ECJs8fq=2FyUG95aRfgRG=2Favjyrkt?=
 =?us-ascii?Q?kfqoaBVKE8TosIjCYxqJSNYeSimAuHdqzpwnpRc?= =?us-ascii?Q?DUc=3D?=
To:     linux-crypto@vger.kernel.org
X-Entity-ID: 2HmKsRJQ8djIv0lA5shZUg==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

=F0=9F=8D=93 Deborah want to meet you! Click here: https://clck.ru/dZGDH?sn=
7k =F0=9F=8D=93 =E6=A7=98

=E3=81=93=E3=81=AE=E5=BA=A6=E3=81=AF=E3=80=81TRES=E3=81=B8=E3=81=94=E9=80=
=A3=E7=B5=A1=E3=81=84=E3=81=9F=E3=81=A0=E3=81=8D=E3=81=82=E3=82=8A=E3=81=8C=
=E3=81=A8=E3=81=86=E3=81=94=E3=81=96=E3=81=84=E3=81=BE=E3=81=99=E3=80=82
=E4=BB=A5=E4=B8=8B=E3=81=AE=E9=80=9A=E3=82=8A=E3=80=81=E3=81=8A=E5=95=8F=E3=
=81=84=E5=90=88=E3=82=8F=E3=81=9B=E3=82=92=E5=8F=97=E3=81=91=E4=BB=98=E3=81=
=91=E3=81=BE=E3=81=97=E3=81=9F=E3=80=82
=E6=8B=85=E5=BD=93=E3=82=88=E3=82=8A=E3=80=81=E6=94=B9=E3=82=81=E3=81=A6=E3=
=81=94=E9=80=A3=E7=B5=A1=E3=81=95=E3=81=9B=E3=81=A6=E3=81=84=E3=81=9F=E3=81=
=A0=E3=81=8D=E3=81=BE=E3=81=99=E3=81=AE=E3=81=A7=E3=80=81=E3=81=97=E3=81=B0=
=E3=82=89=E3=81=8F=E3=81=8A=E5=BE=85=E3=81=A1=E3=81=8F=E3=81=A0=E3=81=95=E3=
=81=84=E3=81=BE=E3=81=9B=E3=80=82

=E2=80=BB2=E5=96=B6=E6=A5=AD=E6=97=A5=E3=82=92=E3=81=99=E3=81=8E=E3=81=A6=
=E3=82=82=E3=81=94=E9=80=A3=E7=B5=A1=E3=81=8C=E7=84=A1=E3=81=84=E5=A0=B4=E5=
=90=88=E3=81=AF=E3=80=81=E5=A4=A7=E5=A4=89=E6=81=90=E3=82=8C=E5=85=A5=E3=82=
=8A=E3=81=BE=E3=81=99=E3=81=8C=E3=81=94=E9=80=A3=E7=B5=A1=E3=81=8F=E3=81=A0=
=E3=81=95=E3=81=84=E3=81=BE=E3=81=99=E3=82=88=E3=81=86=E3=81=8A=E9=A1=98=E3=
=81=84=E3=81=84=E3=81=9F=E3=81=97=E3=81=BE=E3=81=99=E3=80=82

----------------------------------------------------------------

=E3=81=8A=E5=90=8D=E5=89=8D : =F0=9F=8D=93 Deborah want to meet you! Click =
here: https://clck.ru/dZGDH?sn7k =F0=9F=8D=93 5pff3qr
=E3=83=95=E3=83=AA=E3=82=AC=E3=83=8A : dnn4mx1z mq6bqwt
=E9=83=B5=E4=BE=BF=E7=95=AA=E5=8F=B7 : 20461-20461
=E3=81=94=E4=BD=8F=E6=89=80 : hybq8c
=E3=81=8A=E9=9B=BB=E8=A9=B1=E7=95=AA=E5=8F=B7 : 850208486506
=E3=83=A1=E3=83=BC=E3=83=AB=E3=82=A2=E3=83=89=E3=83=AC=E3=82=B9 : linux-cry=
pto@vger.kernel.org
=E3=83=A1=E3=83=BC=E3=83=AB=E3=82=A2=E3=83=89=E3=83=AC=E3=82=B9(=E7=A2=BA=
=E8=AA=8D=E7=94=A8) : linux-crypto@vger.kernel.org
=E3=81=8A=E5=95=8F=E3=81=84=E5=90=88=E3=82=8F=E3=81=9B=E7=AB=B6=E6=8A=80 : =
=E3=81=9D=E3=81=AE=E4=BB=96=E7=AB=B6=E6=8A=80
=E3=81=8A=E5=95=8F=E3=81=84=E5=90=88=E3=82=8F=E3=81=9B=E7=AB=B6=E6=8A=80=E3=
=82=AB=E3=83=86=E3=82=B4=E3=83=AA : =E3=81=9D=E3=81=AE=E4=BB=96
=E5=95=86=E5=93=81=E5=90=8D=E5=8F=88=E3=81=AFURL : a2mshte
=E3=81=8A=E5=95=8F=E3=81=84=E5=90=88=E3=82=8F=E3=81=9B=E5=86=85=E5=AE=B9 : =
a6o62rkn

----------------------------------------------------------------
=E3=81=93=E3=81=AE=E3=83=A1=E3=83=BC=E3=83=AB=E3=81=AF TRES (https://tres.c=
o.jp) =E3=81=AE=E3=81=8A=E5=95=8F=E3=81=84=E5=90=88=E3=82=8F=E3=81=9B=E3=83=
=95=E3=82=A9=E3=83=BC=E3=83=A0=E3=81=8B=E3=82=89=E9=80=81=E4=BF=A1=E3=81=95=
=E3=82=8C=E3=81=BE=E3=81=97=E3=81=9F
