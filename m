Return-Path: <SRS0=Q7wt=RI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E48C43381
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 18:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2992C2064A
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 18:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="hEaLXBUv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfCESez (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:34:55 -0500
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:44118
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726256AbfCESez (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Mar 2019 13:34:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgePx+yLQLnt/8Rhq9UTI1uWnRbYJPYhOBSHA059vVI=;
 b=hEaLXBUvgbdon3qbiG5ThBkARcdOLvGKJDBE0BaGf0AipnN44TDcULYfPvQzpBr6KgUlI5X3Jyhs+qBfz1wolsEiXM3vl+R1nXkP34wqYTP3QCmsidbeQxlKyXZjZW7BCq06crUSuD3js6pXXt6KlfUHjKZ/lBdAZb3H1mSpPKY=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2894.eurprd04.prod.outlook.com (10.175.24.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.16; Tue, 5 Mar 2019 18:34:50 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531%2]) with mapi id 15.20.1665.019; Tue, 5 Mar 2019
 18:34:50 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v3] crypto: caam/jr - optimize job ring enqueue and
 dequeue operations
Thread-Topic: [PATCH v3] crypto: caam/jr - optimize job ring enqueue and
 dequeue operations
Thread-Index: AQHU0320NnCLOY5LjU20asmkOTCJWg==
Date:   Tue, 5 Mar 2019 18:34:50 +0000
Message-ID: <VI1PR0402MB3485F07836284C462A62544D98720@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190305180040.8860-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fd27f2a-d969-4c22-8645-08d6a199407f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB2894;
x-ms-traffictypediagnostic: VI1PR0402MB2894:
x-microsoft-exchange-diagnostics: =?iso-8859-2?Q?1;VI1PR0402MB2894;23:eoCr4sjZWub4ipiXWKsimLSOrV4uDJxUenaY3?=
 =?iso-8859-2?Q?slcwFJZ6oeQ9yCnpYfszdMYoJkAvxPoEKAexSy9zVtwn9viA197S5wZ9RA?=
 =?iso-8859-2?Q?y2hpFQaRo9IXfaeSKdUeMKjDTWGUfxZZ0zXsqyVKwKVePhilr5evvumYAz?=
 =?iso-8859-2?Q?hIw3E9ntjUAJUCbq6FO5j4b73nEuCSt2SUZ2/9LtFptAVJuJu/a4l+axNv?=
 =?iso-8859-2?Q?j0rF2Nb2T2Bier+7vAsw+YixEJ71KkeyHmxGUtcFedU2Ux9v38+a5eDR6b?=
 =?iso-8859-2?Q?i8xSiayqHmuFNln8b0N7QSrbPRdjR9+bToX585bHsOUnMLqTclmMxvJ5ow?=
 =?iso-8859-2?Q?/d34suMcPSc9kNuXnvdqZvW/8/q2bv54aNlCg+9i3C3dXd6Uuf7RnfMk4c?=
 =?iso-8859-2?Q?QACr5B6957/XbltIGxds7xH351f+xMXDXGTQue9u8RwBuwwBvQ7+86/WO8?=
 =?iso-8859-2?Q?IU9qYwQpWf7HTAGUzf1+runhhRJcgTO7KaknL7Fgf0258OqHPuSPfUE/pW?=
 =?iso-8859-2?Q?ykiKldpuhsKcgytVdSo7N0tIqceEptzCuOPhwA4U3s6nGOrXWdQeqsJkJl?=
 =?iso-8859-2?Q?CLnxrtiTm6tNfSvsdQ99NwUoSkRSnp0BN2fAIxuPzbynY+TE7v1z9uEPnn?=
 =?iso-8859-2?Q?FmNHgh0/VT93JK1pL1TNYaLB+Z46ZDcUNV5uevOxwRYzhszrcU+GbECI+P?=
 =?iso-8859-2?Q?PQ5t7X0r8LHmd9dNxngxEmX42Dlnq5Jsto5cNzy8docJy4WbGwlyKthceo?=
 =?iso-8859-2?Q?CtJ3j/g0wpa7DB1KNbKs68ISHPkBhcksGiHq/IXGUJYb/m1e7vuUNLXlxM?=
 =?iso-8859-2?Q?xHh+btXAo7OPPjHwBV1z5MX6dspz9a+sIV5rIL9jvUaJGv45vmHqJ8GyVr?=
 =?iso-8859-2?Q?5AQSWtI+0I2mzl0LFoeS4wBhqi7PtUpP/lx0+w9140sBYm2PB890cFHGHb?=
 =?iso-8859-2?Q?WTywlkUtR4yJR1UYm1IW9rnAOAt4P9KB0o7PEMkhxTIdEuxz41pwcX1TmJ?=
 =?iso-8859-2?Q?AjfV8QsehgWMY07+E8eLoD5Xw2vTr7l+dY77bsmWPsoacGbZ0wr1tGk/3b?=
 =?iso-8859-2?Q?K+13g/7lQtgDp5M1PQdwFoCZ61zwMoNxvKWlx/AuVw5x5KB+NAk47rRJQQ?=
 =?iso-8859-2?Q?HSWp5UMq95R+udSL9LS2X3wFNfqkYN1ul8N1DkUoFAC0aWn79gaH2WyyXk?=
 =?iso-8859-2?Q?Ks54+oooxzibuy4VYW2f6q5AzLFnPIqL/doEgICXpk6fqj8vW8p3uv6B5w?=
 =?iso-8859-2?Q?/dC/aUonpyPQzchCw6wSPvS+HPHOHDFxiQuLlNKa2qG05XI23sdIPpW+ZE?=
 =?iso-8859-2?Q?aQEqmAwyqbqG3DvQbWkfDUEyXssvMkwnX/G8K+T3GOssSdQ=3D=3D?=
