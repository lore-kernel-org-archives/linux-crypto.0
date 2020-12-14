Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A3EC4361B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 17:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DA9422516
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 17:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408494AbgLNRXA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 12:23:00 -0500
Received: from mail-eopbgr150074.outbound.protection.outlook.com ([40.107.15.74]:49638
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731155AbgLNRW6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 12:22:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iw48XYHBSIBt4EN89I7Nc4OIK6CmVgpCgbyab0FLwbzlWOQdzaw1EBcEhbsQyamvk/XEg30ksOHrNFtBRcVMH/4NvduEWo3oPkliyKqdP4Wz56DE8hoIJDlhe8eMPuTV3bxtSEB/dkhyDD0e8W/YUbnBmKapGLhfrb2Z3tF1EEIRWbLa1LY6sXaEMQEcluY2H0cevEBuFhloQFtOVU/EuOgbFZ/cHRtgO0/VRzMdB7hbbjcMVkjjdApezjumxeamBwVktnTtAknetyQTJaV2ORtLf1TcCiIQTC3L9ghERMGS8ZWj/7nAYCdy9wGu1dCIgojVgWGrDKALxPz+pHwpsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTLzy8gONeK/8vYNzbP/j24HlnaDGgi4C83ygjcFz1U=;
 b=O5XUF76WW4VMc4Fojx43sCLCz0a8GbB5GrraYRb9+lPLvjLP5uap1JjmLEydY5+OojbwvleWIc9nJqDfqhXXPKAazcBwi4QukNyZuQR5WEZ55kkDT/jeOdbXn7ms5VjnYDi32pLRermvaptaG3wN2HTURVuydLWqWsxtX8QkvYQS+rSgkW355sNL9i6HBYFJaCZbGdCmqjCsqo1f8YWjSc+vtfJXJ70Nd4yHceEtrqcodB+7E18v69It7WXvTnOkMoIMJYL1RgsCUNILiM7Z7c7uZgZQhnto9DOoGFKhMaJuwXitd5xNNOwkSvUX/l+RC05V8ulOLPN48W6018A+Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTLzy8gONeK/8vYNzbP/j24HlnaDGgi4C83ygjcFz1U=;
 b=oE7kTvgXWmS6QEiPTEorzS94T8yYKG0jyNRZTxQ4iUwY89ekIBV3hY0eIk90oExzrKPkhWfwJDbdKSO65QwhZyloijqGDtTcHMIzThAPd7O+XM6gEnQF5pRMoF3j/n+4Ns5AtZ2dznTFHNi5v+z5Kkfmslg1ucCnJVMAZ+Tp/GM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0402MB3952.eurprd04.prod.outlook.com (2603:10a6:803:1c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Mon, 14 Dec
 2020 17:21:57 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3cd1:fe15:f8d4:ac32]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3cd1:fe15:f8d4:ac32%5]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 17:21:57 +0000
Subject: Re: [RESEND 04/19] crypto: caam: convert tasklets to use new
 tasklet_setup() API
To:     Allen Pais <allen.lkml@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "lars.persson@axis.com" <lars.persson@axis.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "bbrezillon@kernel.org" <bbrezillon@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "schalla@marvell.com" <schalla@marvell.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "krzk@kernel.org" <krzk@kernel.org>, "vz@mleia.com" <vz@mleia.com>,
        "k.konieczny@samsung.com" <k.konieczny@samsung.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Allen Pais <apais@microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
References: <20201207085931.661267-1-allen.lkml@gmail.com>
 <20201207085931.661267-5-allen.lkml@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <be826ecf-82ac-948a-035c-b97133070ca8@nxp.com>
