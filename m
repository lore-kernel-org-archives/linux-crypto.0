Return-Path: <SRS0=KDyu=3C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA58C33CAD
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jan 2020 13:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 121B42081E
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jan 2020 13:07:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="i6cE0Wal"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgAMNHF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jan 2020 08:07:05 -0500
Received: from mail-eopbgr50062.outbound.protection.outlook.com ([40.107.5.62]:38390
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726593AbgAMNHF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jan 2020 08:07:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7ACKgBgjHfmglI1HGWV8qrcDluPKgiAQD5YMtv0PQCT04sKwwYB/S2i9uNJBzwGda7WumZMTAxQCUlJlWGJuk6/4H/Cb9vT5h2+rsVB8tbJ9OnpFg6dkNrT8n1qhqyWSsCFZMyuXUMGV1aE2toQ46RnWysBqLlbdKr2Yt1QN+JMuzzr//qdN+faY3LsPTviJ6PrqIW85oCCrnUTzzyqoPk+A+jH5ah3d0//jho6xbWFi90gen42V8lR9YCwQiFRbmoMCcjd3P4kpBd15u9c/5t9c+yEQCrJM5c4KF61vUjw/8CyZ4sQzH16M9VLHO+DuwBlh0Ql03T3qb6aqWrlWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcERSi2zefvTsZEqtTdGXK8f3Rwxr7eUPiNMIwv1jcQ=;
 b=Ec1qOWbZbez7qxRWtLQZ0UQKuO0h7LWkvamketBuH2xbpn3OMQHqy6bqQpYeC6hZeXqcX0/bhcG04OQ8UwTiHnkrNLr2MootPmz8zV5k8ZP9440kK2RRuvpjIfShMDEuFcvlnjG+q7JTngjd3idpwAv0LIbEYXrq5L+0+cydLVpbihL9+57hHIKscDQSMapYECyFQnGk785793+kapIg8OckOMegbT0yd3felWQUjMERm8xFB1u0yZyl08BpoESoz98NXjwtxLHTCxkZEcWJOAEvRlxZpe/D304Jsx3wlZJtOkt59Gpc75EFzM7T1SOuvxasZ85LyUcYrOUzEcNn1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcERSi2zefvTsZEqtTdGXK8f3Rwxr7eUPiNMIwv1jcQ=;
 b=i6cE0WalX3NdmrFk+U1PpVPmK7kpRPaU+N7GpW5Yrz/zme60E+HKzkE7W43sibb+DtGovAK+ZEieLhlAjz44SJ07Y3sDNixnjflZ15IROXRqjgaqoQkmMaCiGGleLq3AZYg0AmHL7JfQH/LZ02pHQiUow+57PB6Z9R4ONAgw/kw=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4911.eurprd04.prod.outlook.com (20.177.49.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Mon, 13 Jan 2020 13:06:21 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 13:06:21 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 09/10] crypto: caam - add crypto_engine support for RSA
 algorithms
Thread-Topic: [PATCH v2 09/10] crypto: caam - add crypto_engine support for
 RSA algorithms
Thread-Index: AQHVwdGq8oNojU3+Pkqj8F8q9Ip8Bw==
Date:   Mon, 13 Jan 2020 13:06:21 +0000
Message-ID: <VI1PR04MB4445B8ECE7BBF2E64A486FBB8C350@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
 <1578013373-1956-10-git-send-email-iuliana.prodan@nxp.com>
 <VI1PR0402MB3485162217C242B16CF1371B98380@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <VI1PR04MB44452FF06F35075413CF87F88C350@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <VI1PR0402MB3485EE10F3200D7E7EE1EBA698350@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4accdb92-897b-427b-8f2b-08d7982962eb
x-ms-traffictypediagnostic: VI1PR04MB4911:|VI1PR04MB4911:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB49111AC0A723C1144B826CFF8C350@VI1PR04MB4911.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(189003)(199004)(4326008)(7696005)(52536014)(5660300002)(86362001)(6636002)(8936002)(478600001)(8676002)(55016002)(81156014)(54906003)(110136005)(9686003)(81166006)(316002)(6506007)(53546011)(66476007)(66446008)(2906002)(33656002)(26005)(44832011)(186003)(71200400001)(66946007)(76116006)(91956017)(66556008)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4911;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +OV+5IcLX41YS5DluKywiDJf/zmmSySPiyIVQiuNRUQZ6C2ubD2Mc+ydsXmMzOgi2BaHEOV/gsapecXanFTXSebBJYjJXrU2kattG+xcxgaC1BDaJ7LuH+CZgJ6YSEvyaEHUUaceYmQbiR8r/HnjygU+jBIsWYovGGTU9wP4R4IrdFwUWbeAK/VlFnuqpEyLooXwrvianLTKXDt2a9lYPmbylz3uX0ne5ypnNDzgTFsXKNNyrBHky++zwbV3W+DS+15aFNO/VUopYaEDyOj6iu+i8/O7098cGzeIXuf2OKhUDpFYF/hJs+7L5IUS2FxygY6MwT1VuhnzecyRgU8nFsjquv5BTYEv24hzB590WK2RiIv8bVkbQjtIM5jzMtVilabT9c7H9wwkH80e5lBK7/UXm5cSfHwZ+eNLeNcfpbULAAH4nf5MmEppvSJC0on/
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4accdb92-897b-427b-8f2b-08d7982962eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 13:06:21.5791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DaHtyHkWUT9jZE5pbj5ukbFiOxdp2TAXBuYuCmaEDgr5XpX3Zxn7nZ4UN65KKIanCaB+14RSmma+nM2wTj+p3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4911
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/13/2020 2:21 PM, Horia Geanta wrote:=0A=
> On 1/13/2020 11:48 AM, Iuliana Prodan wrote:=0A=
>> On 1/10/2020 10:46 AM, Horia Geanta wrote:=0A=
>>> On 1/3/2020 3:03 AM, Iuliana Prodan wrote:=0A=
>>>> +static int akcipher_enqueue_req(struct device *jrdev, u32 *desc,=0A=
>>>> +				void (*cbk)(struct device *jrdev, u32 *desc,=0A=
>>>> +					    u32 err, void *context),=0A=
>>>> +				struct akcipher_request *req,=0A=
>>>> +				struct rsa_edesc *edesc)=0A=
>>>> +{=0A=
>>>> +	struct caam_drv_private_jr *jrpriv =3D dev_get_drvdata(jrdev);=0A=
>>>> +	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);=0A=
>>>> +	struct caam_rsa_ctx *ctx =3D akcipher_tfm_ctx(tfm);=0A=
>>>> +	struct caam_rsa_key *key =3D &ctx->key;=0A=
>>>> +	int ret;=0A=
>>>> +=0A=
>>>> +	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)=0A=
>>>> +		return crypto_transfer_akcipher_request_to_engine(jrpriv->engine,=
=0A=
>>>> +								  req);=0A=
>>> Resource leak in case transfer fails.=0A=
>>>=0A=
>>>> +	else=0A=
>>>> +		ret =3D caam_jr_enqueue(jrdev, desc, cbk, &edesc->jrentry);=0A=
>>> What's the problem with transferring all requests to crypto engine?=0A=
>>>=0A=
>> I'll address all your comments in v3.=0A=
>>=0A=
>> Regarding the transfer request to crypto-engine: if sending all requests=
=0A=
>> to crypto-engine, multibuffer tests, for non-backlogging requests fail=
=0A=
>> after only 10 requests, since crypto-engine queue has 10 entries.=0A=
>> Here's an example:=0A=
>> root@imx6qpdlsolox:~# insmod tcrypt.ko mode=3D422 num_mb=3D1024=0A=
>> insmod: ERROR: could not insert module tcrypt.ko: Resource temporarily=
=0A=
>> unavailable=0A=
>> root@imx6qpdlsolox:~#=0A=
>> root@imx6qpdlsolox:~# dmesg=0A=
>> ...=0A=
>> testing speed of multibuffer sha1 (sha1-caam)=0A=
>> tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):=
=0A=
>> tcrypt: concurrent request 11 error -28=0A=
>> tcrypt: concurrent request 13 error -28=0A=
>> tcrypt: concurrent request 14 error -28=0A=
>> tcrypt: concurrent request 16 error -28=0A=
>> tcrypt: concurrent request 18 error -28=0A=
>> tcrypt: concurrent request 20 error -28=0A=
>> tcrypt: concurrent request 22 error -28=0A=
>> tcrypt: concurrent request 24 error -28=0A=
>> tcrypt: concurrent request 26 error -28=0A=
>> tcrypt: concurrent request 28 error -28=0A=
>> tcrypt: concurrent request 30 error -28=0A=
>> tcrypt: concurrent request 32 error -28=0A=
>> tcrypt: concurrent request 34 error -28=0A=
>>=0A=
>> tcrypt: concurrent request 1020 error -28=0A=
>> tcrypt: concurrent request 1022 error -28=0A=
>> tcrypt: At least one hashing failed ret=3D-28=0A=
>> root@imx6qpdlsolox:~#=0A=
>>=0A=
>> If sending just the backlog request to crypto-engine, and non-blocking=
=0A=
>> directly to CAAM, these tests have a better chance to pass since JR has=
=0A=
>> 1024 entries.=0A=
>>=0A=
>> Will need to work/update crypto-engine: set queue length when initialize=
=0A=
>> crypto-engine, and remove serialization of requests in crypto-engine.=0A=
>> But, until then, I would like to have a backlogging solution in CAAM dri=
ver.=0A=
>>=0A=
> My point is you need to add details about the current limitations=0A=
> in the commit message (even in the source code, it wouldn't hurt),=0A=
> justifying the choice of not using crypto engine for all requests.=0A=
> =0A=
Yes, I understand your point and, as I mentioned above, I'll address all =
=0A=
comments, from all patches, in v3:=0A=
- update commit messages;=0A=
- handle resource leak in case of crypto-engine transfer;=0A=
- remove unnecessary variables, in some structs;=0A=
- will remove patch #6.=0A=
=0A=
Iulia=0A=