x-microsoft-antispam-prvs: <VI1PR0402MB28949BA4CE1A4DA5F02D4FF898720@VI1PR0402MB2894.eurprd04.prod.outlook.com>
x-forefront-prvs: 0967749BC1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(136003)(39860400002)(366004)(189003)(199004)(446003)(478600001)(8936002)(68736007)(6246003)(25786009)(6116002)(3846002)(6436002)(229853002)(55016002)(316002)(2906002)(53936002)(54906003)(9686003)(14454004)(110136005)(256004)(99286004)(81166006)(8676002)(81156014)(486006)(44832011)(6506007)(52536013)(105586002)(76176011)(74316002)(305945005)(97736004)(106356001)(7696005)(2501003)(102836004)(71190400001)(71200400001)(476003)(53546011)(4326008)(7736002)(4744005)(33656002)(6346003)(26005)(5660300002)(86362001)(66066001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2894;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ilp6AsOFanjDgdq0ZztklxQ17I2o2kbzXjAXlamyStJDKwk1ddhOZGOUs3MZzQrS7fzM9mKc6Fw1kEapue2yxY+kLbrf+Z++U+OJbSYww/y36BZmdjSdQOMnwQig0Mn3f3HZfAbOEeHb6uOdePRKrDe/rGQ3EPpHGHsIM8WYxN7ODW4JPJeABUxv7b84nGHVOSC9Yr/4UGyogdoaykDhTz254vJlxeQdbfJPc4oG9VXdQPMuXrlU1NK2sJOvQSPBYbd/ag94deuGA4q4IGeGqjwqJBc6CuSrgMTaHvYrOm5gg6GTJoSILr+V3QXHlKOcMGWlWDvKaGi4Is2gOJYN5sy27J8yuowSSRgC6UcKphgPWpy571lo8GpWP+NSSTbdDtkiZQPMtWMCWOw+c7xAlZs6l69NbzYjsYfVbs11XjY=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd27f2a-d969-4c22-8645-08d6a199407f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2019 18:34:50.3141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2894
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/5/2019 8:03 PM, Vakul Garg wrote:=0A=
> Instead of reading job ring's occupancy registers for every req/rsp=0A=
> enqueued/dequeued respectively, we read these registers once and store=0A=
> them in memory. After completing a job enqueue/dequeue, we decrement=0A=
> these values. When these values become zero, we refresh the snapshot of=
=0A=
> job ring's occupancy registers. This eliminates need of expensive device=
=0A=
> register read operations for every job enqueued and dequeued and hence=0A=
> makes caam_jr_enqueue() and caam_jr_dequeue() faster. The performance of=
=0A=
> kernel ipsec improved by about 6% on ls1028 (for frame size 408 bytes).=
=0A=
> =0A=
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
