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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34626C433EA
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 041B0619D0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhC3UaA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:30:00 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:58393 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232466AbhC3U3j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ck2QcV6lwHjoue9CmME6jJJaIFfmTJ0untdWxK2+FRU=;
        b=G3u47MB0F86iX2ONbJnUe7n5z1Ka/axTuH5MuRztqTnF1NNVx2Fi5/E33h0eFwHlkOZgNo
        YVq8vP3ustTjztvJqUs2NUSslkqZbzjxEmciKZ2LsQE9xOxyjMBAUHfhaDivtN8lSOGK1Y
        0ZZ8LlO5KuPLleDtyTenIafH4N6Yf98=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2058.outbound.protection.outlook.com [104.47.13.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-zcgHQTKqOpK_Sr7NhoPguA-1; Tue, 30 Mar 2021 22:29:37 +0200
X-MC-Unique: zcgHQTKqOpK_Sr7NhoPguA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBV/h45WqCCh5NKnic1VYzYNVPm+Qa51EEKhKAq+8rmTa+4fd8uhIgVaJV9bkq0gfm9cHpYQwgMRoc/KwVWtkSGFiCXP7bLwSk5DmGzz+tZ2giQXiucDe0nbukYbdYhuqC2ScacA+mkPzwwkJZWwHW9SQGmtzF6hrJtZFLc5rfAktSmMfZj70UwedaC/X7MgjEcwFkfuMmcHz2qtbiU2kERZuPXYNghVUGfEA1BYJZLgC4pHZ9jo73uVAI2hrxw+kWT7LQLGwu36AOr/U73N4iytiX23UA03pcfy+9KwrHH3PskIRtB/57xet68bl2PbrKvMuZqpi1YAqMreiGk2VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZVUAaIXfOfb7Wh9tTf/Yi7eWHyAEOzzTTUE/RoD8Qs=;
 b=k3M/l5SusamQr0fm87k+cqrCpQNoDFycIXFF2w+kxxZqUv47lZJBQCJCtAmL1EhRdQddK5oasitf7GJUQ/w2x/R/wfgetO7raNPpXXpbEWAaPvojPUGcXRQscScOtWQUtpjNeoAvhe89q+m8DM/Flht5086ZW3cB8FnCm4n+rB5balhqg3mvYyYIoZd8D12YiyzVev3gZ61PupYLXQCYzMxJpT4gIlPfc3x6Aq8vx/dfLdkSBO8loR50b2DyPiNwWI+FAaxa0QxvkNrLWp5PiXP0QyPYKMzDF/F2bNfSbgh6xRaidO0U9P8ggaQt+MFbhlXoh+yeMZeUy0wEEdWo/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM4PR0401MB2321.eurprd04.prod.outlook.com (2603:10a6:200:4e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 20:29:36 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:36 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 10/18] crypto: rsa: Move struct rsa_mpi_key definition to rsa.h
Date:   Tue, 30 Mar 2021 22:28:21 +0200
Message-ID: <20210330202829.4825-11-varad.gautam@suse.com>
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
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cf23760-4547-4fcc-20fa-08d8f3ba881a
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2321:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB2321893C8B9830D49B55F666E07D9@AM4PR0401MB2321.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LJOY7JW1s2rRMcq9iTxjTaxtbfKbNQLn2ggdknRFDM3LBOOsy+0I2Hxfp4HlYrt4MCJLBqHntDy2+UTeaTQtArP8QSDyi8NkGdKs55AfpGTNkRyyJepv9s6AeYZHee/Gx5/n31c301+GqWtbUSfseRR32jCg9O077fSEcHrspJK3L17T05NflI/Qr5TQYfffsQwuXrvHRFftg4t3HBEEjbbCfYgR0Nb19iB4oCViUZa5b7Uw/G62xABAbMy5j+ZLE3RMmP+hTSnMq8sRcGALhflklplcWOE9DSUoB3SUwVIxgeUJy82aCyVYGspIhwCUBvn2fSJzSUK7tqF++vfMiIXp9iI+QVMK7aqxvD473jygpccLfs7ehd69oIRyAxpo4c56ZUqF8L7p+NNDQfpDeDorjEjJbhvkX4U0fVcX0iNCPpT2CNQVixXKW1hHIWiEe2g12mDPsuDTJsRCQrUrFJFTbdHqFyewSlBEJDj1dJsfTP+3tDFoBpbIQmLEJs96ERGaELW2W+omqmevHwlQJFnuZmW52k7szvloqP2K7b5w/KOTQkXb6A/eY6CQKcRuFljAJR38m6DbwHyuOlgScQa3otOZkDg1wm0fPqEfUDVYeszzJPffGeo4av5tGOiU511XGdUVQlq+H5ihEWR6nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39850400004)(478600001)(4326008)(8676002)(36756003)(186003)(6916009)(38100700001)(66476007)(26005)(66556008)(8936002)(6666004)(66946007)(5660300002)(86362001)(54906003)(316002)(6512007)(1076003)(16526019)(52116002)(83380400001)(44832011)(2906002)(956004)(6486002)(2616005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mAIf7WcFTvKrKKeHlXQXND1cyNmX04qss33jSxmFnQwON08xj19BXmDZ7uOf?=
 =?us-ascii?Q?x9E7fEsZqBaq8RlyLY9we6vkzq8bKXewFp6fdzINGlprpbaq1yRmB7ClXmif?=
 =?us-ascii?Q?SxCdy0uXoFUZtM2yneRw6e2mF/vFQvavehyjMyxLeqD4Q4M4/42TlugId0d0?=
 =?us-ascii?Q?u453Kcq2kyDGvFHxOyE9MvzwBVdGFR/1zMrWsTvtDAUacbSsiMuOCDWlBFWU?=
 =?us-ascii?Q?r/k6cpivevmY5d87I6ndC3qtyM9FzyT/g+ggZfP4dTLMy8vYOnhv884wohV8?=
 =?us-ascii?Q?rU27QT0l86/qtI0f/TagRmQZcOeZM1YR/1ygROXbOWgEzFtU7yBWrFk1/h84?=
 =?us-ascii?Q?crG1JrkoCvNpSCY2FzLrwluxM+zXYH5A9G7L1ByVwN067kP1F79N8hGQFTLp?=
 =?us-ascii?Q?Qbsk2rIKxMfFh2jsvQ3Kd9BljpcLjQ9kb+nY/d25OW6Fwkjl64TKampOhIc4?=
 =?us-ascii?Q?bsL/zIHQ8bG9iYYXXPq7l90AtOsbLaEzm/DC0z0hUGGMao4lSuhLkMVTms8B?=
 =?us-ascii?Q?rc8fvV6WeSxnqjgzTm24o3T6e4Lx+DrphM0LxMBsfubJlDvEVBeeFoNHYrVc?=
 =?us-ascii?Q?ViNvSRuUlLvsy6s9u910WA7mt9tBtl5Cc8bsbwv2MHfFh86/HDlHkbk6tqDv?=
 =?us-ascii?Q?4zYsiWj2xQJvSlAwsrALQU617sGNNxFsmyT7xmfxXWsfSEeQh5j54ZHxAZ9u?=
 =?us-ascii?Q?N5fFweiCoKvU6XW4itDo2yEQ9kXSWkLohVxQu2MTj2APFKQjj5lHrc5vnz7l?=
 =?us-ascii?Q?XCGLJL05QS3dnmnHc2vDhX3BBEpxcrh9TKtGcCH6KLZGKXs7XOMfqKk7hCXv?=
 =?us-ascii?Q?OIkFCuMlfPEuU2n8R3Fmn9+2vBm80vD+ut1yWoKhyblKpR85tfXypKqc32DZ?=
 =?us-ascii?Q?UT2XRJ8qcLBI8w1GszU+xiCRK/q+l+WUEFKu8mc+06tnWKUn6iO/M+Zwq7J+?=
 =?us-ascii?Q?dVParnAwf+OK8e0gjzI8ijwaP61oUMkvsLp2qP2IzZmewJYp3IyAZ4Qe+Qc/?=
 =?us-ascii?Q?4EAGfRLYeyMuj7IxPRL3JOLcDAnuH2QWHdkirusUzayuTiM3d/sGlGRYsnYz?=
 =?us-ascii?Q?ytNMbVhvRI7vGQk6eNaIe+IAP3S8JEDugqvHOK8Ya2NAL0SUNdkkJtwAIe3m?=
 =?us-ascii?Q?1IWfA2Asomxp2mIaC7aickKj2x6CKjyxP57YKsVe1+k8LminRgh9FkAfzb+B?=
 =?us-ascii?Q?5VXoPKsgmLyBIA5bT6MjyigcmCq3u2fcTi+eb2+14knNLa6B7nkpempSXwM9?=
 =?us-ascii?Q?I89lHw/E5E/1uh3PyxNwMbkMjJ8rDBQIjOgzl2O92PmT7UyvdiEDup+ZsQWc?=
 =?us-ascii?Q?uodUdiO1iRLsyCYHmuv9EWm9?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf23760-4547-4fcc-20fa-08d8f3ba881a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:36.4125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I+WytI/tkzar45KwWs3tzV/BVlScv3zGeQ+s/GjqgFVag41vgyw6oMpsnCUfGqwIQBX8TXrFe949Vjq4vQVIaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2321
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The RSASSA-PSS signature scheme requires knowing the RSA modulus size
in bits. The rsa akcipher_alg max_size call is insufficient for this,
as the returned keysize is rounded up to the next byte.

Since the RSA modulus is stored as an MPI accessible via
struct rsa_mpi_key, move the struct definition to rsa.h to help RSA
sub-implementations query the MPI values.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa.c                  | 6 ------
 include/crypto/internal/rsa.h | 7 +++++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 4cdbec95d077..5c4eece5b802 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -12,12 +12,6 @@
 #include <crypto/akcipher.h>
 #include <crypto/algapi.h>
=20
-struct rsa_mpi_key {
-	MPI n;
-	MPI e;
-	MPI d;
-};
-
 /*
  * RSAEP function [RFC3447 sec 5.1.1]
  * c =3D m^e mod n;
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index e870133f4b77..e73c61f788e6 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -7,6 +7,7 @@
  */
 #ifndef _RSA_HELPER_
 #define _RSA_HELPER_
+#include <linux/mpi.h>
 #include <linux/types.h>
=20
 /**
@@ -53,5 +54,11 @@ int rsa_parse_pub_key(struct rsa_key *rsa_key, const voi=
d *key,
 int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
 		       unsigned int key_len);
=20
+struct rsa_mpi_key {
+	MPI n;
+	MPI e;
+	MPI d;
+};
+
 extern struct crypto_template rsa_pkcs1pad_tmpl;
 #endif
--=20
2.30.2

