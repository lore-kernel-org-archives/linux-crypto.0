Return-Path: <SRS0=vKz2=A6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C066C433E1
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jul 2020 06:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59B41207DA
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jul 2020 06:09:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="lMXKoBRt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgGSGJN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Jul 2020 02:09:13 -0400
Received: from mail-eopbgr50098.outbound.protection.outlook.com ([40.107.5.98]:42814
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725355AbgGSGJN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Jul 2020 02:09:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0FJSQCkT/qeq9Q6BqtXa+1eY0Slg6p8/TPSbXq1ff+RkIao32iDS9Xhuc2JdHE+ndTeK9hJw9ISIp39OFJcNbNW58QypE7bkMvg/G7Q0IJSTmxGONOYdGpOkz/KjJkZ1cipbqHm3NGp8qLf2FFO88o9quLPPln1AzyUsmJpTbiRAU4qmqvLvXuz2XhyiHuzW6av7YJerYvjxTSQaBNgf15QXomzAxOoR4IY7/o168FKetbHrRujJ/p/6IaUW47er/I6nXa7nF7E22OU2Jauz9DIsPgE8Ddo0e5lDXI55l7MflVNUWZXwSyQMF0UTnm3004jAeqHL1Yf7orWBWV4vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rN8SCEj06l0qDoezf0EpTOmrj/HNf4CCx7OKutwdOkY=;
 b=gpUiRroPQjmwoM6mlcj6ppxNAjDcpTkev6e9VgdYNf3+VAcLpF9JdNaj5TK7bzOpp7rxbKxdjzhzHERoFvs69CpbHtZr6UJ1m/HEdtnzv+5+uSwltsaXqDh4VOh+FVG9+8rEbLFGjNYXc973PHZsOfZk/4EoEJReGnvkIlkDFy+VKBhoon15la97IQORMIbvFIZG+wwYWPHQu44+AUMVGGVLSidggs6EjNyEqNGxyqr6NTVYHvTgYHdTpNau/0oEHC9SgPdfSz4Dkwy4L1+c2mffDymv/Yf47xsVDr0bg3PiXSMOvP2PGRij8nE8K3PErleHq7hXPi0d9f+gvVq0WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rN8SCEj06l0qDoezf0EpTOmrj/HNf4CCx7OKutwdOkY=;
 b=lMXKoBRtGwOsu/WIQhlGr0iRz+AHrzKPexHKhQEf9bjfbQINjTuH84/LA2LkSz8FR9rK85KtVjFmsugNJWGnqfl5LwQyUHRq7XBsIr9wi0wWpsBvTi7EyOVvg8yCO73TXFuJLKPUQGTB7boHXrYXK/iU/nFZpxu/MFI2mwjb4TQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM4PR0501MB2244.eurprd05.prod.outlook.com
 (2603:10a6:200:46::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Sun, 19 Jul
 2020 06:09:08 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3195.025; Sun, 19 Jul
 2020 06:09:08 +0000
Date:   Sun, 19 Jul 2020 08:09:06 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Subject: Re: [PATCH 1/1 v2] inside-secure irq balance
Message-ID: <20200719060906.rahzddmaxtxpiasw@SvensMacBookAir.sven.lan>
References: <20200718094330.omshxatmro4f2hys@SvensMacBookAir.sven.lan>
 <CAMj1kXFNFA6htycNvbMJEY6ik3o146Ac93i=kPjQSq9khqUd6A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFNFA6htycNvbMJEY6ik3o146Ac93i=kPjQSq9khqUd6A@mail.gmail.com>
X-ClientProxiedBy: AM0PR04CA0112.eurprd04.prod.outlook.com
 (2603:10a6:208:55::17) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (109.193.235.168) by AM0PR04CA0112.eurprd04.prod.outlook.com (2603:10a6:208:55::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Sun, 19 Jul 2020 06:09:08 +0000
X-Originating-IP: [109.193.235.168]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 050cae6b-0c70-4794-6a4f-08d82baa3f74
X-MS-TrafficTypeDiagnostic: AM4PR0501MB2244:
X-Microsoft-Antispam-PRVS: <AM4PR0501MB2244EA92DA0B3FF924432926EF7A0@AM4PR0501MB2244.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xi+2buC16lBmYuiYMSvWL2ljxiAgiwx43DTVgjV1uuKrgt9WegZuyjJ9W8qy9OBgbRxUZIh25tL6JM8clylhYHM/D3VYuKC4O91HlILz7l23qBKFrpicZGueYAGKdw8axQj9qr6pCuamVYipF6uyCsHi7xDmVr4w4BuPbX4KqkJrvWgTdddj57/Zlqgi/uTtPv9xvdTuiuDyjRmHqpDOQNmBMJFXriNTl4V5VxxpwN8Qym0j42BjjUuCLTZaDxe7jjI2d33Lb3cEheE4XMsr2XSIePOmwZvHx5QR0ELEOWJalkkJtn9j191mSIrmOS/9Uyqad9pxgbm8qP2DQbSeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39830400003)(376002)(346002)(366004)(136003)(396003)(2906002)(8936002)(44832011)(8676002)(1076003)(956004)(4326008)(7696005)(52116002)(66476007)(316002)(66556008)(3716004)(508600001)(66946007)(6506007)(54906003)(86362001)(5660300002)(6916009)(55016002)(9686003)(16526019)(83380400001)(186003)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 37cza+Oke0cXO9xlryI4ASOEAi6eKCWUy39qvJB00zIAqvGvgQuB3Ygbkz1zIkaepJ9m01MFZIvlJ6YS3jmtBZffoJdRO8Ko+2aDd9AGOpAP/wHpAtfo4unKljSiIEI2PmQUKdJjrMqE5h9PjInPbmpNBByKCSHeFsFOyKBrHeCzG9qnor3La7XmoDnhDpBDHXhKAlpml3l2144AY1mpgA1LGwhy8yM1N9oJmnvRRB0rrhkhGs8jeUk+WMiNqEEP7jCo6uwITP3LQfkgzTH7LxKeLD+rVJpyUeW373WGYS+KEjY5cVDZo9VyPEYukRzar5pa6Ti5LaRkTIRPaqUNKOIY+8uHgQeZNE+8Uv3NnVUhXg6AsMWaQsRi6beAiIplENVb6vm6gaxJyKIJXduXkB1rcTxj0wivAbno6gj8eOC8HOdFycMBmy95MiGYPVFFftSZtM5XQHrf09fqIJPKr3savb3fmD88IbZKWgFq3xq5hjEEDcagG2NdFv12vknN
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 050cae6b-0c70-4794-6a4f-08d82baa3f74
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2020 06:09:08.4912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3qWCrAZe3HeTYUAwo+Jt1MlrGae/J5t7z+kmf8o9Yq/g4mBGKc4f1pHKtIeduXHo2glWxEiuq8E/9AtVdlqZ3g3nR6302Iw25Qd5Ma/hAqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2244
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jul 18, 2020 at 04:25:29PM +0300, Ard Biesheuvel wrote:
> On Sat, 18 Jul 2020 at 12:43, Sven Auhagen <Sven.Auhagen@voleatech.de> wrote:
> >
> > Balance the irqs of the inside secure driver over all
> > available cpus.
> > Currently all interrupts are handled by the first CPU.
> >
> > From my testing with IPSec AES-GCM 256
> > on my MCbin with 4 Cores I get a 50% speed increase:
> >
> > Before the patch: 99.73 Kpps
> > With the patch: 151.25 Kpps
> >
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > ---
> > v2:
> > * use cpumask_local_spread and remove affinity on
> >   module remove
> >
> >  drivers/crypto/inside-secure/safexcel.c | 13 +++++++++++--
> >  drivers/crypto/inside-secure/safexcel.h |  3 +++
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> > index 2cb53fbae841..fb8e0d8732f8 100644
> > --- a/drivers/crypto/inside-secure/safexcel.c
> > +++ b/drivers/crypto/inside-secure/safexcel.c
> > @@ -1135,11 +1135,12 @@ static irqreturn_t safexcel_irq_ring_thread(int irq, void *data)
> >
> >  static int safexcel_request_ring_irq(void *pdev, int irqid,
> >                                      int is_pci_dev,
> > +                                    int ring_id,
> >                                      irq_handler_t handler,
> >                                      irq_handler_t threaded_handler,
> >                                      struct safexcel_ring_irq_data *ring_irq_priv)
> >  {
> > -       int ret, irq;
> > +       int ret, irq, cpu;
> >         struct device *dev;
> >
> >         if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
> > @@ -1177,6 +1178,10 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
> >                 return ret;
> >         }
> >
> > +       // Set affinity
> > +       cpu = cp = cpumask_local_spread(ring_id, -1);
> 
> Please use the symbolic constant NUMA_NO_NODE here, so it is obvious
> what the second argument means without  having to grep for it.

Thanks, I will change it and send a new version.
I will wait a few days to see if there are more comments.

> 
> > +       irq_set_affinity_hint(irq, get_cpu_mask(cpu));
> > +
> >         return irq;
> >  }
> >
> > @@ -1611,6 +1616,7 @@ static int safexcel_probe_generic(void *pdev,
> >                 irq = safexcel_request_ring_irq(pdev,
> >                                                 EIP197_IRQ_NUMBER(i, is_pci_dev),
> >                                                 is_pci_dev,
> > +                                               i,
> >                                                 safexcel_irq_ring,
> >                                                 safexcel_irq_ring_thread,
> >                                                 ring_irq);
> > @@ -1619,6 +1625,7 @@ static int safexcel_probe_generic(void *pdev,
> >                         return irq;
> >                 }
> >
> > +               priv->ring[i].irq = irq;
> >                 priv->ring[i].work_data.priv = priv;
> >                 priv->ring[i].work_data.ring = i;
> >                 INIT_WORK(&priv->ring[i].work_data.work,
> > @@ -1756,8 +1763,10 @@ static int safexcel_remove(struct platform_device *pdev)
> >         clk_disable_unprepare(priv->reg_clk);
> >         clk_disable_unprepare(priv->clk);
> >
> > -       for (i = 0; i < priv->config.rings; i++)
> > +       for (i = 0; i < priv->config.rings; i++) {
> > +               irq_set_affinity_hint(priv->ring[i].irq, NULL);
> >                 destroy_workqueue(priv->ring[i].workqueue);
> > +       }
> >
> >         return 0;
> >  }
> > diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
> > index 94016c505abb..7c5fe382d272 100644
> > --- a/drivers/crypto/inside-secure/safexcel.h
> > +++ b/drivers/crypto/inside-secure/safexcel.h
> > @@ -707,6 +707,9 @@ struct safexcel_ring {
> >          */
> >         struct crypto_async_request *req;
> >         struct crypto_async_request *backlog;
> > +
> > +       /* irq of this ring */
> > +       int irq;
> >  };
> >
> >  /* EIP integration context flags */
> > --
> > 2.20.1
> >
