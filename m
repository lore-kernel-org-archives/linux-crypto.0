Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D25C00140
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Aug 2022 05:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiHHFiE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Aug 2022 01:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiHHFiC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Aug 2022 01:38:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2BF2670
        for <linux-crypto@vger.kernel.org>; Sun,  7 Aug 2022 22:38:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2VC+E5m/skrNlzsPiiFcsgZzUbNILJYiz9M/7WyYKhhG+KujyxsQjZE34w7J4G9dx92Xa6ziYcey2v6RbsiUaJnbcr7gLdXwxhcVfW1loGeDGiX/aTTQWPhGAi1kjD2BdrSpYOXojfSAJvkqukvEcZKsWUo6nQLs1fCtEOIzfak4b0FBpEI2mgGgK/gD/oVFb+9h65z46oUjaAghJ6BLDVhgqyBFEw143Aomkxh3ZiChq05Zi1pGPyHNKbpY7AbxW9fjFoqIWoJkVU9MxUG2vWWQ4yVh+5TmwGC5IuugAl80QoSV/6uppaP1WAsG+6Tvc7pAQ57Tf1JOd4OzUevCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QxNfODTwBL+NeM3fhmYlqdunEYJrMOeyELSQsxt1bVA=;
 b=eCrkwgjmztjApYUB4oMGb1RVlKAWXfJbxMO9yYu5yWDow3eEjUSVoQPq95k0EMxJWFvTM+pCzISRPLEhl1+JLCvIfoKmNolr9pcR4hXIdDCcZ6A66bQ8ucj/AofZ2rcWXQhJGaCYvRjdJxq0s4a5KhRWwtgpBQstP5bG4Fjs7g19AB0UDaH/Akz5FVXOzEKPBSdY0rhgcJ8zTGPe8OOzyKLoSjleiFvCNEa0l8hhovlPoEBCgSogvcFSLjmALPBD79UoYdR+75PezjpwxKlRHophXSH7j6Ko0QJVFlQBRk3E5rUwEwCvvkYNT14MJcQ55VgZLjwulvPJqg2yQ7w5hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.136.252.176) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=stryker.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=stryker.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stryker.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QxNfODTwBL+NeM3fhmYlqdunEYJrMOeyELSQsxt1bVA=;
 b=eduJXFkVRcQke5BL31D64Bvp9nz5cxVl7qAbgLQSS/33qk2H9wXJNs5TfR7zK5xJf048ufhS3TaxwRYf+VXs1sRUFGseg0zdZDL0y6zQ0QPz0RFf2nuhh3BrI940/Uh1vVCLT9Y7jW3B+c31//p2YxhxAGVbx21G0S03XKgMkaJBO9ufgsOM47SVg8KteCPPepShMz+ZNwSyDav+D7gyqTI1mQeGqLy4pdS3iUkq9fPanC95xHvhr8KBXina8XRGFQdqBtlnz0uxRWimHom85STLKzxSVMnPsx3pRrUZmFQIRuC/XLLu/nD6k+GgeVDcLo9iuuOpdNK5PMZ6icIuXw==
Received: from DS7PR06CA0033.namprd06.prod.outlook.com (2603:10b6:8:54::15) by
 DM6PR01MB3753.prod.exchangelabs.com (2603:10b6:5:8e::17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.18; Mon, 8 Aug 2022 05:37:58 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::e2) by DS7PR06CA0033.outlook.office365.com
 (2603:10b6:8:54::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Mon, 8 Aug 2022 05:37:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.136.252.176)
 smtp.mailfrom=stryker.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=stryker.com;
