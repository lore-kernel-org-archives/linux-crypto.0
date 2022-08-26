Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E538FECAAA2
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 02:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244768AbiHZCmI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 22:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244751AbiHZCmE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 22:42:04 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA09CCD49
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 19:42:03 -0700 (PDT)
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q29muW008321;
        Fri, 26 Aug 2022 02:41:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=kiZXR22zOZo/PYBEp5i/C0TugVMRcDscZco7XxxTf7Q=;
 b=JUGMpuvd39+YH6ka8zP1ks8vC9N4lTn0ljZWt11xh7d3wagO7LpCJz9gGI1JH1GEgN7y
 w7qNRRwgnJ7WXwLh39pAX1tnaZLUOFlm7ZuNSYv65AnIoPLwdD7S4Dyx8/uGofM8HZjF
 YF8BCndfGKs+8+PIW0xcWiRq7CJIlzRnXaG7Sd4yo8STrx+73euHbo2z1KfQHQVITccv
 FlW9oD5UUg93UR2HVHj49nt3HgD3tJBgJ9YLlsK7GPab5PgsH4xMeOk6uEz2PLA+M3ng
 zKb7itbXUSjv9WDYG38bb6pvJRYidE3nh/MC/M/nTeXZ9ZHy9P6/EWyNFvKiHa17BKQ0 eQ== 
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3j6n5608ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 02:41:22 +0000
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14881.it.hpe.com (Postfix) with ESMTPS id C32AC807900;
        Fri, 26 Aug 2022 02:41:21 +0000 (UTC)
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 25 Aug 2022 14:41:00 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Thu, 25 Aug 2022 14:41:00 -1200
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 25 Aug 2022 14:41:00 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6jRulwIh0mzGE7flJ0kCloQLLiXXSyE/hRT0KTFEqgjiIzRoi5Ac0Fv+2nXCwYt7ZWruC3drVDUB0vTTVOjas4K2/D2uKB9Qm6ye05koFwznBLoV15/MswM+e8hXMukv1HZ5n8WEHELMkkryO/h7EuQyo/0swaYZR2S5OJVSHSQ/dGPW1eMVmyyhQ6ZmzmrYuHiHl6ircEPGpeR7QnTPWScqgZ1Ceqh8dMWpLOrPtz3AhIY+265adFctOnbPF5kqaaBKlZgjs3x7NKNto63H++xYFWtsS0Inuzv2Hc5s+2GHE6bN97MQW5pEPijKQiJvqNic6VoMpktq6ry0UWyKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kiZXR22zOZo/PYBEp5i/C0TugVMRcDscZco7XxxTf7Q=;
 b=JWIDPguyiJ9WCSz1OvRZJ4p2OCMTND/x9Ytwy58FTf+TJbuW+bg1QBFWffBFnA+elyV3LnjKorqvEFV9L9mHTCzj3uTWPwU7pX6w0dCl6Tnok8EnnwucGyzVsUAPGuEJgPgNjshv8KsCnbPaULjInThvgxJ0kugEU9+5ZYmXj+31ybLwTU6BrqFQ/ILwmLO4qFli9SlCxBILJa1Q7MnYFKN1FozVldcS4wmSE/wFQ+ygTdEolvv+DCMHCv+KcuxyOMoISq2j79E5r8AkqQqhmxsNlHS1QwG+VT01DVm9jirK4yIDnrB4oUZ8cRL2fLyuWKy9u/9uwAuO89CLNRmf8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by PH7PR84MB1886.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:155::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Fri, 26 Aug
 2022 02:40:59 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1cc2:4b7b:f4c5:fbb4]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1cc2:4b7b:f4c5:fbb4%5]) with mapi id 15.20.5525.011; Fri, 26 Aug 2022
 02:40:58 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "Elliott, Robert (Servers)" <elliott@hpe.com>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Kani, Toshi" <toshi.kani@hpe.com>,
        "Wright, Randy (HPE Servers Linux)" <rwright@hpe.com>
