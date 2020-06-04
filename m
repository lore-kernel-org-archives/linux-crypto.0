Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28945C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 10:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F357C206DC
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 10:08:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="eckZslun"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgFDKIz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 06:08:55 -0400
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:60230
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725959AbgFDKIy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 06:08:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhIqpc61G6tqNXyaVT9iY11p36J37BC2Gfc9zI1G4Vk2TQRQo72sYLU6NG7xWb4v+Fq7nKbyz/RGRVeNzqm5vVmKA0xJVXUY4sXNjckaHL6azl5A9yBfPFGfH5P2SWMFC5CC9HDGeJHkus81LxlrohkvR6YRYVl5nPDT1U+1mcQWxB2E0J54+ZhPMsIZ3jN3lWFF8hyU9MXqtpYE64/TTDbonoZQNNCsW+RHkAUssLX0UnmOo/8X2T+Mya356P0PXDUUwR7miasiS5UFeIATAZSn+CkMaQrSxe7+MM7FJmPzCf8DFtcnAAaif09QqZ1VJaG8uCv2grXeBQauIUSp+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Dx6eHFgLEKz6c2DfdVEKREvxnkKJ0UnI0oPUyhNqoI=;
 b=Iye2qljuMS/iW+1hfg8QBoamQ+TrB3iwEdn/aslYRmAqhbTX7Df3seKRa0kTAjxxnIo6bAK0ap2B04weWaQQioTMOK6MWd0zz51P6hc0CkebHBH2sMo1Vo0Qd5PbzVAwWnAbV6mSyKZcZTu6R+GpqcOyS4YXU3aQ1pQBaS8wLvB0+7Sb1CZVGjvGz+UcAdcf7FHtk7YMqTCcV4ho4APgIDVsPzPYlqj4BAyNoUuwX8HukDT8S9K/gvUAlg1QlxEOXy4r6v4+J5qwvDr023I5nVQ0lq4bws7JxQ5V2FelHIu2Qs9DZMrnkZc0Ft+OJ5KpdCWqTGfZvwVzM1PKWNEuJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Dx6eHFgLEKz6c2DfdVEKREvxnkKJ0UnI0oPUyhNqoI=;
 b=eckZslundbBBPlMMWaQZAfBluUi9XfNhIDTvVFDln66YPhUN21FLy5se512C3CWkrRUDmYSlO5sZKq473jv5hCxERMvzWIyQWHIjCW/w6tVPx1FfrWInx1/GAahcovvUjIBWOVeMkjDgy4Qz96d5eWu+cqRKeSQHw43aV2kiN9M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5711.eurprd04.prod.outlook.com (2603:10a6:803:e7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Thu, 4 Jun
 2020 10:08:46 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd%4]) with mapi id 15.20.3066.018; Thu, 4 Jun 2020
 10:08:46 +0000
