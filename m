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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CDAC433F1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66F13619D2
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhC3UaB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:30:01 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:45666 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232477AbhC3U3o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uVYCLF/9AHi8yJw5e+r7ZE6Q2SL5ZPu4Og+oLgDZ07A=;
        b=FT1iJpYD3/HDJXEDypVvCt3LrMad1Iy3wYGwetYv27FtXQak3R1EKEDF1Y9nHQs7IsyVPw
        USK7PkjNY+Yh3CnXrrKlyJ83Yig63Bl1AKJgOT7Ax27a16RMaeLQnNifvtiehMGmjT8/ka
        L8ZwDP2yzzNK9RwWpXu6pHIk7hjvXYg=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-38-TAv4JsSrPSyYb8RB7TBfBQ-2; Tue, 30 Mar 2021 22:29:41 +0200
X-MC-Unique: TAv4JsSrPSyYb8RB7TBfBQ-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rdyvh67Lwnui5Am+3tVPYCczd2wFxWM/GGaAbh6BuwJ/BEJu0itl29zcT9W6iZezCy2YsDjRoUTjnSEVb5QI3QiyTukIPcPgUctK4BA7DlHFiK0kUpy2OUuRgbc3mUvezIwZPimfYLYmpJKTzrYcFLMpRoqWk1kw5n5TVPBf4hHKmF241GXuyG0FsP8pW9GBo/K/KMTWptP86+8w3GRljazOOanQzg0RlZttA+zENqCvhJz9+Ww/mC/rXITadXTPWbr++gxOUYGbJFrVTGN5FQrssrXOCb+2QoRvrzuftgdFZN5yKHAGN33r7pe7zYi7bWNS+oU3IzK3sTc0hTwksw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFuRBKRDwUFSxZVwJ/RE11lRr/LbkxKEZrYVVCrkKw4=;
 b=J03TbseKwaYQD344dje8SvBoxj4R0eD9kwMIVPIv6FkjHLrYeRyNvVs1lI+Gzl+Fk5qcXykDRUFzrFN+xDH0j7p4tAkXvm7ZtTEEmMSqCuX1LsqyVDBg1jh18amNGxRj+lZfI0wPFfsGlqwLTt7ly59TMF4OIyVjFeQPFJHQW0ToucT0WzE87Wc95OzIAXNqAcRGqkLRBVjnbE0GBP45T6bYKcjP/z1MtwlVhcX2C42bqrrXNpBb9tUDJ7i6NVrGbYOWZdu9M+tXclnHtMgHJZ18QTrEnZPcA1UQAgDVSQsAJVXbzroQx7a1LIiT3n4a/zXGfDFnHMGzrLJZfs5mfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM4PR0401MB2321.eurprd04.prod.outlook.com (2603:10a6:200:4e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 20:29:40 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:40 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 12/18] crypto: rsa-psspad: Introduce shash alloc/dealloc helpers
