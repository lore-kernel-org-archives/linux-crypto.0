Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E49C43603
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 12:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E80D5208C3
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 12:28:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="W0YAvDMi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfLJM2h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 07:28:37 -0500
Received: from mail-eopbgr50086.outbound.protection.outlook.com ([40.107.5.86]:18702
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727116AbfLJM2g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 07:28:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwpjU5X9FrKaT9upyJSj4F6aJ7E4eVREVIBwPqzaPXTXTIUYD77SGbRIRO9RWj3xBWJv087PhtgQFhrx3tiZiF0le0lLdYyNXnLaDR5Dm/LBk6oILsUtebO85+g7/mrrMhjzpafhItsTuB03OfUmxek06YVSNSvJjA7vlU1M3O564MrUkpgHicpIt2J7L5Cyw2XSAHF8URBEcyKHRyQR6owrJXUQsO/875PC/9ck89uULJuxQxkkB3UOtmu3tgyL20gh5RZszn5FV5Yn5t1+ey2928ERg0IgUWP3qV7ze75qWu0roFs5N9zLqoCf9ESUL0uKURcGHczemzwOxATlzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Y0Pv6HvicXWBqaUStQ+EbmeDQeBNrjIIgKW1xtGO2I=;
 b=NxEtHEwrrw/UlcCDNCUeeJEbkaALevxTwfCBy0b98G3m8OS33bQB7lSU+sJhND1mnVybv/Ssi608dlkxmbYKCQdsE2HrRHKcefCHLNJ5+xsVdgALWB1v6YiqhWbeZOLJirJSbLIGxHoeTohkz3Dr7syHUOIF2u249//Auqbco6uez0YJP9k4wS7FRZRZs5IctU2cZ5nqqnRvsOyeIkyUSCc/PXlAVOC/1Vw7IFlA+e9R8Ql/BpfDb2FVR9sxG39Y8wj2yli4ftsvQIhAQntjHmmaClabZfVd6wEX65FTl3/OhKU4voCJiSLy7NL1KQUv6qu44b9nF2HMTz/Y7jrT0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Y0Pv6HvicXWBqaUStQ+EbmeDQeBNrjIIgKW1xtGO2I=;
 b=W0YAvDMi0mqHd8ioPf1zeTgWOPzNwEVPA7caOpVMzr8T++tp/+mXeONBcuFoO+1t3m7cA0+Me+LT8lhQXyiv3/51Zs7qu44EukBuhJpPDKQXR7jjh+1vDO572DtdYNL07XUAAmc+i+S8YYmwiUb2zbphAYeI2F9HrUbqWfbBqHI=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4975.eurprd04.prod.outlook.com (20.177.51.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 12:28:29 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 12:28:29 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Bastian Krause <bst@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 06/12] crypto: caam - change return code in
 caam_jr_enqueue function
Thread-Topic: [PATCH 06/12] crypto: caam - change return code in
 caam_jr_enqueue function
Thread-Index: AQHVnZazAqjqlL3De02YIoYBT7QMrw==
Date:   Tue, 10 Dec 2019 12:28:29 +0000
Message-ID: <VI1PR04MB4445826D1424BF72A4C019B58C5B0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-7-git-send-email-iuliana.prodan@nxp.com>
 <705afee0-155b-2b6f-3b57-615a07fb7e4f@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 66ec7c5d-d1fe-46f8-938e-08d77d6c76c9
x-ms-traffictypediagnostic: VI1PR04MB4975:|VI1PR04MB4975:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4975D3DB79D2E89EC4C76EB88C5B0@VI1PR04MB4975.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(199004)(189003)(81166006)(81156014)(52536014)(8676002)(55016002)(7696005)(66946007)(76116006)(91956017)(9686003)(64756008)(86362001)(66556008)(71200400001)(66476007)(30864003)(8936002)(5660300002)(4326008)(44832011)(316002)(26005)(54906003)(33656002)(6636002)(110136005)(478600001)(2906002)(6506007)(53546011)(186003)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4975;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v0EhM0Rogh66WtXYE2eP+S/hyMAGvoz1PCoNpa8B1nMTFC3lYHdZz/RIFRfLCK/zxbI/BzNpgWIyJKITSQ5iZ/b++PM+utCxe+uRck8iksrC0VhNf84vJcDoQIdFxyABFJs0GdjNtmzjTFxEItQHZ1u3Dn8sFYoiO9CBjZlm4Uu6RQUfVgJKc/l3upKwOa/PeBlHpGJP29FQ5gnSesy0HGrvAKeCFtruzqXH5sxn2F4ng9om7cmCuzMEscMrsktoMDB2kx7L6213rUMZYPVoVsGNmBMw5zXQSI5xYBq6jPu2Mo9KN4N81PiNkq5y8ZYStyuW+epBeavHULS6zaj+PSEYB9eBd9EtS2jIqgNHAKsMk51tNznU4nYugxhjZ3/pWKKFKGBcz3H5uhd53mhVsIS4xODjD1y+AfG5iaj8cwR2FB1B5ZkfP3wxiArvZHJd
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ec7c5d-d1fe-46f8-938e-08d77d6c76c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 12:28:29.7807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m4ysh7dC5Niv2Rw4p5RSVvRrXxJfK3kcaCt6Wy0C42SAXmuPNdDb9QbjSJq9dP0aOBVt1Kc0ch8DOV1r1klCTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4975
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/10/2019 1:56 PM, Bastian Krause wrote:=0A=
> Hi,=0A=
> =0A=
> On 11/17/19 11:30 PM, Iuliana Prodan wrote:=0A=
>> Change the return code of caam_jr_enqueue function to -EINPROGRESS, in=
=0A=
>> case of success, -ENOSPC in case the CAAM is busy (has no space left=0A=
>> in job ring queue), -EIO if it cannot map the caller's descriptor.=0A=
>>=0A=
>> Update, also, the cases for resource-freeing for each algorithm type.=0A=
>>=0A=
>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
>> Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>> ---=0A=
>>   drivers/crypto/caam/caamalg.c  | 16 ++++------------=0A=
>>   drivers/crypto/caam/caamhash.c | 34 +++++++++++-----------------------=
=0A=
>>   drivers/crypto/caam/caampkc.c  | 16 ++++++++--------=0A=
>>   drivers/crypto/caam/caamrng.c  |  4 ++--=0A=
>>   drivers/crypto/caam/jr.c       |  8 ++++----=0A=
>>   drivers/crypto/caam/key_gen.c  |  2 +-=0A=
>>   6 files changed, 30 insertions(+), 50 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg=
.c=0A=
>> index 6e021692..21b6172 100644=0A=
>> --- a/drivers/crypto/caam/caamalg.c=0A=
>> +++ b/drivers/crypto/caam/caamalg.c=0A=
>> @@ -1417,9 +1417,7 @@ static inline int chachapoly_crypt(struct aead_req=
uest *req, bool encrypt)=0A=
>>   			     1);=0A=
>>   =0A=
>>   	ret =3D caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);=0A=
>> -	if (!ret) {=0A=
>> -		ret =3D -EINPROGRESS;=0A=
>> -	} else {=0A=
>> +	if (ret !=3D -EINPROGRESS) {=0A=
>>   		aead_unmap(jrdev, edesc, req);=0A=
>>   		kfree(edesc);=0A=
>>   	}=0A=
>> @@ -1462,9 +1460,7 @@ static inline int aead_crypt(struct aead_request *=
req, bool encrypt)=0A=
>>   =0A=
>>   	desc =3D edesc->hw_desc;=0A=
>>   	ret =3D caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);=0A=
>> -	if (!ret) {=0A=
>> -		ret =3D -EINPROGRESS;=0A=
>> -	} else {=0A=
>> +	if (ret !=3D -EINPROGRESS) {=0A=
>>   		aead_unmap(jrdev, edesc, req);=0A=
>>   		kfree(edesc);=0A=
>>   	}=0A=
>> @@ -1507,9 +1503,7 @@ static inline int gcm_crypt(struct aead_request *r=
eq, bool encrypt)=0A=
>>   =0A=
>>   	desc =3D edesc->hw_desc;=0A=
>>   	ret =3D caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);=0A=
>> -	if (!ret) {=0A=
>> -		ret =3D -EINPROGRESS;=0A=
>> -	} else {=0A=
>> +	if (ret !=3D -EINPROGRESS) {=0A=
>>   		aead_unmap(jrdev, edesc, req);=0A=
>>   		kfree(edesc);=0A=
>>   	}=0A=
>> @@ -1725,9 +1719,7 @@ static inline int skcipher_crypt(struct skcipher_r=
equest *req, bool encrypt)=0A=
>>   	desc =3D edesc->hw_desc;=0A=
>>   	ret =3D caam_jr_enqueue(jrdev, desc, skcipher_crypt_done, req);=0A=
>>   =0A=
>> -	if (!ret) {=0A=
>> -		ret =3D -EINPROGRESS;=0A=
>> -	} else {=0A=
>> +	if (ret !=3D -EINPROGRESS) {=0A=
>>   		skcipher_unmap(jrdev, edesc, req);=0A=
>>   		kfree(edesc);=0A=
>>   	}=0A=
>> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamha=
sh.c=0A=
>> index 5f9f16c..baf4ab1 100644=0A=
>> --- a/drivers/crypto/caam/caamhash.c=0A=
>> +++ b/drivers/crypto/caam/caamhash.c=0A=
>> @@ -422,7 +422,7 @@ static int hash_digest_key(struct caam_hash_ctx *ctx=
, u32 *keylen, u8 *key,=0A=
>>   	init_completion(&result.completion);=0A=
>>   =0A=
>>   	ret =3D caam_jr_enqueue(jrdev, desc, split_key_done, &result);=0A=
>> -	if (!ret) {=0A=
>> +	if (ret =3D=3D -EINPROGRESS) {=0A=
>>   		/* in progress */=0A=
>>   		wait_for_completion(&result.completion);=0A=
>>   		ret =3D result.err;=0A=
>> @@ -858,10 +858,8 @@ static int ahash_update_ctx(struct ahash_request *r=
eq)=0A=
>>   				     desc_bytes(desc), 1);=0A=
>>   =0A=
>>   		ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_bi, req);=0A=
>> -		if (ret)=0A=
>> +		if (ret !=3D -EINPROGRESS)=0A=
>>   			goto unmap_ctx;=0A=
>> -=0A=
>> -		ret =3D -EINPROGRESS;=0A=
>>   	} else if (*next_buflen) {=0A=
>>   		scatterwalk_map_and_copy(buf + *buflen, req->src, 0,=0A=
>>   					 req->nbytes, 0);=0A=
>> @@ -936,10 +934,9 @@ static int ahash_final_ctx(struct ahash_request *re=
q)=0A=
>>   			     1);=0A=
>>   =0A=
>>   	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);=0A=
>> -	if (ret)=0A=
>> -		goto unmap_ctx;=0A=
>> +	if (ret =3D=3D -EINPROGRESS)=0A=
>> +		return ret;=0A=
>>   =0A=
>> -	return -EINPROGRESS;=0A=
>>    unmap_ctx:=0A=
>>   	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_BIDIRECTIONAL);=0A=
>>   	kfree(edesc);=0A=
>> @@ -1013,10 +1010,9 @@ static int ahash_finup_ctx(struct ahash_request *=
req)=0A=
>>   			     1);=0A=
>>   =0A=
>>   	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);=0A=
>> -	if (ret)=0A=
>> -		goto unmap_ctx;=0A=
>> +	if (ret =3D=3D -EINPROGRESS)=0A=
>> +		return ret;=0A=
>>   =0A=
>> -	return -EINPROGRESS;=0A=
>>    unmap_ctx:=0A=
>>   	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_BIDIRECTIONAL);=0A=
>>   	kfree(edesc);=0A=
>> @@ -1086,9 +1082,7 @@ static int ahash_digest(struct ahash_request *req)=
=0A=
>>   			     1);=0A=
>>   =0A=
>>   	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done, req);=0A=
>> -	if (!ret) {=0A=
>> -		ret =3D -EINPROGRESS;=0A=
>> -	} else {=0A=
>> +	if (ret !=3D -EINPROGRESS) {=0A=
>>   		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);=0A=
>>   		kfree(edesc);=0A=
>>   	}=0A=
>> @@ -1138,9 +1132,7 @@ static int ahash_final_no_ctx(struct ahash_request=
 *req)=0A=
