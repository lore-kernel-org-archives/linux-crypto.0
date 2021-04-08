Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB73C433ED
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 14:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 452C66113E
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 14:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhDHOR6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Apr 2021 10:17:58 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:59084 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232008AbhDHORV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Apr 2021 10:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617891429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=///ASwrCwSoyQk6TntxWUaPjldH2ujSwh3Qa/ku6+rk=;
        b=O/v8kxtOZDYfcQGwFZm05ikfek//dIomhGrov/Ca69owWM9kXLCubR3LsoZWXgfThLFL7n
        yM0z5SPEkrM9zIxJqPvr3/DsyA6yUBAKEVi55C6pJ8SmfQabLB2A/kKCKB2NZVD5OSWxKJ
        Om6/MKeQT4aZhR2nNIC+U8YyDSwn/VY=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2105.outbound.protection.outlook.com [104.47.17.105])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-5-SvHOEj-INEKeOoVWjtp8Fw-1; Thu, 08 Apr 2021 16:16:58 +0200
X-MC-Unique: SvHOEj-INEKeOoVWjtp8Fw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3QQEMTu2Xf7xVZtCq3N4+R4u9J11ACP9pAC2RCzJ9Lg7rodkP6Efu/yKa7/8pq2KkLyjUDOFuMUMHvxvagCLc4X/QTHKtB4Fic8/3g23rc9WeXfKIasC6HfVSoTXnEcaV+nivkiy2c8gx9gVcTfstvDDYRyabLQtL7TKHiBCbiVoZaOGsoPu0Y4h+8nzf38Q+I5f1PBWxkh+sIJmYb7ykj/DWYOK1xI61SLl0wxvv+dQpYDiU2/LubcniBcPUy4/DNLV5bftkPyd+SDsAHGhoZY9g2CXQPi1+ukCSvH9wnrbqJ6Vfyuug2+M5mdDut1nbTsNl2iofrRd3LSURlEdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNB1YDHlns+BxNLIqTflqWFz5pX3SsgTctL5ouUKofk=;
 b=QfncvG2zIgYhrL1+EjR342e7Wa4fQuRmNbZ7Za2bi9X9TGCUlsUOimGOx5p9Rl0cdmik+A95FsgAsJ5348maVDhgUyXgtXb8ybbajyTnipi3VHgsOo1YuZWOkUR9WKUSaANqDqheBR/q66aQc9AjcTOTCCUEhriWS/1nYppIyr3Swv8GHp1zEN6TFBxOVJp94GJMECqKBDJXSUd5SfY/ljdBRB4TcVAgjM6BA69D20i7gZRGPAXlspuuSQ2xlJnfUVwQbzsQZORygjhU8qkd+QRlEAEAlPaBDGB7EpcMc0KkbJVrK33STSIGBPAglLEe2u6UwPyiFvB9gIpTKvkuiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR0402MB3572.eurprd04.prod.outlook.com (2603:10a6:208:22::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Thu, 8 Apr
 2021 14:16:43 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d%6]) with mapi id 15.20.3999.032; Thu, 8 Apr 2021
 14:16:43 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     varad.gautam@suse.com, dhowells@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, vt@altlinux.org,
        tianjia.zhang@linux.alibaba.com, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org
