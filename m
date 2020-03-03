Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F880C3F2D7
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 13:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45FE420675
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 13:57:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="tUbLKn1N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgCCN56 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 08:57:58 -0500
Received: from mail-co1nam11on2088.outbound.protection.outlook.com ([40.107.220.88]:6191
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727175AbgCCN55 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 08:57:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrYSuGfl2xvDqLt6Xdg/4UbtEuHWt2ZkYk2CsdHkpSs3MJuKKI5n6MPiQQSzvwwRuj3Ugb8ORpDHgNfHRlFiPJkuRYFvHzwS4++m8oKXSve629fBHO9qiTNlWfZ4UH0RFh+RkkSo+WOtxYHqowIXWQdYyeFtz/KTiK31iOZ+MeQrRpJahxKgmxPpOJB84qAKubA8jGxhdViDN4vAonCOYQWPCjfHom5EgJJ6FdD3LBH9vEzLPU/CzxSm3wXSL0APsZIW6I12Sroh4oZE7HB4uI1Uyhom3try+5U+ENUsXrw0tIFxJy9NVeGrZY1vG0nTAC5BqEVo66DgkGphfyqyuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZMWb7Eq4ivM9vyllqWft4rmA4RrCkNSa+MXkv+okm8=;
 b=LhBKOCohxNLp8+/NTg4ClFWtB0Gcq/qxAg4/QnGyy203TRz2MSorIBKG/NpePYn9iEwQLDNhc5cDbhO/V8eqWb7rcbZ2GPRXOC0baJ6VzskN8Y+ylQq+hKk99cDpvs1X9aZgWbUdaktbW5loQ5FoM7IJEklw2a2Zz7AI9ytWscd9KcCdHO5eUeNn1O0+KHxjKandJcUJ3E9pvKrv0DKQaHxfXSfOdMAjTpZqlX/JiLlN3ojULAXS3l4ivAomjerQlIIMeofk9g/DFevNIwJ2f/39KP/wZ5FgdNPotbeLj3B2z4Fxk6gvwiI/Ddf5AJQml19FY+P6gbEvmF/eBoTz6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZMWb7Eq4ivM9vyllqWft4rmA4RrCkNSa+MXkv+okm8=;
 b=tUbLKn1N3tmeYyFpzhesRSJdfolJ2MoFaFD+4EnCVCoUnXNup8+7crvsHGa7BAOeKYuwRpMDM1Ea+rXVTYXjmZioLkl5KHVddQJNTqC/qvjfovTQbd1lF21NlF7rXWVNLGl9q1BOE0+fHJHdOaRPe0TA7LNAxhkRQJIJcZk9xa0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=John.Allen@amd.com; 
Received: from SN1PR12MB2448.namprd12.prod.outlook.com (2603:10b6:802:28::23)
 by SN1PR12MB2414.namprd12.prod.outlook.com (2603:10b6:802:2e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Tue, 3 Mar
 2020 13:57:52 +0000
Received: from SN1PR12MB2448.namprd12.prod.outlook.com
 ([fe80::4064:dc7:d9b9:1f64]) by SN1PR12MB2448.namprd12.prod.outlook.com
 ([fe80::4064:dc7:d9b9:1f64%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 13:57:52 +0000
From:   John Allen <john.allen@amd.com>
To:     linux-crypto@vger.kernel.org
Cc:     thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, brijesh.singh@amd.com, bp@suse.de,
        linux-kernel@vger.kernel.org, John Allen <john.allen@amd.com>
Subject: [PATCH 0/2] crypto/ccp: Properly NULL variables on sev exit             
Date:   Tue,  3 Mar 2020 07:57:22 -0600
Message-Id: <20200303135724.14060-1-john.allen@amd.com>
X-Mailer: git-send-email 2.24.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0060.namprd07.prod.outlook.com
 (2603:10b6:4:ad::25) To SN1PR12MB2448.namprd12.prod.outlook.com
 (2603:10b6:802:28::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mojo.amd.com (165.204.77.1) by DM5PR07CA0060.namprd07.prod.outlook.com (2603:10b6:4:ad::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Tue, 3 Mar 2020 13:57:51 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5ec9ade6-b7f3-45c3-f8c4-08d7bf7add8c
X-MS-TrafficTypeDiagnostic: SN1PR12MB2414:|SN1PR12MB2414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2414CDD5CC2439EE5C36A8DD9AE40@SN1PR12MB2414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:108;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(189003)(199004)(478600001)(26005)(6486002)(4326008)(8676002)(81166006)(36756003)(8936002)(16526019)(6666004)(52116002)(7696005)(44832011)(86362001)(186003)(81156014)(316002)(1076003)(2616005)(66476007)(956004)(4744005)(66556008)(66946007)(5660300002)(2906002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2414;H:SN1PR12MB2448.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mba8QG9IdaxnGZmtrd+3QvcpAa9p1Oi8+C0OovHsSRzpFJO41s1Id2Maei3y+4HldqsBeRMHVkf4RrIkoS4odSw5fv9dfF9kf9u/KU/0TUl+IQJOQ2+fgQZhr2Q15WB1SPk5ZAKRcIAOIN3qXOkzMNCR7rovbHABDutTQvLuMLWcelUlLoUX0iqO5s5BIDxn2gBlkadbMXfxsSq9dlIZaVmSRKFSLfTFTj2QOTYbCRYwl+8ag4UY/IBWdVLZFtCd1cdUmnZnHwc0O9Eng4O/JQqyyVwPLD80tkwkdZtlNMRsdJAHKnXif0ozqo7/O2WiJ7Qn3euoU2Na+ILS+4luUB+ewBBKuYGDbsxMuaELBtGwFdANcZ+QGi1V0RzKMt5wspsxH0tnH2B+BI8WOE/zZHkA84CBtvxU2iUEGsDyunPVhhyBKkq+zuCdRuCmUvFy
X-MS-Exchange-AntiSpam-MessageData: sIvPPNfk790tWLzKGmCaJdxQlaOiDJg8bpF8znIrvBzZqVZWdyRm6rqlkJAWTiZLnOfEiGcVw1LQaDudHgcrk1GqZ2ljjIQyZ4ZRWrGTSY/Keb1wfT21cPWs3JAPjstiD8BmJIpM160vl5kO7H2mlw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec9ade6-b7f3-45c3-f8c4-08d7bf7add8c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 13:57:52.3121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o/vy80V9BSsIguW9t81/T7VhVrS8mB5SnHNGxkR3/Oy6C8sq/UKJMST1pHOYtxTdOu5JHaBUl3f74da/h4arWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2414
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Stale pointers left in static variables misc_dev and sp_dev_master will
trigger use-after-free error when DEBUG_TEST_DRIVER_REMOVE is configured.
                                                                                 
John Allen (2):
  crypto/ccp: Cleanup misc_dev on sev exit
  crypto/ccp: Cleanup sp_dev_master on psp device destroy

 drivers/crypto/ccp/psp-dev.c | 3 +++
 drivers/crypto/ccp/sev-dev.c | 6 +++---
 drivers/crypto/ccp/sp-dev.h  | 1 +
 drivers/crypto/ccp/sp-pci.c  | 9 +++++++++
 4 files changed, 16 insertions(+), 3 deletions(-)

-- 
2.18.2

