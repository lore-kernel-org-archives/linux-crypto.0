Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19ED8C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E480C22CAE
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="TS+e9r5R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgHGQWx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:22:53 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:4231
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726996AbgHGQWf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:22:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jh9qgscdqncpn79ITzpR3BoDnDKfl7OAH3J3Rk3SrTwoxEHCDsxYW+Jbx5jvuDMROK/ZINKgKufnmgBZgm0BbZx8xsGyE7ptLeNys57+wMY/RDGDSgt6zOXcN0LlK7JdtsM+zlSoavalr1tunthhgDdr3HCz35KYbEakaLspPU/u7VW0at23/2/H/RzRMQxKaW1IvKHEulDidSqRNK5gXVa2CxCqvrt9MGiNHCFH/WFtVlLA4H9YUdpvKiKlrzpZdFGd7hC6awDu3ZefUmq6IxVYV3ZYJe1C+oMhNh2IUS8ryRKlcV12Dy9FU3WQQJSoB1QgddMZiW85Serobkd8LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAYKh++vF4KpuHhTQZhWSaZQIOj6T+WI/Kqium2hgI8=;
 b=M0/aoE85XR/o0obJzKAOx+TV3jVdCjtJ5W6jBMhTnpNvLk5qleIzpY/0fFdXh7Iwnxxa+pfMH42i7BKCHx8Vu1XAu3Q0aPaMXuyYvX+HTCsx8vRCqQ5vtTazyaoEOOVK2gCQJhetR2w7qSPBsjDue0mt3MgYCNYzcWu9aLPl3Vs9wJa3CRMtu8umHZuOjqitC9L7KBOKEGIk1hnQqVQ46nA2AtT1cs8/280EohUOoBNObjtdd/mfxOMoqXI1Ca7XlPCjsDKu4k7LJVFQCxxm/trxV6QXy4fXnlfKUC/zIdkIpcljbZ5OFcNlFlMUrrwwv5kQby2xzzuD/OQqFaAPfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAYKh++vF4KpuHhTQZhWSaZQIOj6T+WI/Kqium2hgI8=;
 b=TS+e9r5RkchV+RoXdpnpRSfdbMgOhyZ1tPX6/dV/nkowoDemPCvYOF1/gTT5TZog9AfMIBvZiLrkL/p570B5OyssbW0pA7CNXpCZTQKQkXmsKhWr46uH9ayu8CVDkCuCVgY3zjn92dHvCQiQYLFD68Rl/pUGzKu5GniZANIhHOE=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:22:26 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:22:26 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 22/22] crypto: vmx - add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:20:10 +0300
Message-Id: <20200807162010.18979-23-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:22:24 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: db6d582e-f312-4347-9a5e-08d83aee126e
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7359471A5569A61EA9CF0A07B4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SBvn7lOuFex1vjZwY6ydgy4jyzzZtHO/gIs0aX6QgEcPdzCCSf1BTS75NQCyVYdJhxSP0I7YP776icGqlcA72y4redHK7GrbO341CIUxvUqfvn7fG/27E5cEyBKZRZZ7Igs078iuPcSgbSVlRAlHv4tFAq9c0GyjtQHqLUdiSus8AGCNKaXb4PKRDlG7VyyMVa18vMVDqcfnV4O+U9UobRt5T293UwoAyu6KPelqjozk/XjKgdr6k6wqqjSPYVYE1DJRjFyxrnZWgGZCzRceXXiP3QgZxY+5rwYF5GxN/1Idw7fFmLzy++Q7l8axzmdotDZRXaa4U7mYbp0+0EBMhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(7416002)(66574015)(54906003)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(4744005)(86362001)(5660300002)(6666004)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KTItpbhXeOfEP8zVq7C1jZ3rUJg/Axwj1GIaJ6oh6r8O79WA9TeK3NEH3jNgm7iibzK8UrQGc7liMJ0hYADZMa9o8IqZkylaUfMiOi+O0I4p2UMEkD5zZcNIbv7DszcUs9Od5BVL4KHguOzJi+6qV+zbjW36w/mfya7AEMUieWbSs8Tn9ssQ/DAfznckJT5GQ/oGPXPqYvK1HvrtkXzPonErlpUmE+c4Npkyquz9pBAX0wHAKPJ2UbFoPgfCeWB13YgkKF+i6BWg024sPw7XucHGNvRe75lSAz9CoTz3kmCsmSOd7lUqwwXDu+i7IAoV8JgFG+BxNDBQ7lZ+eEul0MIerbT/K/Y21Eu5fTonGTe2hQ9Hh12ztBjt8FVTzdmSvtMgTZW7gIpYcoILTh+TVpjCzO8HduG2n93f47hG8N+1vG5SrxDCuIBFBDeUncLqMI8ZJQz6rqJa0NnDHBYMkcXXdWvpQy4vxwlWSZUeIdtyHmVDdGqU6C0pSfLeehH06/zdLxPiulPavV1/sB2W2Aij77bymNpacXCBcDcQSOtEBeUPZszevu3gVJTNnRCDWQSE9I4K0gSqPypnPpKe6foB3GFKITow3HJ3QevxDhACjjTuP3It9weM/mpqLA7yuOJ9fxINIHEgO8X2Nf/xeA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db6d582e-f312-4347-9a5e-08d83aee126e
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:22:26.0819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NL63hu0oDLC6Gd5K5C0q+EsW26/jq1TLUW9PHxLBY/jvSFuqGNyGLihFO0MIN9gakneY2u+S56Wo04AVePo9EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Standardize the way input lengths equal to 0 are handled in all skcipher
algorithms. All the algorithms return 0 for input lengths equal to zero.

Cc: "Breno Leitão" <leitao@debian.org>
Cc: Nayna Jain <nayna@linux.ibm.com>
Cc: Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/vmx/aes_xts.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
index 9fee1b1532a4..33107c9e2656 100644
--- a/drivers/crypto/vmx/aes_xts.c
+++ b/drivers/crypto/vmx/aes_xts.c
@@ -84,6 +84,9 @@ static int p8_aes_xts_crypt(struct skcipher_request *req, int enc)
 	u8 tweak[AES_BLOCK_SIZE];
 	int ret;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (req->cryptlen < AES_BLOCK_SIZE)
 		return -EINVAL;
 
-- 
2.17.1