Date:   Mon, 14 Dec 2020 19:21:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
In-Reply-To: <20201207085931.661267-5-allen.lkml@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM4PR07CA0026.eurprd07.prod.outlook.com
 (2603:10a6:205:1::39) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM4PR07CA0026.eurprd07.prod.outlook.com (2603:10a6:205:1::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.12 via Frontend Transport; Mon, 14 Dec 2020 17:21:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1d5ee8fa-2c34-4868-6741-08d8a054c263
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3952:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3952971A33ED283EB5A5E98698C70@VI1PR0402MB3952.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4GEdDTbFh3bA9yHz4UHTDF1ZHq+vjP7anGVWlFKqs96RATviQcEULlewBBLoZbKEvHkH5zgMh1NY3EW8YGVL+/Du3u7CMQGBLnIJiw7Z0DtGdbvFySD1u/j2vHqKJmr8oGE18WNV6yVOuOSkRHh4DbGpjxbaaeubf1iJ2z7taAJTI1bL/N7fGaDZfs+p6dEb/N3+marc8ROp071R02ozItsCWQ4rzCFQkhgajcTKVYO+BnZ6wP2zpJia7TkW5/rEo3mkqKfICCks6/BYFGOrrI0ihVJQdavH24nByc3evCozf7J1ImIsmvu6TIQwnjTsMb5aO99H55ETPaacBzI3si/tzZsRX/MT87FixOgLsf/82gsmIqBYtHOuhOPtCrJgJPrxkD0z9AI30y68CN0ln13adRmDFwSYr3o+W7wG+co=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(39850400004)(136003)(346002)(66556008)(7416002)(66946007)(8936002)(4744005)(8676002)(4326008)(31696002)(52116002)(36756003)(5660300002)(66476007)(2906002)(16526019)(54906003)(110136005)(26005)(2616005)(45080400002)(316002)(956004)(16576012)(53546011)(86362001)(6486002)(186003)(478600001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dUFXd3VTcVZLNmpxeEN0eTRjT2tqZjZuMTBoeFdRSzlHY0lqYkxXb3VRVkFE?=
 =?utf-8?B?OUc3Mi93djdHMVlRdmF0Z29IaTFabHZwTXoyWHRaTXlObFdCanM4M1E2UnVQ?=
 =?utf-8?B?YUdabXZTKzdkUXU1VHMwbm5ZODlDRUcxbStJcXN4MHJJRURpWTlpbEdXbTRt?=
 =?utf-8?B?bGZrTVByMlB5ZEpmZHd6M3ZDbEk4cnJJQURTNS9tSGNZcit1UEFCMmVlSjFR?=
 =?utf-8?B?WElTalo3TFNtWUdIdGFaenQwRERWanpaRGN5a0ZVOGFVdkZTdzJhODdHUDVU?=
 =?utf-8?B?N0NaeE1KTkJyWkE2L1FIei9qN1cyNFplTVRRblh1RmdnaWh0S3NMeE5BeTdZ?=
 =?utf-8?B?Tkh0NW1lV3g2VHRwWVZ2blBBVEJ1SEwxRzVzVk1JaEdvUzZRTzRUVS9abzF4?=
 =?utf-8?B?ZEE2eXBRNDhHbHFnNmYzS3RNbFRHa25kWFNXbyt0MEZOLzBtaU0vMTVpZGZJ?=
 =?utf-8?B?N1FUY1dPUGxmdWVSbFhEeXBtdlRpWFhnSnJIU3IwZzFSVlNwQk92U25LL0Nk?=
 =?utf-8?B?RUNFNXpPN2FYL3NiY0F3Y0k3V3MxVURVYjA1aFlOK0FuSVhmVGlJbm0yeFdV?=
 =?utf-8?B?a2tkS0Q3TEI2bkNDK1g0cDJHOTEwVHRWZStoUEQwc1JVTnpITFZJVmZGcDNT?=
 =?utf-8?B?Q1M1UXpiQUh0TTVBSjZGUzlmMFFZN0U5K3puazZRb2ZYbENWV3psR241dkhU?=
 =?utf-8?B?WlZqRTVFV0ZLaHRPMTZtU0ZzOGwwU2dsWHozbDhUcEdsd3dBU2hlVFJ3Vnk0?=
 =?utf-8?B?MFQ2Z3NQckppV3FUc0dNcUdLV1hHNWZzay9DVmplN2JVMFBFRDkvZlA2RG9a?=
 =?utf-8?B?RkZCRmg0QzBHTVFIZGxQVkVtYUNpUGtPT0R6bjJSYUtqVjlSOWY5blJtWGJE?=
 =?utf-8?B?eExRVTVNcW5PZEFoWlNZdG9hRWk4dGJvYTZzNnJnbDBwRmxnYm5sZ0tpNXVK?=
 =?utf-8?B?UUZXVDJ4NTRsK3JiSXJEa3k2MWJDeFpNTk9wWXZNaG5GVjRpVDNpYjJ2aG5O?=
 =?utf-8?B?QVdpeFQvcWJZQ3VDaGFONmtDZ0tFeEVQSTJleTdlM0hXblhaOVE3MUgyQk1D?=
 =?utf-8?B?SzFRT2ZBRkdqUGlnajIybi8yV2tvblEzRWNZQ1VVNERjZUUya3UwM3JaUDZl?=
 =?utf-8?B?ZmhUNXVQSkNpMHA2a0c4ZDZmSnVETmhkRmFJVENvQ2c5QysxTzdjZ1A1Z09k?=
 =?utf-8?B?OWFXeFA2NDNYTHA1S1QzOE1vaEFMZng5VXVBQ2kwenFQSEZPZjVwb1NpZlZK?=
 =?utf-8?B?TjYvVGljNWNxcllUbitpanFDUW5QVkkzcStGMFBRSzJSQ1VIakVGaFlEMEJQ?=
 =?utf-8?Q?ACYCj0o1KsrkSHKIge7Apum49NCDf+OV5m?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 17:21:57.0617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5ee8fa-2c34-4868-6741-08d8a054c263
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g9xxqlnvGrqqX+an8V34GSN6FVi+Qg8iP7dgHh5ch+jLbCtzEevXeT2w8xll/0xAzSrta+Lau0lhLSAAQZbNHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3952
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/7/2020 11:00 AM, Allen Pais wrote:
> From: Allen Pais <apais@microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@microsoft.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
