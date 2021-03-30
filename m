Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664BFC433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E9AA619CB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhC3UaD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:30:03 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:58536 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232478AbhC3U3q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tulGvBsCnhbOvRxIjVzEDXvgBez3x2KNyJw/j62v9tc=;
        b=LrFQKsYtUEnVcPTkttvqJwwXlVd0B5LiC66wSEsxJl4vTxnIy83bJAzFZa+XeP+XDh4eZd
        1VA5ylGpNWLs3UMnGyh1NNLTeiIQVTyzMSUXs382N2M0RJKxAa6HgDOK7Men+HHIt949fl
        Wu3M2mkiqKc0lvz2QSx6N8AtSGA0WiQ=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2051.outbound.protection.outlook.com [104.47.13.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-T7DFSz4LPS224rvkGHQkUg-1; Tue, 30 Mar 2021 22:29:44 +0200
X-MC-Unique: T7DFSz4LPS224rvkGHQkUg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLETIgv7XHZdNRbIDTRywgV6eOgV8Gwk24wTd/wrqB1PdOizDgQawk9LPvOWjQVo7jmraQfgixVsY8wGQljw3FDDUKQzgkPJS/oS+hGHtkBeM/1e4+c3sd+rUWdW1+5OHPOOr9R5NgxWKrbBh/Z63aiRgvtHgoQAI8wv32rSFVrqKHiKIGM4HuFDuAwdpUYzz/QdXFR8oIdz+zoGce7z1/+cP4f0acbaCPBVo3ORPPIm4YZbYi0qdiHJsqoIgoCVsrjiLNoWm0fKpMZ14FTSBkKVsoRnnqxniUGPPUwCeYQqLVGmcaPoex87cc6Tzo8Dzt6emZtylx3zbCzzSD4LZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtaGWAilVYSzQAA4YPzjms4nCHUEHbgL2thqZEfCgNQ=;
 b=jxXDlwIJDYnZheWWyBfxP0wB84RkaNfrcX3MLVm/VWzU+uYVQsYJguN7HPt/vmZanjKmeALu6Vmk5dglRyRMVvMqVsAF5s/2+Ip4Z2pFGWYvASsz9DMFVTGhKIVueEYld4HmPZu6S+wDFFjHihaouK5GjSwIpBZsV7sDztbQKe/br8BfUS3txYvImVdPPlTL55kd1EeoQo7+ndgjlELpH9R1bLSDAb5i8EJzFh3O8ys/O1nfXeE3672ua38I09cCuPWTHMC4naT6bDHhfKfv/8SXrf2ZN2psHqJF5xcMJZtsuMFSuCoLxQ5jvQj6D4ZyBMgJ62/+X36/OBPmGVqdJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM4PR0401MB2321.eurprd04.prod.outlook.com (2603:10a6:200:4e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 20:29:43 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:43 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 13/18] crypto: rsa-psspad: Get signature salt length from a given signature
Date:   Tue, 30 Mar 2021 22:28:24 +0200
Message-ID: <20210330202829.4825-14-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330202829.4825-1-varad.gautam@suse.com>
References: <20210330202829.4825-1-varad.gautam@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [95.90.93.216]
X-ClientProxiedBy: AM3PR03CA0066.eurprd03.prod.outlook.com
 (2603:10a6:207:5::24) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c64d6458-c2d6-49fc-0239-08d8f3ba8d44
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2321:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB2321B912979C5E4B986E9E29E07D9@AM4PR0401MB2321.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:466;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mmGhoGYxfgcwhCAbXRuE5ECGV35MaCW36bDRuBvsApty6RSn/Z4BT1c7CZ8tj275MmFD2HdwqcPIunRIzDvU9Ia/nYl3s3S4KmixniMGaQCglwFItwecTRat/sknPX3BqLcq9yRxZBBjOS4p3fdMzNhV3jP4E2DiLPOIBLOYXNodSeUa1NpKVCMpahNpSwHV9Vq6MYEdTZik/o97rpPafBt7JUMv2xX1Lh8Q0Vw0kNW8Q4/qxN/Y3KNcY1amYKlThg3pr+TVTZa06xI2NHO4pxZA7FvQboxOmuKePXHqjzemdEnbndKp1+bm1haVeMbJ62ngtXQ0AD1aMnNKMiy1N56jwoWOhwdFIpo9AviTLa9n203HUIkjhWk0ZD3rV14N85kWJX3fTYXmHsO6cxjQYLhPuOaiu51NSOCDeujqZYNdyLPIBZmf0csos/bXpwzgzAr676HaSWbRSzaPWCsr4cIkSI30j1RP4ryOYgKopiOlYojghUeKX+khQfp5YY7Glh4IhMgP50i2gXWsF86PtusleHyVkGnt8solnl9tKquHeQO5qY2GICdzF7Y/EsYlDbA7IEAwMgygz3NaBWDCbEa2YynOSzZ2vYVF8knNWJvcf+KiX3vteNOSjMOF/EhguGYIgJRSdVT0BxYwmfoXpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39850400004)(478600001)(4326008)(8676002)(36756003)(186003)(6916009)(38100700001)(66476007)(26005)(66556008)(8936002)(6666004)(66946007)(5660300002)(86362001)(54906003)(316002)(6512007)(1076003)(16526019)(52116002)(83380400001)(44832011)(2906002)(956004)(6486002)(2616005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1fH7KpCOKIM7vDl7D/cJXnYL/WDSlITxnAf83kraP6wtXj70I120mrbwbVKX?=
 =?us-ascii?Q?Cf8rdzCgP5fIuBTyi/qiEkqQe4muuQS7UX+j1bMSfD+gvCfS1NqqPQ5P3bvq?=
 =?us-ascii?Q?M8d8qAikCs3XWxW8UbCU2cEKsT0vgIDFXmxli4eJZDBFBb8UcKTlA48swsFt?=
 =?us-ascii?Q?o0fwUFAvas9H5AbYWGFU/fp53W6A9H/jOVb8xOzTVTtC3AchS2UnvxlNZr2H?=
 =?us-ascii?Q?7Gp2Cg5J/5EjsMyt1rhZvRxkHpbi/bd2lQQU6vPOfU9Na00MiRVgzIc5npXl?=
 =?us-ascii?Q?cLXlqEe1lv8yLYJo3bDv3sza/Qh+sfNrN/1u7ljdL8rBrFoVK5cEYZtETRWC?=
 =?us-ascii?Q?GWwP4emkt3W/EmjuwfX60sqjEOICgKbdnyCbJOe1DW23suaa5iGc3Q4bsqvJ?=
 =?us-ascii?Q?1eMvBnTxMJxhuJ6Dqt3XtUJp17QoSS0gqjWSl4fa8wi8T5VeFTvSxoijFOLk?=
 =?us-ascii?Q?+C/eFfC8s7ee36Kn3pNod+dCNvpA71eWYt1BMPx1a5e4F/xgpxX1k7yiIYJ1?=
 =?us-ascii?Q?zIHn5kWWUEEuatlAtyGn7Ksv98qGp7p46F1rbrLhATfZKpWLWXdJpA0XCk5/?=
 =?us-ascii?Q?eaHD3xeMnE8mxULDVdbl16OF79kA4lyYzy8gKFh1TfgHWl0BocIYx2GidsCW?=
 =?us-ascii?Q?VJTEC7l9Ipk8jlPnOo7oqlm3NhGJ+3sCJai6sA8F778lnIBgbSocBgZDnPmD?=
 =?us-ascii?Q?SN0Il5O4sk3OrbHsxiey7SMdaSADd4hE0Ge2W+VWIxnsmtDQJTtXF3BIFnvC?=
 =?us-ascii?Q?gia5wdV75OzYzSt1dvEk2e9+Pf4ukpQu+NeiACNo8hepp9cSaHZ7xLjNFF6i?=
 =?us-ascii?Q?ksrA60rRw6IhHOqMmovyAxF2+jLyOn2mUrOJSIUO7a7S9yEKyjSRj7PNz0JA?=
 =?us-ascii?Q?wd3iftjLVJnVpNeQYRsZVVTsyt2V9GUrWpcDT6WoiKwZaV5XWIADVGkb9p9o?=
 =?us-ascii?Q?qMVvFiQvUheNbM/lW+7f9hD9gJrFbJeLn1bWM6FvCR7oSHpIu69sTpXbBeKD?=
 =?us-ascii?Q?SXEIs+hvizfR/53gG6rUV797xJWwOeRri8wt8TzmPjfFFT8Um/WcAsGjlsAh?=
 =?us-ascii?Q?12vrwgoYKB9rdbfedMcecmE9rDDdra4I7nyoWnmUK5OmUjLDrDfN0WINAwEP?=
 =?us-ascii?Q?9auWFMcKRnfkcX/zQ3mv77iiELeRkvB5TWCICuiyTcW3QNKupf+2ddO0ObGE?=
 =?us-ascii?Q?OMBn4qCRHn0uSwxbSJpZgS6SzAB2Z1sPfnPXxL9PAgtnhvyrSR09J2DqLwBw?=
 =?us-ascii?Q?b3G24F8aeNwMZ2IJmuCp+tHGVG4gHrX4WTUIsA6IVw0n3lBIi6MaNVNmTNac?=
 =?us-ascii?Q?INgtZXXjYco6tQD7S1BPxz51?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c64d6458-c2d6-49fc-0239-08d8f3ba8d44
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:43.4714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VlNwT4gkRngi8QZyt3X4gEbODOuz9N9/AHMmmU5kUP/Jv0kTytZnfXZDQEZUXn5oxhCeYvOelVPuTWzfR4EBZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2321
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement akcipher_alg->set_sig_params for rsassa-psspad to receive the
salt length for the signature being verified.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa-psspad.c                  | 20 +++++++++++++++++++-
 include/crypto/internal/rsa-common.h |  1 +
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/crypto/rsa-psspad.c b/crypto/rsa-psspad.c
index 855e82ca071a..bb8052821982 100644
--- a/crypto/rsa-psspad.c
+++ b/crypto/rsa-psspad.c
@@ -9,6 +9,7 @@
 #include <crypto/hash.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/internal/rsa-common.h>
+#include <crypto/public_key.h>
=20
 static int psspad_setup_shash(struct crypto_shash **hash_tfm, struct shash=
_desc **desc,
 			      const char *hash_algo)
@@ -33,6 +34,22 @@ static void psspad_free_shash(struct crypto_shash *hash_=
tfm, struct shash_desc *
 	crypto_free_shash(hash_tfm);
 }
=20
+static int psspad_set_sig_params(struct crypto_akcipher *tfm,
+				 const void *sig,
+				 unsigned int siglen)
+{
+	struct akcipher_instance *inst =3D akcipher_alg_instance(tfm);
+	struct rsapad_inst_ctx *ictx =3D akcipher_instance_ctx(inst);
+	const struct public_key_signature *s =3D sig;
+
+	if (!sig)
+		return -EINVAL;
+
+	ictx->salt_len =3D s->salt_length;
+
+	return 0;
+}
+
 static int psspad_s_v_e_d(struct akcipher_request *req)
 {
 	return -EOPNOTSUPP;
@@ -48,7 +65,8 @@ static struct akcipher_alg psspad_alg =3D {
 	.verify =3D psspad_s_v_e_d,
 	.set_pub_key =3D rsapad_set_pub_key,
 	.set_priv_key =3D rsapad_set_priv_key,
-	.max_size =3D rsapad_get_max_size
+	.max_size =3D rsapad_get_max_size,
+	.set_sig_params =3D psspad_set_sig_params
 };
=20
 static int psspad_create(struct crypto_template *tmpl, struct rtattr **tb)
diff --git a/include/crypto/internal/rsa-common.h b/include/crypto/internal=
/rsa-common.h
index 4fa3cf5a989c..84c63830577e 100644
--- a/include/crypto/internal/rsa-common.h
+++ b/include/crypto/internal/rsa-common.h
@@ -26,6 +26,7 @@ struct rsapad_tfm_ctx {
 struct rsapad_inst_ctx {
 	struct crypto_akcipher_spawn spawn;
 	const struct rsa_asn1_template *digest_info;
+	u16 salt_len;
 };
=20
 struct rsapad_akciper_req_ctx {
--=20
2.30.2

