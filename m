Return-Path: <SRS0=pw/0=7L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DABDDC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 20:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A97452071A
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 20:33:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=silexinside.onmicrosoft.com header.i=@silexinside.onmicrosoft.com header.b="LtMYne0l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgE2Ud1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 May 2020 16:33:27 -0400
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:31494
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726975AbgE2Ud0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 May 2020 16:33:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxxefjzXIVfzVbHR963761g4KXnhEdeXHSftB72l1RpOVHnnucNcI97i4Ra9pZL2ozO7D/5aiYFjo2cKT4kcfkxTp8nMBd0hdDMyYRNFB3HwxYvq9EmH/tj64q8OUwZjQmbVVtFYo2EHFfBJ6W/i+jc+vEMbno3eWwmKkaaPgCAemHliaDE11YjAPxHwKLnZzAspfVL5yXUsYUalHbBv+HPt9h/95npzACTOF3LurPdd7RocbB+cq3riIYp7uTzeo+pshuAIUTEDE/37BXYKe65g4w/Z+Gs7cTPS3aU2A138uQZgJPZ5iT0hAz5VeT3cfQHFj1yKfpEyRJv/sn529g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBjVpvxS/fB+qV1h6CHnny0SOXH56l+r13fTlD9qGRc=;
 b=dvuoLTQtQ9jugkhuO8esVYOZCmOYSWkg8m9re9Y/h0F+vLyrTWlfOFsAk4Pav1p08DHyJN6nlzph6JY6E4KUHrNq1o8KMXxTbKzboWxhuOJVxGvQT7RFGuJVvTO7ytQPOh10WYu6HaA+WwxRRO305y4Q/ZO2/p8S4b/76oAf4rIPTrR/InXyQoYGnGw58jkGe/5DckMyrZEB5W0jDGVGQUNY7YuuI0HjIme61MB5kcUcxUyb7Xj7DMcEu7DYTN3nKJVCEawuo+D3+4svHBIl/hcbA1vgPD5o64EJIYbmDX483vXksCIVapO/GlN7MDsPHXYR0JtZLrM+ZsGlmXzvrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silexinsight.com; dmarc=pass action=none
 header.from=silexinsight.com; dkim=pass header.d=silexinsight.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silexinside.onmicrosoft.com; s=selector2-silexinside-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBjVpvxS/fB+qV1h6CHnny0SOXH56l+r13fTlD9qGRc=;
 b=LtMYne0l4rXtqMQ0oSBNVT8vibpfeSQqwXpRn9TAURsHX03882DUCnMem/XKbYQXz4shJYA4QpUqhNkULixekXRQ3kkqrLZ1uvOYe/E9reQ6hDJlryJ/eYdhHqmWAGxsYFwVCDVproJCpoldMOU6UpscnofwsMv98n9v310IaMA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none
 header.from=silexinsight.com;
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com (2603:10a6:20b:10d::15)
 by AM7PR09MB3704.eurprd09.prod.outlook.com (2603:10a6:20b:108::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Fri, 29 May
 2020 20:33:23 +0000
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2]) by AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2%8]) with mapi id 15.20.3045.022; Fri, 29 May 2020
 20:33:22 +0000
Date:   Fri, 29 May 2020 22:33:21 +0200
From:   Olivier Sobrie <olivier.sobrie@silexinsight.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, DTML <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Waleed Ziad <waleed94ziad@gmail.com>,
        sebastien.rabou@silexinsight.com
Subject: Re: [PATCH 3/3] hwrng: ba431-rng: add support for BA431 hwrng
Message-ID: <20200529203321.GA793664@ultraoso.localdomain>
References: <20200525195606.2941649-1-olivier.sobrie@silexinsight.com>
 <20200525195606.2941649-4-olivier.sobrie@silexinsight.com>
 <CAK8P3a3=HoQZuBoqyFgyde1X7BRfcH-GFQpu=8acOi_JhVU99g@mail.gmail.com>
 <20200529171231.GA2581035@bogus>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529171231.GA2581035@bogus>
