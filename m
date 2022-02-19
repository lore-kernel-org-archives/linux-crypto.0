Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC67C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Feb 2022 04:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241297AbiBSEIj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Feb 2022 23:08:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241293AbiBSEIh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Feb 2022 23:08:37 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08hn2220.outbound.protection.outlook.com [52.100.161.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A90255A1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Feb 2022 20:08:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5Pa6SmFX8SuUiZV6K6E5QtnAatnb5ONS6YXWhii+Ss9UIFhSsvnw9/b99D7syhClQlCV2Hh1Z9nP94d0I5d+XnHO5jEPgjrG46tLul2yJwyfXpKugiw8pJxZKXRu1df2zqFY01RuS2N/1pLPY23Q9L2Pw8Ngrr1j6vS21Yfa4R23V/sBq5nzVXGSLhFs5G8NpbzjODh/9pR9rygVjDCLTcZ5wpXWjduo2+kqOyzgfJyrc9aSMbHgbQYES+nc47I6rm5xYVlfFkRGCQNxIJ3Gw1hl4RgbkoEu7HdSHtvac6U5pE8CSVqeUB+/dgP4Cn5bAWMe8/1Y6F54DpTLlYMSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+iJiA0J6jviS6/j+q9zQZlf+odb/fFUug6nr0gp3M4=;
 b=nUFOVCV58ocKbDplSZl25BCuK+TwLJDA8BSvbNACANWzVo2uBE6KkfCGmLiEIxIjFLG0bByr9HI4qtEacMkUaFRtuMWYBLD4dznI5NTT3kJPGGb8RGumL3nrxjIa/jIrSjNe9d31gO6CiL/Owvgqvtphgsa0dT7pLJ8LrzD0BFGnqR8kjT2yM7JXety/aOjZHKT2L5yVOwNbdmcvmtE7XKexRht9EW4yGnVV6M0GvnxCqJlIb/UIxLDSZUJ0Zliz1vOhJ3CTErqthjePsUPwfk7lUZhG/NP4IFuCemzCwyN42Ukbw2CsVwXziAHuTT2itOB/OO0lcHIeX3S1ydjOwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 216.169.5.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=u-csd.com;
 dmarc=none action=none header.from=u-csd.com; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucsd4.onmicrosoft.com;
 s=selector1-ucsd4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+iJiA0J6jviS6/j+q9zQZlf+odb/fFUug6nr0gp3M4=;
 b=aFhnuicqGIUtMJsAzpJgAbFENaSM1i9Q/vUthbSi0/Gw8325Ibpw9lytBm6nRZSWpTnp9VNYOow5Qopc7LMAJcqRs807lcWmBk2i9NApLHx6Eg3NmXu1t+immjjdwpKdF8jMTbFMHDtPfKmDDZEIYYTYkH/JIf1bXEX+7SW4GOU=
Received: from BN6PR17CA0051.namprd17.prod.outlook.com (2603:10b6:405:75::40)
 by SJ0PR06MB7439.namprd06.prod.outlook.com (2603:10b6:a03:329::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Sat, 19 Feb
 2022 04:08:11 +0000
Received: from BN7NAM10FT004.eop-nam10.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::5d) by BN6PR17CA0051.outlook.office365.com
 (2603:10b6:405:75::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24 via Frontend
 Transport; Sat, 19 Feb 2022 04:08:11 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 216.169.5.195)
 smtp.mailfrom=u-csd.com; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=u-csd.com;
Received-SPF: Fail (protection.outlook.com: domain of u-csd.com does not
 designate 216.169.5.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.169.5.195; helo=UCSDEX1.u-csd.local;
Received: from UCSDEX1.u-csd.local (216.169.5.195) by
 BN7NAM10FT004.mail.protection.outlook.com (10.13.157.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.16 via Frontend Transport; Sat, 19 Feb 2022 04:08:11 +0000
Received: from UCSDEX1.u-csd.local (192.168.16.43) by UCSDEX1.u-csd.local
 (192.168.16.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Fri, 18 Feb
 2022 21:55:13 -0600
Received: from [199.231.186.244] (199.231.186.244) by UCSDEX1.u-csd.local
 (192.168.16.43) with Microsoft SMTP Server id 15.1.2375.18 via Frontend
 Transport; Fri, 18 Feb 2022 21:55:13 -0600
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: HI..
To:     <linux-crypto@vger.kernel.org>
From:   "Kristina Pia Johansson " <info@u-csd.com>
Date:   Fri, 18 Feb 2022 22:55:13 -0500
Reply-To: <piakjp2022@gmail.com>
Message-ID: <97655089-2c2c-4a5a-ba3e-5610343b9deb@UCSDEX1.u-csd.local>
X-CrossPremisesHeadersFilteredBySendConnector: UCSDEX1.u-csd.local
X-OrganizationHeadersPreserved: UCSDEX1.u-csd.local
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ceaf6839-ca0b-4501-a0bd-08d9f35d71ac
X-MS-TrafficTypeDiagnostic: SJ0PR06MB7439:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR06MB7439B7C0E7351313C93D97AF97389@SJ0PR06MB7439.namprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Forefront-Antispam-Report: CIP:216.169.5.195;CTRY:US;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:UCSDEX1.u-csd.local;PTR:InfoDomainNonexistent;CAT:OSPM;SFS:(13230001)(39860400002)(346002)(376002)(396003)(136003)(46966006)(36840700001)(40470700004)(8676002)(956004)(5660300002)(8936002)(4744005)(7116003)(86362001)(2906002)(31696002)(508600001)(31686004)(336012)(9686003)(186003)(26005)(6706004)(81166007)(36860700001)(3480700007)(47076005)(82740400003)(356005)(70206006)(70586007)(16576012)(316002)(2860700004)(6916009)(40480700001)(82310400004)(40460700003)(16900700008);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?69xTR+uWlIrfPs8nZo89GgqOXbsrEsBCKLJhNSdaDf/axRE1xYAEceRasa?=
 =?iso-8859-1?Q?1K8CzNCqycERzswdPSElTwjWylsmQG9LFIoLa+JoDGcnhXB9SCZ+DDHfvN?=
 =?iso-8859-1?Q?BCdhFxSgTcqTQKLJREYyCq1xMJbBaScID914tMkSgkoRKEbQIJ/sXLNzsd?=
 =?iso-8859-1?Q?rfZgA0qy3E07TsCTe0CX2V/dBJdG/kZdXPBMGKIfyd5/Ap9MsE0CxzbVGp?=
 =?iso-8859-1?Q?4XSbIEwpcRy6iLrz0c9xa545x6ZFmyzsuzZN/sucnS9sFggHPPnkCpXMB1?=
 =?iso-8859-1?Q?iS6n8YtoCSFfau0ypk8+9btrJ80KCtYwtkS1K3hAkfRUmT/A9sWRHim6iQ?=
 =?iso-8859-1?Q?9INbINaE44Vuu/9q9KPkfZSf8AOx9iwK7dSxhyl7ft71WFrH9OERWMCYcH?=
 =?iso-8859-1?Q?6+/Gxdf/lV3ALSjVoIw99QqfqM/K/Eyq/0CjXaCPqQJKtfvNOrG4Npc9ee?=
 =?iso-8859-1?Q?asvmNaZPfdfoSCcRhglyL+EWJuBM8vQ0n8my4E33oEWfC69U0PtAINkYGe?=
 =?iso-8859-1?Q?/JOThfuehcd2BRci+qMex0mqZGsCL1EZcpV9asxOz8COaXYuUAYIrsxZqG?=
 =?iso-8859-1?Q?Pn/qs6eYQ0vjwnajHyg7eko6ra1qsON1/Foi13J7INk8/2glPQHBTsqhgX?=
 =?iso-8859-1?Q?5EfZfrYpzUk4Sr8MGUZGxiuYVV7S3flTmPR27sd+RKjgQjoQgYqstjrd/E?=
 =?iso-8859-1?Q?wtcwQktQv9BZPltCZKYH5no6UL8khUilv9eaSaORa5vnQ1iRPMmltq1FgI?=
 =?iso-8859-1?Q?buipMqA5QiWZRi/5TND4a7CnGRAjv4djPUFM7gNaAGYY6Y7ej+QsXM7ct7?=
 =?iso-8859-1?Q?1JDMQuQxu0eTEGEjBF2Kfhlxc3gWMnNwNM+pvBj+WgUvmryDNydA1zcmoK?=
 =?iso-8859-1?Q?SbuSMcwfbpwMU2RBays4+usfnmw4IfSlJi+hByK9eDS1PTaveozWQuyk1k?=
 =?iso-8859-1?Q?+nBPNYW1bpBU+/kLiAh2Q0qU7UjIDC+QDTCsPDoZyMmQxP+uJQuhsXyd1m?=
 =?iso-8859-1?Q?L3x7rK946BRF8MbZu7JUNUkGAWms8dHoSFrbd01r8WJ3pHeZZcAX9yIqLH?=
 =?iso-8859-1?Q?dwKMhEs/bH3CohMoyVkhitY=3D?=
X-OriginatorOrg: u-csd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 04:08:11.3501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ceaf6839-ca0b-4501-a0bd-08d9f35d71ac
X-MS-Exchange-CrossTenant-Id: 663d4886-a028-4654-8be0-f6e600c88247
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=663d4886-a028-4654-8be0-f6e600c88247;Ip=[216.169.5.195];Helo=[UCSDEX1.u-csd.local]
X-MS-Exchange-CrossTenant-AuthSource: BN7NAM10FT004.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR06MB7439
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi

I hope that you are at your best and doing well. The purpose of this letter=
 is seeking for a pen pal like friendship and I'd love to and be honored to=
 be friends with you if you do not mind.. If the Idea sounds OK with you, j=
ust say yes and we can take it on from there. I look forward to hear hearin=
g from you.. My name is Kristina From Sweden 36 years , this will mean a lo=
t to me to hear back from you.

Warm Regards.

Kristina
