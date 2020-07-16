Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E88C433E4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 09:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31DAC20809
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 09:21:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="kRjs6yqr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgGPJVn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:21:43 -0400
Received: from mail-vi1eur05on2128.outbound.protection.outlook.com ([40.107.21.128]:60385
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726027AbgGPJVm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 05:21:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPumCFtuw6pQLyQB94K8KkIXFIsvZj+1ppe1M/ZiQf7SBvIQTfGeE01uiq/VH4Vi0YtU70EWDS+qKZfOogM8rwPDfAhuhjNeRR/HFWmGk2bK14QMPUVw2BPo+P/U8uQmaoKEkqXspHwL6ahy4CgxI7J4Z7U8jZqpRH/g1bSbrySlH9pF+FU056XCp1+G1SNRM7R4ff88wxASW49pGmb0JCbtgyKjpjchtp0LEcQCLQ2KxHhI5hSwCtpbiZddLeA3JIioPEMMH+GF4yoGC4tr/Qsvdr9mxIGGHmroFiyVpnBFOpS5TZ8CFvW1CgTpyImwIxMAPsBbis+tzM8CLiiN7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpgSKPOORHDMN84l2M8ZNchSuJQ3jrOSDfNzgII+T1Q=;
 b=nRCCvfxx21wWGDpUOAIqz0aAWgWhDlNza1EpyKW2JygZa+VaQy9XlO9bw6OuEm7x6lGXX775Y9hntyS4PMnvTayH+XFstrKc8Mzo88tBrpAXENhki0m1R328e8trVVI3mMRCvaNl9Jm20UsZQckQgeokBbstt+smyfGDVB9G/piHKMCigFmE8XCWcNeUfFceyH77Tc0ufH2h+Kcn1/mxs7TmBlX4QDWJq6bUrP75k3/pGkxDioSmqxW7oDvBR2vSryFioMTLitXNxhMKVWyWX/IUtS34fg7RBt67y7TzOxM1hv0sUoJMOCsmr7oNaUdAV5vph04IVgzPWBuCOuvwSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpgSKPOORHDMN84l2M8ZNchSuJQ3jrOSDfNzgII+T1Q=;
 b=kRjs6yqrZmjZjbhMWH9Ywr5UE0UX3AZ0MPN7fFeNxXKQYRua5LuO+BCPCfleCqCk9Iw4lpoOdazSnDLtY6PK4ijcAtjkGpETlgjSlOf5ElcrZq5sbA1ZC5e75lWZHNwjV8+ZYFJZXVm54G40SFxXqsEeCUALGlpOCTNheQkJlio=
Authentication-Results: rambus.com; dkim=none (message not signed)
 header.d=none;rambus.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM4PR05MB3281.eurprd05.prod.outlook.com
 (2603:10a6:205:8::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 16 Jul
 2020 09:21:38 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3174.027; Thu, 16 Jul
 2020 09:21:38 +0000
Date:   Thu, 16 Jul 2020 11:21:36 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/1] inside-secure irq balance
Message-ID: <20200716092136.j4xt2s4ogr7murod@SvensMacbookPro.hq.voleatech.com>
References: <20200708150844.2626m3pgdo5oidzm@SvensMacBookAir.sven.lan>
 <20200716072133.GA28028@gondor.apana.org.au>
 <CY4PR0401MB3652C2232E0B0A7951B84596C37F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR0401MB3652C2232E0B0A7951B84596C37F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
X-ClientProxiedBy: AM3PR05CA0085.eurprd05.prod.outlook.com
 (2603:10a6:207:1::11) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.42) by AM3PR05CA0085.eurprd05.prod.outlook.com (2603:10a6:207:1::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Thu, 16 Jul 2020 09:21:37 +0000
X-Originating-IP: [37.24.174.42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcb7aa68-7542-45a6-d9ee-08d82969a465
X-MS-TrafficTypeDiagnostic: AM4PR05MB3281:
X-Microsoft-Antispam-PRVS: <AM4PR05MB328170189D5737A4E86119E2EF7F0@AM4PR05MB3281.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dTN27Pwsf8UmTpfUAlHEsYkNHBHXUxKPKp1A/MYF693xUguupcUvPI9bTsdNXMYHFPH7Y6dHRCqSNAauQ/RgCq2Ft5VoLiu4cRYzruBLU0mj1ESb1EURqsaYl2MaWrrinZS1oeEaJpnRntdGMzhVyXgT4ppCqWUBnF/RtQaHnqA+52u1LCzx8zeFXPgN+IFrh09Mfm9/C6fBlPfSD6NpR+gQJ0p6v8BUrZl8CGWibXYIDIxEPUWhkEHmbkyKGmBztv/wqw+sbFiYQ4LcNlxIgtIRw92ufaEmsypSIB/1lgyDTTQ/pS2H9vb41kVR0hEeEb/OMmfmaYGLIqUi9ce7R3sk2Hn74Pk60yukEbORl15fYCqAOKXnY66r/EqH9B47uHaU9lJw1kXGxMB3qXfi2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39830400003)(26005)(55016002)(9686003)(6916009)(83380400001)(1076003)(966005)(16526019)(44832011)(316002)(186003)(7696005)(52116002)(86362001)(8676002)(5660300002)(8936002)(45080400002)(508600001)(83080400001)(2906002)(53546011)(66556008)(66946007)(54906003)(66476007)(4326008)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +Lf2uNm60OIvnle2I3/L+HeySd/qqc4mMwLgp9bgAeKurkfng4KSBj13bE5h+8GaM1alppcoDBChmlk2wESCvcM/8zDs/cDb9MVB6trz9tBoUAT0a7zxUBpofSZEQTwap2/kqY0wJEfbd9RmoydXqb1TYgJuxUkEgnZHPqh18mxr6BszBJSVenrGYJEQoNcRiZTLN3xXNtdHVuy+m5cg/DS79LdjbSqYSgR1U7/0ILgpGhARyTESY6zFuUE3JiRVAe+THkqb79OyXIsNW7uZH1pRTn9M658l//vQ1xSjE3FSQa2p4UfAJpTAZS7gr8KEP56caL7AKmIfTOTklD5RLj6JEs6jxXIXHpV8abDjAzUZsCvWSiOm38mK7c1fFEUGWBzeoubU+cKXTt0rnrWiLmUHrGoSPtTwZ6NDCh7m//IRDXz9UK4Hj6RmFfn/3kXMCZyZRuah9+fQ2HA30nll2TjTHMEjM0HYDW21HWybWSI=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb7aa68-7542-45a6-d9ee-08d82969a465
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 09:21:38.1807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h5TVyqK3o0LwvPih2dl011uA+fOfFLp/hbWSFYa5wqvkHZJlso8b+r9217xvxUNeu4c+suXfjZFis6a2Lzv8zhamZjBIUzW/KNymR43uaM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3281
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

You are correct, let me have a look at how to get the cpu bit correctly.
Well everything runs on the first CPU now, what do you do if that does down or up?
I think there is no mechanism in general at the moment for the current or my implementation.

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
