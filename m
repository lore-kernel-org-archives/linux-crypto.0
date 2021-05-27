Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FD1C4708B
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 16:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ADB6613C5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 16:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbhE0QOR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 May 2021 12:14:17 -0400
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.223]:31012 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbhE0QOQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 May 2021 12:14:16 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1622131889; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=MjlLshNtw/FO/5LvmcfF562Xx+gHXSz2tVqH/KI6qHirEcnlVIzmifzEbYMwzbSQ0q
    91TO8qafn3wQaJ4htooTG9qhF3SGLE7PLHK+iA+4h2smNJQiniLh8kxWHrk5+e6E3nJ2
    EGbJhBVYw6C6Z3PEAr3W/zderu6pUIS66BQFsx/SNT9PhBueuXBkLzsLV7OUqGHzMLbv
    yZu2tDGUgnkBhjyjZFALXCPVHH3GSkHiUpFkLTHQ/cqTUutVC+mMW+z7S7oOkB/LeJSd
    ggo1pXNZfGeZvrBaqGFB/nt0ChNvqy5At1QNE3Hp481pGd9rl619yUsZe0s2EK7jIhYk
    MCNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1622131889;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=3+1S5y2UCp1XKPR4u52C0YirNbd3Or34oSz96L582lU=;
    b=Rru+oDgKtuHFuB7pmuPj4dqInJlU+W6CjnEh2ElHL3xBjV/VXLsRFeeZbAOxV2qusJ
    vQZ02vRVl9e8A8pKvZVmz+Ei1jaK2NwjcR7ckVYW81ZYJ8MUDq3JwpJr60sI95f6ZWgE
    ioqjf/A2JZo8iMx0jiIznWJ253/J6EoNjDSo6B+6PBP3/EJ3/vijabnYBHex1ZfYe+KN
    WEfm6NhVosDgXoj6gAMEKyj7XLWJWpCj/6yTTTukJi2bLlZGNObBnUV8lHevsfUaR7rt
    KyoNB4g7PFw54XrVArBoZYjBv0LXvQEKnFPsThmPO0KniAwccJvC44mz4zkFScZMJRAX
    FzoQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1622131889;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=3+1S5y2UCp1XKPR4u52C0YirNbd3Or34oSz96L582lU=;
    b=cNKoSIvRuz+/85whU2/oxNf8GbSjps1jNnL/vZjg9xrV2M1PDF2p+23RT4odIOHzac
    eUYOuRgsHKtkN/9mbctw2LIMWb6msdW3Ck9Mz56JThBCY0FfohSS4lEvRVR9V6bavZ69
    RDHFpLro9XOtPRGAiyODOQ5zANnCKhTcbDJohmEntpVo/6HchP4qX764ago5VFFDc+Ym
    ZIDUn43F1ooH0Awuzr9gCAYAKo8wjP4Jc3+7sf4GF302mxG+MdDE7QJluMZqePqhzKuc
    M4YEV0PoQDAGGFBZCLMH3v82m6pqn4WJvRVSwx2IEzzfy/4+J+WNWt/N9ZNHIaO4iPw8
    wPLQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJvSfFeK2"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.26.3 DYNA|AUTH)
    with ESMTPSA id R0123ax4RGBS0To
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 27 May 2021 18:11:28 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Tso Ted <tytso@mit.edu>, linux-crypto@vger.kernel.org
Cc:     Willy Tarreau <w@1wt.eu>, Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Petr Tesarik <ptesarik@suse.cz>,
        John Haxby <john.haxby@oracle.com>
Subject: [PATCH v40 06/13] crypto: DRBG - externalize DRBG functions for LRNG
Date:   Thu, 27 May 2021 17:59:28 +0200
Message-ID: <1877167.Op4sVUbLkj@positron.chronox.de>
In-Reply-To: <18450229.rjpLZT9oXI@positron.chronox.de>
References: <18450229.rjpLZT9oXI@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch allows several DRBG functions to be called by the LRNG kernel
code paths outside the drbg.c file.

CC: Torsten Duwe <duwe@lst.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Alexander E. Patrakov" <patrakov@gmail.com>
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: "Theodore Y. Ts'o" <tytso@mit.edu>
CC: Willy Tarreau <w@1wt.eu>
CC: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Vito Caputo <vcaputo@pengaru.com>
CC: Andreas Dilger <adilger.kernel@dilger.ca>
CC: Jan Kara <jack@suse.cz>
CC: Ray Strode <rstrode@redhat.com>
CC: William Jon McCann <mccann@jhu.edu>
CC: zhangjs <zachary@baishancloud.com>
CC: Andy Lutomirski <luto@kernel.org>
CC: Florian Weimer <fweimer@redhat.com>
CC: Lennart Poettering <mzxreary@0pointer.de>
CC: Nicolai Stange <nstange@suse.de>
Reviewed-by: Roman Drahtmueller <draht@schaltsekun.de>
Tested-by: Roman Drahtm=FCller <draht@schaltsekun.de>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
=2D--
 crypto/drbg.c         | 16 ++++++++++------
 include/crypto/drbg.h |  7 +++++++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 1b4587e0ddad..b7c962a882c4 100644
