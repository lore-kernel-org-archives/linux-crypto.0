Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F482C32771
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 12:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FFA92067D
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 12:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="XA3EX7Mr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgAIMx4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 07:53:56 -0500
Received: from mail-bn8nam11on2087.outbound.protection.outlook.com ([40.107.236.87]:6054
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728298AbgAIMx4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 07:53:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJuyg9B+36xEC/TdSMZt/ObeoI8rDaNZKYH13KtZlPm0I0rqk/NY3EU2QT55+p3v2rET7AkXvurtEaXB39TQtdepd9O+sQe8hcYlDneosTO/VNRAHr8e/i/qpqTgciKYjblHT4BWVhXQm59F3k1kWy8orbPWUlHz3EPOOAXu9rgyQcOgFpKramOy3suVAuLXexjmnz7TKZkM8Z7Bdusbyu6e5e6vBGUYYi8DwcoAb/F6IFnlpuemgBuhZv1Kzuk/0/qAIJaNLHUMmmKKB12DsqadXVOaicHzgMh2WlShd/NyORX4eHNYNsLYeCmAiAoOokQBYdg0IPJvE6Czt6YVFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msmWI0+gsNGx4byDCTESAIsEz4PuI7X501afLIUfC0c=;
 b=kb1QM+rAkV2c3KMQA6RtTkTvtfnyMmCNjsxn7SvWrXPw7NXL6YJAJAy3TPcPxWGx0aaHGSke6kS9434Bz0GetzOCLF4f4pKlbT58838VXXCo23EtckOlXQRIH1At5DWCvCkcBHMcqqco4wgXbWt8jQ8FIqARPeC8C2vwajSW4HtROgdvq/kWOXqtRnvZ751MDsVRDtWvbyzgBDixCPvsvY4iFAsQn12BfYekhrEmHZs/D23MiXUEzMVy+ncYrPWk1xlFefN79Vfzc4s9NcYBhQhCz8q2bKT9PrE3CJNEw0BWRLTTf/EgYNVVJBUpjeVHHsbeRj05Net1N9ywjuyoZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msmWI0+gsNGx4byDCTESAIsEz4PuI7X501afLIUfC0c=;
 b=XA3EX7Mr8y4NTdZDNPMATic9YmeFoVOikotRDTedva5CzzgkhdlxyC7Wwoa+W+OM0RfcLBuMhkHHcb0jWueNTD+VhRNjZ/AbEpYelj0swpA17wpdcG6v736Gv66XwzVs6CMB2ZtV5fWT1KVXR/1apdaij2S2P5DfIZ26QtH/VRg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1206.namprd12.prod.outlook.com (10.168.166.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 9 Jan 2020 12:53:53 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2602.018; Thu, 9 Jan 2020
 12:53:53 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Jens Wiklander <jens.wiklander@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary R Hook <gary.hook@amd.com>, tee-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 0/5] amdtee: Address bug report
Date:   Thu,  9 Jan 2020 18:23:17 +0530
Message-Id: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::13) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from andbang5.amd.com (165.204.156.251) by MA1PR01CA0119.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Thu, 9 Jan 2020 12:53:50 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 440cc282-9d6b-49d3-7199-08d79502fb08
X-MS-TrafficTypeDiagnostic: CY4PR12MB1206:|CY4PR12MB1206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1206779E629AEC58EC3D27E4CF390@CY4PR12MB1206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 02778BF158
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(376002)(396003)(39860400002)(189003)(199004)(6486002)(478600001)(4326008)(5660300002)(26005)(2906002)(7696005)(110136005)(54906003)(4744005)(36756003)(6666004)(86362001)(966005)(52116002)(16526019)(66946007)(186003)(66556008)(66476007)(81156014)(8676002)(956004)(2616005)(81166006)(8936002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1206;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MK0WzNQcs0VDv9swOd+IKeyctgYThE5BIYjJiOQn6nCb6OICe0Q1bFh1tX61KfePxojrj6wGfFrVArxUelOA3a4KG/5IK2VdxyTFL84cbHvC0vMQiGyalM9Gd51N5qLAA6weNRVBMSKqyhyiePcpD13528VCBsBCtQydpsXtFMSvGvZJ26TQT6879Z8MxWt2XoK1kIYJfVwtQHfVtkt6U6e9diRmz64kkotz38Tovo20oBF+ibYjsfB3BRZVdzz9tyzP2dIGVu5RFNGzS2pcZa48kJ3dRuA2S4NWqaTdH0NkulLANI6LiTYKlywTsTcmqEMk54H3FiWrj9VntO7b18Ox4LCDcZp/HzLXxCr39cQaQo55TznsbjAhZmaOWY3TL6a5gv+DtA3RGa+6fBYr2Lvfti1Mbh86CxZ3GjFbjumCvlecbCUUsIL1M7l9Qb9QLaizNtchXd8q4vWp0zYt4jKu2mOanoaPZIvMjiU/ClHHvMmSBkJ15QlxyrSN4Mp6XRanyq2Zr9q8pUifbz8ySw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 440cc282-9d6b-49d3-7199-08d79502fb08
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2020 12:53:53.4690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0F7yPV0I5dDP+0usXlYNGJkUcER1AhulpyMHd0d0PHxJv89YEzGDOq8J/JaFQ8zaHVri3V36WizPF2l4CKcwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1206
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch series addresses the bug report submitted by Dan Carpenter.

Link: https://lists.linaro.org/pipermail/tee-dev/2020-January/001417.html

Since, these patches are based on cryptodev-2.6 tree, I have included
linux-crypto list as well.

This patch series does not fix the static checker warning reported due
to incorrect use of IS_ERR. Colin Ian King has submitted a fix for this
issue. Link: https://lkml.org/lkml/2020/1/8/88

Rijo Thomas (5):
  tee: amdtee: remove unused variable initialization
  tee: amdtee: print error message if tee not present
  tee: amdtee: skip tee_device_unregister if tee_device_alloc fails
  tee: amdtee: rename err label to err_device_unregister
  tee: amdtee: remove redundant NULL check for pool

 drivers/tee/amdtee/call.c | 14 +++++++-------
 drivers/tee/amdtee/core.c | 32 +++++++++++++++++---------------
 2 files changed, 24 insertions(+), 22 deletions(-)

--
2.17.1

