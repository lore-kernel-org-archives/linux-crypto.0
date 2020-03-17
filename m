Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36C4C1975A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 21:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61C5520738
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 21:37:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Iz5i2+QZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgCQVhn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 17:37:43 -0400
Received: from mail-eopbgr10071.outbound.protection.outlook.com ([40.107.1.71]:53220
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726549AbgCQVhn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 17:37:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGpFWHXtZSfU9N92Qd8ZDo1BkPVKiO1AgDUy1WYsJXWUxez/j9xpe3mqD5E+f8EVFy7ozUQJipiVnxsrRRj2kBcZysyd4Cg1Dsa/JhZmM+GN1bu/BK7eHhj+HQFPK/4edhXgJ70+o/AK/ouxQgsy2hA1RcUVG9WKF0LDsJxCVE6g8l+firno6xc3D/SkZpAno1PiW2t+KXVAdaHyT+gckSpmhVfbYmpWcngn5zrDimHXMRCIF9wkxNdbgdBu9It1o8YxRzXdcaGhpEnIpFA9+AFrQ01cqOFgaIKqFnBPYq78LZUiXD+ndJZ5vqW/aTG4pUH7wIzp+gNx1ActyL5f/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0qssbrpcwNZcgBeEZmSjljdVaRkT7WKh9Xj2rOlBII=;
 b=j+EaFFmfdgsraqRZ3cSmO5BC86cDP3gM9BJoJKEeeA2dCPfaosLimM/uJqMKnP4u6sQu1U60+/d9Kx4CyGUVFVIOYMopFzQOmHvcMtkf4B6/5H/tgDotEdVf3BzpAWJSVDaBknzCz724h+jqF/xqynEEGQ3L24wRrNhp77rSIG81cWnFj85TwBUpqaKIiX/0KxClaYVaMvR/o1U2SRz/xmkffeSVpIXWm4c+GMlOqbqPnmxypmo878J6/XcuLO1cDQSLmCa7LEiHT45smmCj9G4+SfVPaaULXfl/C93lAxMCLiXd5aIaigF1iqaj17+FaG8RVJ5GkAqiWW7o4NVN5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0qssbrpcwNZcgBeEZmSjljdVaRkT7WKh9Xj2rOlBII=;
 b=Iz5i2+QZ1awUONrIZeh7D9Ij/diC6iDlLSPgwvq7jnuUywGCioDDvB//VBzrtbBH2io8brbzQrnk9piOjWTAX+k73LHcdmqbHaUAbud6v6ctsVb+k0R7IohPFNqzx11i7cUCOMfHUI8ricm1dwZX41uTek+rxodsVOdh1iCWHe8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3438.eurprd04.prod.outlook.com (52.134.2.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.18; Tue, 17 Mar 2020 21:37:35 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::751e:7e8d:ed4:ef5f%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 21:37:35 +0000
Subject: Re: [PATCH v8 4/8] crypto: caam - simplify RNG implementation
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
 <20200316150047.30828-5-andrew.smirnov@gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <a662c74d-96d9-dd76-2a5c-627973898a89@nxp.com>
Date:   Tue, 17 Mar 2020 23:37:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200316150047.30828-5-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0701CA0021.eurprd07.prod.outlook.com
 (2603:10a6:200:42::31) To VI1PR0402MB3485.eurprd04.prod.outlook.com
 (2603:10a6:803:7::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4PR0701CA0021.eurprd07.prod.outlook.com (2603:10a6:200:42::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Tue, 17 Mar 2020 21:37:34 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 35ec7892-6ed2-42e2-efc0-08d7cabb6848
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3438:|VI1PR0402MB3438:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34385FF5158129F6DBE42D7D98F60@VI1PR0402MB3438.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(199004)(8936002)(52116002)(4326008)(8676002)(36756003)(316002)(54906003)(81166006)(6486002)(956004)(81156014)(31686004)(16576012)(110136005)(2616005)(53546011)(478600001)(5660300002)(2906002)(186003)(66946007)(66556008)(26005)(66476007)(86362001)(16526019)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3438;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wg1FI9/lS1vo7YATv686aGFPyizyFqMIomKzd1/WMqw9hLZuBiLzT0cDCTjc60iws4xHYg4kvLlWIvUlF4174R0k8A1zOSuM9d8+oRGcWn2ps42wjAr2ncl+2uVWPwvDBhOC4zNNxqq7JXjF8Y0ETwwmsWpuypJ85n2Pj0dW0E7sISc5Qyn8X6NgbOmw9tzSgsBX/I2pE0g9KIPnmWgjh7R7h3OSDPIKq1rmzGfFkadOObRlCsg9ATg6uNC/kNfElAH/T4RdKxyLgfe2Y0+rGRnAFx94gCL1Sz2NkpE/iocQU/9fsU2mzeEDsKsQBat1eVWw2N0MRJa+DtlVog2NsNImk5Q4705cfLdw6CnxJWE+jmqBngNE+/fC2eADbKruF6h93zFg/O9FWeaGMbVuJCHrE/87MJ6t07I8XF2oReuEKgKztoDG8zRAzjombVy6
X-MS-Exchange-AntiSpam-MessageData: XJp372KT33RpDIBeBzZEs7fZrZTx0KCkA1G1R7CBNNW3sljIvqxIKYuFnMBda3V8C5FMu4Jt+yf1K9C26aTpePU7AuCu1Qv3iylOQFDde/yUMZA4QKmi/ErKKRYgd6YQvHXhlYgL3Zd4f0n8mAqBXQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ec7892-6ed2-42e2-efc0-08d7cabb6848
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 21:37:35.7008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 09DRJb5ERe55XfBuR0olLwx3GBw4+ygD2kZX78Xmc+bsBFwkzkRZ0zmb7VfFVaB8OwzYXMlrdhkOYUWLN5lmnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3438
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/16/2020 5:01 PM, Andrey Smirnov wrote:
> Rework CAAM RNG implementation as follows:
> 
> - Make use of the fact that HWRNG supports partial reads and will
> handle such cases gracefully by removing recursion in caam_read()
> 
> - Convert blocking caam_read() codepath to do a single blocking job
> read directly into requested buffer, bypassing any intermediary
> buffers
> 
> - Convert async caam_read() codepath into a simple single
> reader/single writer FIFO use-case, thus simplifying concurrency
> handling and delegating buffer read/write position management to KFIFO
> subsystem.
> 
> - Leverage the same low level RNG data extraction code for both async
> and blocking caam_read() scenarios, get rid of the shared job
> descriptor and make non-shared one as a simple as possible (just
> HEADER + ALGORITHM OPERATION + FIFO STORE)
> 
> - Split private context from DMA related memory, so that the former
> could be allocated without GFP_DMA.
> 
> NOTE: On its face value this commit decreased throughput numbers
> reported by
> 
>   dd if=/dev/hwrng of=/dev/null bs=1 count=100K [iflag=nonblock]
> 
> by about 15%, however commits that enable prediction resistance and
> limit JR total size impact the performance so much and move the
> bottleneck such as to make this regression irrelevant.
> 
> NOTE: On the bright side, this commit reduces RNG in kernel DMA buffer
> memory usage from 2 x RN_BUF_SIZE (~256K) to 32K.
> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Horia Geantă <horia.geanta@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-imx@nxp.com
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
