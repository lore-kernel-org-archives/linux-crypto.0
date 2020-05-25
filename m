Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2BFC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 20:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A66BD20776
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 20:07:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=silexinside.onmicrosoft.com header.i=@silexinside.onmicrosoft.com header.b="Fec02xZd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390708AbgEYUHE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 16:07:04 -0400
Received: from mail-db5eur03hn2211.outbound.protection.outlook.com ([52.100.12.211]:3649
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388794AbgEYUHD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 16:07:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfF9JXatG8F636xHE46X2rbbzRwYj5yxyo7iDxkiXMmqEKgq09QTsgt0vgQ6OVHI55QfkEk88aWIGM7TkMcer50QqELtiX6ZGagnFdv73sr0UvRftdM/L1RXm5qjwWDwyoxn8wPn6lY++8oHXuZTtePdp1TQsNatysKeAKkyfIT1HDsTpXKkgsqz0vFjldO23tOV+BRFlKK06C7RQ1xtlhMW50WSPqh92HIZQkf92ozmf505WRan9WaDt9m9t2woYZJVG2nicOiMeiRpkgEa4otv7B9w5m0jwb92ZclKiS2SrEh1f69o70e1leyny1Bik0/T1ua6rxlC1ayR22c/4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/pS1cIeIVfkEniXMCE/fhuUO2Qc8spGTHmgfh9zKaY=;
 b=ZbxnHa+ZNq1A0V5+3xjY3Bl2Pb3Uutbb6j6ofu+HLnwulu/tqYGxVviemL9G+izYui//PMYAlGYcmF/CxDSMzQIRLgbzKL1jkYaUqv3V9fV2KaA2XUifsVF+uFkbLC/Xl8iFL4EwKbEnDgHH8QUxhQY3v2LIbm7HZQxaTZFAq0e2KkzTGJumaRyM4lzddABHvSXrqLKU0ss0P5mIKeJRd1J+W2SGV83ZD0zzGy+CB+VmzNcs16G5yQKT73NL/mSBSi2AFjch/MNWufLF40AbhTOBH8WrJreP0f2AUhlIKdr1LdBmlpavAY5dtOY3c2BMQ2i+lvuX8IFiYCt9OynEug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silexinsight.com; dmarc=pass action=none
 header.from=silexinsight.com; dkim=pass header.d=silexinsight.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silexinside.onmicrosoft.com; s=selector2-silexinside-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/pS1cIeIVfkEniXMCE/fhuUO2Qc8spGTHmgfh9zKaY=;
 b=Fec02xZdfu+d+ySE4k1LBmDbazH3JN1Lz3vqCizz/UyxnS/rdpFkNY3K1kU3ziTYjCOcVaW1RQDvFyLmhP7cw42cmDiL1ZdZXy4wy9v0gYqdaMeUnvYzOeUigDNTwZLJXUGupTomcTfqtCVKL6J100nNFb/riugInJJahGOZmdk=
Authentication-Results: selenic.com; dkim=none (message not signed)
 header.d=none;selenic.com; dmarc=none action=none
 header.from=silexinsight.com;
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com (2603:10a6:20b:10d::15)
 by AM7PR09MB3735.eurprd09.prod.outlook.com (2603:10a6:20b:dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 20:06:58 +0000
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2]) by AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 20:06:58 +0000
From:   Olivier Sobrie <olivier.sobrie@silexinsight.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Olivier Sobrie <olivier.sobrie@silexinsight.com>,
        Waleed Ziad <waleed94ziad@gmail.com>,
        sebastien.rabou@silexinsight.com
Subject: [PATCH 0/3] hwrng: add support for Silex Insight BA431
Date:   Mon, 25 May 2020 21:56:03 +0200
Message-Id: <20200525195606.2941649-1-olivier.sobrie@silexinsight.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0072.eurprd04.prod.outlook.com
 (2603:10a6:208:1::49) To AM7PR09MB3621.eurprd09.prod.outlook.com
 (2603:10a6:20b:10d::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a02:a03f:a7df:f300:30f9:36cf:6713:51ae) by AM0PR04CA0072.eurprd04.prod.outlook.com (2603:10a6:208:1::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 20:06:58 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a02:a03f:a7df:f300:30f9:36cf:6713:51ae]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f19eab8d-3ad7-4a82-cc2b-08d800e72dfa
