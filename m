Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2EFC76190
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 06:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEC22223A1
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 06:14:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="swxZ2B36"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388167AbfGWGOr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 02:14:47 -0400
Received: from mail-eopbgr40086.outbound.protection.outlook.com ([40.107.4.86]:52967
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388149AbfGWGOq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 02:14:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AI/9BQFY2lDBk6CMM6KEvIKh4XvgEbSvP2O9WUsYDGdWQGKbIuYwE71i1/LjCHEmLPWWalR+fZ1DZQte2ppZgg2kPGhFZbUaAxLkoFLXmapvoZUUNKnAh9jqZTlw5NBFOofK3K0H6rE0wneDu8MDPOpES/RHsLbeMOgTZGUvC82PvieBbIi4HlekUs81ol55+ezaocl4LTgR+jgQSob9EEYZBhyiZLY4KwYqq3bJ6Yl+m8NMhW8cYzUcb0R9om0y679IJ8ufLEU823r7DLg2gLPUd9hGw7ivnxCTDl4NdB7i84sYNcZdKSpRqIe5ziSgv3khN/U4UIpZDGMMosCk4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKLTZOG5SegjLKMtMrezMtUYYA9YdvreEy4bqTKYG8s=;
 b=RWBr0Flmi+lbYg+ZDQuuMOrK0bbne7EyH8HU/3/b+Xo5l6h6ycEz+71ZWEm18QPCjQn8l54LY4Zj10dipb6Q7PcDiKldkw99KO9kI0Sb9QJyhtaLiZ4hGaYtWnzu83PzVqDAIRMC8dj9mDlnnlDtkWxB/8BWm3pmjhgIOwvhRpyMB5c+zQGOSXmDAurknKLf+PX+cVyE4FWj2ItzU+qVqN6zQfekWxYe3RKiy1sSvnIKb/U6UnwO8SHd+RwZ5Bf2WFVsmgn/jhTDgK9zWHliLABxLYOVaO6NNHFivcJscIaala2DsxMp6xZxA4aurQkzh3WwUp4H9eJZ1PjcPYQ43g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKLTZOG5SegjLKMtMrezMtUYYA9YdvreEy4bqTKYG8s=;
 b=swxZ2B363gJRX+NMCHK8FokW1OH0m6NBWCwIa5M0tWzhCBtIkZB1D8EaZ2pndAVHM9kRrqKwtjIh4wADrhDOkiSOLJdTnKuObhTmLc117FyyLlQ3n8kqm+XFl80bTqeZtv8vpUxMu9JccmbWURUtPgQWIutnQYQY6oI+Z06ZZfo=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3486.eurprd04.prod.outlook.com (52.134.4.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 23 Jul 2019 06:14:44 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 23 Jul 2019
 06:14:44 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVPiRTTO5nYvxvX0qf2jZsStExEA==
Date:   Tue, 23 Jul 2019 06:14:43 +0000
Message-ID: <VI1PR0402MB34854E7762F7A602F322003B98C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190719111821.21696-1-vakul.garg@nxp.com>
 <AM0PR0402MB3476F392D3A791DDE2F5B67898C40@AM0PR0402MB3476.eurprd04.prod.outlook.com>
 <DB7PR04MB46203BDE7B36E66FCD5D03D08BC70@DB7PR04MB4620.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98630e20-fc6d-4e3c-5806-08d70f350e1a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3486;
x-ms-traffictypediagnostic: VI1PR0402MB3486:
x-microsoft-antispam-prvs: <VI1PR0402MB3486005F84D9E80E80B696A998C70@VI1PR0402MB3486.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(199004)(189003)(99286004)(33656002)(14454004)(53546011)(26005)(6506007)(256004)(54906003)(6246003)(53936002)(2906002)(486006)(316002)(110136005)(229853002)(81156014)(44832011)(66946007)(81166006)(8936002)(76176011)(186003)(8676002)(102836004)(7696005)(4326008)(6436002)(2501003)(25786009)(74316002)(86362001)(66476007)(64756008)(5660300002)(66446008)(446003)(305945005)(66066001)(66556008)(52536014)(476003)(71190400001)(71200400001)(6116002)(478600001)(68736007)(76116006)(55016002)(7736002)(9686003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3486;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f7M/pLobOwN6cGdMm2xePULgGn4YT6AK2sVIpyaZ4cAq2DAZYeD6MzEcWtQiCq2bFBV3Ful/CjtavYK/SGRf9JAC4G80Y3mW5DW/UaixCn23diSrTuv12PdOgO8eapUPKbHOTl+KZVH9at5fuiWNiIa0aG+8xpvd4KtTa2duHB07XFjOtXxC2tB5cxhePT3Nt2eIE/PsyABTKzzC6aLihk6s9Nir8gyvK47w5ytF+HPPtJt9D/NDh1BKK83uneU3p/22C2fVhzxQGwdRu2g0uai1OnUbl5tbN0gK5FjSO6hRVC8DCiY5h49AGz6X30PHJWiHZa/7ddI+ztEQtxInzratIeVZzAeu+PE0xcznWci3OvKEIrcJAJdDV0QKD2aQYTBfPltzAXeBVsv+9e7pdbANUSZr58ukqKLOH3pq3Cw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98630e20-fc6d-4e3c-5806-08d70f350e1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 06:14:43.9316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3486
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/23/2019 4:20 AM, Vakul Garg wrote:=0A=
>>> @@ -64,6 +65,7 @@ struct dpaa2_caam_priv {=0A=
>>>  	struct iommu_domain *domain;=0A=
>>>=0A=
>>>  	struct dpaa2_caam_priv_per_cpu __percpu *ppriv;=0A=
>>> +	struct dentry *dfs_root;=0A=
>> dfs_root is used only in dpseci-debugfs.c, let's have it there as global=
.=0A=
>>=0A=
> =0A=
> I submitted this change in v3. There is still a minor issue with this pat=
ch version. =0A=
> Before submitting the next v4, I have a question.=0A=
> =0A=
> Could there be a situation that there are multiple  dpseci objects assign=
ed to kernel?=0A=
In theory, yes.=0A=
fsl-mc, the bus dpseci devices sit on, allows for multiple instances.=0A=
=0A=
However, caam/qi2 (driver for dpseci devices) doesn't have support=0A=
for this.=0A=
For e.g., all dpseci instances would try to register the algorithms using=
=0A=
the same name & driver name - something that will trigger an error=0A=
in crypto API.=0A=
This could be easily fixed, however the real issue is that=0A=
there is no load balancing support - neither at crypto API level=0A=
nor at driver level.=0A=
=0A=
> In that case, we need to maintain dfs_root for each separately.=0A=
>  =0A=
Ok, let's keep dfs_root per device.=0A=
For now this has no practical value, but at least makes the work easier=0A=
in case load balancing support is added at some point.=0A=
=0A=
Horia=0A=