Received-SPF: Pass (protection.outlook.com: domain of stryker.com designates
 64.136.252.176 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.136.252.176; helo=kzoex10b.strykercorp.com; pr=C
Received: from kzoex10b.strykercorp.com (64.136.252.176) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5504.14 via Frontend Transport; Mon, 8 Aug 2022 05:37:58 +0000
Received: from bldsmtp01.strykercorp.com (10.50.110.114) by
 kzoex10b.strykercorp.com (10.60.0.53) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Aug 2022 01:37:57 -0400
Received: from bldwoapp11 ([192.168.131.10]) by bldsmtp01.strykercorp.com with
 Microsoft SMTPSVC(8.5.9600.16384);      Sun, 7 Aug 2022 23:37:53 -0600
MIME-Version: 1.0
From:   <noreply@stryker.com>
To:     <wos@stryker.com>
CC:     <linux-crypto@vger.kernel.org>
Date:   Mon, 8 Aug 2022 13:37:53 +0800
Subject: Der Ruckgang der Kryptowahrung macht Sie zum Milliardar
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Message-ID: <BLDSMTP01HL2bti2SbP00132163@bldsmtp01.strykercorp.com>
X-OriginalArrivalTime: 08 Aug 2022 05:37:53.0552 (UTC) FILETIME=[016E0900:01D8AAE9]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3c5fbfa-927e-4529-b8cb-08da79002711
X-MS-TrafficTypeDiagnostic: DM6PR01MB3753:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZTxnSr8uhg9pshWKSYq1JdEte8tJaxxIjzDwLmFUUn1KIDpSa2VCPqYeDgJD8NVewBTiLuOYkuAjg31w3Gh6BF+1Nx/IBFEMp7bRTH958+OM63i93kKiRw1iuLWHWmMiWF+tCPJdWIBNgBl/cLtzsyRHpNDy2oXeGXBTSll7mYY4TuzLMLDqt8dwyvUyVxnLz1bntl+tZ3/lxl1OdTpo8W/uvkQzOkA3gvEC5bkT3qhHnliPsv90fwzmnBpSIY0Z6936WFqxsBVtbtRFVdnDhiVUuVDwxWq+/vDEfbHg155BZtT6d0FntKgL5viAo2GTvqRWgPSV9lVGitErGPpIHT++V+r9Ls2XgH1RNyR+Sit6JOitDNdBc88S2hdPmoDVNmChlZsWayoqgt8YatHMpZBpzP2J9VEZEKwJPF7ymXXVo4C+KFkkeka1ooF54lgCpHqn+nDrUqPuFeBf2e1ylcjxwi4715Rf9hxVRX1GpfSNlsikX/HdYcWcUwVXMU02pjVWSzJNV6KZfohNNPX8cnLYgb7ApawXG3lLUJLH9xffJoYpcPMXylp9XtAMoAafHXkQanA3ZhK44JXOceC4Z2ZADFtRiDHOH7WdZMN+62AyYk0Y5CrkLb+mhxFoSH0ZrurWKtRNZCdoW74rmUjyujlDNb/5qsqW8vErTJYkQAcUdPc/pydPZXjKhYQiWH4yfInFvS5i3OrV61GYp+OvXTBYnET6hIpsGv5p3uZhJdmDQgF9fEBcPCVGmofK4QJkYccEp11B4Oo4yFEBUKdr0ApcCBk7kWSyx11SG7PawbOZXuKDZvrs06f2UZ4VBKYvjuOKmRJ88MZTA8WZQoFwxQ==
X-Forefront-Antispam-Report: CIP:64.136.252.176;CTRY:US;LANG:de;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:kzoex10b.strykercorp.com;PTR:ip176-252-136-64.static.ctstelecom.net;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(396003)(376002)(39860400002)(46966006)(40470700004)(36840700001)(70206006)(8676002)(4326008)(558084003)(40480700001)(2906002)(478600001)(6636002)(2876002)(316002)(966005)(5660300002)(40460700003)(8936002)(70586007)(6862004)(9686003)(36860700001)(41300700001)(356005)(26005)(186003)(336012)(47076005)(82310400005)(83380400001)(81166007)(86362001)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: stryker.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 05:37:58.7217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3c5fbfa-927e-4529-b8cb-08da79002711
X-MS-Exchange-CrossTenant-Id: 4e9dbbfb-394a-4583-8810-53f81f819e3b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4e9dbbfb-394a-4583-8810-53f81f819e3b;Ip=[64.136.252.176];Helo=[kzoex10b.strykercorp.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3753
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Der Ruckgang der Kryptowahrung macht Sie zum Millionar https://telegra.ph/D=
eutschland-hat-eine-neue-Einnahmequelle-von-479049-Euro-pro-Woche-08-07

Follow this link to read our Privacy Statement<https://www.stryker.com/cont=
ent/stryker/gb/en/legal/global-policy-statement.html/>
