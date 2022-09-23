Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03ADFECAAD8
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 02:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiIWCjg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Sep 2022 22:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbiIWCj0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2022 22:39:26 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5963D11A695
        for <linux-crypto@vger.kernel.org>; Thu, 22 Sep 2022 19:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1663900762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=LquGr8zs4Yhieu3LOa8w/KjWikRLKlSpWvxxl6RvYCM=;
        b=aaXKa/Yvj4Yp9xxcZfxFbEOeua6LUdQl0lTT8yrg+v0ZmUxfeWC5tLnWsdNY3j35D1IBlp
        0TlvfIAr5lmkRBVXUQHhCyD1OVPrDIou24tkACDP3oE2NT6eH9kyNJmDDlxO5p9qXyQ5oa
        qm1svuClOcNYEaNU4fzfAxmwmVuBar+pzp2bpyMGzn9rU8oenTDdyPSfoiDjgdOneByLnI
        tMfwzl0lMBEWw5oHscxteFQWhBYphQBoqI8kAJQi0GkEA2V5kF+h5HS0y+TPwKTpPfKrWl
        FdSvIhIyed1KpYAsPV/NrVJtnTa4/kh0Rz93IfSqgsRMR6o05lgWWzOBnxBwUw==
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-Fr0bMEswMAOxyAP-SwN6fA-1; Thu, 22 Sep 2022 22:39:20 -0400
X-MC-Unique: Fr0bMEswMAOxyAP-SwN6fA-1
Received: from DM6PR19MB3163.namprd19.prod.outlook.com (2603:10b6:5:19a::23)
 by SA1PR19MB5668.namprd19.prod.outlook.com (2603:10b6:806:23d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Fri, 23 Sep
 2022 02:39:18 +0000
Received: from DM6PR19MB3163.namprd19.prod.outlook.com
 ([fe80::d02e:2c4b:c65b:36b2]) by DM6PR19MB3163.namprd19.prod.outlook.com
 ([fe80::d02e:2c4b:c65b:36b2%4]) with mapi id 15.20.5654.019; Fri, 23 Sep 2022
 02:39:18 +0000
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     Antoine Tenart <atenart@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        linux-lgm-soc <linux-lgm-soc@maxlinear.com>
Subject: Re: [PATCH v2 2/2] crypto: inside-secure - Select CRYPTO_AES config
Thread-Topic: [PATCH v2 2/2] crypto: inside-secure - Select CRYPTO_AES config
Thread-Index: AQHYwZuhJOtFv92MlU2QoKo8a0Nwig==
Date:   Fri, 23 Sep 2022 02:39:17 +0000
Message-ID: <DM6PR19MB3163A2F50926BA046B08913EA1519@DM6PR19MB3163.namprd19.prod.outlook.com>
References: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com>
 <60cb9b954bb079b1f12379821a64faff00bb368e.1662432407.git.pliem@maxlinear.com>
 <166247313358.3585.5988889047992659412@kwain>
 <DM6PR19MB31633BFB6AD885E0EAF68F14A1419@DM6PR19MB3163.namprd19.prod.outlook.com>
 <166254049905.4625.8082287890585826042@kwain>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR19MB3163:EE_|SA1PR19MB5668:EE_
x-ms-office365-filtering-correlation-id: f8e82eb7-4e6f-4afc-3a81-08da9d0ccfeb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: onBQGjApGa9fsdmUTjRy/o5RvvvfmqlrkCfHMs67byxuxUUBF+jlHy6iMkX22hHvd2d3A9CDdax9K2mQ8gNlP538j2Eem87W3FDiWs+SrvTzjW/kFYmavW1A+d3fGo4hiaYc+47tjcsI5RUObitEzRtfY2TvR6fWLfn2xQcGebH630qHc9KgxMZG03yvrtpuhbvO3geyv985x/b7aQtsWgGwHNPd66uuax0Bzv2ZOP2DwyY8tNffVJ/PDRfjTFq4GbQwrrf9X3IqS3nrTWU58QqDeZZcdegeQI4j2yPdMMyXpH4xjObxPtX7f6VrPcN0VLdStbGsnsnoRS8k5/uyyPLnwrBHjhZoaWcPRoeooYjwTWWpuXFPfjJ8HpTFsvqnRNPZxQw7ITI5UNKioctOTk59nZJ5xVhk35XrO03jsUoWC1vdvsZngutcfdC7RimdxILW6kRCstaxxHFZ7lZkIdC+fyJXTxl+HR5/w3opMGsuPnTSYtVEUutTb0Cu5yR54MSxbR1BwKDnyn1OLnPMzhqXLvnIK9ib51dms5fztVFPW+Ltpqtd3OQcuicuZ47HUtSgGL4p20D0P5tWx74/Kq8gCJkaa9e3wIAIb/+7ap8ODqL+0kvxTTO5NoydjgbA8HMBBE0+WQamwD/xjPyhbgSAhIxB4N3gukIOSNkKdw4VyNVAnBT8jI2TUDVjUcDWm0V5Xduszj/9vbWYmmYksrESe2C4Ya609jWkWELANwLCD4kNTWsfeqgCsp8OAQj64cUitXCUsSTRVQnDHwsFvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB3163.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39850400004)(136003)(376002)(366004)(451199015)(38100700002)(122000001)(8936002)(5660300002)(2906002)(186003)(86362001)(83380400001)(54906003)(110136005)(66556008)(38070700005)(64756008)(41300700001)(66476007)(107886003)(7696005)(478600001)(71200400001)(66446008)(52536014)(91956017)(76116006)(4326008)(55016003)(26005)(8676002)(33656002)(316002)(9686003)(53546011)(6506007)(66946007);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BSK4Z8YLMGdIek3Cls/5IjHoS471hk5OlU/nxFfa5jS8Rb6dVLkHIKJy4F8d?=
 =?us-ascii?Q?80lgEDRzKAuHRisJRDGYPD183y+gPL0dPcHwAkufmDCTQAtwyiuNAiewFWTi?=
 =?us-ascii?Q?d1VYVffiqqHq7QdExr9sZyhj1V84ehcdLiiWyU/XXqRvcVsNp6kGtmiqykhp?=
 =?us-ascii?Q?H8pXbqXeU+F+j+15RnuJlfosv5fI5j6myT8kxvhRJ5WEONDzxcGZv4Ekc0VN?=
 =?us-ascii?Q?F+SLrzqqHqwZvoDzH17TPg1LYCiu4KlNIaALv12qZltqubAoPs/W/PFjSg6H?=
 =?us-ascii?Q?wHxnxvCxcxAZOhaehCMYKr/TmRN/ISrAw4oDoXWsuqasr/Z8FGOhIwPJbsml?=
 =?us-ascii?Q?78LtHaVJhcSXRzbdy5/AsVEu4NJTbUkUxvqhYEqw/MmlNBhXve5WaBORvECD?=
 =?us-ascii?Q?0Wyoa3xRV5OaJn8A/YyyUp0m0u1hwSu++rMYYHjGgMeDB0wQ4mGATFmSqD4I?=
 =?us-ascii?Q?h/d1VD2li6PK8a/ztbpgjFOpQJ7zVY1ZjgUBUV+9XvQPTT08eDlylzcWUGkU?=
 =?us-ascii?Q?HewL9YxBAcnok8Bca/ZZ7juJMpsXzsqlEmA9Pb+XTzO4oNFrNrs3BtTAUjWE?=
 =?us-ascii?Q?TF+Yvi+vgMSCLly54YwgEiZboDQ5qpVgLBlrCho/xwfdi80KUWEETp/rS8Eh?=
 =?us-ascii?Q?k80WmObfYSHAkCrBaJ6wnhbZ1k9sXAnMnoO5t1jyoIH/VGO/e3w7w6Rd7TZ6?=
 =?us-ascii?Q?QrbQtiCQp+pdW3eawSoYUAoIYsyETxN5lrcETOgJAPnhK4vj9ahQgFjtRrFi?=
 =?us-ascii?Q?Thfx2hrdRi2rzvlYoJ2Q3Mk+n3Cnt5LAi1sALYnEc9xoPcwyfM8eUPztchqK?=
 =?us-ascii?Q?7CDVEt3x1qcPau07/MIL4Xc+ZxHKCpRmhOSB9DqjGXFdp3ehtjyQGnCyBPL8?=
 =?us-ascii?Q?6ACB5cWSM5sBNREFSNZlX8vB45kiKnRoxNbVkfbiz1mZxSbfXijXVgBn2M9z?=
 =?us-ascii?Q?FxXFVZOD5aPY1+roffPGanoySySiczzEsBIUzuipg19Z0gZFDwSmIHKkJZ29?=
 =?us-ascii?Q?Oe5pHlcnzaGnVJwUGISwIlk+SH52BgbJFtjU6p7IGBov11y6X1tlfog9vXSv?=
 =?us-ascii?Q?gzgWvNVAyG7lAs00hL5q1+0TDPpB4q+GF9siDQ93dK6Gd/Ex5V+9mEsVMlQN?=
 =?us-ascii?Q?dt7adzPkmw3ur3JSIWKae7+xETiRGqoR7T2J9qoczXIE2d9vJDGd2WnS7zak?=
 =?us-ascii?Q?9sWcesN4Q8eLs6O3eQj9gSYW0tcR8Eb19cHmzWaBn6mGxi1sFicTFx+7ccR+?=
 =?us-ascii?Q?VweRti5NVIoYhrTp710eF8zVZKG6X6/fuwZnziICrSWG6UPLTuB5S3yLqJ5m?=
 =?us-ascii?Q?KVkY6Si8Gxbj019HO8yyTif6P0KQ2QHOjx/e1qZhR765H9uVEk+swZgSKnHI?=
 =?us-ascii?Q?wrxwRkR7HZpftIL2KfrFpf8YHwfSWoQShURq3NjixDaUGg+cvTR+LSBjJGhF?=
 =?us-ascii?Q?VQvnKJwX3Ggo7MCTsbyGvLT1FCyeMcyVJACWaMNd6NzkPooWA1vtpeqbxENo?=
 =?us-ascii?Q?ss/pjmFtoKz7YykCjHt7rqfFcYsc2DW6F/lroBusXEja02EKou4uwr9Hdovk?=
 =?us-ascii?Q?mCL4wEfjn1I5BVfyK+wtUkD6DiSS7JMIWS9aj4w2vUEE+Hm07gh6pKa0AqE+?=
 =?us-ascii?Q?lg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB3163.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e82eb7-4e6f-4afc-3a81-08da9d0ccfeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 02:39:17.9658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x28iTu6+FNHoO6SlKLX5CIMGDA7l+SQC8BCb0j3ISfz4CvJF93OBtuaR5kJ4b3A06ef8zEXQTqaqsMG0CNMTwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR19MB5668
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/9/2022 4:48 pm, Antoine Tenart wrote:=0A> Quoting Peter Harliman Liem =
(2022-09-07 08:46:32)=0A>> On 6/9/2022 10:05 pm, Antoine Tenart wrote:=0A>>=
>> CRYPTO_AES is needed for aes-related algo (e.g.=0A>>>> safexcel-gcm-aes,=
 safexcel-xcbc-aes, safexcel-cmac-aes).=0A>>>> Without it, we observe failu=