>>   			     1);=0A=
>>   =0A=
>>   	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done, req);=0A=
>> -	if (!ret) {=0A=
>> -		ret =3D -EINPROGRESS;=0A=
>> -	} else {=0A=
>> +	if (ret !=3D -EINPROGRESS) {=0A=
>>   		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);=0A=
>>   		kfree(edesc);=0A=
>>   	}=0A=
>> @@ -1258,10 +1250,9 @@ static int ahash_update_no_ctx(struct ahash_reque=
st *req)=0A=
>>   				     desc_bytes(desc), 1);=0A=
>>   =0A=
>>   		ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);=0A=
>> -		if (ret)=0A=
>> +		if (ret !=3D -EINPROGRESS)=0A=
>>   			goto unmap_ctx;=0A=
>>   =0A=
>> -		ret =3D -EINPROGRESS;=0A=
>>   		state->update =3D ahash_update_ctx;=0A=
>>   		state->finup =3D ahash_finup_ctx;=0A=
>>   		state->final =3D ahash_final_ctx;=0A=
>> @@ -1353,9 +1344,7 @@ static int ahash_finup_no_ctx(struct ahash_request=
 *req)=0A=
>>   			     1);=0A=
>>   =0A=
>>   	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done, req);=0A=
>> -	if (!ret) {=0A=
>> -		ret =3D -EINPROGRESS;=0A=
>> -	} else {=0A=
>> +	if (ret !=3D -EINPROGRESS) {=0A=
>>   		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);=0A=
>>   		kfree(edesc);=0A=
>>   	}=0A=
>> @@ -1452,10 +1441,9 @@ static int ahash_update_first(struct ahash_reques=
t *req)=0A=
>>   				     desc_bytes(desc), 1);=0A=
>>   =0A=
>>   		ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);=0A=
>> -		if (ret)=0A=
>> +		if (ret !=3D -EINPROGRESS)=0A=
>>   			goto unmap_ctx;=0A=
>>   =0A=
>> -		ret =3D -EINPROGRESS;=0A=
>>   		state->update =3D ahash_update_ctx;=0A=
>>   		state->finup =3D ahash_finup_ctx;=0A=
>>   		state->final =3D ahash_final_ctx;=0A=
>> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc=
.c=0A=
>> index ebf1677..7f7ea32 100644=0A=
>> --- a/drivers/crypto/caam/caampkc.c=0A=
>> +++ b/drivers/crypto/caam/caampkc.c=0A=
>> @@ -634,8 +634,8 @@ static int caam_rsa_enc(struct akcipher_request *req=
)=0A=
>>   	init_rsa_pub_desc(edesc->hw_desc, &edesc->pdb.pub);=0A=
>>   =0A=
>>   	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done, req);=0A=
>> -	if (!ret)=0A=
>> -		return -EINPROGRESS;=0A=
>> +	if (ret =3D=3D -EINPROGRESS)=0A=
>> +		return ret;=0A=
>>   =0A=
>>   	rsa_pub_unmap(jrdev, edesc, req);=0A=
>>   =0A=
>> @@ -667,8 +667,8 @@ static int caam_rsa_dec_priv_f1(struct akcipher_requ=
est *req)=0A=
>>   	init_rsa_priv_f1_desc(edesc->hw_desc, &edesc->pdb.priv_f1);=0A=
>>   =0A=
>>   	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);=
=0A=
>> -	if (!ret)=0A=
>> -		return -EINPROGRESS;=0A=
>> +	if (ret =3D=3D -EINPROGRESS)=0A=
>> +		return ret;=0A=
>>   =0A=
>>   	rsa_priv_f1_unmap(jrdev, edesc, req);=0A=
>>   =0A=
>> @@ -700,8 +700,8 @@ static int caam_rsa_dec_priv_f2(struct akcipher_requ=
est *req)=0A=
>>   	init_rsa_priv_f2_desc(edesc->hw_desc, &edesc->pdb.priv_f2);=0A=
>>   =0A=
>>   	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);=
=0A=
>> -	if (!ret)=0A=
>> -		return -EINPROGRESS;=0A=
>> +	if (ret =3D=3D -EINPROGRESS)=0A=
>> +		return ret;=0A=
>>   =0A=
>>   	rsa_priv_f2_unmap(jrdev, edesc, req);=0A=
>>   =0A=
>> @@ -733,8 +733,8 @@ static int caam_rsa_dec_priv_f3(struct akcipher_requ=
est *req)=0A=
>>   	init_rsa_priv_f3_desc(edesc->hw_desc, &edesc->pdb.priv_f3);=0A=
>>   =0A=
>>   	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);=
=0A=
>> -	if (!ret)=0A=
>> -		return -EINPROGRESS;=0A=
>> +	if (ret =3D=3D -EINPROGRESS)=0A=
>> +		return ret;=0A=
>>   =0A=
>>   	rsa_priv_f3_unmap(jrdev, edesc, req);=0A=
>>   =0A=
>> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng=
.c=0A=
>> index e8baaca..e3e4bf2 100644=0A=
>> --- a/drivers/crypto/caam/caamrng.c=0A=
>> +++ b/drivers/crypto/caam/caamrng.c=0A=
>> @@ -133,7 +133,7 @@ static inline int submit_job(struct caam_rng_ctx *ct=
x, int to_current)=0A=
>>   	dev_dbg(jrdev, "submitting job %d\n", !(to_current ^ ctx->current_buf=
));=0A=
>>   	init_completion(&bd->filled);=0A=
>>   	err =3D caam_jr_enqueue(jrdev, desc, rng_done, ctx);=0A=
>> -	if (err)=0A=
>> +	if (err !=3D EINPROGRESS)=0A=
> =0A=
> Shouldn't this be -EINPROGRESS ?=0A=
> =0A=
Yes, it should be -EINPROGRESS.=0A=
I'm working on a v2 and will update this, also.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
=0A=
>>   		complete(&bd->filled); /* don't wait on failed job*/=0A=
>>   	else=0A=
>>   		atomic_inc(&bd->empty); /* note if pending */=0A=
>> @@ -153,7 +153,7 @@ static int caam_read(struct hwrng *rng, void *data, =
size_t max, bool wait)=0A=
>>   		if (atomic_read(&bd->empty) =3D=3D BUF_EMPTY) {=0A=
>>   			err =3D submit_job(ctx, 1);=0A=
>>   			/* if can't submit job, can't even wait */=0A=
>> -			if (err)=0A=
>> +			if (err !=3D EINPROGRESS)=0A=
> =0A=
> And here the same?=0A=
> =0A=
> Regards,=0A=
> Bastian=0A=
> =0A=
>>   				return 0;=0A=
>>   		}=0A=
>>   		/* no immediate data, so exit if not waiting */=0A=
>> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c=0A=
>> index fc97cde..df2a050 100644=0A=
>> --- a/drivers/crypto/caam/jr.c=0A=
>> +++ b/drivers/crypto/caam/jr.c=0A=
>> @@ -324,8 +324,8 @@ void caam_jr_free(struct device *rdev)=0A=
>>   EXPORT_SYMBOL(caam_jr_free);=0A=
>>   =0A=
>>   /**=0A=
>> - * caam_jr_enqueue() - Enqueue a job descriptor head. Returns 0 if OK,=
=0A=
>> - * -EBUSY if the queue is full, -EIO if it cannot map the caller's=0A=
>> + * caam_jr_enqueue() - Enqueue a job descriptor head. Returns -EINPROGR=
ESS=0A=
>> + * if OK, -ENOSPC if the queue is full, -EIO if it cannot map the calle=
r's=0A=
>>    * descriptor.=0A=
>>    * @dev:  device of the job ring to be used. This device should have=
=0A=
>>    *        been assigned prior by caam_jr_register().=0A=
>> @@ -377,7 +377,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,=
=0A=
>>   	    CIRC_SPACE(head, tail, JOBR_DEPTH) <=3D 0) {=0A=
>>   		spin_unlock_bh(&jrp->inplock);=0A=
>>   		dma_unmap_single(dev, desc_dma, desc_size, DMA_TO_DEVICE);=0A=
>> -		return -EBUSY;=0A=
>> +		return -ENOSPC;=0A=
>>   	}=0A=
>>   =0A=
>>   	head_entry =3D &jrp->entinfo[head];=0A=
>> @@ -414,7 +414,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,=
=0A=
>>   =0A=
>>   	spin_unlock_bh(&jrp->inplock);=0A=
>>   =0A=
>> -	return 0;=0A=
>> +	return -EINPROGRESS;=0A=
>>   }=0A=
>>   EXPORT_SYMBOL(caam_jr_enqueue);=0A=
>>   =0A=
>> diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen=
.c=0A=
>> index 5a851dd..b0e8a49 100644=0A=
>> --- a/drivers/crypto/caam/key_gen.c=0A=
>> +++ b/drivers/crypto/caam/key_gen.c=0A=
>> @@ -108,7 +108,7 @@ int gen_split_key(struct device *jrdev, u8 *key_out,=
=0A=
>>   	init_completion(&result.completion);=0A=
>>   =0A=
>>   	ret =3D caam_jr_enqueue(jrdev, desc, split_key_done, &result);=0A=
>> -	if (!ret) {=0A=
>> +	if (ret =3D=3D -EINPROGRESS) {=0A=
>>   		/* in progress */=0A=
>>   		wait_for_completion(&result.completion);=0A=
>>   		ret =3D result.err;=0A=
>>=0A=
> =0A=
> =0A=
=0A=