X-ClientProxiedBy: AM4PR0701CA0033.eurprd07.prod.outlook.com
 (2603:10a6:200:42::43) To AM7PR09MB3621.eurprd09.prod.outlook.com
 (2603:10a6:20b:10d::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a02:a03f:a7df:f300:fd7f:ed6c:a5df:c492) by AM4PR0701CA0033.eurprd07.prod.outlook.com (2603:10a6:200:42::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Fri, 29 May 2020 20:33:22 +0000
X-Originating-IP: [2a02:a03f:a7df:f300:fd7f:ed6c:a5df:c492]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aad59dda-616a-4766-8341-08d8040f8803
X-MS-TrafficTypeDiagnostic: AM7PR09MB3704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR09MB370407246A9DF80FAC89178DF48F0@AM7PR09MB3704.eurprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vFfx0FJ5Jjb86Ugn9Po28Scy7bneAOPEw+q6YzsJ2zET2WHSM8qUoJzEwPsr9QovEJIGbnm3kSZBWqCT3VGquq1o1TztxOvftHOuEJrwoClUVW7SBxivFOkLRu38dugz0EiiBhz/pjPAqFUnEInaY6NZp1raSr2g1CvT5vo8RJ5tEW4aBAhuDvSVKpq1RTsvFDyUkrSsMWhzyyZBfqZfG6w0ti2y0CKPX2SPW0DSr+LAnnbV1i3xq+n2QmhggGrugO3smbYaO+E/RKWVcdqaw8r8MqlQMtofyLbwVbNz1tboLfyVKW8BddhVyy6+Yf8r33EZNyFRlh1JN3AK/dZtNDxrMmfsnAJmiQk10uxKLWRESt2jYeNjzkMRTTuzpKqE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR09MB3621.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(366004)(39840400004)(396003)(346002)(107886003)(6496006)(2906002)(6486002)(66946007)(316002)(54906003)(8936002)(6916009)(1076003)(86362001)(33656002)(83380400001)(4326008)(5660300002)(44832011)(52116002)(66476007)(186003)(66556008)(9686003)(8676002)(53546011)(16526019)(508600001)(17423001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +sCP3lAdP39+da9BvX7PYRsAxBE9XDN49DVSMjocQ9bWLqRgN5zu3l/1q2WRg6gzUL7Qidm9r5+ZgQiRNfIH2aH3DOj5PtksDLHpq6aPqCV4PJPTsYE2AFV8H7ZbyjfEXstPMG7SdGln/mPmwGB76TNpK08dcqx9pMeZMhCNoMHb8HhzQRE6CP1WZj49OSUwN8E1KjVfma0bWyqIputgLC6trjQh59f6mweB21qMgCy0kmI50ay0VmbmfdyHEpewo2fNAmavxlIFy8f4zU57XIHzOnBtbUNqJVGTfNrZk1L4f2jwU4WzxmKNffxhCBy5L9VVgY+eFmk+Uh3GwPws1cAAOxGH7DqR04MRyK8wA3brkHBNeudsvs4oL8Ri6cM+lts5tj2vo2wdz72+YIHosJDm7jZTlgIDGz5f0/AgZfJenmb0VxtKWyZPzf+7fGZje6nm8iX81CFy8crSlHAHeGPEksbOx5XLCeqOLxoqp0wk33n4IEqUz7+cxcUn1r4C1Maj/mtPtGwYuFMot8mRPJIJWT1lib/yktNCwZJu7vvOOirG4l4RYYpryGiTsoTW
X-OriginatorOrg: silexinsight.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad59dda-616a-4766-8341-08d8040f8803
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 20:33:22.8067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a02f6f9b-0f64-4420-b881-fca545d421d8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 15gNh3DQsPytSbUS7Ojx2TnntTaGMqLun+WSeOBaC6rbQ5JGcu9152Zkp4mt1cMcmQTZW+/u4DwMvdz/06NcUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR09MB3704
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 29, 2020 at 11:12:31AM -0600, Rob Herring wrote:
> On Mon, May 25, 2020 at 10:28:46PM +0200, Arnd Bergmann wrote:
> > On Mon, May 25, 2020 at 10:07 PM Olivier Sobrie
> > <olivier.sobrie@silexinsight.com> wrote:
> > >
> > > Silex insight BA431 is an IP designed to generate random numbers that
> > > can be integrated in various FPGA.
> > > This driver adds support for it through the hwrng interface.
> > >
> > > This driver is used in Silex Insight Viper OEM boards.
> > >
> > > Signed-off-by: Olivier Sobrie <olivier.sobrie@silexinsight.com>
> > > Signed-off-by: Waleed Ziad <waleed94ziad@gmail.com>
> > 
> > The driver looks good to me.
> > 
> > Acked-by: Arnd Bergmann  <arnd@arndb.de>
> > 
> > >  drivers/char/hw_random/Kconfig     |  10 ++
> > >  drivers/char/hw_random/Makefile    |   1 +
> > >  drivers/char/hw_random/ba431-rng.c | 240 +++++++++++++++++++++++++++++
> > 
> > I wonder if we should move drivers/char/hw_random to its own top-level drivers
> > subsystem outside of drivers/char. It seems to be growing steadily and is larger
> > than a lot of other subsystems with currently 34 drivers in there.
> > 
> > Not your problem though.
> > 
> > > +       /* Wait until the state changed */
> > > +       for (i = 0; i < BA431_RESET_READ_STATUS_RETRIES; ++i) {
> > > +               state = ba431_trng_get_state(ba431);
> > > +               if (state >= BA431_STATE_STARTUP)
> > > +                       break;
> > > +
> > > +               udelay(BA431_RESET_READ_STATUS_INTERVAL);
> > > +       }
> > 
> > Looking for something to improve, I noticed that this loop can take over
> > a millisecond to time out, and it always runs in non-atomic context.
> > It may be better to use usleep_range() than udelay().
> 
> Or better yet, use the register polling helpers.

Indeed, thanks for the suggestion.
I'll replace this loop by the readx_poll_timeout() macro.

Olivier
