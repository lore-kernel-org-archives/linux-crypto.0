Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A107CC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 10:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ED1C20897
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 10:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="S7FWKbMN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgFDKkx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 06:40:53 -0400
Received: from mout.gmx.net ([212.227.15.18]:47639 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgFDKkx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 06:40:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1591267238;
        bh=y1kI7VIlfs2LA9lPs0hK6UiVkciIYKzDNPdz1Yn8r8Q=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=S7FWKbMNn6nprt23aHzzBAju2iqk01uHfz9hH2pJODxLqYqxlgc+lu2ZYzRjc4PQ5
         ABEX/2je4wX7qfPRVO8t3wz4Qf8LHLTvFxVNC4Eo4+c+rLjnZFn+fnBh73+oGgNkVa
         RV057IL4z8U1y8B5J/59LKUd/3ziwLAbGj2hqM3Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from LT02.fritz.box ([88.152.145.75]) by mail.gmx.com (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MnJlW-1jHO653gfc-00jKcL; Thu, 04
 Jun 2020 12:40:37 +0200
From:   Heinrich Schuchardt <xypron.glpk@gmx.de>
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH v2 1/1] crypto: caam - fix typos
Date:   Thu,  4 Jun 2020 12:39:47 +0200
Message-Id: <20200604103947.11276-1-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nqZItOZOWHDAAptD8ANtmNSiu8H5Cmm71OjEFhtwD320LBGWVpC
 rCSeoPpT5cAJe+KVTMsmMP5eYRCTABNBzzTNeUZTOruGJ4mvKtSuZDzJ2/HQqiQ8Mkjb2sm
 vie3xBrOhIW8bx3gGt1Rpg/JjTwHmi3dtKLbiPRSOpfcei2qoT8k3wTjhWp+vcKztwDlYJ0
 KAO2YMkZazZEgu55v0FKw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QExcY3i1fRo=:vmUwc7cDQjybn84kM8OCzv
 kfesoHRoKbT3gEBsAlaaX4M1d2dnYqYVL9be1cpJOQBXnEJLiUO9uJ+jbkdB7G0qOgsHMRJ2j
 vOuzsOpj/R/k1xXcldET2vKdH37tHZgGpWEXwJPh+rFURMuC4EJplq+JasIdbZJS4xcWhJ0TD
 QbjiXykqvv8ny0Cabz3L3K4Z3CTk+ay0J/AEi/R6VbpSVG67+u1DJU1EWo2/ks4tGWMCUiTqj
 2pxuMA7gxDFvXorgXPbZ+TROYGMgkhyiRwvukfpJniEQqjTAgYLJJmoDvj9ojM/T32Vz+TbuL
 iLNqGiXBgQyJwqqSAMe32ssCyI0b5gqpFtUMpnOX6E+lACGsmOBSkw7X2YQPHX1nGAIaLfKQ9
 1FWNoYEsDGabNf/mb6N/0HZ8fkjD2J+Ko/dAheEjO9gPU9Gu7YDand2cQ1TM1TiiJmu/giLq6
 +cpRBIP+Gjfmn0wOT1otR+RVC9SAs5+bGbkY0mD5N63mjdVTxnwywdJOkWMbTsTTUv0RTPKc4
 EI6FlRu27KOKMel67DRd0iUobHtZnNUEVNr49wPTaTQOjsz7vt/m0TZfrrvAn4Tw4efMc7KwR
 ZXk4twDvBgSi/+Cfq+AeJYirhEbWhjET/AcMz021cqVD64K/0FZIKlEoL6Qcewlc3FhQwceEr
 krY19R9TgxKCEXZTI+CKWO9fyEDa3Hz5e2foM2QFwPnLbvfHvNjzg9z8HVj3KIuD2V9Pfd/lP
 dr1Amrl55BJ8Mrpe2Q8ECmiuQzrAnklN+Sdufgo2ecXcUk6Pndi9DCETMCRAEHDOIkK3GVoy8
 4c5qTUAbBmDfsaSZysO1aDFIcK4Af9RE1+kT7tWXOQyYz6b7ysxYro1DcxmSVF6UCrhwfgFgf
 4WtWZyNToj0jnWffraEXuVbNLTWXd+k0BVUhnc9F7QAp1Yco/ir7R06E3LWOs53FJWeM2P16u
 mImANuVP4fxyoPAAcTrdm/5LLOxDJEbDMC88/qrLedU6LYUXDfSkpcdH9XlJWpbu8TfGI3Y14
 wr0XoUg1N0ixdg+WH78n8++BOOlTW6gj2yzQvT/LVxBGMjJpqhqV0uAwvfGeErovpRGNV35zW
 uelBH+6ChK8cV1yAEEj3b5MmUebGdTlFb0RS7G6PvxL0oLM8XrneZk0P3qH0X/XP7hHdC59m0
 SHVxXJSEkbho1a97ltrYb1JhSjOE6FZYGmzwXcHXq54lLg5WMdYUUVPrfMd5xVwUzaFCud6K5
 OsekqIMBMFOrudC6C
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix CAAM related typos.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
=2D--
v2:
	fix additional typos as indicated by Horia
	replaces https://lkml.org/lkml/2020/6/3/1129
=2D--
 drivers/crypto/caam/Kconfig |  2 +-
 drivers/crypto/caam/ctrl.c  | 18 +++++++++---------
 drivers/crypto/caam/desc.h  |  4 ++--
 drivers/crypto/caam/pdb.h   |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index a62f228be6da..bc35aa0ec07a 100644
=2D-- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -147,7 +147,7 @@ config CRYPTO_DEV_FSL_CAAM_RNG_API
 	select HW_RANDOM
 	help
 	  Selecting this will register the SEC4 hardware rng to
-	  the hw_random API for suppying the kernel entropy pool.
+	  the hw_random API for supplying the kernel entropy pool.

 endif # CRYPTO_DEV_FSL_CAAM_JR

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 4fcdd262e581..f3d20b7645e0 100644
=2D-- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -54,7 +54,7 @@ static void build_instantiation_desc(u32 *desc, int hand=
le, int do_sk)

 		/*
 		 * load 1 to clear written reg:
-		 * resets the done interrrupt and returns the RNG to idle.
+		 * resets the done interrupt and returns the RNG to idle.
 		 */
 		append_load_imm_u32(desc, 1, LDST_SRCDST_WORD_CLRW);

@@ -156,7 +156,7 @@ static inline int run_descriptor_deco0(struct device *=
ctrldev, u32 *desc,
 				     DESC_DER_DECO_STAT_SHIFT;

 		/*
-		 * If an error occured in the descriptor, then
+		 * If an error occurred in the descriptor, then
 		 * the DECO status field will be set to 0x0D
 		 */
 		if (deco_state =3D=3D DECO_STAT_HOST_ERR)
@@ -264,7 +264,7 @@ static void devm_deinstantiate_rng(void *data)
  *	   - -ENODEV if DECO0 couldn't be acquired
  *	   - -EAGAIN if an error occurred when executing the descriptor
  *	      f.i. there was a RNG hardware error due to not "good enough"
- *	      entropy being aquired.
+ *	      entropy being acquired.
  */
 static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 			   int gen_sk)
@@ -733,8 +733,8 @@ static int caam_probe(struct platform_device *pdev)
 	handle_imx6_err005766(&ctrl->mcr);

 	/*
-	 *  Read the Compile Time paramters and SCFGR to determine
-	 * if Virtualization is enabled for this platform
+	 *  Read the Compile Time parameters and SCFGR to determine
+	 * if virtualization is enabled for this platform
 	 */
 	scfgr =3D rd_reg32(&ctrl->scfgr);

@@ -863,9 +863,9 @@ static int caam_probe(struct platform_device *pdev)
 			}
 			/*
 			 * if instantiate_rng(...) fails, the loop will rerun
-			 * and the kick_trng(...) function will modfiy the
+			 * and the kick_trng(...) function will modify the
 			 * upper and lower limits of the entropy sampling
-			 * interval, leading to a sucessful initialization of
+			 * interval, leading to a successful initialization of
 			 * the RNG.
 			 */
 			ret =3D instantiate_rng(dev, inst_handles,
@@ -882,8 +882,8 @@ static int caam_probe(struct platform_device *pdev)
 			return ret;
 		}
 		/*
-		 * Set handles init'ed by this module as the complement of the
-		 * already initialized ones
+		 * Set handles initialized by this module as the complement of
+		 * the already initialized ones
 		 */
 		ctrlpriv->rng4_sh_init =3D ~ctrlpriv->rng4_sh_init & RDSTA_MASK;

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index e796d3cb9be8..e13470901586 100644
=2D-- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -18,7 +18,7 @@
  */

 #define SEC4_SG_LEN_EXT		0x80000000	/* Entry points to table */
