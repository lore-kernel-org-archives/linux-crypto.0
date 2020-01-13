Return-Path: <SRS0=KDyu=3C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1EDC33CA8
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jan 2020 09:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 763B22075B
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jan 2020 09:48:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="OUlKM8ns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgAMJsP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jan 2020 04:48:15 -0500
Received: from mail-eopbgr60086.outbound.protection.outlook.com ([40.107.6.86]:9127
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726133AbgAMJsP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jan 2020 04:48:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvnBGQuy5M6jT6sK/OJi5LNsNi9ImR9VepO6Rd1/bhuCEdpckjNy8GYindT1zbmxki44+n7d+u6pbAo5F0pc5b0ngsxzyqKmvNOdYMwxlWb6aV49hYsQO96I5JGeedEpGS8ylre95Jx7bIsEfD1GeTIHWMXo08FPRgZbtZk7dKTA5LQbLeu9+UeyjYyB1dJOXgFnNCZm5Qi1z6AEFK9f3BWmqBBY4TKlATSpRLCijSCbcNiGES2JV970+IeFObbBfiHL7X6E1DhmHmn69H9FFqCZu71jKojJ3Z8mQIITnlo5qoc77KoXTZ6GyscdpUCqzF5lkpvmrnSFVQyZQigosA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+4XjqEErXiPa8CUhqEeWXWeV27ntMqeYON1iquokMk=;
 b=nEP38vQ8pTvNZnfZ7PKETTRiJ8irYL9Pmdgyz7XeNRRusZWCS8gKuMbdb2yyIMCw1+2nv60KpEez+rDygWsCyfPhxwPr15E7YQGOfXw8LbWcLAX8GAWfSzXHPXgagwMA7Hr7qwBP24MqJf4csfJbkqrOA4GM6xSTWPC5u+PImrGdHpf2eBDSqwqqck1Ao3167O5wPbg3iv8g1NJSkBum3T7sqZ5Aht2y5/Gc/OvUyOcwJup1bzHQ6HRZbIdmoghb50TRcPSOcdUHgnIoBYKWzQfafSA6GpC7ulnJEbqd/Gb8oK5qrJZq0CAeGLeVBn5N8immk1k896wtNlPm8CB0bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+4XjqEErXiPa8CUhqEeWXWeV27ntMqeYON1iquokMk=;
 b=OUlKM8ns6NWvngB+pmyb7HE3xkZEHGlVuqm1BBduETbInU/WuOQeUTdZfzyAFAuXLnVQI26F71Auj8OLF+nrU3Nz7jgNcha9E2pFZUON6jPg1FcHx97y9Mk2U1gDVmsPOfp5F43jwkT6HTMrN6ymm3qHLzQ/ZoZiZqKHi1pweJ4=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4431.eurprd04.prod.outlook.com (20.177.55.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Mon, 13 Jan 2020 09:48:11 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 09:48:11 +0000
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
Date:   Mon, 13 Jan 2020 09:48:11 +0000
Message-ID: <VI1PR04MB44452FF06F35075413CF87F88C350@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
 <1578013373-1956-10-git-send-email-iuliana.prodan@nxp.com>
 <VI1PR0402MB3485162217C242B16CF1371B98380@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15eb61f2-b022-4454-693e-08d7980db3c8
x-ms-traffictypediagnostic: VI1PR04MB4431:|VI1PR04MB4431:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB44314EA7439BD4E94B826A978C350@VI1PR04MB4431.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(189003)(199004)(55016002)(53546011)(6506007)(8936002)(86362001)(5660300002)(9686003)(4326008)(6636002)(81156014)(81166006)(8676002)(7696005)(2906002)(186003)(316002)(52536014)(71200400001)(478600001)(33656002)(66946007)(64756008)(54906003)(66476007)(66556008)(44832011)(66446008)(91956017)(110136005)(26005)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4431;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7AIU79BNg1Zcot9JcZiTLdbeieOK7b25pmmAtuKwAgPPw0vbRhY0U/iUY9x4FcbmUPjEukYJZJCbPJa5ku88NvR3pwRB38gYc4kyTTmLWGtLC729iN0S5HgVM7TMmzTuuHhOKKYR2dCD0jBkcyERU/WBZ2hZEjMuA2vfoI3QzFSHhYoDvywnnfdcnF3GOE6br/snEgt4wP8sKRWpdp+yT38jjYudInLjVq7e5T0myCM2LWjng8liLQro82aUaQgOb0FMwENq6RuteOL5FgU5gs0ATI4SJYzXUnbzTj+Lzw0RSkuONKLTkntlzuFaMw7zjPrYtL0YhKjLfnKq5OTDRzp4ShjQJV1hbSWtbnlAEv80KjI4Supk3N3zbE5v0bbSUfepH82tOT00fZ9it2mv3RkET7zXtWsKJFkIz4DYNvk2JGhhVHrmQ0O1Z1f7GU1e
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15eb61f2-b022-4454-693e-08d7980db3c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 09:48:11.2957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BZMmehiujCUgEgRkKuYb/udvxXa3E0pXTK/J/q5ubbdV0oB71HFseoMfe0Pulj4BfGu0LDGv/yRVmrrpkkcyuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4431
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/10/2020 10:46 AM, Horia Geanta wrote:=0A=
> On 1/3/2020 3:03 AM, Iuliana Prodan wrote:=0A=
>> +static int akcipher_enqueue_req(struct device *jrdev, u32 *desc,=0A=
>> +				void (*cbk)(struct device *jrdev, u32 *desc,=0A=
>> +					    u32 err, void *context),=0A=
>> +				struct akcipher_request *req,=0A=
>> +				struct rsa_edesc *edesc)=0A=
>> +{=0A=
>> +	struct caam_drv_private_jr *jrpriv =3D dev_get_drvdata(jrdev);=0A=
>> +	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);=0A=
>> +	struct caam_rsa_ctx *ctx =3D akcipher_tfm_ctx(tfm);=0A=
>> +	struct caam_rsa_key *key =3D &ctx->key;=0A=
>> +	int ret;=0A=
>> +=0A=
>> +	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)=0A=
>> +		return crypto_transfer_akcipher_request_to_engine(jrpriv->engine,=0A=
>> +								  req);=0A=
> Resource leak in case transfer fails.=0A=
> =0A=
>> +	else=0A=
>> +		ret =3D caam_jr_enqueue(jrdev, desc, cbk, &edesc->jrentry);=0A=
> What's the problem with transferring all requests to crypto engine?=0A=
> =0A=
I'll address all your comments in v3.=0A=
=0A=
Regarding the transfer request to crypto-engine: if sending all requests =
=0A=
to crypto-engine, multibuffer tests, for non-backlogging requests fail =0A=
after only 10 requests, since crypto-engine queue has 10 entries.=0A=
Here's an example:=0A=
root@imx6qpdlsolox:~# insmod tcrypt.ko mode=3D422 num_mb=3D1024=0A=
insmod: ERROR: could not insert module tcrypt.ko: Resource temporarily =0A=
unavailable=0A=
root@imx6qpdlsolox:~#=0A=
root@imx6qpdlsolox:~# dmesg=0A=
...=0A=
testing speed of multibuffer sha1 (sha1-caam)=0A=
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):=0A=
tcrypt: concurrent request 11 error -28=0A=
tcrypt: concurrent request 13 error -28=0A=
tcrypt: concurrent request 14 error -28=0A=
tcrypt: concurrent request 16 error -28=0A=
tcrypt: concurrent request 18 error -28=0A=
tcrypt: concurrent request 20 error -28=0A=
tcrypt: concurrent request 22 error -28=0A=
tcrypt: concurrent request 24 error -28=0A=
tcrypt: concurrent request 26 error -28=0A=
tcrypt: concurrent request 28 error -28=0A=
tcrypt: concurrent request 30 error -28=0A=
tcrypt: concurrent request 32 error -28=0A=
tcrypt: concurrent request 34 error -28=0A=
=0A=
tcrypt: concurrent request 1020 error -28=0A=
tcrypt: concurrent request 1022 error -28=0A=
tcrypt: At least one hashing failed ret=3D-28=0A=
root@imx6qpdlsolox:~#=0A=
=0A=
If sending just the backlog request to crypto-engine, and non-blocking =0A=
directly to CAAM, these tests have a better chance to pass since JR has =0A=
1024 entries.=0A=
=0A=
Will need to work/update crypto-engine: set queue length when initialize =
=0A=
crypto-engine, and remove serialization of requests in crypto-engine. =0A=
But, until then, I would like to have a backlogging solution in CAAM driver=
.=0A=
=0A=
Iulia=0A=
=0A=
>> +=0A=
>> +	if (ret !=3D -EINPROGRESS) {=0A=
>> +		switch (key->priv_form) {=0A=
>> +		case FORM1:=0A=
>> +			rsa_priv_f1_unmap(jrdev, edesc, req);=0A=
>> +			break;=0A=
>> +		case FORM2:=0A=
>> +			rsa_priv_f2_unmap(jrdev, edesc, req);=0A=
>> +			break;=0A=
>> +		case FORM3:=0A=
>> +			rsa_priv_f3_unmap(jrdev, edesc, req);=0A=
>> +			break;=0A=
>> +		default:=0A=
>> +			rsa_pub_unmap(jrdev, edesc, req);=0A=
>> +		}=0A=
>> +		rsa_io_unmap(jrdev, edesc, req);=0A=
>> +		kfree(edesc);=0A=
>> +	}=0A=
>> +=0A=
>> +	return ret;=0A=
>> +}=0A=
>> +=0A=
>>   static int caam_rsa_enc(struct akcipher_request *req)=0A=
>>   {=0A=
>>   	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);=0A=
>>   	struct caam_rsa_ctx *ctx =3D akcipher_tfm_ctx(tfm);=0A=
>> +	struct caam_rsa_req_ctx *req_ctx =3D akcipher_request_ctx(req);=0A=
>>   	struct caam_rsa_key *key =3D &ctx->key;=0A=
>>   	struct device *jrdev =3D ctx->dev;=0A=
>>   	struct rsa_edesc *edesc;=0A=
>> @@ -637,13 +726,9 @@ static int caam_rsa_enc(struct akcipher_request *re=
q)=0A=
>>   	/* Initialize Job Descriptor */=0A=
>>   	init_rsa_pub_desc(edesc->hw_desc, &edesc->pdb.pub);=0A=
>>   =0A=
>> -	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done,=0A=
>> -			      &edesc->jrentry);=0A=
>> -	if (ret =3D=3D -EINPROGRESS)=0A=
>> -		return ret;=0A=
>> -=0A=
>> -	rsa_pub_unmap(jrdev, edesc, req);=0A=
>> -=0A=
>> +	req_ctx->akcipher_op_done =3D rsa_pub_done;=0A=
> This initialization could be moved into akcipher_enqueue_req().=0A=
> =0A=
>> +	return akcipher_enqueue_req(jrdev, edesc->hw_desc, rsa_pub_done,=0A=
>> +				    req, edesc);=0A=
> edesc, edesc->hw_desc parameters not needed - can be deduced internally=
=0A=
> via req -> req_ctx -> edesc- > hw_desc.=0A=
> =0A=
> Horia=0A=
> =0A=
=0A=