Date:   Tue, 30 Mar 2021 22:28:23 +0200
Message-ID: <20210330202829.4825-13-varad.gautam@suse.com>
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
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8013d31d-cf03-4274-7349-08d8f3ba8b89
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2321:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB2321452F78A3A05FF38CC662E07D9@AM4PR0401MB2321.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oXUit/vL3iXD4iHNfkBFW7xgPoEsUon5cJJWah1LCOzkHvbadYG3vIZEs5QHdvTlhKa0Ix0JU3WXQwF8BGoZgrjXerVM1PWhlZBJTyOTJvEfhiEagHk9rH0FPI/sdVGl0yY+Y71CABtf9OZ+ItjpQIzgScI3lSaY4JP/QnBQnlXuKrf3bZbMY2QvUSa7eJIm+xrw3tQAJbw61UrbaG3lZbFyHzZ7ZZpOsdARHhm0G5753/PMiXndRTF8DRAi+wbkhCioTN5p65WxEk0U3fELYJ6Xly+Ck/X4Ea2hMTP7riqOWzSh1rJQIonQ6b58AESrGtTKdltk/XgQnKg1smIIDHkROFxH50imJBUpvI8n/dcF4WVMWj/xO2mu4+4UvtSxQLiSA9hoUKoq79kpAavr+AeJjXxs1tziRGjR/9nbvXKakIfQB/cc5SUaTLOO6U9/bCIrcaBEXg4TxfSB7ii0bhFa4BOL5YJJuU+XXUs0eT1JTdTw8VXHANRambU/Wuw6xMJVm2uIw4muFz1tGKij0ELAWyGsDoFByQ9TbG9bC3ESc3D3q5lJyIMx0Wxcnrb3544tkF6/ujR0q1+sLIiruXhHS3EoZ3xyB/ARLHWq4B11caf4lf2OyKd01Adc9ID6WRxHggevNyqVZWqbs/LhKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39850400004)(478600001)(4326008)(8676002)(36756003)(186003)(6916009)(38100700001)(66476007)(26005)(66556008)(8936002)(6666004)(66946007)(5660300002)(86362001)(54906003)(316002)(6512007)(1076003)(16526019)(52116002)(83380400001)(44832011)(2906002)(956004)(6486002)(2616005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IAUdT1iz3QVvR/zh32xwH+YnCQ2+l+804b2xBw6Nf2GtEQ0aMMJrQeiNVfgA?=
 =?us-ascii?Q?Cz/9NQaGPjB61beFE9aTreoZE4KFDaIW+dw22CXbIrUrJVhckOGrqoWk3w/r?=
 =?us-ascii?Q?r3s1GB5WDg816oRjGmq7W762YhA7NvuGFBvwn261G665S4ajtvNs8FL1vckl?=
 =?us-ascii?Q?B2IxIBkB4g+8iuw0A57fsmCR2K0QfDpKdADmMBrF+tYeS8S4+NpAf3qQKA7E?=
 =?us-ascii?Q?Y2kF0i10R+D9PYpDBIG+ookUzhclb5/i2IAXpFJyFbf5kDyXMs/OyQn0D1br?=
 =?us-ascii?Q?mKCoQ+ViasQf8sxF0whRt3IQaH5yyE/nSDQyRaRhtLhhRv9PwuPvP2jHtWi4?=
 =?us-ascii?Q?9YOjiJXF3aBAM0Xp4pU9rDHHoMYm448q2+dFhOKI0JrV6pUAT1LgmnaowTc8?=
 =?us-ascii?Q?sfTN3lZCLRNQmA9oTvJ3d80jV4l+41feQGOyINTWergqz868lQZGqYiKdyZY?=
 =?us-ascii?Q?mag/vkwuBhEJClN636TOCrV3IEiZ0nUg/GqmBA/OXtaO4a3huheYbihT0FUx?=
 =?us-ascii?Q?nh11Nr5nuQ0M29mnxOB5vUSvRawJbVn2R5AU9n1RQbOEOvdbSLYOoINYFe/E?=
 =?us-ascii?Q?kA8X2vDhJuOaMpKpRth8+Aloc0OcWvjEvzVIfB7foLISIHFgtubQa3mfNRtl?=
 =?us-ascii?Q?HhsWkpAp4itCOyrWLxhkW+nQXI+C0Zqs1dM8SYYGuTAhnGx9PPiUOL2GdeML?=
 =?us-ascii?Q?66Q0Mqq8U2qyXUvfun46imw0zBXXyx7fgOOXcw5lx1WprBTS1qRzYHrDEu/S?=
 =?us-ascii?Q?DjNpnDEiN77Fis+ZKe57Go8sUoCeXJoy6cn+pqGPd08aFI1oHn+3NM53Ys5t?=
 =?us-ascii?Q?82ozSBLfNt7N38qN3bq9sxNVVnu7t7ee2TdRwHyKMr0ebLZDq/4iNtkRZQVj?=
 =?us-ascii?Q?0rjyhZeDkGxI8ytOl/blFlzu6gcZOpFBo/L1fXqubmX/W3TanRCv/XD5CFpP?=
 =?us-ascii?Q?RzawOrfK3G3n7RVJvQlounQLaRyiwXjs1npQ0ln6o5Ve6W/NMr/ZDSbpwucq?=
 =?us-ascii?Q?mnqwG/2NVfecB/qV4AdPqYDh8lsxB7PkuTCQn00gNmA4nMOlACC6f6erSk7k?=
 =?us-ascii?Q?JR5i4CZMKU17BuammnDjBqGCqm159xdpSkxes1gdLe5K+hXA5OVv/vg2DMpO?=
 =?us-ascii?Q?DQ1VOz3IJ1wu/gJ4OmKnx4Ul18mh+PEefjche8ixb9JxqitAofzwojuq2UTI?=
 =?us-ascii?Q?9I166HuZeBi45uYuQzrH9dVWsGlkbYZipjuJe0D8aVeV6BkwHXCMkTsWEhsm?=
 =?us-ascii?Q?YTfYRURewJCJNqBAS3K9iAAdN7ChR5jgRcg3A4gTOnP9PDJ4gj77WKadDdIb?=
 =?us-ascii?Q?dtcGeNXw5j7KL4HZIpusvgeA?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8013d31d-cf03-4274-7349-08d8f3ba8b89
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:40.5971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0hnNA+g9No4q7dgkP24yCRx+P2te2DBYDaVwUgkKpzSZw4sERdxhpaIQllaINesZecvfz0z0IYCfxU9OHUp3OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2321
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
index 0e5422b05c08..855e82ca071a 100644
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

