Return-Path: <SRS0=chSI=24=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E35EC282DD
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 20:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 480FD2081E
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 20:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgAGUbD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jan 2020 15:31:03 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:33591 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgAGUbD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jan 2020 15:31:03 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MdNLi-1jNzGd1Hsm-00ZMDB; Tue, 07 Jan 2020 21:30:43 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ima: make ASYMMETRIC_PUBLIC_KEY_SUBTYPE 'bool'
Date:   Tue,  7 Jan 2020 21:30:30 +0100
Message-Id: <20200107203041.843060-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ZEgeThKH95YGwIPMAJtHd+2vyEnR5Gf4z4NycDvpMltoNTD3qh/
 /aJUkacxQlY9YOSWv2ierQLql1Kc7wAqrHd0RC2QAqNMZLArRzXVIWI5Mcz0USGYKa6I/su
 xAjMFuHWD4XBSsdDH5Z4KZBJhQBe8dPiTyJFt/m0Ou3deKidBiqVGd68ZMu0jrDbsWQXJmm
 LLDGcZ4rhOpxk8juBwNjQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:fw669OqxhOo=:5MiDxcR+OnD0flNZf4Q2Fz
 Fvm8om7GgV8y6CdnSdv06vNV/4ifmwz2oWxYgVkkC3YVJcr8TopFmnBP7/et7yW0zzkAuckal
 dlgSYRlIWEgzXb/3VlPTmO0EOKSrj1PZhKFja35TMeb/r9mTKjs7eTbj314A2RpoM2MVWEiN3
 lS1UF/KLKEiXPmg6p6DPk77F271YSxIZ8+o23lqWEfN1Ec8zmrPGZIuDl/BqcCM/rW5U9a5fv
 2K2rOyacwDoQn75iO88h9b9xQSiFHhkfTCKPXfJOM8MasajY3EWH1vbAYa/qGr9/LeMpT90pV
 AtgaR+ba7cXx/CkY+W5N3XJb+KfSOMeasF/00LBMFMtGj3qi281RyhJFPGw2RlqNZzFRwPea3
 HPgiaEsNSxfOypA/ARBBA3ejOC5cQwbLvEnPwg8VlABoi4O/JQlrz3nDlFCH93PwUltgX0Y4O
 nwHTl5bJ0vV2aPdM2l8F+XTL4fguEbTt7az/M+CuRyb93Rlh1BSBXFnvNznj5H/RjjwZwz8G/
 sXdipv4dntau9mcvp2MlLGKaHYmqKJbk9FCgGlXdu2aCCMYMZN6zju/1/oCEh6vFhFa1q96T2
 5eymiSuYER6IrxwTHZDTAo7z5vYpzNgpYCKSSs6vzhnP2fRVnAk/AcgmuelpAy4uGTz5NBBxa
 EKlcmSBdqaDLUm2F0+DbhMwbBbx5qsf66Kal3rrI8pQ0hzx7R7sJRRWlDSDBCq67X4NhwaQSR
 7/OC60r5khQ2AZkfDB1CE3Hu4/m7z/rPMMJKy+kRk05U4quZdG7mLf6uPisMQNywmCrLQNMU1
 w1/XabK4jcmtTWb9fnNvC4/RBuhHugi03ZXK5nUbs3dnY1KJhWHlSQ9Gikw+M8+e9X4Tov1kc
 Iu4TMIj/Ji8ns8cWdvSg==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The asymmetric key subtype is only used by the key subsystem that cannot
itself be a loadable module, so when ASYMMETRIC_PUBLIC_KEY_SUBTYPE is set
to =m, it just does not get used. It also produces a compile-time warning:

WARNING: modpost: missing MODULE_LICENSE() in security/integrity/ima/ima_asymmetric_keys.o

Make this a 'bool' symbol to avoid both problems.

Fixes: 88e70da170e8 ("IMA: Define an IMA hook to measure keys")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/asymmetric_keys/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 1f1f004dc757..f2846293e4d5 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -11,7 +11,7 @@ menuconfig ASYMMETRIC_KEY_TYPE
 if ASYMMETRIC_KEY_TYPE
 
 config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
-	tristate "Asymmetric public-key crypto algorithm subtype"
+	bool "Asymmetric public-key crypto algorithm subtype"
 	select MPILIB
 	select CRYPTO_HASH_INFO
 	select CRYPTO_AKCIPHER
-- 
2.20.0

