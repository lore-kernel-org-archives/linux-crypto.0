Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D63DC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 10:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D467820760
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 10:31:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="h4gvtbMz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgGPKbg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 06:31:36 -0400
Received: from mail-eopbgr60122.outbound.protection.outlook.com ([40.107.6.122]:51073
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726190AbgGPKbf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 06:31:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSjcwaWJ8xl1Nu7+ZgXeM1rlKvb0S6EhS7krJ79VpIYVspT5yfdC8SWtXNBs+hSnOG3dggu2q51n5TkOskihKAIu8HUuy+yiOBHfs1wv3+QbzkYnjd4wQ10K1jTdhaWZu1QGDiJjrjeG/UPMKDNsmQUgC3Fp+QW+jumvzj7bhIuNIqmBxm8ca/QvS62a5yTeheosURXz6JeQSHBB6O9BtkvR5kvay1iFsa+BD2jWWGvJ6THlNczkTwXR2fwD/+cKRFqFkI0REWvIwIvueKe0+q3s+azGskJFYUR9JrPHpthzNV+lSga8NYXkVh1HrjFurPXI07Pyo3ElbJ2IIelGNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHeK8qQ92t9RSene+ETl/1w0hgEqAd1PVrZjgqV8Gns=;
 b=VshY8qNGF1VWVqIYdegWQb1icLKiHWy5VfK3Z0EkhLUkcX/bDREmR6iMLvImcebLCPYU/XyduN3kfliLFaBm61wk2ixHZH3c+XiLh2qcumV2NvBHLFtWYC9ucFXaimLVb9/M/Tk+6lRMkDfcIS+Gxj1O/a9VVeiVnlGTJ6Tvthx/83Y2TduDXe6VrgsHDmI6fMyFrkBy7Zh6lDsu0LUnT4ILC8d0+PRV7eU3am3It7oi6yTh72OFvMo1Hmlentrer7rSScLFnz2Pao+pqD4R3djQSvJs2Ak6y1UC5wrdt+jRheLBsjyyGteITG/0djUo7dMivLoqv7MIcNoanBTuTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHeK8qQ92t9RSene+ETl/1w0hgEqAd1PVrZjgqV8Gns=;
 b=h4gvtbMzxqmMx/tn9mOhnKml16+BdBLfdFp3g1Qzn9hCazjCVU2RgVG3dhAvNFOm25Gt1VfSBOHGRCqOPJVtU0okKeFBPnxnlajsur8EShmJU8I2W80ubzDhapVuWQkFwlULIooz4t9PD5E3fVuGOasrqOkyWnLuyJBsMkoCgtU=
Authentication-Results: rambus.com; dkim=none (message not signed)
 header.d=none;rambus.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM0PR05MB5779.eurprd05.prod.outlook.com
 (2603:10a6:208:117::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Thu, 16 Jul
 2020 10:31:30 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3174.027; Thu, 16 Jul
 2020 10:31:30 +0000
Date:   Thu, 16 Jul 2020 12:31:29 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/1] inside-secure irq balance
Message-ID: <20200716103129.wltutfcxpwkm6cyv@SvensMacbookPro.hq.voleatech.com>
References: <20200708150844.2626m3pgdo5oidzm@SvensMacBookAir.sven.lan>
 <20200716072133.GA28028@gondor.apana.org.au>
 <CY4PR0401MB3652C2232E0B0A7951B84596C37F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR0401MB3652C2232E0B0A7951B84596C37F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
X-ClientProxiedBy: AM4PR0501CA0060.eurprd05.prod.outlook.com
 (2603:10a6:200:68::28) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.42) by AM4PR0501CA0060.eurprd05.prod.outlook.com (2603:10a6:200:68::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Thu, 16 Jul 2020 10:31:30 +0000
X-Originating-IP: [37.24.174.42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15419a3f-9f2d-4c99-b978-08d82973676a
X-MS-TrafficTypeDiagnostic: AM0PR05MB5779:
X-Microsoft-Antispam-PRVS: <AM0PR05MB5779F6D96B69FEEB367DE757EF7F0@AM0PR05MB5779.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QRBaE+vhwRGDp3N3fFH3pc7CRXC9o/ZKyEK+8GNsbEyfS4qcLAV7kIBuT0xfjn0GD6V5A75ztxPFZ9NE/P8J0zRBA6jHueDiFa7CanzF2eS1IT+U+NQSAJ1xK9KEME3ectybM6FEwgbhPWJWVmBmHSSU6CqmO0fYgFkR1ydGyY+pr8uSJm8reBIXF5YFJ25+UHan6FNM0cUmZ7lPD4KsK8Y8MiVlIH0Kfevd4VOPKzF9AN2CdsbdBB0mvjf/xlU69fYTEVhJ05i/YjrGrnff38mE6icOm+DjLmKOIBNrFGYs5hB6lVLeq9vWWO+XD2FlF8sFLPrEd4qOYC8di7zqKdVZmr/fAZ7a116wCr5g/c2xTjsclcMzkk4CpbmVOeorrZQO9DntAPv35LTd7yDc1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39830400003)(966005)(45080400002)(83080400001)(66556008)(66476007)(4326008)(186003)(16526019)(66946007)(5660300002)(54906003)(83380400001)(44832011)(55016002)(9686003)(316002)(956004)(508600001)(26005)(8936002)(86362001)(6916009)(1076003)(53546011)(52116002)(7696005)(2906002)(6506007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: TTRlUNtWvKSLBMizI+T1F6VTZWuYc7Fh4yxtvDSs9gRNXPYqxV79WWjsfJfk/hGqJMg+Zoh3XzG0RVrckzwpk2e2C4QiPDPtmkXfJak4sV4oWhnA9TJm/xP/ZsQOf22oTKQV/fIC9VpDTyIKNjzVjczObmTUAf1PFPQ44gKerEbmTprMWOst/Llg8QT3leqi1fClN28hatx9sLaoaukZmPXhYeSB/jK9Yng9VA0vDR1kWbMp9iIyLKmfa6cG2T/r/g1UAyvErWrmAS5Ma0DmVMT4N9Tjs8sC+HjC8RKu/BkttobtlWvcQO4sX8KXrqPXkVusDZq5PZM0ZQTrpYbDzZ7/QWlJH/T0x+77uiphQ1lCQhAp60kM0RatZWV2BxSN8YOqoLr9KRIdt5NSOuRI7Wq/mSHelh9lPZS9o/d78ZJnO4dwVb2vz1KHUBLA5dBqN/1gf+wPj7wDPimb13RnoBMYJdYvyz9XtT++dusFqVE=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 15419a3f-9f2d-4c99-b978-08d82973676a
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 10:31:30.7439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPFJylhkoMnFkauZ/Bt9sEFRFQcS0o+5q1y7CUO+wkUepCWgbTrCQbMbct35V85WbP0DQ1oH1OksbdrUteW8ogTA+KGzSYE3ItiI89aexY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5779
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 16, 2020 at 08:44:23AM +0000, Van Leeuwen, Pascal wrote:
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of Herbert Xu
> > Sent: Thursday, July 16, 2020 9:22 AM
> > To: Sven Auhagen <sven.auhagen@voleatech.de>
> > Cc: linux-crypto@vger.kernel.org
> > Subject: Re: [PATCH 1/1] inside-secure irq balance
> >
> > <<< External Email >>>
> > Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> > >
> > > +       // Set affinity
> > > +       cpu = ring_id % num_online_cpus();
> > > +       irq_set_affinity_hint(irq, get_cpu_mask(cpu));
> > > +
> >
> > This doesn't look right.  There is no guarantee that the online
> > CPUs are the lowest bits in the bitmask.  Also, what are you going
> > to do when the CPUs go down (or up)?
> >

After some further reading this is only a hint.
If the CPU is not online a different one will be used.
If the CPU goes offline the cpu hotplug code makes sure to move the irq
to a different CPU or remove the hint completely.

This should be safe to use and btw other crypto drivers do it the same way.
For example cavium nitrox or cavium cpt.

Best
Sven

> 
> Ok, I was just about to test this patch with my hardware, but I suppose I can spare myself the
> trouble if it doesn't make sense. I already had a hunch it was too simplistic for general use.
> However, he does get a very significant speed boost out of this, which makes sense as having
> the interrupts properly distributed AND pinned to a fixed CPU ensures proper workload
> distribution and cache locality. In fact, this was the whole idea behind having multiple rings
> and interrupts.
> 
> So is there a better way to achieve the same goal from the driver? Or is this really something
> you cannot fix in the crypto driver itself?
> 
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2F&amp;data=02%7C01%7Csven.auhagen%40voleatech.de%7C42783499b8fa4d11a9c608d8296474d2%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637304858734739951&amp;sdata=GNleSUVRQe56P%2BkG6OQ3JH7AkXzKve6UP6ai5dKpN0M%3D&amp;reserved=0
> > PGP Key: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2Fpubkey.txt&amp;data=02%7C01%7Csven.auhagen%40voleatech.de%7C42783499b8fa4d11a9c608d8296474d2%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637304858734739951&amp;sdata=nqUVTBAMn1ifyR6lj9nyxBFQZNR9Au8r0aUJR44ziyc%3D&amp;reserved=0
> 
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect Multi-Protocol Engines, Rambus Security
> Rambus ROTW Holding BV
> +31-73 6581953
> 
> Note: The Inside Secure/Verimatrix Silicon IP team was recently acquired by Rambus.
> Please be so kind to update your e-mail address book with my new e-mail address.
> 
> 
> ** This message and any attachments are for the sole use of the intended recipient(s). It may contain information that is confidential and privileged. If you are not the intended recipient of this message, you are prohibited from printing, copying, forwarding or saving it. Please delete the message and attachments and notify the sender immediately. **
> 
> Rambus Inc.<https://eur03.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.rambus.com%2F&amp;data=02%7C01%7Csven.auhagen%40voleatech.de%7C42783499b8fa4d11a9c608d8296474d2%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637304858734739951&amp;sdata=gCBXI0rNikA%2FG2ME7RxWwwmkuUNl9wRlyQqDGbFoGHk%3D&amp;reserved=0>
