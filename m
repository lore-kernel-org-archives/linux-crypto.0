Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670CAC18E5B
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 13:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 310CA20738
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 13:08:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="pZC+CRZo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgCQNIW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:08:22 -0400
Received: from mail-am6eur05on2042.outbound.protection.outlook.com ([40.107.22.42]:11818
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbgCQNIW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 09:08:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0OVn+TvF8Pnw2Yb5li+vCSzTGCcBqiSn2HmnNLw92SmTJaw3bvnJIMb9rTPGwO4p51XwiJ+YuhbTuBipvoRR/zOomMQuaAu6wsq4HtDtOnNALGOEL9eaF0YWZm2Gupi0OPq7ipb2+tKo8g2oT5ETWEykhvegWu4dPuRfCM3bpJhizjO1FTWXJJjTSbayIONwIpPFU0hmG9m4WVOpN7X14vd2vaaVOwRJr/tuIQN38uodLgyy43JWIBWNNRRDcD9vdLlERyG+YtuLZkgMmCb+7yaVFP8JnxDJcfs2CBU5BwUzC5pYkxKOR74rx9f+uc7o2liaoYXpqjjqdwb2LuT/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fyyMdo78pZQMkLuuxWh963x89cERymKsYzfa4q8JCg=;
 b=cITtuvFkbtGSk6BvnMc2oVLWxIwT8R/cUT65d5Y/wezyERrnDKphhNWn9lGrRHcZ9EFHrsMte/2VHE+AXc6X/qVD0V1p5f1WlxnV2QzAk+hSTSdW+ilJpHHP5+tcdyYF6hhRpy3jwFrrffOBmOIhJD026Y5WZaMUPRf3BwzsN0Wk0tR5cNKy8zVAP9h9uTkDqKs9J4Snyn3TocwfUEmP6squ28fWWYI5kq6fh5llH2zLzehAHlXod5DSn0j0nX/Q/U91bi0cfFfmWV5K9iM/ZcuBrtT3Xv6SijmdCmJv/fCMNb7QgQKapVYGc96E1VrzVrtYNuWlx6/Vvs4RCo48OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fyyMdo78pZQMkLuuxWh963x89cERymKsYzfa4q8JCg=;
 b=pZC+CRZolMsaJFlF8iTJm5c/ukk39hzg/PzZAWr6lPZbdFABUqnhR7MQkHBJrWzndhShTjwZlc+Zgb1WHZ7xi6/afIG6hi8Kw1OoR172Was96+3uMd/ZMlWL4kShQXpjB5+jwplL9Tsz4VxDELTq3QEbTSM0094/Wg5HIX+V+LI=
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com (52.134.14.25) by
 VI1PR0402MB3439.eurprd04.prod.outlook.com (52.134.2.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Tue, 17 Mar 2020 13:08:18 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::8153:b06e:8386:a584]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::8153:b06e:8386:a584%6]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 13:08:18 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <mripard@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4 1/2] crypto: engine - support for parallel requests
Thread-Topic: [PATCH v4 1/2] crypto: engine - support for parallel requests
Thread-Index: AQHV9ZwplCPBsoqUKkWl+/E0XiXZQA==
Date:   Tue, 17 Mar 2020 13:08:18 +0000
Message-ID: <VI1PR0402MB3712DC09FC02FBE215006C5B8CF60@VI1PR0402MB3712.eurprd04.prod.outlook.com>
References: <1583707893-23699-1-git-send-email-iuliana.prodan@nxp.com>
 <1583707893-23699-2-git-send-email-iuliana.prodan@nxp.com>
 <20200312032553.GB19920@gondor.apana.org.au>
 <AM0PR04MB71710B3535153286D9F31F8B8CFD0@AM0PR04MB7171.eurprd04.prod.outlook.com>
 <20200317032924.GB18743@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9669300d-e2f4-48b0-d251-08d7ca7442d9
