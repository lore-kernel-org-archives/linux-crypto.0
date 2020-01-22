Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06843C32771
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 07:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2AF92465B
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 07:00:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="Xv6tVMiS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgAVHAF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 02:00:05 -0500
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:38113
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725877AbgAVHAE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 02:00:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ML/dyqqTPpYh6eqwroogjhi5aLHkJbuSSKVESu/+61Ing1RRDUsXXCBI3jqu2rB5bgzixlUadn+6tvP09dukUFVDawaKo7GLbYA1rwXdLXMlWRUfNCSJluI97QsE8WMAoId1Yv1OaShrdS6KF3nRDcPxwpBy85dXWgGP3ebRxmZPNG107gIj01EE/PXxBYKCy2ASAZtsMdSxglzwQo4ZnvjUwwW3bM3MoWlgfPFkTe5rXDSj6xIh8ghSF9zWggvClNYZSnJJp44E6r8Z9XiSfqZ/JKsHpy0e2sqYmlFpXchKJN+NpokG1dtWvMKsyy+wcm5crwAXG8xNW06iJZqJbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bFSQwCyT0Dsibdo/OdwluZZbaYQTX8No6lMvcBCbOI=;
 b=e8dWJX9rGdSqPi9he92hfdOCeBMN7MFrdL0IoIX6X7MBhvT078GlhvNgE2l1yfuMy/iOO9muxNE1SuW95Y2Iax9L8qQnrHyHUASmm+zigYng27jAzTMgpJpzDmsD4weqMn9oBSjSHh0LQ2rxvNbzCt/++KxwP4P50b1iCaJPe3Aar8t6TvhWMLyy4DxlQe7FCN/PzjoLCjDH5tDhDIozYV4g+i5/4atzXfcqFOnGYsIi2kzdgFqWWzpso+cEteGlA0CFAp9XF6sXOEuN0kducZnheYmtVT3HFU3cA06iG4X/W9Sbn0QBj8sPI47LDnrPmPpcWqX3VOd8THIYpbrLrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=xilinx.com; dmarc=bestguesspass action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bFSQwCyT0Dsibdo/OdwluZZbaYQTX8No6lMvcBCbOI=;
 b=Xv6tVMiSD+67TdRC9Tcy3NzRfaMSjEcZ1MOugQOBODVT2HnJqu8+OijWqTPpkucZ86S1WvpsmrrsloewFswhJbOjXSWA2lEwhXLFs1NwgkqDDKZbEWN17N5KbC5NQVnUINbJiq2ipG62rVFS5mQGQud1L7sk3WXbMaskIRGplRQ=
Received: from BL0PR02CA0094.namprd02.prod.outlook.com (2603:10b6:208:51::35)
 by BYAPR02MB5958.namprd02.prod.outlook.com (2603:10b6:a03:125::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18; Wed, 22 Jan
 2020 07:00:00 +0000
Received: from CY1NAM02FT037.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::206) by BL0PR02CA0094.outlook.office365.com
 (2603:10b6:208:51::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.21 via Frontend
 Transport; Wed, 22 Jan 2020 07:00:00 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT037.mail.protection.outlook.com (10.152.75.77) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Wed, 22 Jan 2020 06:59:59 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iu9za-00017Y-Sb; Tue, 21 Jan 2020 22:59:58 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iu9zV-0003cz-OV; Tue, 21 Jan 2020 22:59:53 -0800
Received: from xsj-pvapsmtp01 (mailman.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00M6xpVj005378;
        Tue, 21 Jan 2020 22:59:51 -0800
Received: from [172.30.17.107]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1iu9zS-0003be-UD; Tue, 21 Jan 2020 22:59:51 -0800
Subject: Re: [PATCH V4 0/4] Add Xilinx's ZynqMP AES-GCM driver support
To:     Herbert Xu <herbert@gondor.apana.org.au>, monstr@monstr.eu
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>, Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>
References: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
 <BN7PR02MB51241CCD25BD1269B4394D9AAF320@BN7PR02MB5124.namprd02.prod.outlook.com>
 <20200120075559.kra4dqdphbbnid5h@gondor.apana.org.au>
 <1abdf222-9517-976e-b3d3-bfc1c92c4663@seznam.cz>
 <20200122055111.azr7zzhredywyusx@gondor.apana.org.au>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <7de607d1-e41a-724b-7fd6-714b5dda9384@xilinx.com>
Date:   Wed, 22 Jan 2020 07:59:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122055111.azr7zzhredywyusx@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39860400002)(199004)(189003)(356004)(70586007)(9786002)(4744005)(478600001)(31686004)(2906002)(186003)(70206006)(6666004)(26005)(44832011)(81166006)(81156014)(8936002)(4326008)(54906003)(8676002)(426003)(2616005)(31696002)(316002)(5660300002)(36756003)(107886003)(336012);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB5958;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c532f94-8a45-48ad-08e0-08d79f08b23f
X-MS-TrafficTypeDiagnostic: BYAPR02MB5958:
X-LD-Processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
X-Microsoft-Antispam-PRVS: <BYAPR02MB59589EAA3D31E1BE094DE877C60C0@BYAPR02MB5958.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 029097202E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WbNXeUgqrtzrdzQYkP05boBUH6idShcZSBC83qKZ5sAcZzNAT9wyOCRbwvV5dhTWq8ioTvN5JTChwOxVxM2qzwOrcDXCzW2gXrgSXw373aZFi/XCz8emRs36B6DT49BQj05tJ9fTNTY8dwLF55QCHF8CptpkVDuL5vv8MlQM7WfZ9L2XWZZMqIvNECgexXJrfDjT/+PLhdUCMgfDh+vF7u5BFWePOkgblLQ90IbTquwVrhXWZ1AvcohfJo4vdzCGk85043+eJXpBpaEwpVTRhUboe8bDfdeSkVtBsPAcj9K28HgAtph/WvQh5NxNYcdWFgaNvysIxRaJ3ldCy2BQg9kRYTo1AEq7BV3oVnnxxvETsB1nEoC783TxgD+cw9I1l7oggc2YcUKpmGEFSi4j7ABkVT+AYd+m7+cvh/t5X/+rO0d1A5KCcwpEx0dj7Lkx
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2020 06:59:59.3963
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c532f94-8a45-48ad-08e0-08d79f08b23f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5958
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22. 01. 20 6:51, Herbert Xu wrote:
> On Tue, Jan 21, 2020 at 10:26:07AM +0100, Michal Simek wrote:
>>
>> All these drivers which requires firmware interface extension can be
>> added via your tree or I can take them via arm-soc tree with your ack.
>>
>> It is really up to you. I am happy to just ack patches out of crypto and
>> feel free to take them via your tree.
>> Or please let me know when you are done with review and I will take them.
> 
> Thanks Michal. If you could ack them once they've been resubmitted
> then I can just take them via the cryptodev tree.

Great.
Michal
