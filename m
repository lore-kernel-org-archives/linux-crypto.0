Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E05C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 22:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0F1E223CA
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 22:49:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="h618PEMa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKSWtc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 17:49:32 -0500
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:65252
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbfKSWtb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 17:49:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=duxVMdxFudyz+sFGGZfaeMDbiQSNuZkkfNQGYK4o/9lqxjPf7nDrJ5s9AdItIhnQ09IVg7D68rpoIrbtBuQpLVgqVpByYPhnQuHM5LrIF71TnlDuMklb/xp2QA+5HXZqYmFeXYfHezYrE2eLUk7KvFLxtmgdrL7e6U8wtnGiYQ1R1+PypA6CzXLHpXeSneS1Z4mD31h6Ci0Z51JbYBpvDA1O2bbirUzpCRulFfSUjlc414CCHi11oyNZUCngFq1kP8FlMsswCEI6Bhx12UCu/TyLpvhBAraq9+YpKVXe/nJRBoZskKDREkmIFKoz/gPrpz1aeLKJqkQWmr36NIDDFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIQV8IhjvIw2/7Clcvu2OZXmz8QHz4yM69lsciGd9Dw=;
 b=mvsH8SK03WuZo60LuXymhTCXf06wbb4FC5Lk1embwS2AxjRVEEgN9ZgNzS3lUrQUoXGjh6OO5T9fAtGpavLr/izzlmUheFotqrHw8hxbSO9oddGs4+GNFdDEC/Iie9XHAt5XL+TEHWy+Lv06Y4IX9JLtm/w2GiI7PTyJsNB7cntCiyUGwYn1JtrlREQuNVPE6lsLA2UdHRXYQ2VicSw67m+2ajeIr1O3+oIU3jvqplGLetHdOl8xki0oLPo94Kpvr8tyC/6SGHZ4JzthunjEoxTBLXGRuP294dqBVhxHug6g5L9Y2rF38muvx6AjIs7f45mesoar/k61u1pggP1s1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIQV8IhjvIw2/7Clcvu2OZXmz8QHz4yM69lsciGd9Dw=;
 b=h618PEMaQGqOVPpqSYLtAf27mxnOcv7vZ+gys5y1X6c30ikdONlFcaYjuoFCvDbsFBg+pOxAmVm79fNiWjuyJIA+BVYp+EeTn8a0Wxrm18zBEmqwBD6zvBkSm/dZacNWlSfL6fpE5ag+c/ThXNVFZTEs0b21XDaCaji2mtrfxRM=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB5598.eurprd04.prod.outlook.com (20.178.204.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Tue, 19 Nov 2019 22:49:19 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::f:e0f5:1b95:a5d]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::f:e0f5:1b95:a5d%5]) with mapi id 15.20.2451.031; Tue, 19 Nov 2019
 22:49:19 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 07/12] crypto: caam - refactor caam_jr_enqueue
Thread-Topic: [PATCH 07/12] crypto: caam - refactor caam_jr_enqueue
Thread-Index: AQHVnZa0BoWdCWDvSky4rKZ3/nrdZA==
Date:   Tue, 19 Nov 2019 22:49:19 +0000
Message-ID: <VI1PR04MB44452654BA9716CA43992AA68C4C0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-8-git-send-email-iuliana.prodan@nxp.com>
 <VI1PR0402MB34853893505F95195F4C125B984C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2668063a-743e-4bd6-caa6-08d76d42b6cb
