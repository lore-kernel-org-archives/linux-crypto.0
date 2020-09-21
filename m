Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99DEC43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 11:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3C6020EDD
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 11:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgIULei (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 07:34:38 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:36970 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgIULei (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 07:34:38 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 21FF51C0B7A; Mon, 21 Sep 2020 13:34:36 +0200 (CEST)
Date:   Mon, 21 Sep 2020 13:34:35 +0200
From:   Pavel Machek <pavel@denx.de>
To:     thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccp - fix error handling
Message-ID: <20200921113435.GA20450@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Fix resource leak in error handling.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index bd270e66185e..40869ea1ed20 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1744,7 +1744,7 @@ ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct c=
cp_cmd *cmd)
 			break;
 		default:
 			ret =3D -EINVAL;
-			goto e_ctx;
+			goto e_data;
 		}
 	} else {
 		/* Stash the context */

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2iPywAKCRAw5/Bqldv6
8kt6AKCJfXT80NLwOxJcyAGK6AhV0nDn0QCcDmbOodUew6N04IcDIE4W858W680=
=HHOS
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