=2D-- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -114,7 +114,7 @@
  * the SHA256 / AES 256 over other ciphers. Thus, the favored
  * DRBGs are the latest entries in this array.
  */
=2Dstatic const struct drbg_core drbg_cores[] =3D {
+const struct drbg_core drbg_cores[] =3D {
 #ifdef CONFIG_CRYPTO_DRBG_CTR
 	{
 		.flags =3D DRBG_CTR | DRBG_STRENGTH128,
@@ -191,6 +191,7 @@ static const struct drbg_core drbg_cores[] =3D {
 	},
 #endif /* CONFIG_CRYPTO_DRBG_HMAC */
 };
+EXPORT_SYMBOL(drbg_cores);
=20
 static int drbg_uninstantiate(struct drbg_state *drbg);
=20
@@ -206,7 +207,7 @@ static int drbg_uninstantiate(struct drbg_state *drbg);
  * Return: normalized strength in *bytes* value or 32 as default
  *	   to counter programming errors
  */
=2Dstatic inline unsigned short drbg_sec_strength(drbg_flag_t flags)
+unsigned short drbg_sec_strength(drbg_flag_t flags)
 {
 	switch (flags & DRBG_STRENGTH_MASK) {
 	case DRBG_STRENGTH128:
@@ -219,6 +220,7 @@ static inline unsigned short drbg_sec_strength(drbg_fla=
g_t flags)
 		return 32;
 	}
 }
+EXPORT_SYMBOL(drbg_sec_strength);
=20
 /*
  * FIPS 140-2 continuous self test for the noise source
@@ -1215,7 +1217,7 @@ static int drbg_seed(struct drbg_state *drbg, struct =
drbg_string *pers,
 }
=20
 /* Free all substructures in a DRBG state without the DRBG state structure=
 */
=2Dstatic inline void drbg_dealloc_state(struct drbg_state *drbg)
+void drbg_dealloc_state(struct drbg_state *drbg)
 {
 	if (!drbg)
 		return;
@@ -1236,12 +1238,13 @@ static inline void drbg_dealloc_state(struct drbg_s=
tate *drbg)
 		drbg->fips_primed =3D false;
 	}
 }
+EXPORT_SYMBOL(drbg_dealloc_state);
=20
 /*
  * Allocate all sub-structures for a DRBG state.
  * The DRBG state structure must already be allocated.
  */
=2Dstatic inline int drbg_alloc_state(struct drbg_state *drbg)
+int drbg_alloc_state(struct drbg_state *drbg)
 {
 	int ret =3D -ENOMEM;
 	unsigned int sb_size =3D 0;
@@ -1322,6 +1325,7 @@ static inline int drbg_alloc_state(struct drbg_state =
*drbg)
 	drbg_dealloc_state(drbg);
 	return ret;
 }
+EXPORT_SYMBOL(drbg_alloc_state);
=20
 /*************************************************************************
  * DRBG interface functions
@@ -1891,8 +1895,7 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
  *
  * return: flags
  */
=2Dstatic inline void drbg_convert_tfm_core(const char *cra_driver_name,
=2D					 int *coreref, bool *pr)
+void drbg_convert_tfm_core(const char *cra_driver_name, int *coreref, bool=
 *pr)
 {
 	int i =3D 0;
 	size_t start =3D 0;
@@ -1919,6 +1922,7 @@ static inline void drbg_convert_tfm_core(const char *=
cra_driver_name,
 		}
 	}
 }
+EXPORT_SYMBOL(drbg_convert_tfm_core);
=20
 static int drbg_kcapi_init(struct crypto_tfm *tfm)
 {
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index c4165126937e..71d53e028e6d 100644
=2D-- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -278,4 +278,11 @@ enum drbg_prefixes {
 	DRBG_PREFIX3
 };
=20
+extern int drbg_alloc_state(struct drbg_state *drbg);
+extern void drbg_dealloc_state(struct drbg_state *drbg);
+extern void drbg_convert_tfm_core(const char *cra_driver_name, int *corere=
f,
+				  bool *pr);
+extern const struct drbg_core drbg_cores[];
+extern unsigned short drbg_sec_strength(drbg_flag_t flags);
+
 #endif /* _DRBG_H */
=2D-=20
2.31.1