-#define SEC4_SG_LEN_FIN		0x40000000	/* Last ent in table */
+#define SEC4_SG_LEN_FIN		0x40000000	/* Last entry in table */
 #define SEC4_SG_BPID_MASK	0x000000ff
 #define SEC4_SG_BPID_SHIFT	16
 #define SEC4_SG_LEN_MASK	0x3fffffff	/* Excludes EXT and FINAL */
@@ -113,7 +113,7 @@
  */
 #define HDR_REVERSE		0x00000800

-/* Propogate DNR property to SharedDesc */
+/* Propagate DNR property to SharedDesc */
 #define HDR_PROP_DNR		0x00000800

 /* JobDesc/SharedDesc share property */
diff --git a/drivers/crypto/caam/pdb.h b/drivers/crypto/caam/pdb.h
index 68c1fd5dee5d..8ccc22075043 100644
=2D-- a/drivers/crypto/caam/pdb.h
+++ b/drivers/crypto/caam/pdb.h
@@ -453,7 +453,7 @@ struct srtp_decap_pdb {
 #define DSA_PDB_N_MASK		0x7f

 struct dsa_sign_pdb {
-	u32 sgf_ln; /* Use DSA_PDB_ defintions per above */
+	u32 sgf_ln; /* Use DSA_PDB_ definitions per above */
 	u8 *q;
 	u8 *r;
 	u8 *g;	/* or Gx,y */
=2D-
2.26.2

