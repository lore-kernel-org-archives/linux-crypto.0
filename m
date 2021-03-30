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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFC0C433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EC23619CC
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbhC3Ub3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:31:29 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:56503 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232537AbhC3UbC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GHepSS3Vy4lR/a3Gm+qJxWkfBniUrSrX1LTWunOaGYk=;
        b=L7lgt5sKGng+Ep0hluoopgIy37MIQL+5wwjk9klJMPji29920M39USdZcsPCM+MqG2+O+X
        NM6ZvsgzOoJfebdFOo4AGWDL9ZWo+ZL/lYoeZ/L7pjun3BpegujOxAjatKRdTizZuqQ2B7
        AIKWa9cW2Qhmn+LhHWlDawCyI0kUfe0=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-2-hL6_RrhDO3qIf8M4iqvhTA-1;
 Tue, 30 Mar 2021 22:29:47 +0200
X-MC-Unique: hL6_RrhDO3qIf8M4iqvhTA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEIu6ruS6eqMFIJD86XSeV42O2YQNtqIvsAYPeto9DmJMBokLUOW3qJ7ayqxYcKlpNoPdHRWV+EHsBrVnabr52/d8BGYE3bYPrRjGxkzKgOc3aIfTMWcWgm1a8Z8WbXFR5JDXZh07WZIz5GdVS5Cn/X6f4nIFUGUM3MiemwU5/2ZL6kbSAyJRC0N0eQaKc85wsa8bKpr3nASpEF1PaxbeqUClfBPBhDph7mXkPeiBk9KCqxDJdfkGnEsWMcLpdS7WDcTLCz1JQI1r2PyOe2DP2kq7og/hGJ2VAk166Z8ZROBMMZUJsguT+LD6Ke7zhnAn/DPU6scbXu0zk2+1rVi7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZVZgEUnDj9tU46k6BnFUyvHlNHFhm0M8qHCOciqpnk=;
 b=kwc8SbkFQnjwIqC2QX+L3tXKiYJE9fadqZD2NcT4OZ/2OYpz/Bvjh2FOqXZWjLn+RV5kxCX6n2NhWY48/Dld2lrxcZLjkWdT4KSn58EtVPGKm/Asb4WowtlbP0/qEE7M5H8qc2tyg+/ieMpz9xuUdpId2+D/BIxGFGi5bxKtkctrg2TZTlVEoeCxDUTT2mEXPFXHgr61+ZCNa6AhlmrJ8XvHKspGIpJwPKVNTT436UoyuFChwY5q4awypvhY0th6UX5gOXaiUFsXud9TcKflHpA0XBmwYY/6GezJKk6bR4FpCnpeF7cgjyd6NyNraKYz2E+fzVWY058wq2jDrcOo0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM4PR0401MB2321.eurprd04.prod.outlook.com (2603:10a6:200:4e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 20:29:44 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:44 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 14/18] crypto: Implement MGF1 Mask Generation Function for RSASSA-PSS