Subject: [PATCH v2 12/18] crypto: rsa-psspad: Introduce shash alloc/dealloc helpers
Date:   Thu,  8 Apr 2021 16:15:10 +0200
Message-ID: <20210408141516.11369-13-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210408141516.11369-1-varad.gautam@suse.com>
References: <20210408141516.11369-1-varad.gautam@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [95.90.93.216]
X-ClientProxiedBy: ZR0P278CA0137.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::16) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xps13.suse.cz (95.90.93.216) by ZR0P278CA0137.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Thu, 8 Apr 2021 14:16:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69317702-6bd2-46a4-5309-08d8fa98ef76
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3572:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3572E4F3629EF3032E270FD4E0749@AM0PR0402MB3572.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Juf8W7aFcmPVe5qrvCwuzpbYpXzvPgmhMuj5e4qgREzEe0Mrijz0bhS0IKzmCR26/FncfnSiDkowyV+bDoLp6acuPyGrtkC0WQB5JEfXGTEPGiSP2Y6Qz4Lz1AMp/42RgVU1Q1Ll6F3H8BgsR5KUzBIEzluCjZhfIciWeQ/4/SxuWMrnXwhfNyQHhewd++dmkn7qQZO3/5OhYNY3eBC3jIYJaDSUp6nazC2obuC6FBVKPdJ73FixcLgwUg8LEmQn+QJwMkOvBX2HIppPG/kY1RwzsiOQfXxFO4bag+ZdgRwdTtMm3M24vrLdrLdlrws2IUSflivtnffvhGhC+gBti5oLyyd2N7bJMSm+bi0XNtcMBwPRvrkCla6t21t+zKs+xzW/2Gt2pgL4HBgK8NMK1uAX5xAZwtg1GQDzQmZpb/H+tsmKGNz3pLIr9DD9H8NwfT+pNNYjf42NJlqUtMjcrJt9X0/7u92eXwVV5jEeRcNSleKWX9Z5cjB9sL02wbQk86hGRSqb0QLrdeUs8isyuEFPpF1wB38UG3n3y8zwzFvhQRDC+2a7uYKtAm7bpNf1OySWFcuEy/2uRZoowBCPbVRoKt8wdfbie/6oNvPUm0Om+ejHtUOUDq0G1vxzkFgvStJKvFURzbRsDvXAeA9ipDMOEGDcbTCTyrNvdLVsTggSkbT3kT/brw0oTHdHZJyp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(376002)(346002)(366004)(16526019)(186003)(38100700001)(2616005)(956004)(38350700001)(52116002)(6512007)(2906002)(36756003)(44832011)(6916009)(83380400001)(6666004)(8936002)(26005)(66476007)(66556008)(66946007)(4326008)(316002)(1076003)(6506007)(6486002)(478600001)(5660300002)(86362001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MbZuw1DN+wkd7VkZTQterXK70D/51bTsDRp+ulvrjLClAEye/IkTjbRcwdcc?=
 =?us-ascii?Q?yZP1qAyoYFcFBmUMDpEtF0HjbQaq5dkzUvvR4v4XxyHEEgpNQrZJhAtK4+Ql?=
 =?us-ascii?Q?4wpihgiIgWumbfYQ+18dvedirXy3ElvNbeQ6UqPky2c+xF81sHp7plN4z1te?=
 =?us-ascii?Q?r2DnQFzI7kNyPNrhMRppxqO3/m4kSokFSl4MrBOEZOeSm4SoJl1QdLUkR1Z+?=
 =?us-ascii?Q?qUwMhv6BD7IdI4e9gCyW3zGKRbcINk2BsXxspXJkG9aJrVINHhaC2r+2GfMk?=
 =?us-ascii?Q?wB3fAcSFka5hAVU0yMEPb3EfcrB4oTHjGQhe4yrGL1G6QIjKSa9iR8A/Ft7u?=
 =?us-ascii?Q?VegV5ImyVozBf8Wl2/rVl5yDtN/ihBDLL5yqO4OBUIJK0S88+87hAeSvEmVC?=
 =?us-ascii?Q?PfBUOn9FtPwChBdDMLoCFvjfnZdSkL9dh30exmYO81OhdD2Ll7Nn26mZypZd?=
 =?us-ascii?Q?WXi7ZAIdWk/HGJT6Gt4tACBQVcAqf7gaycGUX80hgXzjbHFR9P49e3lAx1fV?=
 =?us-ascii?Q?gfw96wx2becFKyeUjKR7rAEZ4DtEzk5G4dH1rjpYezk5Zj8heqwgf109suu6?=
 =?us-ascii?Q?TWCLNyN3K2IdV0uWYLv9nNnfc3TtUo3hdc6J5VoMe+62GLD/aQCfY1paEJ/d?=
 =?us-ascii?Q?TjMnYlyjF79GJ5JJvTMgYn0TcIMVyCa2ZNxGSTW0TdnfDTL036FKDLilqIWH?=
 =?us-ascii?Q?XjgLW/VC96jttrUn/+gsOo8GgeG6l+5KEJSwZzh4HBays2vHydrpJwZClXiV?=
 =?us-ascii?Q?KGQu69pXtJTcpi1yRRM9zRL0ND9zMGGKJGXE1jVFhcDPebI4fQIkFRK7dkJt?=
 =?us-ascii?Q?5ZpCEtARcvPW5oHOdibIOt+ldV+NVHNEqKuGETi6YoEs+i5nPBFxJkmPKxPq?=
 =?us-ascii?Q?uTa4l5CTNHB8uy7g0Z/ms6sAyQ7ptZc8ZTwKMGoIW2CsOo7LD3znF7tz03ic?=
 =?us-ascii?Q?ME1KZBO4nLFBNuAkeYPskmxyrCGUjf6ux7arZd3hc1MGDFb8k/pwlX2hl9BL?=
 =?us-ascii?Q?MN8KnNRlf3nZGzIESSLV24dkyu6zrpfN4RlnPkgaiyh4CHn5dUKmVmc+aX+D?=
 =?us-ascii?Q?ekHoWZnMWQDhSik8JWJKEoFmJxEyDAVNfKf0MWaJxGu+AjO0ML9ji2kfLc3k?=
 =?us-ascii?Q?v9O3KimaLFPiVN6z9SH/0e4Ezcu7NfluWDeGDxe19GLZhRqFcE8nXyWJmrKW?=
 =?us-ascii?Q?Vmi3n7Y69oqzilSJuX5qnjwx+uwVwlQi3qTQXjADrn5hdDq4ewM/cDdq9oNd?=
 =?us-ascii?Q?OdhH0ABM9GwNm8xwqcksez+6b+QqSKlsRw0l+uU3QCQqOytiXGa2B8et/Rwh?=
 =?us-ascii?Q?Hf8IYehBcHPbEZjJ4Smc4i8e?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69317702-6bd2-46a4-5309-08d8fa98ef76
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 14:16:43.4156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4BMnTyYjx4hVby9lVWIremJsE/LmyIDLizW6FJAJ1NzppfAD4bH9bEHDLqSV5505rFuF8mLqpMIct5lAaoSRAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3572
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RSASSA-PSS verify operation needs to compute digests for its
Mask Generation Function (MGF1), and for digest comparison.

Add helpers to populate a crypto_shash and desc for use in both cases.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa-psspad.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/crypto/rsa-psspad.c b/crypto/rsa-psspad.c
index 0e5422b05c081..855e82ca071a7 100644
--- a/crypto/rsa-psspad.c
+++ b/crypto/rsa-psspad.c
@@ -6,9 +6,33 @@
  * Authors: Varad Gautam <varad.gautam@suse.com>
  */
=20
+#include <crypto/hash.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/internal/rsa-common.h>
=20
+static int psspad_setup_shash(struct crypto_shash **hash_tfm, struct shash=
_desc **desc,
+			      const char *hash_algo)
+{
+	*hash_tfm =3D crypto_alloc_shash(hash_algo, 0, 0);
+	if (IS_ERR(*hash_tfm))
+		return PTR_ERR(*hash_tfm);
+
+	*desc =3D kzalloc(crypto_shash_descsize(*hash_tfm) + sizeof(**desc),
+			GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	(*desc)->tfm =3D *hash_tfm;
+
+	return 0;
+}
+
+static void psspad_free_shash(struct crypto_shash *hash_tfm, struct shash_=
desc *desc)
+{
+	kfree(desc);
+	crypto_free_shash(hash_tfm);
+}
+
 static int psspad_s_v_e_d(struct akcipher_request *req)
 {
 	return -EOPNOTSUPP;
--=20
2.30.2