x-ms-traffictypediagnostic: VI1PR0402MB3439:|VI1PR0402MB3439:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34390C5FD433FB807D57E29D8CF60@VI1PR0402MB3439.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(52536014)(66446008)(55016002)(26005)(9686003)(54906003)(316002)(7416002)(86362001)(478600001)(91956017)(71200400001)(66946007)(66556008)(64756008)(76116006)(4326008)(66476007)(7696005)(186003)(6506007)(53546011)(2906002)(5660300002)(81166006)(6916009)(81156014)(8936002)(44832011)(33656002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3439;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cLMF+9pD8q9CLlzbo8wMMbdRhvn7JebppWFstkrVjOJQEhSBvDX1M3pImw9WqRnxbsI4REnoKAprKXB5v32PrDe+E8u0vSQfqQcZqW6953s2RFEjsKOMBqaMRIniUDld4Mn1UyqYPkWCVtyv74Psdc3SVAb6SnabYhCTwrGmnY/X6dWrLKZA7OlNa7h9jjo7JECsMTpyPrvC3olApPAEEwXmr+OxJH6OpIW3NCnqnProdm3+ChQybclNhmc8uDp1iTmlsMitGDbdtonJCux3iX+MFMYPmr538BKVwMqYw+g88BC2v3K6k0O8qIEQSdTYHU/4cHv0dmeWDvweN2I5YnphI3YiTAxy4eEzkZ/XmG7x0OcgnRj+Y0MIgYuDJ0+8t4r+C3KRQXg+nBiuuvIWdeCQznNir88vSdQ8N/H1HOWOd1A9Fs78pJWPYJjDB2xT
x-ms-exchange-antispam-messagedata: qfu6wLz3qDoUxPFfs9adF/ZEJGxxN2b22clYhXNrO1DdOYeDmydQ8t/8Lp0JYyfFNJMcG+R3e1/+G/JvMRWmof5ocfNCiuaETmmtmvpT13HBjHQuM1J5CTzPyr83vmybt59ltfpw06u1QY6lu59OEQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9669300d-e2f4-48b0-d251-08d7ca7442d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2020 13:08:18.1643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4MMY4N29Isba6Hr5bz9FPTcE5oCA5tJGLMaGkXii47dKQFiSjVtSihiQfi3nLNX/N9+KcBWY3cYyp5uAZ0fCHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3439
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/17/2020 5:29 AM, Herbert Xu wrote:=0A=
> On Thu, Mar 12, 2020 at 12:45:54PM +0000, Iuliana Prodan wrote:=0A=
>>=0A=
>> There are two aspects here:=0A=
>> - if all requests go through crypto-engine, and, in this case, if there=
=0A=
>> is no space in hw queue, do_one_req returns 0, and actually there will=
=0A=
>> be no case of do_one_request() < 0;=0A=
> =0A=
> OK, that makes sense.  However, this way of signaling for more=0A=
> requests can be racy.  Unless you can guarantee that the driver=0A=
> is not taking any requests from another engine queue (or any=0A=
> other source), just because it returned a positive value now does=0A=
> not mean that it would be able to take a request the next time=0A=
> you come around the loop.=0A=
> =0A=
=0A=
This case can happen right now, also. I can't guarantee that all drivers =
=0A=
send all requests via crypto-engine.=0A=
This is the second aspect from my other mail. There are cases, when we =0A=
send requests (non crypto API) to hardware without passing to crypto-engine=
.=0A=
=0A=
To solve this, I'm thinking of adding new patches that doesn't do =0A=
request dequeue from crypto-engine queue, just peek, and dequeues the =0A=
request after was successfully executed by hardware (if it has =0A=
MAY_BACKLOG flag, otherwise will dequeue it). What do you think?=0A=
=0A=
Also, the above modification will imply changes in the drivers that use =0A=
crypto-engine.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
=0A=
>> I've tried this, but it implies modifications in all drivers. For=0A=
>> example, a driver, in case of error, it frees the resources of the=0A=
>> request. So, will need to map again a request.=0A=
> =0A=
> I think what we are doing here is a major overhaul to the crypto=0A=
> engine API so while it's always a good idea to minimise the impact,=0A=
> we should not let the existing drivers constrain us too much.=0A=
> =0A=
> Thanks,=0A=
> =0A=
=0A=
