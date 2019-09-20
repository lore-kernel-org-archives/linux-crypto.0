Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB049C3A5A2
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 15:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 954AB20882
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 15:35:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="snLB+6cZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404034AbfITPfR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:35:17 -0400
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:16864
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404071AbfITPfR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 11:35:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXHq+xAQbrwuQ20h/ZKi8mD9VQGBsO63KnrHxHt8D3mm2fVA/pE/5E5ggBmi+E46Mger77UObY4uSu4RVFQTwj+pgot3Gl9wFuZz5fmpvzKopapdALw7P541/i+jkj07gIhuaF2UJZ921qXw+lLV5i08PID4D9P4z+8qkb9vtqleQKZ/xI1/5hUV7xeVCzh/HFV3lKQH5kj/rIgKHIk5557zTjMsK09yLuMZM0cjS+iMw/SAec4IaqvaURr/iFkIpe5OfiyS1Cxw75R/ENSRV7wodN1aZ6tOmwOGZZb5wTK972oo3WbTrNUYGKCsUDFEGTxqDQBad/f0mRlFqC7eCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LsiFeYlSNElQ9Qd3tvDYD78AWUCH4sz4eA52gQyBZ6E=;
 b=WuCpwQ9Jcyag9J2Wq8XUruWehpopb/fBFTvJKVB1g3xJlH9Kt0Dqd89gXbo16LI6CIbhQXe8kSkVArqxKOYWcYMME2NZwpIr4axoejvn1sKylqtT+xdMPE/30TCpcLMZiTtHdmaS97KpXJt00yF5wakvbMSpmGjz5ajlJCMo3Da+fi1VmuVbWiluf0nl9WnZHb4qjejP87c/KG1tU4vP18SIpTOKp7H7XFt8f/20QHCGQuSzD1X4YF6qc1Krjz5jdNEt2tMBLU1ug1Nsw9ydjRVNUXSjvBQCrBY089BpIOPFvBOXz/9WWgDuuYgGai7ZptVzYEkSGGu2hZS+zTCWuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LsiFeYlSNElQ9Qd3tvDYD78AWUCH4sz4eA52gQyBZ6E=;
 b=snLB+6cZ+GHw60sXZ+ZBzSvNDEPnA6Kn+0C9qVjM2JgIggyyz4hPMtcE+7MPRJ103il1DqQDKrFz2ppa2rxqZGQgsA/SYLSqzKHSOXEn8Va6O8Eij/kUv50tzIgFzpr6rfJyDn5blGSAApwp434JZmreTQbr4m7py5xAtHemDvA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3792.eurprd04.prod.outlook.com (52.134.16.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.23; Fri, 20 Sep 2019 15:35:14 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::70b4:7829:2e8e:1196]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::70b4:7829:2e8e:1196%7]) with mapi id 15.20.2263.023; Fri, 20 Sep 2019
 15:35:14 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/12] crypto: caam - populate platform devices last
Thread-Topic: [PATCH 10/12] crypto: caam - populate platform devices last
Thread-Index: AQHVYsl10q9huA5nekC38LfZsQ11ew==
Date:   Fri, 20 Sep 2019 15:35:13 +0000
Message-ID: <VI1PR0402MB3485D61A50108A58FCAEF20098880@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-11-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82404500-2261-42ba-995a-08d73de0218d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3792;
x-ms-traffictypediagnostic: VI1PR0402MB3792:|VI1PR0402MB3792:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3792A8CF1B04323C8B71040198880@VI1PR0402MB3792.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:494;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(189003)(199004)(14454004)(91956017)(2906002)(81166006)(8676002)(33656002)(8936002)(81156014)(2501003)(6436002)(86362001)(486006)(44832011)(5660300002)(6116002)(446003)(4744005)(229853002)(52536014)(476003)(3846002)(54906003)(26005)(4326008)(186003)(316002)(7736002)(74316002)(110136005)(305945005)(66066001)(71190400001)(71200400001)(7696005)(6246003)(76176011)(9686003)(478600001)(55016002)(76116006)(99286004)(102836004)(256004)(64756008)(66946007)(25786009)(6506007)(66556008)(66446008)(53546011)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3792;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xOQEnp500Gld/xm8Ma1BaMJsFEoEQBE4pfikPoN68wwwwENk9C870AoaSZsxfHTeDys9/rJ8spzDpqpBVMkuFyyw/PNgK/oMTE4pCZlXtE20/deCwV5P/KclzGTVnUKvVpT16Lf4IioGX8tc66RnxXPBXtzqD6dtL8Nfq0TS9iliZxdEMQrApBPtogp2bW1S4RfWHMR/ig+puFtdjpHBEmtgX/MTutdh/qrr39B0e0J/nHjof7PpssaZJflYq1zyvZ7uTxkOq81O6Is/5nW1Is3P8ZIvb4cgK9OTQNilQiWU8Hg8JSU5JLbmALKzOj0aRewVWMgurKleWlJqLzjMbM1TUbfFnmvGMhx56MnrugtAH27t9mBdsEO4VRshZ9ifKEqV4BHhOcXRK6aDzl2nN3HLTRwscKmqMByhOy+34AE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82404500-2261-42ba-995a-08d73de0218d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 15:35:13.9062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iQYhbREhg7AQr9TkiFFH+t9O1rLKJIa7a8Wm0vwJzaevRRjCK6pCkfQ+DR0rUbygUfrMp6TybaCrevA9oWO5yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3792
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/4/2019 5:35 AM, Andrey Smirnov wrote:=0A=
> @@ -906,6 +900,13 @@ static int caam_probe(struct platform_device *pdev)=
=0A=
>  	debugfs_create_blob("tdsk", S_IRUSR | S_IRGRP | S_IROTH, ctrlpriv->ctl,=
=0A=
>  			    &ctrlpriv->ctl_tdsk_wrap);=0A=
>  #endif=0A=
> +=0A=
> +	ret =3D devm_of_platform_populate(dev);=0A=
> +	if (ret) {=0A=
> +		dev_err(dev, "JR platform devices creation error\n");=0A=
> +		return ret;=0A=
> +	}=0A=
> +=0A=
>  	return 0;=0A=
>  }=0A=
This is a bit better:=0A=
=0A=
	if (ret)=0A=
		dev_err(dev, "JR platform devices creation error\n");=0A=
=0A=
	return ret;=0A=
=0A=
Horia=0A=
