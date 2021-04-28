Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8378DC433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Apr 2021 09:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4357861186
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Apr 2021 09:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbhD1JqV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Apr 2021 05:46:21 -0400
Received: from mx01-sz.bfs.de ([194.94.69.67]:43485 "EHLO mx01-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhD1JqV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Apr 2021 05:46:21 -0400
X-Greylist: delayed 635 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Apr 2021 05:46:20 EDT
Received: from SRVEX01-SZ.bfs.intern (exchange-sz.bfs.de [10.129.90.31])
        by mx01-sz.bfs.de (Postfix) with ESMTPS id 6622F203D5;
        Wed, 28 Apr 2021 11:34:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1619602499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1OcoJeGI7nIYUxcB+eIkJLyMMk/GmpnqsmPK09oEq1w=;
        b=mUczqE5cBKIRx2O7+Eb2zXqfdF42gYdXHP/a+1AjxY9iHQo2qmaYZ/wVrmhFZTcJV2bqnt
        Uk0hPQvo8zxY2m3JA8i54+VoQ1QRx1om/VpTqcjU3mB+nLPqUtnfKBHpaj0IvTT1YWf/AI
        lvCCvqvKk1K2iB/m4y3UUN6ktGmXdi0H1tuNHJTOljxXN5qqpHu1iSuOlAn7RPe11xkOPn
        48LJFU4iixP8QZEilcNmMnRoxkxcqJexTEOh4KiUBglg5FyDzVTc88Oa/oG9Fsqvwp9NMG
        u4pDy4E7g7ERIVauNFwf9Xxk0Hf4nWWoJUCd4glwAvBVUP1kwgjqh4H9tCkfyg==
Received: from SRVEX01-SZ.bfs.intern (10.129.90.31) by SRVEX01-SZ.bfs.intern
 (10.129.90.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2242.4; Wed, 28 Apr
 2021 11:34:58 +0200
Received: from SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a]) by
 SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a%13]) with mapi id
 15.01.2242.008; Wed, 28 Apr 2021 11:34:58 +0200
From:   Walter Harms <wharms@bfs.de>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "gcherian@marvell.com" <gcherian@marvell.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: AW: [PATCH] crypto: cavium - Use 'hlist_for_each_entry' to simplify
 code
Thread-Topic: [PATCH] crypto: cavium - Use 'hlist_for_each_entry' to simplify
 code
Thread-Index: AQHXPADcKh3hPUi810mckHZ+wU3y0arJqq9s
Date:   Wed, 28 Apr 2021 09:34:58 +0000
Message-ID: <c621542318e644239008eea5f670390e@bfs.de>
References: <5a7692aa1d2ffb81e981fdf87b060db7e55956b8.1619593010.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <5a7692aa1d2ffb81e981fdf87b060db7e55956b8.1619593010.git.christophe.jaillet@wanadoo.fr>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.137.16.40]
x-tm-as-product-ver: SMEX-14.0.0.3080-8.6.1012-26118.006
x-tm-as-result: No-10-0.361300-5.000000
x-tmase-matchedrid: RlE/Xlx8wK/RubRCcrbc5grcxrzwsv5u3dCmvEa6IiGoLZarzrrPmfKD
        H4hGq6yQhNJdnjCqAbpwE0Mkl9ZaE+7GBH+sbvN4iVJZi91I9JixT02+VRUpqdjV3pEXvjHeN4I
        xix1zvwXnHqJEtsM2g7xFpZGWIKcrzECxVOnBRA4eTAX99VElYA8JAnaMw0RV/q/20XcvFJXbJM
        bTT9K/Ta3aC25avUua2v4PzRk1tzIiK/gF68FTSd9JA2lmQRNU64sVlliWKx+/WXZS/HqJ2gtuK
        BGekqUpOlxBO2IcOBYV7A+VLWfZ75BpzoYEbvl0AhlLvxrd1HzvccRqRr5Z11y6CNNIEVIcDwKe
        tZp3SdfIZNGNZy4hjo7cZpYhy9Ubftrw6OBuv3EorPY7HEKSnM0bQv3yPxsy+toqr+8ptZ9j6l0
        ihn9/So9BUbIZioG5lExlQIQeRG0=
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
x-tmase-result: 10-0.361300-5.000000
x-tmase-version: SMEX-14.0.0.3080-8.6.1012-26118.006
x-tm-snts-smtp: A2C9A7A1459D92F427AF30AC9FD10232DCC8B7EF4CAC08BF6D38DAE5C248ADCC2000:9
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spamd-Result: default: False [-15.43 / 7.00];
         ARC_NA(0.00)[];
         TO_DN_EQ_ADDR_SOME(0.00)[];
         HAS_XOIP(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[wanadoo.fr];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[bfs.de:s=dkim201901];
         WHITELIST_LOCAL_IP(-15.00)[10.129.90.31];
         RCPT_COUNT_SEVEN(0.00)[7];
         NEURAL_HAM(-0.00)[-1.000];
         FREEMAIL_TO(0.00)[wanadoo.fr,marvell.com,gondor.apana.org.au,davemloft.net];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         BAYES_HAM(-0.43)[78.39%]
Authentication-Results: mx01-sz.bfs.de;
        none
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It is also possible to drop the else and simplify
further.

hlist_for_each_entry(chunk, &queue->chead, nextchunk)
if (chunk !=3D queue->qhead) {
                                queue->qhead =3D chunk;
                                break;
                        }

re,
 wh
________________________________________
Von: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Gesendet: Mittwoch, 28. April 2021 09:33:37
An: gcherian@marvell.com; herbert@gondor.apana.org.au; davem@davemloft.net
Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-jani=
tors@vger.kernel.org; Christophe JAILLET
Betreff: [PATCH] crypto: cavium - Use 'hlist_for_each_entry' to simplify co=
de

WARNUNG: Diese E-Mail kam von au=DFerhalb der Organisation. Klicken Sie nic=
ht auf Links oder =F6ffnen Sie keine Anh=E4nge, es sei denn, Sie kennen den=
/die Absender*in und wissen, dass der Inhalt sicher ist.


Use 'hlist_for_each_entry' instead of hand writing it.
This saves a few lines of code.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only
---
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/=
cavium/cpt/cptvf_reqmanager.c
index 4fe7898c8561..feb0f76783dd 100644
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -244,11 +244,7 @@ static int send_cpt_command(struct cpt_vf *cptvf, unio=
n cpt_inst_s *cmd,
        memcpy(ent, (void *)cmd, qinfo->cmd_size);

        if (++queue->idx >=3D queue->qhead->size / 64) {
-               struct hlist_node *node;
-
-               hlist_for_each(node, &queue->chead) {
-                       chunk =3D hlist_entry(node, struct command_chunk,
-                                           nextchunk);
+               hlist_for_each_entry(chunk, &queue->chead, nextchunk) {
                        if (chunk =3D=3D queue->qhead) {
                                continue;
                        } else {
--
2.30.2

