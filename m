Return-Path: <SRS0=yJek=4W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFD5C3F2D1
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 15:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E65F2073D
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 15:22:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ph1gntAs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCEPW5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Mar 2020 10:22:57 -0500
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:54658
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726413AbgCEPW5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Mar 2020 10:22:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ls9VXZVCxfrDfK1IaddF1YUeaup22dHN7YoVZqfYUnvNUQHYTLAtg0eSY5wyQMXBsOleY18QRAB+57OPo4LOlTx5P5BebX78QeF/o+W4BHfStvij+g5jtNSpav6ot5PsE1P49TeTwp1fUJCN/joLBteBVlOx4MbrQkt8TtTSjl/Yli9HP/pCyySwoK4M49bYLMbuGFO1eXklj2+7QT/BW9VSwgGUymLxAQA0ksICAru4PWQ9F4yZsM0jOLZNFZqgglt7VKjbNYPk9atXvhbawCRdf6p/ba/Xmnugod4WDgo2zfBsIkTthdqeNzMHArrqeHgoJAKR0dbpllbOg/rv5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYqGmPT1brv6ph8EjqOto7COR4sIhDwT8GZ9MipF6x8=;
 b=KQMGES6ChDZt8mM7Ls8Jv3LKwOK9TQiKG3Fg+9LykxvwFClTb/1BRIAwrjzuzOtR+SOgs3vtTwOvA2oyikIR18ygkLY9XGgbOjQ4od2LR7U8C+bXIo0QVvNiJpSv4K2JATj2siPc6GU2EfRRvD835uNEDYL8E9ujflS9w0sGDVTqJNC3MZeca9JI/6I68rnZD+rCmXuxaxzCdcvUHmsVMXWi3IIrifIRqf2KhVciI6ckdIe6CzYlbr6wtfG8JfWX/UTpraNBtmzytRRTz+8FsWpZ/msP5wJWazw7a/4Q8I6Y31XgCUVqRMjJu2Q3BM8usQeAQdYXMtySyIpfsmOFlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYqGmPT1brv6ph8EjqOto7COR4sIhDwT8GZ9MipF6x8=;
 b=ph1gntAsLId/MS/6VrHcLBEh/99tA1lnngl0RX/Ml1ztRlQ52GseGj1mGTKEYJmDC7jlyr/9JatqM6RFUXx6G5gdbSefRKvgXxcD9I/jMfl0wF8gc0961upKuD5gLv0ZRaaDSEp1bNmn7+XYvRY/fGFTDcJmGXGP1y78k5+fupo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3391.eurprd04.prod.outlook.com (52.134.1.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Thu, 5 Mar 2020 15:22:54 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 15:22:54 +0000
Subject: Re: [RFC] crypto: xts - limit accepted key length
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>,
        "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <b8c0cbbf0cb94e389bae5ae3da77596d@DM6PR20MB2762.namprd20.prod.outlook.com>
 <CY4PR0401MB3652818432E5A28BC5089E15C3E70@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <c69cebf0d6cb48ff93389d73dea6ba3e@DM6PR20MB2762.namprd20.prod.outlook.com>
 <CY4PR0401MB3652485437D698D9F9FD1603C3E40@CY4PR0401MB3652.namprd04.prod.outlook.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <7264f497-8fee-04ac-5ed0-819ab7dd5b9e@nxp.com>
Date:   Thu, 5 Mar 2020 17:22:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <CY4PR0401MB3652485437D698D9F9FD1603C3E40@CY4PR0401MB3652.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0701CA0023.eurprd07.prod.outlook.com
 (2603:10a6:200:42::33) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.171.74.188] (212.146.100.6) by AM4PR0701CA0023.eurprd07.prod.outlook.com (2603:10a6:200:42::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11 via Frontend Transport; Thu, 5 Mar 2020 15:22:50 +0000
X-Originating-IP: [212.146.100.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5238907-1a0f-4b32-95e5-08d7c11911cd
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3391:|VI1PR0402MB3391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB33912AA9E6D58CE6E3087DB698E20@VI1PR0402MB3391.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(189003)(199004)(110136005)(54906003)(16576012)(4326008)(316002)(16526019)(186003)(86362001)(26005)(6486002)(52116002)(31696002)(478600001)(31686004)(53546011)(8676002)(66946007)(66556008)(36756003)(81156014)(5660300002)(8936002)(66476007)(81166006)(956004)(2616005)(2906002)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3391;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aTQmmj8iB0WCr5MpQeDvKCeKHbDN6zHnaFVLmy/bWFyRijqQSW6C5BBgt/pwsU2RaBrLtkVxI1OvPuSlkyYX4sdfC/8JRaNeCW0YXuhx215u4SJiPL36X/QCs0/bvcip3HtlPZhRWwRfOctEwvaCXecdKaOSXqLlS8aU8YQXX6D4yLFyCisaSQhkNTujRega8Gj3oxVL0kT8mGq7AQjUKoHtEZ+N0DSiK/S4P0Pn4KPaDt9B2O3rdCJydi6aPBwtGCL08pzJN03sp2KuPf26iRA9zunTYyDlPiZG9+hEp2/EnzzwTbwp3tdOGeEynzhCCCtkzi4sMdVB2E9Li/z14q0OFiui58EhKBcwEKFCT+4Q82cx8RafqSQrReCCvdYeQvjEHBoRtgI8Y29IZCQuxXWtsQBrdLaVlhFtXmE2KSovb0IcH5ud+gc5k0xNvF6s
X-MS-Exchange-AntiSpam-MessageData: Q4Uwa8IlC71tm8K2VvvwS10j0cFpjL0MA2x4hkaXNcLKlbvcTiXCjTsXheabxdAENoRZXMDUUojthZ7oDCy9jz4ijyR8D1i55o19CEoVOXNyu6Wwzrh2GHERUYYxOAnOboRn+faZS24qL8ah9egawA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5238907-1a0f-4b32-95e5-08d7c11911cd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 15:22:54.1577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xLiJb0v5YYOnaqe8iDb7jGuQ3PXICgKVDKHxNyF7ayhbYevSRhYam0ptpDvLu+o1j1HNGrEvul/7KZsaInugHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3391
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/3/2020 3:09 PM, Van Leeuwen, Pascal wrote:
> What is wrong with software fallback for the 192 bit keys in your driver?
More code to maintain.

AES-XTS-192 should be:
-either rejected (since there's a standard in place) or
-at most made optional (allowing for implementations to *optionally* support
more key sizes), meaning crypto fuzz testing shouldn't fail.

Suggestions on how to do this?

Thanks,
Horia