x-ms-traffictypediagnostic: VI1PR04MB5598:|VI1PR04MB5598:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB55983102D289F4D37F659E7F8C4C0@VI1PR04MB5598.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(199004)(189003)(102836004)(9686003)(316002)(71200400001)(76116006)(71190400001)(91956017)(6436002)(81166006)(446003)(8936002)(66446008)(66946007)(66556008)(64756008)(6246003)(81156014)(4326008)(6636002)(256004)(14444005)(186003)(478600001)(25786009)(66066001)(2906002)(99286004)(74316002)(110136005)(26005)(6506007)(54906003)(53546011)(44832011)(86362001)(55016002)(5660300002)(3846002)(66476007)(33656002)(76176011)(486006)(7696005)(476003)(305945005)(14454004)(229853002)(52536014)(7736002)(8676002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5598;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZRTuprXwLJvXoJQNk+56fqiCNWMeSNR05COsXidru8HpRLYF86nl017BB/5fQcQ/RiafC2cH+cxh7tUts65bNfPCVHD0O49rRKiqXkkvJ4Ln/2ZUcjC4A859DAxFid0tJrOZNQWdzjZFNrStMZD99RZP/qu9bi2IOBd1gGncPdFsrLBN0+ZEP7bpdks54uwd3wCf9Hb3eFK+YGd2vhaJYltHbbpOGr5NxZtcl7xRntMWdsA5GlXTQkuI127V6ntkHv+CQcOZtTTH2jATv0KKscoUgXinqGIAj+kYQaa0eBEVPi8mQqMmz9GsGPzZ0D7VOtgB6T6RdyqKoAhflDMK3q0e9InwzSgCILqpKGXslNUBm9vJQMcL+cMIMS5ZqILMIaSJoTTbcw3Z8C5T/iGxZq268ArYUSnBqAFr8ZY0z8C+UE1JI6Tcw4mZJ4DEQ6mK
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2668063a-743e-4bd6-caa6-08d76d42b6cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 22:49:19.7828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KylCcqBA0jv05a2pmS/8Obg490DsZK7lfzpPKI+oK12iJz1B3+fd8faxc4s1IciyEvQmXGnVGAff67ZW0NT/4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5598
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/19/2019 7:55 PM, Horia Geanta wrote:=0A=
> On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
>> Added a new struct - caam_jr_request_entry, to keep each request=0A=
>> information. This has a crypto_async_request, used to determine=0A=
>> the request type, and a bool to check if the request has backlog=0A=
>> flag or not.=0A=
>> This struct is passed to CAAM, via enqueue function - caam_jr_enqueue.=
=0A=
>>=0A=
>> The new added caam_jr_enqueue_no_bklog function is used to enqueue a job=
=0A=
>> descriptor head for cases like caamrng, key_gen, digest_key, where we=0A=
> Enqueuing terminology: either generic "job" or more HW-specific=0A=
> "job descriptor".=0A=
> Job descriptor *head* has no meaning.=0A=
> =0A=
>> don't have backlogged requests.=0A=
>>=0A=
> ...because the "requests" are not crypto requests - they are either comin=
g=0A=
> from hwrng (caamrng's case) or are driver-internal (key_gen, digest_key -=
=0A=
> used for key hashing / derivation during .setkey callback).=0A=
> =0A=
=0A=
Right, I'll update the patch description in v2.=0A=
=0A=
>> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg=
.c=0A=
>> index 21b6172..abebcfc 100644=0A=
>> --- a/drivers/crypto/caam/caamalg.c=0A=
>> +++ b/drivers/crypto/caam/caamalg.c=0A=
> [...]=0A=
>> @@ -1416,7 +1424,7 @@ static inline int chachapoly_crypt(struct aead_req=
uest *req, bool encrypt)=0A=
>>   			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),=0A=
>>   			     1);=0A=
>>   =0A=
>> -	ret =3D caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);=0A=
>> +	ret =3D caam_jr_enqueue(jrdev, desc, aead_crypt_done, &edesc->jrentry)=
;=0A=
>>   	if (ret !=3D -EINPROGRESS) {=0A=
>>   		aead_unmap(jrdev, edesc, req);=0A=
>>   		kfree(edesc);=0A=
>> @@ -1440,6 +1448,7 @@ static inline int aead_crypt(struct aead_request *=
req, bool encrypt)=0A=
>>   	struct aead_edesc *edesc;=0A=
>>   	struct crypto_aead *aead =3D crypto_aead_reqtfm(req);=0A=
>>   	struct caam_ctx *ctx =3D crypto_aead_ctx(aead);=0A=
>> +	struct caam_jr_request_entry *jrentry;=0A=
>>   	struct device *jrdev =3D ctx->jrdev;=0A=
>>   	bool all_contig;=0A=
>>   	u32 *desc;=0A=
>> @@ -1459,7 +1468,9 @@ static inline int aead_crypt(struct aead_request *=
req, bool encrypt)=0A=
>>   			     desc_bytes(edesc->hw_desc), 1);=0A=
>>   =0A=
>>   	desc =3D edesc->hw_desc;=0A=
>> -	ret =3D caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);=0A=
>> +	jrentry =3D &edesc->jrentry;=0A=
>> +=0A=
>> +	ret =3D caam_jr_enqueue(jrdev, desc, aead_crypt_done, jrentry);=0A=
> Let's avoid adding a new local variable by using &edesc->jrentry directly=
,=0A=
> like in chachapoly_crypt().=0A=
> Similar for the other places.=0A=
> =0A=
I've removed jrentry and req (as mentioned below) in patch #11 of this =0A=
series, but I'll remove them, from this patch, in v2.=0A=
=0A=
>> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamha=
sh.c=0A=
>> index baf4ab1..d9de3dc 100644=0A=
>> --- a/drivers/crypto/caam/caamhash.c=0A=
>> +++ b/drivers/crypto/caam/caamhash.c=0A=
> [...]=0A=
>> @@ -933,11 +943,13 @@ static int ahash_final_ctx(struct ahash_request *r=
eq)=0A=
>>   			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),=0A=
>>   			     1);=0A=
>>   =0A=
>> -	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);=0A=
>> +	jrentry =3D &edesc->jrentry;=0A=
>> +=0A=
>> +	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, jrentry);=0A=
>>   	if (ret =3D=3D -EINPROGRESS)=0A=
>>   		return ret;=0A=
>>   =0A=
>> - unmap_ctx:=0A=
>> +unmap_ctx:=0A=
> That's correct, however whitespace fixing should be done separately.=0A=
> =0A=
Should I make a separate patch for these two whitespaces?=0A=
=0A=
>> @@ -1009,11 +1022,13 @@ static int ahash_finup_ctx(struct ahash_request =
*req)=0A=
>>   			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),=0A=
>>   			     1);=0A=
>>   =0A=
>> -	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);=0A=
>> +	jrentry =3D &edesc->jrentry;=0A=
>> +=0A=
>> +	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, jrentry);=0A=
>>   	if (ret =3D=3D -EINPROGRESS)=0A=
>>   		return ret;=0A=
>>   =0A=
>> - unmap_ctx:=0A=
>> +unmap_ctx:=0A=
> Again, unrelated whitespace fix.=0A=
> =0A=
>> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc=
.c=0A=
>> index 7f7ea32..bb0e4b9 100644=0A=
>> --- a/drivers/crypto/caam/caampkc.c=0A=
>> +++ b/drivers/crypto/caam/caampkc.c=0A=
> [...]=0A=
>> @@ -315,6 +317,8 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akci=
pher_request *req,=0A=
>>   	edesc->mapped_src_nents =3D mapped_src_nents;=0A=
>>   	edesc->mapped_dst_nents =3D mapped_dst_nents;=0A=
>>   =0A=
>> +	edesc->jrentry.base =3D &req->base;=0A=
>> +=0A=
>>   	edesc->sec4_sg_dma =3D dma_map_single(dev, edesc->sec4_sg,=0A=
>>   					    sec4_sg_bytes, DMA_TO_DEVICE);=0A=
>>   	if (dma_mapping_error(dev, edesc->sec4_sg_dma)) {=0A=
> [...]=0A=
>> @@ -633,7 +638,10 @@ static int caam_rsa_enc(struct akcipher_request *re=
q)=0A=
>>   	/* Initialize Job Descriptor */=0A=
>>   	init_rsa_pub_desc(edesc->hw_desc, &edesc->pdb.pub);=0A=
>>   =0A=
>> -	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done, req);=0A=
>> +	jrentry =3D &edesc->jrentry;=0A=
>> +	jrentry->base =3D &req->base;=0A=
> This field is already set in rsa_edesc_alloc().=0A=
> =0A=
>> @@ -666,7 +675,10 @@ static int caam_rsa_dec_priv_f1(struct akcipher_req=
uest *req)=0A=
>>   	/* Initialize Job Descriptor */=0A=
>>   	init_rsa_priv_f1_desc(edesc->hw_desc, &edesc->pdb.priv_f1);=0A=
>>   =0A=
>> -	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);=
=0A=
>> +	jrentry =3D &edesc->jrentry;=0A=
>> +	jrentry->base =3D &req->base;=0A=
> The same here.=0A=
> =0A=
>> @@ -699,7 +712,10 @@ static int caam_rsa_dec_priv_f2(struct akcipher_req=
uest *req)=0A=
>>   	/* Initialize Job Descriptor */=0A=
>>   	init_rsa_priv_f2_desc(edesc->hw_desc, &edesc->pdb.priv_f2);=0A=
>>   =0A=
>> -	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);=
=0A=
>> +	jrentry =3D &edesc->jrentry;=0A=
>> +	jrentry->base =3D &req->base;=0A=
> And here.=0A=
> =0A=
>> @@ -732,7 +749,10 @@ static int caam_rsa_dec_priv_f3(struct akcipher_req=
uest *req)=0A=
>>   	/* Initialize Job Descriptor */=0A=
>>   	init_rsa_priv_f3_desc(edesc->hw_desc, &edesc->pdb.priv_f3);=0A=
>>   =0A=
>> -	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);=
=0A=
>> +	jrentry =3D &edesc->jrentry;=0A=
>> +	jrentry->base =3D &req->base;=0A=
> Also here.=0A=
> =0A=
>> diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h=
=0A=
>> index c7c10c9..58be66c 100644=0A=
>> --- a/drivers/crypto/caam/intern.h=0A=
>> +++ b/drivers/crypto/caam/intern.h=0A=
> [...]=0A=
>> @@ -104,6 +105,15 @@ struct caam_drv_private {=0A=
>>   #endif=0A=
>>   };=0A=
>>   =0A=
>> +/*=0A=
>> + * Storage for tracking each request that is processed by a ring=0A=
>> + */=0A=
>> +struct caam_jr_request_entry {=0A=
>> +	/* Common attributes for async crypto requests */=0A=
>> +	struct crypto_async_request *base;=0A=
>> +	bool bklog;	/* Stored to determine if the request needs backlog */=0A=
>> +};=0A=
>> +=0A=
> Could we use kernel-doc here?=0A=
=0A=
Sure, will do in v2.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
=0A=
> =0A=
> Horia=0A=
> =0A=
=0A=