res when allocating transform=0A>>>> for those algo.=0A>>>>=0A>>>> Fixes: 3=
63a90c2d517 ("crypto: safexcel/aes - switch to library version of key expan=
sion routine")=0A>>>=0A>>> The above commit explicitly switched crypto driv=
ers to use the AES=0A>>> library instead of the generic AES cipher one, whi=
ch seems like a good=0A>>> move. What are the issues you're encountering an=
d why the AES lib makes=0A>>> the driver to fail?=0A>>=0A>> If I load the k=
ernel module (CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not=0A>> set), I am ge=
tting failure messages below.=0A>> IMHO this happens because some functions=
 in the driver still rely on=0A>> generic AES cipher (e.g. refer to safexce=
l_aead_gcm_cra_init() or=0A>> safexcel_xcbcmac_cra_init()), therefore CONFI=
G_CRYPTO_AES is still needed.=0A>=20=0A> That's possible, and the right fix=
 might be what you proposed. I think=0A> it would be nice to understand wha=
t is failing and where, so we have a=0A> good argument for restoring the AE=
S dependency (or not).=0A>=20=0A>> Maybe the alternative is to switch all o=
f them to use AES lib instead?=0A>> Let me know if you prefer this.=0A>=20=
=0A> If the AES lib can be used instead of the AES generic implementation=
=0A> that would be great yes. If that's possible, depending on what is=0A> =
actually failing, yes please go for this solution. Otherwise restoring=0A> =
the AES dependency with a good explanation should work.=0A=0AI have replace=
d this commit in v3 with the change to AES lib instead.=0A=0AThanks!=0A

