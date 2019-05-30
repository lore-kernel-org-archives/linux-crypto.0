Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B31C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6835A2596C
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:18:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="LitPmtS7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfE3NSk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 09:18:40 -0400
Received: from mail-eopbgr00072.outbound.protection.outlook.com ([40.107.0.72]:8581
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726604AbfE3NSk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 09:18:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzHTjjGMQ7qmVqzFecLmtDF2Uh/ikca8qYIM4maCJvc=;
 b=LitPmtS71ELvRU+E9tJ2euqGBadL5fiRMSu5vW0wCgsu4SQYj+0+dRz4g+39oWoh91eFBopKf2kextsu3r6PLQ3882udL4tV+TKc+93S3a6cZEMKM97PukGaJZPcBVPYDVB9Nb8D3fuExI7x2iKbUmGlDNpsLAsbQ0kn5RHFCyQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2703.eurprd04.prod.outlook.com (10.172.255.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.20; Thu, 30 May 2019 13:18:34 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 13:18:34 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Topic: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Index: AQHVFkF+dOvdDzZqYUSH856vNqfARw==
Date:   Thu, 30 May 2019 13:18:34 +0000
Message-ID: <VI1PR0402MB34859577A96645E890BD8F3198180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com>
 <20190530053421.keesqb54yu5w7hgk@gondor.apana.org.au>
 <VI1PR0402MB3485ADA3C4410D61191582A498180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu84HndAnkn7DU=ykjCokw_+bAHEcF0Rm12-hnXhVy2u_Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2c41088-e5a5-4a51-bc99-08d6e50151bf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2703;
x-ms-traffictypediagnostic: VI1PR0402MB2703:
x-microsoft-antispam-prvs: <VI1PR0402MB27035776B5AD5C93CFD25A6F98180@VI1PR0402MB2703.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(366004)(39860400002)(376002)(346002)(189003)(199004)(66066001)(55016002)(9686003)(25786009)(6116002)(44832011)(3846002)(71190400001)(71200400001)(6506007)(6246003)(476003)(14444005)(6436002)(74316002)(5660300002)(229853002)(4326008)(316002)(2906002)(54906003)(446003)(256004)(53936002)(478600001)(86362001)(73956011)(33656002)(14454004)(8676002)(52536014)(102836004)(486006)(53546011)(99286004)(186003)(81166006)(26005)(81156014)(7696005)(7736002)(305945005)(76116006)(68736007)(91956017)(66476007)(66556008)(64756008)(66446008)(76176011)(6916009)(8936002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2703;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VZj4TsGM4JMHhhNsCnE0ZXfFfaMqNS9qh0IB4UKOTIY6sbqkCwOfT738mF/7ux+VXLdK/csXdhsrUMrxL2pYXvVyKeJ+XuDSE2Sitq79ZQ78acE+jDOBIn0l7oKaKk1HT1SwGVODvqsNrEmZYJpzb2PeN/OcbXmM0hK8jP5JZ/ia/EvjB3IMfbLfJ3wCZfocQr8iJmnGrtoDZwdiLAdClvUHibBPacUMPqzIn1bNr8mdNjawaVpAjWXqHhnrhYFdLsUGcA7CeytsFmfun9g4uTRU4ouO5SROb3XEKQ+C1Pmu/Fz0bqWESDhjgIVtPu0lbMxKEvcsrUWtSU53vnYNjjDyCf4zGqlvC4rL6DtxmJwy9BjQFYB97Mne36rH3ndmHXVq4PJECQoOKCeMH2SB8PN7b2dM8GITYJ/U89KveE4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c41088-e5a5-4a51-bc99-08d6e50151bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 13:18:34.7402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2703
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/30/2019 11:08 AM, Ard Biesheuvel wrote:=0A=
> On Thu, 30 May 2019 at 09:46, Horia Geanta <horia.geanta@nxp.com> wrote:=
=0A=
>>=0A=
>> On 5/30/2019 8:34 AM, Herbert Xu wrote:=0A=
>>> On Wed, May 29, 2019 at 01:27:28PM -0700, Eric Biggers wrote:=0A=
>>>>=0A=
>>>> So what about the other places that also pass an IV located next to th=
e data,=0A=
>>>> like crypto/ccm.c and crypto/adiantum.c?  If we're actually going to m=
ake this a=0A=
>> Fix for ccm is WIP.=0A=
>> We were not aware of adiantum since our crypto engine does not accelerat=
e it.=0A=
>>=0A=
>>>> new API requirement, then we need to add a debugging option that makes=
 the API=0A=
>>>> detect this violation so that the other places can be fixed too.=0A=
>>>>=0A=
>> IMO this is not a new crypto API requirement.=0A=
>> crypto API and its users must follow DMA API rules, besides crypto-speci=
fic ones.=0A=
>>=0A=
>> In this particular case, crypto/gcm.c is both an implementation and a cr=
ypto API=0A=
>> user, since it uses underneath ctr(aes) (and ghash).=0A=
>> Currently generic gcm implementation is breaking DMA API, since part of =
the dst=0A=
>> buffer (auth_tag) provided to ctr(aes) is sharing a cache line with some=
 other=0A=
>> data structure (iv).=0A=
>>=0A=
>> The DMA API rule is mentioned in Documentation/DMA-API.txt=0A=
>>=0A=
>> .. warning::=0A=
>>=0A=
>>         Memory coherency operates at a granularity called the cache=0A=
>>         line width.  In order for memory mapped by this API to operate=
=0A=
>>         correctly, the mapped region must begin exactly on a cache line=
=0A=
>>         boundary and end exactly on one (to prevent two separately mappe=
d=0A=
>>         regions from sharing a single cache line).=0A=
>>=0A=
>>=0A=
> =0A=
> This is overly restrictive, and not in line with reality. The whole=0A=
> networking stack operates on buffers shifted by 2 bytes if=0A=
> NET_IP_ALIGN is left at its default value of 2. There are numerous=0A=
> examples in other places as well.=0A=
> =0A=
> Given that kmalloc() will take the cacheline granularity into account=0A=
> if necessary, the only way this issue can hit is when a single kmalloc=0A=
> buffer is written to by two different masters.=0A=
> =0A=
I guess there are only two options:=0A=
-either cache line sharing is avoided OR=0A=
-users need to be *aware* they are sharing the cache line and some rules /=
=0A=
assumptions are in place on how to safely work on the data=0A=
=0A=
What you are probably saying is that 2nd option is sometimes the way to go.=
=0A=
=0A=
>>>> Also, did you consider whether there's any way to make the crypto API =
handle=0A=
>>>> this automatically, so that all the individual users don't have to?=0A=
>> That would probably work, but I guess it would come up with a big overhe=
ad.=0A=
>>=0A=
>> I am thinking crypto API would have to check each buffer used by src, ds=
t=0A=
>> scatterlists is correctly aligned - starting and ending on cache line bo=
undaries.=0A=
>>=0A=
>>>=0A=
>>> You're absolutely right Eric.=0A=
>>>=0A=
>>> What I suggested in the old thread is non-sense.  While you can=0A=
>>> force GCM to provide the right pointers you cannot force all the=0A=
>>> other crypto API users to do this.=0A=
>>>=0A=
>> Whose problem is that crypto API users don't follow the DMA API requirem=
ents?=0A=
>>=0A=
>>> It would appear that Ard's latest suggestion should fix the problem=0A=
>>> and is the correct approach.=0A=
>>>=0A=
>> I disagree.=0A=
>> We shouldn't force crypto implementations to be aware of such inconsiste=
ncies in=0A=
>> the I/O data buffers (pointed to by src/dst scatterlists) that are suppo=
sed to=0A=
>> be safely DMA mapped.=0A=
>>=0A=
> =0A=
> I'm on the fence here. On the one hand, it is slightly dodgy for the=0A=
> GCM driver to pass a scatterlist referencing a buffer that shares a=0A=
> cacheline with another buffer passed by an ordinary pointer, and for=0A=
> which an explicit requirement exists that the callee should update it=0A=
> before returning.=0A=
> =0A=
> On the other hand, I think it is reasonable to require drivers not to=0A=
> perform such updates while the scatterlist is mapped for DMA, since=0A=
> fixing it in the callers puts a disproportionate burden on them, given=0A=
> that non-coherent DMA only represents a small minority of use cases.=0A=
> =0A=
The problem with this approach is that the buffers in the scatterlist could=
=0A=
hypothetically share cache lines with *any* other CPU-updated data, not jus=
t the=0A=
IV in the crypto request (as it happens here).=0A=
How could a non-coherent DMA implementation cope with this?=0A=
=0A=
Thanks,=0A=
Horia=0A=