Subject: Re: [PATCH 1/1] crypto: caam - fix typo
To:     Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200604024013.5669-1-xypron.glpk@gmx.de>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <d32a1b32-ce88-3286-4e6c-3280150f4d54@nxp.com>
Date:   Thu, 4 Jun 2020 13:08:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200604024013.5669-1-xypron.glpk@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::33) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4P190CA0023.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Thu, 4 Jun 2020 10:08:44 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 69f0d98c-afba-417c-d351-08d8086f449a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5711E9E2B34333FCC139751B98890@VI1PR04MB5711.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 04244E0DC5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GI25Hwp91gxhbxLTeB9dfJX7oIYFcqjfAe9cVz+oO5OwpgQHhzYW41k+2oPucjgfpDNJrJWQmCtnKpxAWWHMHVeXiuWX6+csj9yOPeKvo6FzX/lEcye3ZobiTexnqg/Bq2JTpZZSD55SRukdvIQN1+oxHTJGJuAfmuJ9jPFW39yPtZhimLtD3n62xFnHtWkOnOR6QDQozdqOTpwmELpfkskAJmuNOwUzmbwmykKxSWQRhUGTSvFXtNVTIGw8JiZdi6imTHWRStcj8aESITfYuq5Wj3H+a4eNcR+YcDzuC9BzUPZqHveYmCKU9ZZmkjwy7fIRTQZrnF213mqtDCb47NHKjXYq5ykIbmOAlYOiZmmy2XWLDjvYMk/UThNUr22W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(2616005)(6486002)(478600001)(66946007)(66556008)(86362001)(31696002)(31686004)(36756003)(956004)(66476007)(6636002)(2906002)(26005)(53546011)(16576012)(16526019)(5660300002)(52116002)(54906003)(186003)(4326008)(83380400001)(8676002)(316002)(110136005)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UdyOQlvbZ/H5tJjbSiNTm/NXJmqoej0bkB3L5aSVnDFT/0xElVLMia4A2bp+aqK9ti6MbWI5wx63ZbLTEGEw+BLbMiNnn0JrQh58qmHDUMFnDhec5nYM3IKsGPkZpA8yCTWEM4T1NpJpRKDicQv+rt3+Vl0vf7uJWAZhBK8ypXkIr6OZriGamZr1kItQlFp5EmUdyHsSeBZLImrXgDQaHQgmhIKQtecKXaej4RAKYEUPHNFPvZ9uiH+Oky1ZGl89hYQCmp/vh3mQHnyslG6TFt6/esJFi6ZcJMZZ4gINbb6W8x2fXH2u5Jppx7/nnfVIK9S5kagVAEVP6yklHiy/oXSkgot22UophRFQeo6XwdbwlDNX5Z6KJ0iukt8csyGySiP+XV4zk7nI2eSts9v1goAc7Z0H27T36u73DmFvlNwe6acexRccNdls/EbIVN3sTDyBrdS0GTqQ/WYdDKDSihtZnpLbGV03kinzaUiMtt5poV5t6Zf2bsqctd/yPysm
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f0d98c-afba-417c-d351-08d8086f449a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2020 10:08:46.1902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tuyLsOZzoRFn8nJqMabh9R1SE+sIE90ct6ctp6onsrGIVy0Xpb4CDDWZHXksRmkGC1znjYzX2snJ3gHLOOb9ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5711
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/4/2020 5:41 AM, Heinrich Schuchardt wrote:
> %s/suppying/supplying/
> 
This is good since it's not detected by the default kernel spellchecker.

Would you be willing to append also the detected typos?

CHECK: 'interrrupt' may be misspelled - perhaps 'interrupt'?
#57: FILE: drivers/crypto/caam/ctrl.c:57:
+                * resets the done interrrupt and returns the RNG to idle.

CHECK: 'occured' may be misspelled - perhaps 'occurred'?
#159: FILE: drivers/crypto/caam/ctrl.c:159:
+                * If an error occured in the descriptor, then

CHECK: 'aquired' may be misspelled - perhaps 'acquired'?
#267: FILE: drivers/crypto/caam/ctrl.c:267:
+ *           entropy being aquired.

CHECK: 'paramters' may be misspelled - perhaps 'parameters'?
#736: FILE: drivers/crypto/caam/ctrl.c:736:
+        *  Read the Compile Time paramters and SCFGR to determine

CHECK: 'modfiy' may be misspelled - perhaps 'modify'?
#866: FILE: drivers/crypto/caam/ctrl.c:866:
+                        * and the kick_trng(...) function will modfiy the

CHECK: 'sucessful' may be misspelled - perhaps 'successful'?
#868: FILE: drivers/crypto/caam/ctrl.c:868:
+                        * interval, leading to a sucessful initialization of

CHECK: 'Propogate' may be misspelled - perhaps 'Propagate'?
#116: FILE: drivers/crypto/caam/desc.h:116:
+/* Propogate DNR property to SharedDesc */

CHECK: 'defintions' may be misspelled - perhaps 'definitions'?
#456: FILE: drivers/crypto/caam/pdb.h:456:
+       u32 sgf_ln; /* Use DSA_PDB_ defintions per above */

Thanks,
Horia