Subject: RE: [PATCH] crypto: x86/sha512 - load based on CPU features
Thread-Topic: [PATCH] crypto: x86/sha512 - load based on CPU features
Thread-Index: AQHYr2k4ae1ddXSOmky6WV6b3Lh2Q622GE6AgAC77WCACapusA==
Date:   Fri, 26 Aug 2022 02:40:58 +0000
Message-ID: <MW5PR84MB18426EBBA3303770A8BC0BDFAB759@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220813230431.2666-1-elliott@hpe.com>
 <Yv9ubekvQiL3UGwd@gondor.apana.org.au>
 <MW5PR84MB18425E5211BD4EAF09D0CE3EAB6C9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <MW5PR84MB18425E5211BD4EAF09D0CE3EAB6C9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d472ee9-ee8a-400f-86cb-08da870c6880
x-ms-traffictypediagnostic: PH7PR84MB1886:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eZIdIY6RKsSJEP2Cm90gw2jenMDhwW8XOl+TSJCs39mf9ni3T1qV2eCkhoL3EBAeIQnzhUTIeGp+W1svt/vq12qhKVkxXnQB+bNtEb4GIuMKpp9b90DDugGBuv11iXhTSr42HhKrjuJ0MhAqBSOVURfP81xCjiI02nr6csry4dLHZf3/1scUwhytmwwghnJFe8oAIhOMGry1/qM7bwuJlT1z9SvP1rApxv3xK8rJOkKXJC2pMWYErJKyiC3AbHFxtIBiguXwvhQTK0qeBr8JVGTE4SrweYUJi37qbL6iIl55cfaKG1K2nTMoXSVtXz+a/34QpwQRjlt/FygkBNmbkPHGLN9A+MxbDxjBLdJiselSEOlX0tkRsSuxgzMyJSuYKaS4up/+Czi/BK8+12yfm6TCK+ea+nORddw4wc8r12+FXRF1P8elWIoHG/yWnJ7H3rI3BetVf15E87XqagUN83owhzEod5/Rc+m+PKSuNrkW/W5MG5dwwnDUsbFpR7gjFUOE50m7EWP0LETmhmfI/65W696du/F/IThOZ6p2gZsk811Gxfza2XvGtfiWe4gujODBdkblQKzGRr9LCYVvduMijJcqBuVAd24GP5TKRmvSRVQAOP7uCVFOEf93oAi741mjK0aJW3T2CHY4CCkSyAlX18v3gft+hadVCy676jBeYxctvboLmOw8s7oGH9sgkdIMB7IxADpF9y+Kv4jTKzdwSDFve3V63hPNMfUvmCqPxbSNkmReuYzL4FRUNsNVSuRcymRtxeSMtyrbWV0eKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(39860400002)(346002)(376002)(38070700005)(82960400001)(186003)(38100700002)(71200400001)(76116006)(64756008)(66556008)(66476007)(66446008)(86362001)(122000001)(66946007)(8676002)(8936002)(33656002)(5660300002)(54906003)(55016003)(6916009)(2906002)(478600001)(316002)(53546011)(7696005)(26005)(6506007)(83380400001)(9686003)(4326008)(41300700001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8MxIpI0aACGn5msBa7YTjhh/dXBYQIEAtgVxlGUSx277i0ZQJ19C7P1CgHbQ?=
 =?us-ascii?Q?SCpxDpR4elzPkVif2GqkBjfYJo3tG/Yz72qkT+XuUCeBibrHtHFTzA5ahay6?=
 =?us-ascii?Q?xkU8UBvhO85iQipEFbzr7NHqyVha7Rwv1h8pbGaKQINueM0xbAcO12mozHhR?=
 =?us-ascii?Q?GZCAgBsWgDvXNixNJse3u4FyGQSkOmZXiebTSKxtVQ5JGvINmXB3dWqVeaPs?=
 =?us-ascii?Q?5LWVHJ54taKzNy6zLy6zm3AuKuykPU0CvP8rjpR8oX9MFtzLkmSoBz34J/pS?=
 =?us-ascii?Q?NvgX4Ru9yuW/VzFP2N3oXITmx9FtogwdTlbEOuppy7GGbqUaTEBvU8DFuIHf?=
 =?us-ascii?Q?VBaJOGwMEC+Fi6geZdM2VRPgkfCbw3M6b8pq9IsbaCeXfp9lo56rJjedrWDt?=
 =?us-ascii?Q?f6K1AGRDUJCrUrjxJxIumwgWPDJdfhpctijFVLsXcjQKW1IxHEAz6RTGh0ka?=
 =?us-ascii?Q?38Cuqiqy7VDKuNBVYZ5YeUl/VwiFwtWNCbCoWfHuMzBkYh3bm+l3WwRt9y5K?=
 =?us-ascii?Q?coivCLhtmL53GGCJ4m5Lz0jipOTorAbiLax0ydnWFVddHgGo7fStFHg2E/VL?=
 =?us-ascii?Q?0PH0ux658kqcvO0pWASTANyRHYWbEdaSNdSRAytu1Umilx+Gf72Spj9nwVOb?=
 =?us-ascii?Q?2xq+vwOrYMSEeQfeczIYDJuxeGyChiP60aUNJPVW8Eo6GTHOoM3/7jNMmske?=
 =?us-ascii?Q?5FyhWf1sg+jwEel+Im6ecdK88rZWtDQSW/tiebFbKNbaMZHNfm4FgX9Fi8rh?=
 =?us-ascii?Q?iIXmN/ZGamfOBSC5ogWGJAwxP3u+Tnd/lY04uKg/GMfuzoDxUaJQHFLr0Pui?=
 =?us-ascii?Q?hiuWO/PjEXVmErBEkxa6W7DMQD7iMRfjDdyaQfRAbDeGwuObKbBIaYRu6MmN?=
 =?us-ascii?Q?mnmh8JuS2JytuQfVCH0ZF+5C0UJMOjVpwYBu/15WS0dhfT63RcI6uywrmjuw?=
 =?us-ascii?Q?CQG9p7yWcOG5TtwtBHHA1fGUQ7Cb2z4iMs4J/rTDZg63Cduf9qqw+C4trjsm?=
 =?us-ascii?Q?j2p5JFRep1Ua1hnXsPQovnBo5i4uoVY86nycLdbamPZ137NrfxHHOC8WQ/VI?=
 =?us-ascii?Q?eGcQY2auQR0KYviR+mjFEv/yeX9yFoMauymPVjF3nXIkWp9ji7++yYHsMT7g?=
 =?us-ascii?Q?FTfGiHaju9jxwcBe4DQUjHOXLuLVwZmbI+R96wCDkJDSJuw54qHBmw3BaMT+?=
 =?us-ascii?Q?4QByN3IZmO6qkqZROwfgzO4A3P4H56dD2Gl4/e7cqX1SAUkKBHynxraOD6Rf?=
 =?us-ascii?Q?Nw5iCb+9f2db/VnluxByEDilRtA768YmAUAFCopP1y5WzVxEhpRMBhqLlpyk?=
 =?us-ascii?Q?NbRwLxyQbkf1I9TB80Vk81XYhBlIziD9mxN1gC1qEfKVRUfoBbUt7K4r/32Y?=
 =?us-ascii?Q?rOsYVbEx+rkaRU+yq7Af1JBlke/sIy/T/m90o41etdC2yvo6M2S/UJJ56KIA?=
 =?us-ascii?Q?E5+7YFao/NxbvKtQsywRRKcQpOQSzuXqTx2NcdjTNl3U6vrAX08voIjLMacz?=
 =?us-ascii?Q?iboTQt2rJ342vVjikjXaTEauz4C4e1ma+0YHVpWQ50MaBJs8idqsPQWmJDMa?=
 =?us-ascii?Q?MnA9D4A5NE7aAvIy/ZI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d472ee9-ee8a-400f-86cb-08da870c6880
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 02:40:58.8644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ptowDx+QMN6IHxcbx1vZ5z4vmEPfDzBxSQE5Sabns8qQPu+k+4MY5syaNDMz7qS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR84MB1886
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: p1JB9OgMWarCnNbU3FL48Kug7pyFucD-
X-Proofpoint-ORIG-GUID: p1JB9OgMWarCnNbU3FL48Kug7pyFucD-
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_11,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=836 priorityscore=1501 bulkscore=0 suspectscore=0 phishscore=0
 malwarescore=0 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208260008
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Elliott, Robert (Servers) <elliott@hpe.com>
> Sent: Friday, August 19, 2022 5:37 PM
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Subject: RE: [PATCH] crypto: x86/sha512 - load based on CPU features
>=20
> > -----Original Message-----
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Sent: Friday, August 19, 2022 6:05 AM
> > Subject: Re: [PATCH] crypto: x86/sha512 - load based on CPU features
> >
> > Robert Elliott <elliott@hpe.com> wrote:
> > > x86 optimized crypto modules built as modules rather than built-in
> > > to the kernel end up as .ko files in the filesystem, e.g., in
> > > /usr/lib/modules. If the filesystem itself is a module, these might
> > > not be available when the crypto API is initialized, resulting in
> > > the generic implementation being used (e.g., sha512_transform rather
> > > than sha512_transform_avx2).
> > >
> > > In one test case, CPU utilization in the sha512 function dropped
> > > from 15.34% to 7.18% after forcing loading of the optimized module.
> > >
> > > Add module aliases for this x86 optimized crypto module based on CPU
> > > feature bits so udev gets a chance to load them later in the boot
> > > process when the filesystems are all running.
> > >
> > > Signed-off-by: Robert Elliott <elliott@hpe.com>
> > > ---
> > > arch/x86/crypto/sha512_ssse3_glue.c | 10 ++++++++++
> > > 1 file changed, 10 insertions(+)
> >
> > Patch applied.  Thanks.
>=20
> I'll post a series that applies this technique to all the other
> x86 modules, if there are no problems reported with sha512.

Suggestion: please revert the sha512-x86 patch for a while.

I've been running with this technique applied to all x86 modules for
a few weeks and noticed a potential problem.

I've seen several cases of "rcu_preempt detected expedited stalls"=20
with stack dumps pointing to the x86 crypto functions:
    rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { 12-..=
. } 22 jiffies s: 277 root: 0x1/.

(It doesn't always happen; I haven't found a definitive recipe to
trigger the problem yet.)

Three instances occurred during boot, with the stack track pointing
to the sha512-x86 function (my system is set to use SHA-512 for=20
module signing, so it's using that algorithm a lot):
	module_sig_check/mod_verify_sig/
	pkcs7_verify/pkcs7_digest/
	sha512_finup/sha512_base_do_update

I also triggered three of them by running "modprobe tcrypt mode=3Dn"
looping from 0 to 1000, all in the aes-x86 module:
	tcrypt: testing encryption speed of sync skcipher cts(cbc(aes)) using cts(=
cbc(aes-aesni))
	tcrypt: testing encryption speed of sync skcipher cfb(aes) using cfb(aes-a=
esni)
	tcrypt: testing decryption speed of sync skcipher cfb(aes) using cfb(aes-a=
esni)

In that case the stack traces pointed to:
	do_test/prepare_alloc_pages/test_skcipher_speed.cold

Theory:
I noticed the proposed aria-x86 module has these calls surrounding
its main data processing functions:
	kernel_fpu_begin();
	kernel_fpu_end();

The sha-x86 and aes-x86 implementations use those as well. For
example, sha512_update() is structured as:
        kernel_fpu_begin();
        sha512_base_do_update(desc, data, len, sha512_xform);
        kernel_fpu_end();

and aesni_encrypt() is structured as:
	kernel_fpu_begin();
	aesni_enc(ctx, dst, src);
	kernel_fpu_end();

I noticed that kernel_fpu_begin() includes this:
	preempt_disable();

and kernel_fpu_end() has:
	preempt_enable();

Is that sufficient to cause the RCU problems?=20

Although preempt_disable isn't disabling interrupts, it's blocking the
scheduler from using the CPUs (A few of the arm AES functions mess
with interrupts, but none of the others seem to do so). So, I suspect
that could lead to RCU problems and soft lockups, but not hard
lockups.

Do these functions need to break up their processing into smaller chunks
(e.g., a few Megabytes), calling kernel_fpu_end() periodically to=20
allow the scheduler to take over the CPUs if needed? If so, what
chunk size would be appropriate?



Example stack trace:
[   29.729811] rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tas=
ks: { 12-... } 22 jiffies s: 277 root: 0x1/.
[   29.729815] rcu: blocking rcu_node structures (internal RCU debug): l=3D=
1:0-13:0x1000/.
[   29.729818] Task dump for CPU 12:
[   29.729819] task:modprobe        state:R  running task     stack:    0 p=
id: 1703 ppid:  1702 flags:0x0000400a
[   29.729822] Call Trace:
[   29.729823]  <TASK>
[   29.729825]  ? sysvec_apic_timer_interrupt+0xab/0xc0
[   29.729830]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
[   29.729835]  ? loop1+0x3f2/0x98f [sha512_ssse3]
[   29.729839]  ? crypto_create_tfm_node+0x33/0x100
[   29.729843]  ? nowork+0x6/0x6 [sha512_ssse3]
[   29.729844]  ? sha512_base_do_update.isra.0+0xeb/0x160 [sha512_ssse3]
[   29.729847]  ? nowork+0x6/0x6 [sha512_ssse3]
[   29.729849]  ? sha512_finup.part.0+0x1de/0x230 [sha512_ssse3]
[   29.729851]  ? pkcs7_digest+0xaf/0x1f0
[   29.729854]  ? pkcs7_verify+0x61/0x540
[   29.729856]  ? verify_pkcs7_message_sig+0x4a/0xe0
[   29.729859]  ? pkcs7_parse_message+0x174/0x1b0
[   29.729861]  ? verify_pkcs7_signature+0x4c/0x80
[   29.729862]  ? mod_verify_sig+0x74/0x90
[   29.729867]  ? module_sig_check+0x87/0xd0
[   29.729868]  ? load_module+0x4e/0x1fc0
[   29.729871]  ? xfs_file_read_iter+0x70/0xe0 [xfs]
[   29.729955]  ? __kernel_read+0x118/0x290
[   29.729959]  ? ima_post_read_file+0xac/0xc0
[   29.729962]  ? kernel_read_file+0x211/0x2a0
[   29.729965]  ? __do_sys_finit_module+0x93/0xf0
[   29.729967]  ? __do_sys_finit_module+0x93/0xf0
[   29.729969]  ? do_syscall_64+0x58/0x80
[   29.729971]  ? syscall_exit_to_user_mode+0x17/0x40
[   29.729973]  ? do_syscall_64+0x67/0x80
[   29.729975]  ? exit_to_user_mode_prepare+0x18f/0x1f0
[   29.729976]  ? syscall_exit_to_user_mode+0x17/0x40
[   29.729977]  ? do_syscall_64+0x67/0x80
[   29.729979]  ? syscall_exit_to_user_mode+0x17/0x40
[   29.729980]  ? do_syscall_64+0x67/0x80
[   29.729982]  ? exc_page_fault+0x70/0x170
[   29.729983]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   29.729986]  </TASK>
[   29.753810] rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tas=
ks: { } 236 jiffies s: 281 root: 0x0/.


