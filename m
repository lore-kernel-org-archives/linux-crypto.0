Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78F1C2D0E2
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 12:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C5102399A
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 12:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="zR3WPW9q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgIVM7w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 08:59:52 -0400
Received: from mail-dm6nam10on2069.outbound.protection.outlook.com ([40.107.93.69]:23520
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726563AbgIVM7v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 08:59:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsoB/lGQVo+E4bH/0KnHL9tA+/nao1LzcKZPf6Z0Btif6kWza/uFiwF9DCh1iuBfdKI2ktkd89unQp83P15BOCRY4YYXHXZwnw5REvqr3NSYOKOc4Ik+MN5cRT5/d3n9g36W5tMdvPeDbanJzoUdZyUkrPY4pywY4T8XYy2+/vMPdvBtRXwnrNVs0zki/hmirz0ORjwqJpE5sndFiTuZVBuMkJ7XRuvX+jgGgiW27vlAMsl4Jn+S7uA8E3ZJ2ngNV1r1Mzzhf8RXV0PAIkBaXwdxtoJjnmrq7tX2DLO+/oGKwg8wGB1OqU7XR1+auc9gHgyEldAH9pfvs4eZwRgQbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVszv1hS6fG38NL+tKrtbZUJM7fJ88qzGTfuReTO/gk=;
 b=k9yxu0TBTqB+DQoAUnmZTIRi2z3ZR4Kyi4P+OJTcOu6A0rXIQCaewqB+k67wcv48+d2cKxMxVXT8FD3UVuW4cBrVgn3lozJ4IxpQTzB4PRGX5+CPJjkStQACxx9o5cxoqyysBrhm+2X9vAuhLOqcjS/3yuROP0GUDN87JX1rN571HHPbBoVYr3T1pJb5a/OhceZ03HgPBwggjQTa3hVU0lnu42KjrrCtjAHjOngFOPEaqh/csZvH+fVmUPbkcw5lvPfHspO+OAs6Rsy8NeOPF4LzP3sGgbWk3kEWTBLE6QhF6qmWtAbczRz9L2y8TG/LNjkKlvMAnJbBga8n1mJ1Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVszv1hS6fG38NL+tKrtbZUJM7fJ88qzGTfuReTO/gk=;
 b=zR3WPW9qDUlzn++cvkfhyA4Mq8In1+mBeSrP6QqxAdsuS3NUA2b+ic7mdrEuBTx1jptjaHWzzqk+mHrPh9FI3k4CLfcDzjXWZyQf8MAUwiBUDTi8FTDpMx+tLTQ51MBli7AYJdmuRT6JYSb27uPwGbF2dpuBTvl01XjdYUdSJlA=
Authentication-Results: denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
 by SN1PR12MB2557.namprd12.prod.outlook.com (2603:10b6:802:22::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Tue, 22 Sep
 2020 12:59:48 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::119d:6402:3d29:75fc]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::119d:6402:3d29:75fc%7]) with mapi id 15.20.3391.027; Tue, 22 Sep 2020
 12:59:48 +0000
Date:   Tue, 22 Sep 2020 07:59:42 -0500
From:   John Allen <john.allen@amd.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - fix error handling
Message-ID: <20200922125942.GA8119@mojo>
References: <20200921113435.GA20450@duo.ucw.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921113435.GA20450@duo.ucw.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR19CA0015.namprd19.prod.outlook.com
 (2603:10b6:3:151::25) To SN1PR12MB2590.namprd12.prod.outlook.com
 (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mojo (165.204.77.1) by DM5PR19CA0015.namprd19.prod.outlook.com (2603:10b6:3:151::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Tue, 22 Sep 2020 12:59:47 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e9e3ca4a-f3a6-49fe-ba92-08d85ef762dd
X-MS-TrafficTypeDiagnostic: SN1PR12MB2557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB255707BA438E9B801BF0954D9A3B0@SN1PR12MB2557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4YbVEpnwxyeU1eoI2QU1T7yLmA4ZtVMfeIQezlB7ZcSkr6BYjhMtSzpJSsmhqFnGdyqXjRO+Hjkn5Wcsgdfc+LqSCJ68mDz9zOxHnH0zgHMl61TrdA2ooEdh+tcGN334g8J22TAO1cw8HZ5w5obK4wl6PC3ciIDHpvqbmV/PPyQOdwqfHPHxmBA6BXc722jj27Wy0Ki3xWA/EY1zHf1yCAcvG9dnIfSTV2TeRD6FfxXaXXA1YUqvDHa6I7KJzRPS9c9U3X0n0eIGRQBkzakulnNDYSH6+hUfV5s/ZvOp+8MEPRkq+hQCEAQcka0Tg4x6g/H90QBqY8jCthDVzrIoeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(52116002)(16526019)(8936002)(44832011)(2906002)(9576002)(66946007)(5660300002)(4744005)(6496006)(66476007)(66556008)(1076003)(6916009)(8676002)(33716001)(4326008)(86362001)(956004)(316002)(55016002)(6666004)(33656002)(26005)(186003)(478600001)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Y61SzCxazvaqJPkltYan+52Bg8a4CvSwiGWBSrgsYZdib+r/jP8RnRntCq5dRU3jnfE8quHoY8HVdsC+ePX+biFzu+DTpIbjDnLQXi5gIR+D6okmiGre7XaEahm+uMjYN1nhFeHkDU7zLUe8jm+o1XvOY7ba8ol2Do49/z/0MPwXDP6bYW9VPMybQiTCqGi1VJL8W5uBVxfbJ2++I/7NJ+FJBNbwLQe0CrSrZKSe7T0WVWSTdihYHBMI/CCD3sy+z0eAQ40oWJ0zgH7OPY+bv5CFBPVse71psOwcu63mgMyCghmN1M0JMrGn2/bHY8SrjlAsuTuVGz9We6gsqHBoB4F0GaE0AVLy65jP3DfkroSOOd9kSpj1h6kYMxtavE+CqqcwvxQ3jNUrjkNNVUtDzI4gK3rucuz0wIotqfNhvn8KulomahTidGU1tIP0ytj/yBnKI15MEbRj+B2nCmAtG68u6VE8nJaOxLMZonoAsH+9R99IXw4O0RaRhobl2Bm3Ep6FoVeGYUqD2f4Q8jYnmy024i6Y+0Z+VhcxivCppP2g7svKsVZmmERw3dGcBb5zGt3VSzystSXWtB9VXyeuDfjw5W0IItVQ3/YpdAUGpllh9rbMbyiL8C4TNABCxd9C/4AbUyvwZlTSk66T/caE+Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9e3ca4a-f3a6-49fe-ba92-08d85ef762dd
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 12:59:48.5234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btTNDjzpxCfcbeLtE5GzkmyD5gJn1Uf6pW+MXD5ks4YqyEnI5ILvOEfzS7R2yzvwTxe0PFAVubuBQexP3yltBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2557
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 21, 2020 at 01:34:35PM +0200, Pavel Machek wrote:
> Fix resource leak in error handling.
> 
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

Acked-by: John Allen <john.allen@amd.com>

> 
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index bd270e66185e..40869ea1ed20 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1744,7 +1744,7 @@ ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  			break;
>  		default:
>  			ret = -EINVAL;
> -			goto e_ctx;
> +			goto e_data;
>  		}
>  	} else {
>  		/* Stash the context */
> 
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany


