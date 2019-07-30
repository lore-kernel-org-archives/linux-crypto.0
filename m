Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2B4C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 10:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1409F20651
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 10:28:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="EDQ9zxOj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfG3K2T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 06:28:19 -0400
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:40507
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726372AbfG3K2T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 06:28:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jl1q6Y4mJuzXknMQtc15bTexEaLhtHKxP+0qd6cSC40J44YcCEYRtAEt6aBYX/uxI4qhv+HXkblAwOJ4RYsJ4Wf5CLTZMtjgzAByVDiiTVCJ07hmmToXfjwSejtzMNUwQCWOcNHVcFJANURdlYblbDOUhtlz+fj/EV/40AkTQ5Ob2iBWrmc24gk7jM6J/C85+YOluOkkyNGU01uxhBO8sZktabOP8GodI0jPE4+GHod/L1dzqz2OTikmnH1G1yjxmUybXCZbxnMYRhzb95GQbcz976kUN+BWtUIz1Sk6gBPpuibuBelt6d15Sn50fsXNjncT1WzRfSXu5HYcQ6t5Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaNySdQqbleTzeELnzsMfEZRVqkyod0gAAKit8IgBVY=;
 b=Z6I72ggkfLCAPI+mDDit3OPikK6wjEjnRaDZPK+MQa7pNiC9YfdqHKwu5G/qfjV9AI5BwDRND61AZhvbWz51444W620Na/By0vDTOv9ZJ2ic33WkfufDShBNylThgZpPGn11Ea7OvviZ7SKklOfi3xTpOgh02bpBLni2a/deFo0xwNQAfFdCQkGmXAGwcLqjgMbdE74kaDA6f3LfyYq4NN0sTYlnOJUcYDM5ON9THS2/IK3+nOrsgKX6PtHdZPAYPq73kiTjShBp2vIJa3eYQUtM09Fj2eRNDULBRdCihA8KmOLLhJbxlY172JegPm56Mk8rkMMpPJ/0IAlLnMTxFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaNySdQqbleTzeELnzsMfEZRVqkyod0gAAKit8IgBVY=;
 b=EDQ9zxOjF7HE8ppBMS07IvwNmuuzrZXfEEKM3ifrRU+oY1+zKhUtHyromhXoucv39hNHZl10JU1OLhh1eNtM0ld2eMgqdKoVlgn0XV2o+ctOtHnfM8HO7a2G6f/ieIhUCMl46zRu2gUMPUpOOaELQ/8VV7V2xotSRDm/VBrM6Mg=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3325.eurprd04.prod.outlook.com (52.134.7.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 10:28:15 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 30 Jul 2019
 10:28:14 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Richard Weinberger <richard@nod.at>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        david <david@sigma-star.at>, Baolin Wang <baolin.wang@linaro.org>
Subject: Re: Backlog support for CAAM?
Thread-Topic: Backlog support for CAAM?
Thread-Index: ARBzCkuiRpn89WxIsrxtpCssT2oQQg==
Date:   Tue, 30 Jul 2019 10:28:14 +0000
Message-ID: <VI1PR0402MB348585019425D0D9FC9177A798DC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <839258138.49105.1564003328543.JavaMail.zimbra@nod.at>
 <VI1PR0402MB3485A27D2D9643F70E1873A398C10@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <1174635359.52770.1564347035533.JavaMail.zimbra@nod.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a1b67d8-318c-44e8-3183-08d714d8a168
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3325;
x-ms-traffictypediagnostic: VI1PR0402MB3325:
x-microsoft-antispam-prvs: <VI1PR0402MB3325B770245E0E25D2C7E21798DC0@VI1PR0402MB3325.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(189003)(199004)(7696005)(478600001)(6246003)(14454004)(7736002)(476003)(53546011)(4326008)(6506007)(446003)(66574012)(486006)(66946007)(66476007)(256004)(14444005)(66556008)(6916009)(3480700005)(25786009)(99286004)(8936002)(26005)(8676002)(76176011)(76116006)(5660300002)(74316002)(52536014)(2906002)(91956017)(44832011)(81166006)(102836004)(64756008)(305945005)(66446008)(81156014)(86362001)(186003)(33656002)(9686003)(71200400001)(71190400001)(55016002)(54906003)(6116002)(316002)(6436002)(3846002)(68736007)(66066001)(53936002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3325;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wFvmPebGlp8y2xpW3JiNae5/nBu+kzz8A3F2f3E/kL6NWzpyJl4ICHmLG1Db/HlMln0A8LKHM972/jfJzCYXm2DZbrDSwmZCjsl6WKfUbHN4x5x8Df76hz7z2FmOY1ELw2lG0c+rvCUf6i03Q4GsWWs41rAYQ9makDCsNEZOryKBipsw5de5YetEr6lvkbGFfcG2xTMBKo/VoP/CGVHu0gJ0xiPx7Cg6c5C18Nsq+xQ53h8gOVjUeFSpxt4EhN/ATzfAJBYk+wZx14n9GhyRadoVVVhmUUxnQxkyFerLnMsTdeRpc8nznMYmF/umTRDR6+9q3pHjrwQTMJFDf6/Tv5l5QETxDHMb4ilheAGMQKtBiny/23muWlQbbbvMogukFv4LfVwh9zyCeUR5/GWVPjIs3aso+VNaTbuEAWbuMzc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1b67d8-318c-44e8-3183-08d714d8a168
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 10:28:14.8256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3325
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/28/2019 11:50 PM, Richard Weinberger wrote:=0A=
> ----- Urspr=FCngliche Mail -----=0A=
>> Right now we're evaluating two options:=0A=
>> -reworking v5 above=0A=
>> -using crypto engine (crypto/crypto_engine.c)=0A=
>>=0A=
>> Ideally crypto engine should be the way to go.=0A=
>> However we need to make sure performance degradation is negligible,=0A=
>> which unfortunately is not case.=0A=
>>=0A=
>> Currently it seems that crypto engine has an issue with sending=0A=
>> multiple crypto requests from (SW) engine queue -> (HW) caam queue.=0A=
>>=0A=
>> More exactly, crypto_pump_requests() performs this check:=0A=
>>        /* Make sure we are not already running a request */=0A=
>>        if (engine->cur_req)=0A=
>>                goto out;=0A=
>>=0A=
>> thus it's not possible to add more crypto requests to the caam queue=0A=
>> until HW finishes the work on the current crypto request and=0A=
>> calls crypto_finalize_request():=0A=
>>        if (finalize_cur_req) {=0A=
>> 		[...]=0A=
>>                engine->cur_req =3D NULL;=0A=
> =0A=
> Did you consider using a hybrid approach?=0A=
> =0A=
Yes, this is on our plate, though we haven't tried it yet.=0A=
=0A=
> Please let me sketch my idea:=0A=
> =0A=
> - Let's have a worker thread which serves a software queue.=0A=
> - The software queue is a linked list of requests.=0A=
> - Upon job submission the driver checks whether the software queue is emp=
ty.=0A=
> - If the software queue is empty the regular submission continues.=0A=
> - Is the hardware queue full at this point, the request is put on the sof=
tware=0A=
>   queue and we return EBUSY.=0A=
> - If upon job submission the software queue not empty, the new job is als=
o put=0A=
>   on the software queue.=0A=
> - The worker thread is woken up every time a new job is put on the softwa=
re=0A=
>   queue and every time CAAM processed a job.=0A=
> =0A=
> That way we can keep the fast path fast. If hardware queue not full, soft=
ware queue=0A=
> can be bypassed completely.=0A=
> If the software queue is used once it will become empty as soon jobs are =
getting=0A=
> submitted at a slower rate and the fast path will be used again.=0A=
> =0A=
> What do you think?=0A=
> =0A=
The optimization mentioned above - bypassing SW queue (i.e. try enqueuing=
=0A=
to HW queue if SW is empty) should probably be added into crypto engine=0A=
implementation itself - for e.g. in crypto_transfer_request().=0A=
=0A=
Thanks,=0A=
Horia=0A=