Date:   Tue, 30 Mar 2021 22:28:25 +0200
Message-ID: <20210330202829.4825-15-varad.gautam@suse.com>
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
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a082bb55-fbc6-4684-b480-08d8f3ba8dfa
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2321:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB2321CE910B5E3C8E8DF79591E07D9@AM4PR0401MB2321.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xNVqqjQb3qso8vE/f8xnGhgsYqJwDlSykq/h6dREm+VqMiV4AdHP49C3f7kN49mF3o99MwAYRObX5PyYUalPmQR0gW+7h4QW78gEG2tkhS+YLNmA9xQwfB6Fmw6J+GhjWrzCP3DbSw0BhDnB128arK9LL1pJHSPG3mdqaJ/eNWwEXerOuO8gifUN+oSx/xTsutDmXgRw3d/KPK/r6xsVTXpzH2qrL8oXcojHViY5/ak7H+AcA7/lqI1jgdkTBlfR7hlqqwyM9KhCxlpBGnXWJbLDU+ZiwGIjUG4mKRjmCRCuxvxEUXwG87Gst4qHEZDhhcHWg1wcnn/uavcvveeL9GDqF5iebRqOPQ2teC9SBg53pHdlrx+fage2RmqiYDBV4cSi1c2ZEPAqwkTF9FOTnZI1HczpYudaUEwIkBYRp2rwioMK7uJQedgTSHt9CDB7yJCexjxbJd8WSOT1NGgmwAH/PsX1p0118fpPsoVufmVHsquJJalb0SYCwcsAl89+00SJZeRAMASaMqW3DUXN2lod02Ii55Ozzj9zRZEL3dz2OS3xWcp41hzhNVnYZAIveIHDmcUK7X05Z+pYJ6QuerwEqzo8/omGk5rqhblzwhwdlwecVapm3zLQXQkmzUOw3xoLHjiN2NBvhBwb+B4UKChK1qbH09JmAjokCfAe6qm/5hAW+tC3grUh4Mi1Lafg+INyNczB49kFKt6qXdei6Nj2PPTfYi3Mo2B+WBj/6Gw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39850400004)(478600001)(4326008)(8676002)(36756003)(186003)(6916009)(38100700001)(66476007)(26005)(66556008)(8936002)(6666004)(66946007)(5660300002)(86362001)(54906003)(316002)(6512007)(1076003)(16526019)(52116002)(83380400001)(44832011)(2906002)(956004)(6486002)(2616005)(6506007)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GuJng0WLQiQ2KC5EEKYUQito3O1yB0Ba09yfb/0xKvxuz8tEmHtdAzD/yBMq?=
 =?us-ascii?Q?0p7HlJbP9BU1/F9bJhKqbt2I0iZKXvO8QFRFvUsCWe3uEXToz7i9mhHa2VP4?=
 =?us-ascii?Q?M5FbIuxSjDXkaIYJBzDOx+JcjT60nkuhTsccPGqMlzOVIzm7/BqDrQlsvzoW?=
 =?us-ascii?Q?y6AtNS+JZs8jEndkfN6qOK8t+W6ZfMvcUFNb1rdMRpUJWixzxAVioxCiAQPD?=
 =?us-ascii?Q?QhbdaZBaAGzpIzStB6yDH+hQgizytDJowMIvHFc7xAVBz5tBJC6v+8VsEyTz?=
 =?us-ascii?Q?A5JAs0+Pu7GRjnOUZj+y+jzxhvgF95E9T5niJ4ZxsWXufpLARE1ufMScaAYY?=
 =?us-ascii?Q?wL/IH5L8nEvznpJVDrDNjwc1eIovssU4T6ymVsVXexSTT4KqJxAynmK2MgUm?=
 =?us-ascii?Q?LkvWP9CvpHDECT/Nk5elfcxkYTinWHV3wzvWeiCpQVfvV4KhLQw0p1/NRDns?=
 =?us-ascii?Q?MrBTMeCHaeeww38hxRgi0LKzStlIqTQW0ATG7A9BOZVGpINH2Ut4E+KAH1Sk?=
 =?us-ascii?Q?1cPGw4bo+Rn2bO++Vr7r3KiX1179Etz305v2HWvn13vfFPxDiV/sMrjuxSgR?=
 =?us-ascii?Q?TekyiRGYTopyWVxUvfbPFCXMj/MhjeVlKs+uFkgjISL321uH+OkQSdRws/xd?=
 =?us-ascii?Q?bY1rTugE3RZELefjFoW+uB/lUUA01O7Mk/uyBiuOV9fc74pyUwX4KAEHrBtl?=
 =?us-ascii?Q?YUOn3BCE+dixPAcbPjX8MHMDpWqp2E7+SWr4irWOH5zeFl68zAWzP2XL7xba?=
 =?us-ascii?Q?qrOcodkOPLAfJA2rAjHR6MO5RaOvhQUKDD+S+fgGc/DxjTvJ95RrNj1FenKC?=
 =?us-ascii?Q?L8NaSO6I5AuEbFwXrggrufhL9A8JBXkizzesXrVgiLyRLxk5OlfqO759mLg9?=
 =?us-ascii?Q?QeZC3xcuN5L/q0k1jYx0lRpXgmEDLFi/WlRcLs/tCa8WQ9hN5ZnkCVrcwXoU?=
 =?us-ascii?Q?iRnIb8Mu2kuOStnR6DFbHjWbYurgRMkPFe385gorpm5MoMPISdjpnXhMGaJS?=
 =?us-ascii?Q?p4BqtPetXUsbfu7If9ngp29NmBineiD6ocSS2iPVpSXQKw176EVQYFl7qsoS?=
 =?us-ascii?Q?e2mnIvrbml6jxTzNXZULDbP57VvYCy3SC8cUXxbFyjfh8i6Qeqcwhr+tIkWu?=
 =?us-ascii?Q?B0YxpYvJ/W+T2rCd1o3+hB/h2011+qANwCeljPnE1/f3Uh3iREe3q8TVKozH?=
 =?us-ascii?Q?yKGNXgnBSX+NjpRcwcgzgkeqgZGUWjyjC2jpVIqnzviKiJi+cFXQKisT+Xlj?=
 =?us-ascii?Q?yUpLeY+6bf/Y483HrEkewES4nE2rEq/xoT9vzp2XlEpmIjdzlfJlGCDwm4EU?=
 =?us-ascii?Q?ns0axsPevjVpd2gVs5LYQBdl?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a082bb55-fbc6-4684-b480-08d8f3ba8dfa
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:44.7487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jCYdPgFozT+rZhf4pIf6LDvMpgFI/Ge8ZJcTjbtdNDBuJOv8eJstJkl+w1ddYY9aFrWz5iv4kbwIlqcp4Zyikg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2321
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This generates a "mask" byte array of size mask_len bytes as a
concatenation of digests, where each digest is calculated on a
concatenation of an input seed and a running counter to fill up
mask_len bytes - as described by RFC8017 sec B.2.1. "MGF1".

