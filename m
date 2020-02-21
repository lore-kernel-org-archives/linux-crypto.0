Return-Path: <SRS0=BixN=4J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E8BC35641
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 09:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF13C206E2
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 09:00:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=minbiz.eu header.i=@minbiz.eu header.b="hh/ZOY/X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgBUJAv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 04:00:51 -0500
Received: from mail.minbiz.eu ([212.237.2.46]:50404 "EHLO mail.minbiz.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgBUJAv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 04:00:51 -0500
Received: by mail.minbiz.eu (Postfix, from userid 1001)
        id 652DFA26E6; Fri, 21 Feb 2020 09:00:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=minbiz.eu; s=mail;
        t=1582275648; bh=oldVA84WBNA/9UEI6i571Nn9oVnvQPYJJRTunSu0wEs=;
        h=Date:From:To:Subject:From;
        b=hh/ZOY/XDRxhvlq6wkeO8dgpN8A1J9W2haKQm065rMzP0h+o5vmTDW5bKYhc+d4Bm
         Zp30Ql6cJxOIJn1TVJSHemh/STPUTqIlgVDeBuTs3oN8N9DIpDtoEyZrugCR6JLSZX
         OdZ2kzbbFLcs6x7VfRMbr3JIfqGgBDxL2tdMeA78VosTtTXFrsiZAVdIuXhzPjlRzP
         dwyJAE5L3+LO65+inY9IO6ip0M5VHfeHKWfUdgJU+czzgEwQdc6n3g1qlm6cGgO5Pq
         28kAZu4F3mlbM7RqdonatGcK+7laPLhSocCBNHfNf4pjH6XQWWzDCEtdjyu30QloRB
         8dVlgAAUk4srw==
Received: by mail.minbiz.eu for <linux-crypto@vger.kernel.org>; Fri, 21 Feb 2020 09:00:47 GMT
Message-ID: <20200221074500-0.1.1b.1lw9.0.2kpl2faaop@minbiz.eu>
Date:   Fri, 21 Feb 2020 09:00:47 GMT
From:   =?UTF-8?Q? "B=C3=A9ate_Durant" ?= <b.durant@minbiz.eu>
To:     <linux-crypto@vger.kernel.org>
Subject: =?UTF-8?Q?v=C3=A9rification_du_v=C3=A9hicule?=
X-Mailer: mail.minbiz.eu
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Bonjour,

Les chefs d=E2=80=99entreprise qui surveillent leurs v=C3=A9hicules de so=
ci=C3=A9t=C3=A9 en temps r=C3=A9el, y compris le kilom=C3=A9trage et la c=
onsommation de carburant, r=C3=A9duisent les co=C3=BBts d'entretien du pa=
rc automobile de pr=C3=A8s de 20% et am=C3=A9liorent l'organisation de le=
urs livraisons.

Seriez-vous int=C3=A9ress=C3=A9 par ce type de solution ?

N'h=C3=A9sitez pas =C3=A0 me contacter pour obtenir de plus amples inform=
ations.


Bien cordialement,=20
B=C3=A9ate Durant 