X-MS-TrafficTypeDiagnostic: AM7PR09MB3735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR09MB3735DB76BE43DB83F85425DFF4B30@AM7PR09MB3735.eurprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ThPY/RbO9T7swwQ8S5YnksqMdOkFrYI9NmePoR2b9ArXvlsVVEZlgfhRU/cUZZcSgZZBplRA1CLIcdCnK/3FpeuIhlnS6rirPgvtDH1HMMsilbRx9SnjLB9bpm6jjWODN3NxR6iEm588R4XOuhADJ4mvQMGo8flANfTdlhqz+uGs+9WRLqyOTma7O29y7lElMoOLqC4FOw49f8voX5EkmLPwZpgHNHuanRWmj5WEeI5um2jY6kaT5HK1+JRVi1hhRAwYhWG2V24pHzLp3kznRz2Vkjwz+DH3AvASsZz+4aLaQ5weNOTq5RVoLa1jrvxgHhN+cIWxhMerJ5A7QCQQh6HcimGW6tNDmpw1cx6r88D3+AxdMucMBnx5e3ksOI8Nww4/rIq6hVB58J8anlVa/C5f+X8PbBeYghj+m5dvLNQoEQWiRDe/e18spkm1/rZ5R3UUOLzWiIN3jjYfmS3SnC4ToUFIul41RZJlYFtFlHWNqpf0/Ot26/mJr+NVfZNpupCEyMA3UZygBIiE3Nsyo6XFfVOO7wLhN5s0fY/YuKGfWZNjBLWWUxIlhe9IuHEiFY9bF0QqxatXKgjWXlr0N7tpT7+XM2ra34kqThs4h9ONrtBn1rJcSzoGWbDWdN1vSTzZG+uSjqYxKPU9jzB8YqsSM8hT+mPltAoM3+ptz30lWNmLS9PSUyVsZ63k/fJZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM7PR09MB3621.eurprd09.prod.outlook.com;PTR:;CAT:OSPM;SFTY:;SFS:(396003)(39840400004)(136003)(376002)(346002)(366004)(186003)(16526019)(66556008)(52116002)(2616005)(2906002)(66476007)(6496006)(107886003)(44832011)(4744005)(66946007)(54906003)(110136005)(316002)(508600001)(6486002)(8936002)(36756003)(1076003)(6666004)(4326008)(5660300002)(8676002)(86362001)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: DvDAuYDoTRAEFxCwQCuFab1ms52vDM/DX/SrRTm9qRuDhIsIbJkmihm16pn/ZkHbH4vDGxmGbbP9b//ELtxhDjXX7eiXBVWPOeLBDFu0EkDFKb90YM2ik0sPgInwI4EBAVhGhYFChCacyWqoBrR+qmt71u7yJgksP4HTt6+9XR/xMmzpyvK5W/g1ANOxYpfMuQPETVdIRVKCn8XmO1AjES0s4jfjbEs2R7/5L/twgnFPJYcmHUfR2jlI5dFeVx263lPuGI0SZt2pPWMGSj46Eq+3Lh+XC5NZDrXeZU29ZZsJ4zIFs8feYfokHwRapQLjs9MtQiUr1JNxDFULlmM3UvSdxz4RldN3KipiYubWq/817ZMqJ+k6J4334n0CX/fdOjyTxKovgXQ2loiF2yKnYKQ/auT0DIxirnQ3ig1EC0R8/Lo8HVvH2WIW1Y+t1K8x0ppETDs5Tjl+WqjECxmdeFWx4SN2H+q1DjRtymp02jbZ3FvlwFRpd/eeOU9en6tutCw92Vbu+VpA55GWm+wLTLeHv+cuZ9VKiS7zXxlMAy4=
X-OriginatorOrg: silexinsight.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f19eab8d-3ad7-4a82-cc2b-08d800e72dfa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 20:06:58.3095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a02f6f9b-0f64-4420-b881-fca545d421d8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PxFiTZdtFwzTFiZF6WUO9JPzcM25JUa1Vzz25GnMjAAmOurYCgAmIlrGeX15JNz5FzJm9fhQlxDwngESuLpB6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR09MB3735
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello all,

This set of patches aims at introducing a linux hwrng driver for the
Silex Insight BA431 IP which is available for various FPGA.
This hardware is for instance present in Silex Insight Viper OEM boards.

The two first patches are documenting the device tree bindings.
The last one contains the BA431 hwrng driver.

Olivier Sobrie (3):
  dt-bindings: vendor-prefixes: Add Silex Insight vendor prefix
  dt-bindings: rng: document Silex Insight BA431 hwrng
  hwrng: ba431-rng: add support for BA431 hwrng

 .../bindings/rng/silex-insight,ba431-rng.yaml |  33 +++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 drivers/char/hw_random/Kconfig                |  10 +
 drivers/char/hw_random/Makefile               |   1 +
 drivers/char/hw_random/ba431-rng.c            | 241 ++++++++++++++++++
 5 files changed, 287 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml
 create mode 100644 drivers/char/hw_random/ba431-rng.c

-- 
2.26.2