The mask is useful for RSA signing/verification process with
encoding RSASSA-PSS.

Reference: https://tools.ietf.org/html/rfc8017#appendix-B.2.1
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa-psspad.c | 54 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/crypto/rsa-psspad.c b/crypto/rsa-psspad.c
index bb8052821982..46578b8b14b1 100644
--- a/crypto/rsa-psspad.c
+++ b/crypto/rsa-psspad.c
@@ -50,6 +50,60 @@ static int psspad_set_sig_params(struct crypto_akcipher =
*tfm,
 	return 0;
 }
=20
+/* MGF1 per RFC8017 B.2.1. */
+static int pkcs1_mgf1(u8 *seed, unsigned int seed_len,
+		      struct shash_desc *desc,
+		      u8 *mask, unsigned int mask_len)
+{
+	unsigned int pos, h_len, i, c;
+	u8 *tmp;
+	int ret =3D 0;
+
+	h_len =3D crypto_shash_digestsize(desc->tfm);
+
+	pos =3D i =3D 0;
+	while ((i < (mask_len / h_len) + 1) && pos < mask_len) {
+		/* Compute T =3D T || Hash(mgfSeed || C) into mask at pos. */
+		c =3D cpu_to_be32(i);
+
+		ret =3D crypto_shash_init(desc);
+		if (ret < 0)
+			goto out_err;
+
+		ret =3D crypto_shash_update(desc, seed, seed_len);
+		if (ret < 0)
+			goto out_err;
+
+		ret =3D crypto_shash_update(desc, (u8 *) &c, sizeof(c));
+		if (ret < 0)
+			goto out_err;
+
+		if (mask_len - pos >=3D h_len) {
+			ret =3D crypto_shash_final(desc, mask + pos);
+			pos +=3D h_len;
+		} else {
+			tmp =3D kzalloc(h_len, GFP_KERNEL);
+			if (!tmp) {
+				ret =3D -ENOMEM;
+				goto out_err;
+			}
+			ret =3D crypto_shash_final(desc, tmp);
+			/* copy the last hash */
+			memcpy(mask + pos, tmp, mask_len - pos);
+			kfree(tmp);
+			pos =3D mask_len;
+		}
+		if (ret < 0) {
+			goto out_err;
+		}
+
+		i++;
+	}
+
+out_err:
+	return ret;
+}
+
 static int psspad_s_v_e_d(struct akcipher_request *req)
 {
 	return -EOPNOTSUPP;
--=20
2.30.2

