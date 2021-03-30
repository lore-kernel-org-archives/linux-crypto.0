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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F483C433C1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED98F619AB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhC3Ub1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:31:27 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:27315 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232533AbhC3UbC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZG2q3nBTbEqxhzYwuz4UXeDSfxU/8bhB/7YcV6Mt9Hg=;
        b=OiInAvtSmigkRLsR/thhVB9asWWrwuR22u0j9Jspl+PknKTl+iZBywsIlW8s15keUiaJq+
        jiN6mgm1S6jIC6EST8KJHPhpK574R0z/jfuHWAPqzaHNhZG4EmSFGxx1MoPEYOZ0hoMZj2
        1rtFfn7aOc52xi2pBoCErIfvBl93Y1w=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-2-n6XydNNvPIOS7LMTlmq0fA-3;
 Tue, 30 Mar 2021 22:29:49 +0200
X-MC-Unique: n6XydNNvPIOS7LMTlmq0fA-3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEJDWnA/C/ACybDDif4bI9qxHE3QbZwxxVaQ9EUtS7222mUtqKyJ9FvYAWhbMo+2whXEbCQAf8luLlPHR2BDxH0Wzes6xRaEiPG5cLWeRXjoCsDPqhg7bWNwdOSQiSA8xrk8uIEQ3ULCeaRReILbSXbDTEuYJGquxUWabh1HNFT5FZc8XI0W0SDxQl/X4SjxExqHfMN1wakk6Z19KMl2A+7zgMyxwYjHSXdUVRSASuSSsYAYiuOtIivYkmcwVshpuzeXd1LpuktbJ6lwlNo39WRzQaS6R0SMauz16cAU+TH6gbFV9AwGzQNTIQA+u+pEO9YTveNS/pMNC6ZN800eGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqf7Ev3EWaySfHRXohz7oJ4413HDR5jqJObo4e216/U=;
 b=WUTkk/XLDBQC+6uYAUIerHDFk58Y6kkPepJ7gOMnfVwOtzEjJAR57KHcSoeRCAu3N15VMTVFU9bdmJAkknqAsa1fitVliB0ESjD+s3V4sYJB0b4yS2T3FR8t0ShZzVuQ6VJwwjKdgkuVFycYCMVOu7r0KA+VSBA2jnNGLLmRyCXcF+359xG3UJPFJihbObZaRcK/bDC7GkQTAtzoCmzl+aIDWOZBbWd0TNP+LMHWscvwz4Hu4pAryWdGlJ9xKgz6wlU6+BLhpOO4prq82r3dey30Spe7AhkWFIscxQXE1BQOryjhPVm7BXOEO5e40XXFdUblquNllsMM3oEfjm3C6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM4PR0401MB2321.eurprd04.prod.outlook.com (2603:10a6:200:4e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 20:29:47 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:47 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 16/18] crypto: rsa-psspad: Implement signature verify callback
