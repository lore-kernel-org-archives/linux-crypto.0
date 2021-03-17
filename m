Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1BDC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 02:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47C5364EF6
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 02:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhCQCCn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Mar 2021 22:02:43 -0400
Received: from sender4-pp-o95.zoho.com ([136.143.188.95]:25577 "EHLO
        sender4-pp-o95.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCQCC2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Mar 2021 22:02:28 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2021 22:02:28 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1615945596; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=jQujIYenm+uEskiMdWH9EjdpbkdCXhDdn16aT9QYMbeIg6czdfhsS5kv7aCTVbobHK1Qm7AQfNs5LRZlrUNYUDGKQCjqDzPwSdf9gtIq1VrdxTfLSFyBjkxe4TrKE6nx8O6ph6Id6JmKWjXe0zkydhvUgwTNX5lmVaNR5Pg+I1o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1615945596; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=2obGIsLfOvr84VxtUdYijf03Zt+ZtbbyKcwXCUtqlMA=; 
        b=U5wNc40naZaNTOxgeF/prIZWhs7/FHwO/qevFb64ZzEeV2Aqr7XuleH2ysxftFYFrOf+XgGpiIDMmsBDirbKAbwRjb1ezECr973TIQ/7kMw7YNY28851i/qDeefyeVUVD1IBMOkKGRTuJjsxsxFcrUxPLadKx3QJMjJ9yO8eU28=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=zohomail.com;
        spf=pass  smtp.mailfrom=mdjurovic@zohomail.com;
        dmarc=pass header.from=<mdjurovic@zohomail.com> header.from=<mdjurovic@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1615945596;
        s=zm2020; d=zohomail.com; i=mdjurovic@zohomail.com;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=2obGIsLfOvr84VxtUdYijf03Zt+ZtbbyKcwXCUtqlMA=;
        b=lsAYpJpNsdr+kASVvv84O/qXwBOmxq++ZBAIn5bRlkFWI/mh+JNlj7xdiNQ4DKuG
        QPkmMwZwB0Rw+KM419vuagcgMZwqPiSzHWJlbu+yTq/NGuCwP+OAQ8payWRBJvwui6N
        Tf9R3pgh8jZ19R7EizTqgkVL0RgHnZGLo4VM4QDI=
Received: from milan-pc.attlocal.net (107-220-151-69.lightspeed.sntcca.sbcglobal.net [107.220.151.69]) by mx.zohomail.com
        with SMTPS id 1615945594255152.57083268336862; Tue, 16 Mar 2021 18:46:34 -0700 (PDT)
From:   Milan Djurovic <mdjurovic@zohomail.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Milan Djurovic <mdjurovic@zohomail.com>
Message-ID: <20210317014403.12742-1-mdjurovic@zohomail.com>
Subject: [PATCH] crypto: jitterentropy: Put constants on the right side of the expression
Date:   Tue, 16 Mar 2021 18:44:03 -0700
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes the following checkpatch.pl warnings:

crypto/jitterentropy.c:600: WARNING: Comparisons should place the constant =
on the right side of the test
crypto/jitterentropy.c:681: WARNING: Comparisons should place the constant =
on the right side of the test
crypto/jitterentropy.c:772: WARNING: Comparisons should place the constant =
on the right side of the test
crypto/jitterentropy.c:829: WARNING: Comparisons should place the constant =
on the right side of the test

Signed-off-by: Milan Djurovic <mdjurovic@zohomail.com>
---
 crypto/jitterentropy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 6e147c43fc18..a11b3208760f 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -597,7 +597,7 @@ int jent_read_entropy(struct rand_data *ec, unsigned ch=
ar *data,
 =09if (!ec)
 =09=09return -1;
=20
-=09while (0 < len) {
+=09while (len > 0) {
 =09=09unsigned int tocopy;
=20
 =09=09jent_gen_entropy(ec);
@@ -678,7 +678,7 @@ struct rand_data *jent_entropy_collector_alloc(unsigned=
 int osr,
 =09}
=20
 =09/* verify and set the oversampling rate */
-=09if (0 =3D=3D osr)
+=09if (osr =3D=3D 0)
 =09=09osr =3D 1; /* minimum sampling rate is 1 */
 =09entropy_collector->osr =3D osr;
=20
@@ -769,7 +769,7 @@ int jent_entropy_init(void)
 =09=09 * etc. with the goal to clear it to get the worst case
 =09=09 * measurements.
 =09=09 */
-=09=09if (CLEARCACHE > i)
+=09=09if (i < CLEARCACHE)
 =09=09=09continue;
=20
 =09=09if (stuck)
@@ -826,7 +826,7 @@ int jent_entropy_init(void)
 =09 * should not fail. The value of 3 should cover the NTP case being
 =09 * performed during our test run.
 =09 */
-=09if (3 < time_backwards)
+=09if (time_backwards > 3)
 =09=09return JENT_ENOMONOTONIC;
=20
 =09/*
--=20
2.30.1


