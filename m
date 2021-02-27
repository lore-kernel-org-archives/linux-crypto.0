Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA24AC433E6
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Feb 2021 13:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B059164ED5
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Feb 2021 13:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhB0Npe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Feb 2021 08:45:34 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.179]:24360 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhB0Npa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Feb 2021 08:45:30 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1614433250; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ZoUZ+brI853u5u5nSLILgGx0UIzGELSL9vASrB9n523OeKhzYxrFL94tHDs5bdwpbE
    rfJG0LwWl1qJPKmkKmGCEvP5Jvet2czRq+0NykhGuQLkWq9rqx3+rYi/WA0cyYYmrqSq
    ZDCWOnHOsuoFBdJgc2CieGp50fqAbiAZUlSqYeaOCR9Wb38VmNn50EgxqfW097axlD2U
    mKkObc4BhdF9q50h1MIK7Cni3RFQ7hKSYje71PUNY7NyurO+QpOn7Mt2qAgUe21aOGM3
    H+Xakx+sJZg/LnFIUjLQC9E74UTlg/qlOBA1k/lKuVzPJubPBZxciyWyzOcFnISZchRs
    7SqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1614433250;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=aDr4BSmx17CO+92UG7sxwfwUiB8PKlvHnJTNQ/f4X44=;
    b=QDGyR8L0XqgUH5rC5SxP6hFku4m2gnzBE52Pm5mKglM5jdSfguolo5Lj3ZPj8CLcdq
    6TtAso+F29qB/N6Tcv7w2NawZdZuShGHz+SFVhkWF0XsQkI5fwhbEI527RowywUOPyET
    YsX+uF3DGURiQEHGBFpT5Koe7GptYVQikBspFdksk+F5klV+4MuQpo50lXjLLLVO+9ee
    ASk+87pCti+ZzGC9JaB+7r/1UQTL2oUiHTO/M73rGx1wyJTMdQ2n6uot6A/DCeBwImBj
    lWcxZ15+dlBVJaLU67eot7jfNto2DlWNrOhuGLCL5LxTfFZHnoRVS4T8anMnTh5NJUqq
    x8lg==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1614433250;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=aDr4BSmx17CO+92UG7sxwfwUiB8PKlvHnJTNQ/f4X44=;
    b=tBHPwvv3+y800rwYu63UEJL+NMiquFfUdUM4G7LyCd58kEajGbLA613K+LnoD23Qmi
    R19FO7j+kIp2brs8EThO7UFaJD9ai6p4AhhwYxtwLsShmcHnk67ZKJzomUGMFNCnbmLg
    Z6d8weDa6sNfCdlDkNZEUQZX9AbKo0RGEQFmnW8ydUTcCfSioyjzWiT91l/3OxUKBGAz
    Bwdq0wCyE97zVebqidgnBENydH0xgomMfLVanDAhsr760h5B01BKCBeaXyL8MFUZ4QvX
    mfqlqS2i5nIjGUOeH9vcN8F85EhZgKDJf9ncF0A/4m9cwbC/4NXpswoxuFg7DG7VaBHG
    LrEQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIfSc8k+7"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.19.0 DYNA|AUTH)
    with ESMTPSA id 608030x1RDenUDC
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 27 Feb 2021 14:40:49 +0100 (CET)
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
Subject: [PATCH v38 09/13] crypto: provide access to a static Jitter RNG state
Date:   Sat, 27 Feb 2021 14:38:17 +0100
Message-ID: <2020890.OBFZWjSADL@positron.chronox.de>
In-Reply-To: <3277560.QJadu78ljV@positron.chronox.de>
References: <3277560.QJadu78ljV@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

To support the LRNG operation which uses the Jitter RNG separately
from the kernel crypto API, at a time where potentially the regular
memory management is not yet initialized, the Jitter RNG needs to
provide a state whose memory is defined at compile time. As only once
instance will ever be needed by the LRNG, define once static memory
block which is solely to be used by the LRNG.

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
 crypto/jitterentropy-kcapi.c                  |  3 +-
 crypto/jitterentropy.c                        | 31 ++++++++++++++++++-
 .../crypto/internal}/jitterentropy.h          |  3 ++
 3 files changed, 34 insertions(+), 3 deletions(-)
 rename {crypto =3D> include/crypto/internal}/jitterentropy.h (84%)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index e8a4165a1874..c90e60910827 100644
=2D-- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -43,8 +43,7 @@
 #include <linux/fips.h>
 #include <linux/time.h>
 #include <crypto/internal/rng.h>
=2D
=2D#include "jitterentropy.h"
+#include <crypto/internal/jitterentropy.h>
=20
 /*************************************************************************=
**
  * Helper function
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 6e147c43fc18..fa1459f09b01 100644
=2D-- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -117,7 +117,7 @@ struct rand_data {
 #define JENT_EHEALTH		9 /* Health test failed during initialization */
 #define JENT_ERCT		10 /* RCT failed during initialization */
=20
=2D#include "jitterentropy.h"
+#include <crypto/internal/jitterentropy.h>
=20
 /*************************************************************************=
**
  * Adaptive Proportion Test
@@ -854,3 +854,32 @@ int jent_entropy_init(void)
=20
 	return 0;
 }
+
+struct rand_data *jent_lrng_entropy_collector(void)
+{
+	static unsigned char lrng_jent_mem[JENT_MEMORY_SIZE];
+	static struct rand_data lrng_jent_state =3D {
+		.data		=3D 0,
+		.old_data	=3D 0,
+		.prev_time	=3D 0,
+		.last_delta	=3D 0,
+		.last_delta2	=3D 0,
+		.osr		=3D 1,
+		.mem		=3D lrng_jent_mem,
+		.memlocation	=3D 0,
+		.memblocks	=3D JENT_MEMORY_BLOCKSIZE,
+		.memblocksize	=3D JENT_MEMORY_BLOCKS,
+		.memaccessloops	=3D JENT_MEMORY_ACCESSLOOPS,
+		.rct_count	=3D 0,
+		.apt_observations =3D 0,
+		.apt_count	=3D 0,
+		.apt_base	=3D 0,
+		.apt_base_set	=3D 0,
+		.health_failure =3D 0
+	};
+
+	if (jent_entropy_init())
+		return NULL;
+
+	return &lrng_jent_state;
+}
diff --git a/crypto/jitterentropy.h b/include/crypto/internal/jitterentropy=
=2Eh
similarity index 84%
rename from crypto/jitterentropy.h
rename to include/crypto/internal/jitterentropy.h
index c83fff32d130..6e07d86eac82 100644
=2D-- a/crypto/jitterentropy.h
+++ b/include/crypto/internal/jitterentropy.h
@@ -15,3 +15,6 @@ extern int jent_read_entropy(struct rand_data *ec, unsign=
ed char *data,
 extern struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
 						      unsigned int flags);
 extern void jent_entropy_collector_free(struct rand_data *entropy_collecto=
r);
+
+/* Access to statically allocated Jitter RNG instance */
+extern struct rand_data *jent_lrng_entropy_collector(void);
=2D-=20
2.29.2