Date:   Tue, 30 Mar 2021 22:28:27 +0200
Message-ID: <20210330202829.4825-17-varad.gautam@suse.com>
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
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2b92d20-a6c6-40a0-fa75-08d8f3ba8fa9
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2321:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB23211A5063630D3D2D0D5BD9E07D9@AM4PR0401MB2321.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:473;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jMtV+rYqKAcr+KX3X/5oQiJHqFpvfNxWLPL0m/g1/hEWoxyzeK8Jt/q6UJCKuNp2Z+7bEHXBACKtA8mPb4pjsu45SzIEtNOn5xb58SLuDr7BQNYgKDTzVBfWX5S7QfaNNmHlSbxMO2h+7W+0MCs8KYaNUC1BKICWnwM7aO1OBFgTfLAVq8QHj0No05EYGzFa5XwANS8MwdMjcwqQIMwkzWuDx9BaGzGO299x7yk/3S+r/Wopr4u94E/X1DF5C8Qtv3ZDXyhW3gYzf9rktRBhW9HJcWE32oSM2/X5MNVdIiYaFIpU2muzsOoNT3b5hNlSjQkdSqtVdm2GkpM8o39TQ5DGfkHsctEBWM8sxDGC60MZ+xqWDi7IwZPcKSP0piIjL6OhCS+tY+5fqJDyXq6sJUrVrCvg+2dE2ghTKIHx3fAHp7eE0c+qB9qCFKe5kymItiZVhLDxUhODn0dVRSNtSH6PGa0Hl4BJHyV8opu08GUtQqcKve/TST+wBHmeBVt+CM6zI3F8N0Wp3X1EdDmUx4MGW5hOR5DwmBSRGE5MIBSKJATnLDS1Wc5tEG/hro6wMckVGoiLf3x238DU9TjgpoAdq1ESL6QRqhJgcz2kdQBKhJL6g0zJwRoKJnBqQfyN7ECnd/QyGZIhOxbG2nDUf03MAoDXGhuPjR3p4yoUhdXn8YB39xzRwGM0BjmOKMnTr49JdZ5nG6GUfqWMjzEIko9Tej/ydgmtnd1HY8HJ3ok=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39850400004)(478600001)(4326008)(8676002)(36756003)(186003)(6916009)(38100700001)(66476007)(26005)(66556008)(8936002)(6666004)(66946007)(5660300002)(15650500001)(86362001)(54906003)(316002)(6512007)(1076003)(16526019)(52116002)(83380400001)(44832011)(2906002)(956004)(6486002)(2616005)(6506007)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Rl8lyNKBn7WN0B5e6rM87TC5WR8jOr+SLpGHLTfIfxRCSCLui6qCM5VWkYbP?=
 =?us-ascii?Q?vNdw5szyv6a7TTQvScagsb6RavMQmHakb/Ykb+AtCama5PQYlwuPvr4VWiYB?=
 =?us-ascii?Q?TnsAhUu3ywDSLzRnKURvpoEgbAQofQZ7LPExy130UsxBlDonURcH87ThKLoI?=
 =?us-ascii?Q?0sM9y0rW9wy54hh/1TX/Vok/pwnVfP/A+3Jvw3JP6gz41G/HNCMEC9Pcb0LB?=
 =?us-ascii?Q?trDLRdK7L65JAVbLBmfytDHTG/HS6fdsREoMbwfLEspa+M6NEDFrsKwEOF26?=
 =?us-ascii?Q?/L2tPnuX5De4B8t9RvdGjw9mfbJkdSvURIEnEyJibo7wDnwqWyK78sX6tDPd?=
 =?us-ascii?Q?zHFLkil6LE3l0EtEYUqufDfPsqcqH9n7p7BBNZjKmD1r23wknthDyUu0XduA?=
 =?us-ascii?Q?i109XbiZM5IlQBzIIArIcl2Yngz3DfkXU+JsNE7+erM04C8xoNDOxaPqSr08?=
 =?us-ascii?Q?S06XytvUqkvSzxYVAsWEKNE1/G6yNrivQq53Bq1OBpEX4Pxa+IGyjeQPTbrC?=
 =?us-ascii?Q?wRd6eeMZ/rb8U1UpKyViOJV8ZkGBe1MLDmF1UbjkDfJYeStqP3RsAGulLYG1?=
 =?us-ascii?Q?sEHacaFgb7OdIK5UhAKA1v13JwIrPyg7jV7WPD4N5TAiinqrmuvLCPbYiJzc?=
 =?us-ascii?Q?cg8vii6rb8i45rS96XvrGDdmrwBMm8OIJze5HIXJpn9jYbznnkiXxgCBjF04?=
 =?us-ascii?Q?kkT5VtHQ+Tp/FywTl4x4cCbL4SzTaHcjZRlWGbCpWkDUb5V+8JdSQ+qKbq9R?=
 =?us-ascii?Q?T6CHeSfy7OUOMm9hkVLCdt16DrZOclYK2t2Jolnki7WZbV1Ft3SSSkymvVDv?=
 =?us-ascii?Q?pKULHCWeg1rMwmGWxmfncVAaJQ2ZqvZWm84H+UPMl+R7urFkoTvtI5Gz8Kh3?=
 =?us-ascii?Q?owzYzLsPusQQmgfX1D8SoWPWXFEmgJFGEs/I66tYumg7oSaDwBxWEYSDUOcn?=
 =?us-ascii?Q?P6FZnijO219FdJSTz2Rv+eZT7Wq3wRuozdg9mZSbsxppt82uBFHPM+OlRx22?=
 =?us-ascii?Q?Zj1u+z5vGlmyLLM58TJyG5PRnAZcieKIXiFQe6x1+jUVKKsvMA5poK/U4So1?=
 =?us-ascii?Q?/4/3mM53+new3oq+XIVoNT+ICthHCzENVbu+0hw7s2JRMRP/CNGuTMJ0sb1P?=
 =?us-ascii?Q?oY9DlqKpX56yuMUZmECTlBE3WSFSsp7du5IUq1khhxO5UMnt0gNgM0EiMl4A?=
 =?us-ascii?Q?ODt7nzCxvyzQOdPHL+A/hjpIBdCBNRfjWAMcFUezNNHqwz1R+QPw2qauqcWx?=
 =?us-ascii?Q?mKZ86k5VrBufLhgiRyTBQZtm2m5Whfn2oDodLKh63gNjzFWmJeNWSD41oxZC?=
 =?us-ascii?Q?/c+wkyMyYPqRN2mvBMaafusN?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b92d20-a6c6-40a0-fa75-08d8f3ba8fa9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:47.4952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KTbZ/jdvJlPBX0G2h+i+iZWbsGqO3dOdIPajjwwyZ5EOy2eDj18yIsU6fbQhDDgRDFERjMLlnBxpjYT1UgaMAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2321
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The RSA output must be processed as per the EMSA-PSS-VERIFY operation
from RFC8017, which forms the core of the PSS signature verification.

