Return-Path: <SRS0=ep2G=7K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649D3C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 15:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A5702073B
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 15:42:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="YaxKCe17"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404474AbgE1PmE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 May 2020 11:42:04 -0400
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:26086
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404445AbgE1PmC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 May 2020 11:42:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGQLYTpfb59OWxk0RND3ci5x1F+lB5AnGguhh3tMvTMq/akwMwgvfEBwCoBKDG9Po8N5u/0sTHJ8h5uub4ybp16eQcc3FvskAhKNLFNvq+FHnr5MmiY3ptWvFE0b9sVupYmFFVxkejkJMbWkRLuNftJRIdTkO04g7ZMvKrCdX90cdCnmoFm8kmLch1ddm0NHAzXfSTsc8XN75Xsb8It/oDCwXaJu574eyjGAidm4bkA81AzeTPEY5vljDqVj7HbSaKJEezYd3ZEwyrm216e481jm73/nHI/AsR4wT1N92nqiValoHdcpkEyewOEsmjuHGEQFc7J/3I9yEEcrWJP9hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaNt60oByRSxZWIhbZsqCAjydNRv4pjGU7evR7F2PAw=;
 b=P1wfjkAm+32kO4JXT2+W1oavPXSklZRrOxDv5nbzpiBiUsoZy7kFz32/mByQ7i3e9+gaCu/eMSiw1dK65YRZEevHSBkDXUOCV8lflSYSHzRlohKQTtHVA84TeaeitYUCd6NWqYfdjimySTF/fWBQdkVASqgPRZ/cmWgtKmsHWQtQnDhxFzip5y6Y+aPqWDVyuaSmp2cFJVdeDrePonWO/6eA3JiwE43+HvOLcZXgi8neH4fUBC7iwpBEF3mkn6a7QYEjDCp+rKpOb7kL6fyMzZ2jRGSDuboCns3o8oPQHpqkNxxYv3XR6TwT+ZvKgSv3FAJst2NQ2F/JIyWF0/Kc4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaNt60oByRSxZWIhbZsqCAjydNRv4pjGU7evR7F2PAw=;
 b=YaxKCe17yL09X3kqmo+3eHKs5WYXbyOqkE7qTVMIPRoZ7eyCN+L30LMY6mvIk7ebO41aYJbYNxw2voBgEGWbPODEhS+e+hnY32uTKc49IfteQB07exhIec9ADJUmlnv/WE5WlxhiYoYpMkF6MB+6av15AUA6ZJFaI2WL/M9tM50=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5917.eurprd04.prod.outlook.com (2603:10a6:803:ec::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Thu, 28 May
 2020 15:41:57 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4cf0:3c9c:ed2:aacd%4]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 15:41:57 +0000
Subject: Re: [PATCH] crypto: caam/qi2 - add support for dpseci_reset()
To:     "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200528110450.11279-1-andrei.botila@oss.nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <7474713b-93b1-6f8b-600b-08d473ca92c4@nxp.com>
Date:   Thu, 28 May 2020 18:41:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200528110450.11279-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR07CA0003.eurprd07.prod.outlook.com
 (2603:10a6:205:1::16) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4PR07CA0003.eurprd07.prod.outlook.com (2603:10a6:205:1::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Thu, 28 May 2020 15:41:56 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 78b835ed-c830-4988-668b-08d8031da792
X-MS-TrafficTypeDiagnostic: VI1PR04MB5917:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB59175E782F73202BD1B56B7C988E0@VI1PR04MB5917.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S92/nENXv06zwKk6XHQ4pYiT8t6dEWS5EsKISTWzte0uwpoL2b0Q6KQ0sx3IlnJ9K9b1IhBb61SfO9BOKl07CisOBRqB63KxZGjm6fWgptklQ9vevEe9D2bjRgvyqRahkWQ1AdbQ2iWKBdedYnsJkgfWt+d5HMIfF+UkE3bgAtUdKKnHy9B75WUDWszE9b2xyQ/04oZFJbJpDMI2ZIoXzTudFoO2rG0sM9kPkY7FNPo60zbigA2XVSn+++zG5JzdfELGYaOEhpqWdbtqMF2EQFUnvWaNwS0EcWNGtcOYQbAFYLeMbCka/4J/q6uH6T/0aQ75U9fiKsbsjfAj2YL2hsQkfXEZskbCBCyITII3qqrqk3NY75oQVZoxa4i12C0t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(66946007)(4744005)(4326008)(5660300002)(83380400001)(2906002)(110136005)(16576012)(316002)(2616005)(86362001)(478600001)(66556008)(66476007)(54906003)(956004)(8676002)(36756003)(26005)(8936002)(6486002)(53546011)(31686004)(31696002)(52116002)(186003)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0XsrGfxYGGNhcWUh6QWu82V215qt+ZLVaANPeFIKuVb02C+KlxiHaZfLGT1nPvPgqY+fVmK+lL4K//NDoCQawe6E8VUBenl9fg2yGO2HEFmsGTR70P/fgRj4O0lwexlYl0FTiIkFDJo1nEIqkEO1KGhrB3OwC2BsMMnvaVCm2i6kkOboo8Il1ASjV7kcO+tZOK46gC9Xzr4iSvUgmfP2iCi7FAbbgPTO5z8HMeuIQFbZU6GwhaWZvZOTVBwHEL4MetCtvf/2c/jjCn1hicsM/mUCO9UOhJLIo3At52SJkjEVuVhBhck8nzOIVHp0nD8E4vhpLWGC45K3pzd2lkslzIw7amvXxk4gWyqU7wQqmnKACiV61hbe+ednBH0DyX5ee3DMPfdyFeMZNToJvzGYxWkEb0cA843nu1UA7SP6BGs3phANYWHvPtmOs5Z3z03FkiATKrRrVhxyab0qBIjovNvUR6wqufg0xCynUQZa5TjdMD5fjUY4CqovFjHrojy+
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b835ed-c830-4988-668b-08d8031da792
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 15:41:57.5128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oX8zyhLGqwp69uAPgtf6MwDK2g9OQng8P1lkUjmPmGV+68TqctUgPHoaNnXNbDe7X7kZ0pbaqXeMnpTWEVuozg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5917
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/28/2020 2:05 PM, Andrei Botila (OSS) wrote:
> @@ -4698,6 +4698,9 @@ static void dpaa2_dpseci_free(struct dpaa2_caam_priv *priv)
>  	struct device *dev = priv->dev;
>  	struct fsl_mc_device *ls_dev = to_fsl_mc_device(dev);
>  
> +	if (DPSECI_VER(priv->major_ver, priv->minor_ver) > DPSECI_VER(5, 3))
> +		dpseci_reset(priv->mc_io, 0, ls_dev->mc_handle);
Even though dpseci_close() should be called in all cases,
a warning when reset fails would be useful.

> +
>  	dpaa2_dpseci_congestion_free(priv);
>  	dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
>  }
