Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D7AC18E5B
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 11:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09D6E205ED
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 11:16:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Qh461vG+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgCQLQK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 07:16:10 -0400
Received: from mail-am6eur05on2086.outbound.protection.outlook.com ([40.107.22.86]:14145
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727972AbgCQLQJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 07:16:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1cRa+d3TORftexyCHyPPzRQKgOxSBT3WNJFjAnwV9+dPbL8zurcyHKTupsPf6SKjf107XOxCJHJKXxCgW+ZKpMdrP5zj+BdGmxMhHOuq5UJ73yM5wzOY7e5xNhP7k6o52lp+MJtLaq0w/eKVRNsZeqpgJqB3Wn9sc8OFNr+RHq1xpf+OJE7WslL9Uxlv/aBOH8VLPmphfEH+7tuRlN2zfF7PPum5azB7PyhNLM0vJ3IkRKXHf53vcqL/WLgUiPJw+9ctcCBRRf6JBvfH+PvmTg+W56A1dGY0j61b4kv736kw5klEr3w9lOugWAbnQOzwMFY0lYjEd4UOE+S8c+5Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmeRkQuCq9+A+TIda6mzShgBGTQl68Lo/ND2lXY/xhg=;
 b=Imeav3lkBiFQxXl91Sn0S8UK5NPycL9KLKPjAHUP75rVEr0U6qrv0g3DoPoDA80iKU4HtPPT7+xhe/AmEwiU5bAmUMjEz3u4ATqPSZ9wDUvGt9nfExRkuZq7yXvkpSsdlVXbdkEO9cAgeCj/4Lb6vCZuESUAO35cV0Lw5JfD38mmFWTpFEYyJnJ/nNTUhPTUoyXVPO1kVUCm4tBf2uKDrK1LejcWZ5LJikAZ4gJAKqwK3Oyu8cS7sff0tMic1XMkXeWBUegw7blX5MnlrcqUCbRjUHxTfhEDaCPoJwNdJ3zLCfaZ0QkMkfiJPB/ew4OlE97uW/qAJrjPOTGsTKKWvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmeRkQuCq9+A+TIda6mzShgBGTQl68Lo/ND2lXY/xhg=;
 b=Qh461vG+YsxPUH0CxSnr5gXHN+4LZWBgAEYb3OZ+C80QrXJCm1dNa6sg1H9+WIB3+KEbe+4/WEbrlrz1RXgIbUaoe8ASoDomAHemXrCwY7bDS1eLp9qlNzc9ElMU6JyrUQXjEEUS4s4QQA/LEGI9FWdVMES9JHgG0Vb1n6HuKKg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3373.eurprd04.prod.outlook.com (52.134.5.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Tue, 17 Mar 2020 11:16:05 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 11:16:04 +0000
Subject: Re: [PATCH v8 0/8] enable CAAM's HWRNG as default
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <1a416e7c-3175-6e42-5034-1228e99b283f@nxp.com>
Date:   Tue, 17 Mar 2020 13:16:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200316150047.30828-1-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0006.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::16) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR10CA0006.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18 via Frontend Transport; Tue, 17 Mar 2020 11:16:03 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ebe45fb-bdcd-463e-9803-08d7ca649523
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3373:|VI1PR0402MB3373:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB337332CE74DDE6520D8F587498F60@VI1PR0402MB3373.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(136003)(366004)(396003)(376002)(199004)(26005)(186003)(8936002)(16526019)(8676002)(81156014)(45080400002)(2906002)(81166006)(66476007)(5660300002)(31686004)(66946007)(66556008)(4744005)(6486002)(31696002)(53546011)(52116002)(966005)(478600001)(86362001)(316002)(54906003)(2616005)(4326008)(16576012)(956004)(36756003)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3373;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vl0jT9wTDgfQd00hOnZwoZ2qr6rmm2dKDcwUssiWvpre000Hxd3pjjxbSvFhVXC1XYWMA2wSIsZXj+G3rVpCS6sj6bhTB0scfwhDoS/Lr/1G/VGblhv0AqmYYgxk3siA9MNJmFlBZnlc1SswwMmI86A2I0ESSBBNj1BdNDGNxL4mFWEjB06M1rOJVFAYWIl9GIMYc8Lz1S8SqTKClT4MkoehCgmqALzVV95A9YaTUtwmkIBv5Ep8wUkX3XldtsQtnxYA6Slss7UhpkX1gXyZaSdiqV9EY+sPdiMpV+aj3ZLRS5a2OLnY4JjM5pnpKjIZLCcFt15ay7X9qPMg7Fr7H5TKJzKasfpa/5T45JUIEvxXHj2mQd+iHyCrHqYceeTIIppvpQBiOssr+WBbbQl+x5sUyQKb9P1bbxmlhZd4tX5uMFGFLVtgPpP6neAKP1pg19kY/tx/HdXbPCvGK1CXDoLa8wq6qC4rIg4IwGrEAV1jbVd1XLer5sYcwo+JGRIiQRz8bsMvnFe7uNwbDd0i6g==
X-MS-Exchange-AntiSpam-MessageData: AE6QyhJXZ6c+iizLrosSSlXpVq+AKSWPtBt97LlQJK29g5Nq4nuwLGyITdxMfXCwhsyXiEFy3rMLQbN7JcfwKFOPT3XxyWv++XNrAoAD3GeR2D6Eh3T4cyxM4o+//1+BvIXnrsSCBn0yzPM5b2+1GA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ebe45fb-bdcd-463e-9803-08d7ca649523
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 11:16:04.7510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmyH0yxwAFvAjlhudT/U5PAp2CQbxCXbEsOH0EhM7bCrE9oOA7i+8vdCRi74vRpLtQLjSzBfEmDPca/Nm1RVUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3373
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/16/2020 5:01 PM, Andrey Smirnov wrote:
> Feedback is welcome!
> 
The patch set does not compile.

Patch "bus: fsl-mc: add api to retrieve mc version"
https://patchwork.kernel.org/patch/11352493/
was not applied, the plan being to merge it via cryptodev-2.6 tree,
see my comment here:
https://lore.kernel.org/linux-arm-kernel/VI1PR0402MB3485DB40CE1C1631D920EE7598040@VI1PR0402MB3485.eurprd04.prod.outlook.com/

I think it needs to be formally included in the patch set.

Thanks,
Horia