Implement the verification callback, which operates on the RSA output
buffer.

Reference: https://tools.ietf.org/html/rfc8017#section-9.1.2
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa-psspad.c | 107 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 1 deletion(-)

diff --git a/crypto/rsa-psspad.c b/crypto/rsa-psspad.c
index 1ca17b8b93f2..2ce750c5a23f 100644
--- a/crypto/rsa-psspad.c
+++ b/crypto/rsa-psspad.c
@@ -8,6 +8,7 @@
=20
 #include <crypto/hash.h>
 #include <crypto/internal/akcipher.h>
+#include <crypto/internal/rsa.h>
 #include <crypto/internal/rsa-common.h>
 #include <crypto/public_key.h>
=20
@@ -106,7 +107,111 @@ static int pkcs1_mgf1(u8 *seed, unsigned int seed_len=
,
=20
 static int psspad_verify_complete(struct akcipher_request *req, int err)
 {
-	return -EOPNOTSUPP;
+	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_akciper_req_ctx *req_ctx =3D akcipher_request_ctx(req);
+	struct akcipher_instance *inst =3D akcipher_alg_instance(tfm);
+	struct rsapad_inst_ctx *ictx =3D akcipher_instance_ctx(inst);
+	const struct rsa_asn1_template *digest_info =3D ictx->digest_info;
+	struct crypto_shash *hash_tfm =3D NULL;
+	struct shash_desc *desc =3D NULL;
+	struct rsa_mpi_key *pkey =3D akcipher_tfm_ctx(ctx->child);
+
+	u8 *em, *h, *salt, *maskeddb;
+	unsigned int em_len, em_bits, h_len, s_len, maskeddb_len;
+	u8 *m_hash, *db_mask, *db, *h_;
+	static u8 zeroes[8] =3D { 0 };
+	unsigned int pos;
+
+	if (err)
+		goto out;
+
+	err =3D -EINVAL;
+	if (!digest_info)
+		goto out;
+
+	em =3D req_ctx->out_buf;
+	em_len =3D ctx->key_size;
+	em_bits =3D mpi_get_nbits(pkey->n) - 1;
+	if ((em_bits & 0x7) =3D=3D 0) {
+		em_len--;
+		em++;
+	}
+
+	h_len =3D req->dst_len;
+	s_len =3D ictx->salt_len;
+
+	if (em_len < h_len + s_len + 2)
+		goto out;
+
+	if (em[em_len - 1] !=3D 0xbc)
+		goto out;
+
+	maskeddb =3D em;
+	maskeddb_len =3D em_len - h_len - 1;
+	h =3D em + maskeddb_len;
+
+	if (em[0] & ~((u8) 0xff >> (8 * em_len - em_bits)))
+		goto out;
+
+	db_mask =3D kzalloc(maskeddb_len, GFP_KERNEL);
+	if (!db_mask) {
+		err =3D -ENOMEM;
+		goto out;
+	}
+
+	err =3D psspad_setup_shash(&hash_tfm, &desc, digest_info->name);
+	if (err < 0)
+		goto out_db_mask;
+
+	err =3D pkcs1_mgf1(h, h_len, desc, db_mask, maskeddb_len);
+	if (err < 0)
+		goto out_shash;
+
+	for (pos =3D 0; pos < maskeddb_len; pos++)
+		maskeddb[pos] ^=3D db_mask[pos];
+	db =3D maskeddb;
+
+	db[0] &=3D ((u8) 0xff >> (8 * em_len - em_bits));
+
+	err =3D -EINVAL;
+	for (pos =3D 0; pos < em_len - h_len - s_len - 2; pos++) {
+		if (db[pos] !=3D 0)
+			goto out_shash;
+	}
+	if (db[pos] !=3D 0x01)
+		goto out_shash;
+
+	salt =3D db + (maskeddb_len - s_len);
+
+	m_hash =3D req_ctx->out_buf + ctx->key_size;
+	sg_pcopy_to_buffer(req->src,
+			   sg_nents_for_len(req->src, req->src_len + req->dst_len),
+			   m_hash,
+			   req->dst_len, ctx->key_size);
+
+	err =3D crypto_shash_init(desc);
+	if (!err)
+		err =3D crypto_shash_update(desc, zeroes, 8);
+	if (!err)
+		err =3D crypto_shash_update(desc, m_hash, h_len);
+	if (!err)
+		err =3D crypto_shash_finup(desc, salt, s_len, m_hash);
+	if (err < 0)
+		goto out_shash;
+
+	h_ =3D m_hash;
+
+	if (memcmp(h_, h, h_len) !=3D 0)
+		err =3D -EKEYREJECTED;
+
+out_shash:
+	psspad_free_shash(hash_tfm, desc);
+out_db_mask:
+	kfree(db_mask);
+out:
+	kfree_sensitive(req_ctx->out_buf);
+	return err;
 }
=20
 static void psspad_verify_complete_cb(struct crypto_async_request *child_a=
sync_req,
--=20
2.30.2

