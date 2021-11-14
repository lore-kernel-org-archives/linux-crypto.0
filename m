Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5F0C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Nov 2021 02:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2584560F46
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Nov 2021 02:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhKNChJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Nov 2021 21:37:09 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:40600 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230299AbhKNChI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Nov 2021 21:37:08 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ADKqKeH014045;
        Sun, 14 Nov 2021 02:34:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=FIt0oqIBMAxQac8/LpyZBBodWkcoCvzKxD8vNREisI8=;
 b=Cs9+NsEPUEDWh9S1Gy1bIdV2zzm2QPnAvw75FbvpAwS9boZXuxhLJnBHBkqq3fKaFjE+
 9ssLfrHZXD5mrpo3t5eOFc6xg8D1EKLqcSvT1sB7mLsSgdVqBjJ9x1ZCO9ggI71GHBSM
 9ADmUnPLdOz6fFjvtrbjCipjMeVMc2P4M2vRRcntZgrIGw5StK28bV97+FfycI1+EfYU
 2nUd4pdTOylkBrrHtDN1gypfy56IVwngXYOIc0wrF0x9JcwuuHLyyAldXsfx//a6N8yP
 wkQ7xtLD6nti5tlJeGrPxRPPP31iJ21DUJW5k763BdR3XlsEA8wyYGv3/oz+qD4jayZ1 qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ca3sda4av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Nov 2021 02:34:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AE2Gqc5118427;
        Sun, 14 Nov 2021 02:34:09 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
        by userp3020.oracle.com with ESMTP id 3caq4pjqgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Nov 2021 02:34:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaOW7ZC0DS37KGRon3VnqO0Fls+skkL+u97ST1JfInwkTaACiDUmNxabFLCJ7Kky3nCJNIg2vWfyUnqkQ+p8bEvXNRpYPwRG9RaCbhpok2T9fxmQ6hRuYysIiQmwnc39ssj9WwVDoHEbMt9KD5Do+HGJXcxI3NM2CJOKMb6Rg03Y9AxkGF/lIknKqP4B1eGhqgcYu4nS8IvvPBj86nFFtQe5wSax6TOokXRfRWSViAO+pB3len5BqdPqPd0BL/w7mSzWVNOxlCS4ln9qepiyLoZQJ2c4bmAR8AY/2SAIJBy59hlSEdN+MP96oS3lYHSeBJJ7b6lwlZpbSCcw3fS7rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIt0oqIBMAxQac8/LpyZBBodWkcoCvzKxD8vNREisI8=;
 b=em+al5zgmEOYoM2VMYlyMG7Y38iYOAOO+hSGbPuoq3PDtQduD68i/qQlVNXzg+82zOaQo6v6CWINCMcUV9qWrc+V66LiezqEyB2TMo70A0Wwqzb5FBcRVSeVTqHCbI6+aIoSWJjmUVoOoXANTsK1T45l7IJzZOh3Hspr/SY+DdV1JoHQ6QxRCrDLmh14UEYamsCu6JzJ3GEZbk7ymMGobtU8DqUNLoILnm6e45MGts14yJZM2nkE2T3qZpPNUVbZXW5sdWjhS4pdhywANskxcGOjVPXxaYlw5Wh81Z5AMRHTQD4uDUZqCbABUqbkUV1GrAcNC45n7ua1h/SJEEQd2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIt0oqIBMAxQac8/LpyZBBodWkcoCvzKxD8vNREisI8=;
 b=M/NmBDKGvOT/GcO/f3sUgWR24LwftdNGEpfzdwzhRM4zOsvWBMUXxFiZB6LIKXyya5OWNKUe+dfxa6EUckaa7KmYiYetpAlbdQnl4pEIE5zxvlCsWd7RWsqM/5GHhbEOMeVTHNOLcOdcpngJMVfHipDinELSH4tP/NRxXrFR7E0=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Sun, 14 Nov
 2021 02:34:08 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::2ded:9640:8225:8200]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::2ded:9640:8225:8200%6]) with mapi id 15.20.4690.019; Sun, 14 Nov 2021
 02:34:07 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     David Howells <dhowells@redhat.com>,
        Alexander Krizhanovsky <ak@tempesta-tech.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH Strawman] crypto: Handle PEM-encoded x.509 certificates
Thread-Topic: [PATCH Strawman] crypto: Handle PEM-encoded x.509 certificates
Thread-Index: AQHX1/X58mV+Icz79EaIVabYCdvL7KwB1PMAgABADgCAADtDAA==
Date:   Sun, 14 Nov 2021 02:34:07 +0000
Message-ID: <202C4936-FE6A-4422-A9BF-7DF47EF8BCC6@oracle.com>
References: <163673838611.45802.5085223391786276660.stgit@morisot.1015granger.net>
 <YY63HENw3fjowWH0@gmail.com>
 <46C06033-B65B-473A-91F1-584878354C72@oracle.com>
 <YZBD6MukiZXKgLo3@sol.localdomain>
In-Reply-To: <YZBD6MukiZXKgLo3@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e49edd6-840c-4acd-5a68-08d9a7173bcc
x-ms-traffictypediagnostic: SJ0PR10MB4496:
x-microsoft-antispam-prvs: <SJ0PR10MB44963F840A3A70C17D85F16F93979@SJ0PR10MB4496.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P3ZscWZAhFAcl51nXVjIJJx3mVpY+mDfAqmK0M0jTq7Ao58TA+726bW6MLXylQXPLvxk5b6oVSf5rHXD4dKgxJUHgZgFUiZh4/9aTU3WHjT1J2gekcnNGLaMTu0TKAtclK4p1gUZIYIyzTARmIOLzyzaLHFasWe6P5PB3k18iiFs0hiWtTGXWun/kfcM1suwJMi1Xcta0X+RgR+fPJPlRRSVESGAGhy+FoItYkR6WhAcfjQVixfkfZeccngtBuNTssIDLrvv8GU6ItxE0Wp2cnGfRPbYKAm7HBHeHBOAh8uQ3iZBA335207TyI2yKGUrxVSlS6nMfO9SsrZJ7JEpJYWyAZwUvYZ9ohz9KRldatGl8ACHlqTebieXtnUYS0his1mV98jOvQLpnxrqHebYSO+7cBCk07b8rkbfrMSN3N7ugG59yX4uVcYSJR0K11XT55xReMTCZ6M0FtnGGFiTaAEQn+o1Re4T135pzt73psEYkv8v0FvKG/cKmaCChjlQMhlfvc3xrfWW65QWlYNSqWgCQwYU3ty0B+tp2QNC87I5gryhyrQ0TgZL5OkY2k5M6K0LqJfQSl37IsUmzqDBtv2dlHXKaiswWNjOxezoOaVs702ayE8NBKQknqUrXbcE8rpiZzHN+HydxfM14otvISKdAWoVKdWURNAWsCSypoinhkSxdq5D5UMyjIP2qHPW5INfQqWCc57kxJKPVcu3YmP1tAoT8u8BXFVXSKsp8+WyHC53ZtaFcMrABjVv7M0yMeQt6C6GytrfVS1aA+/dE9i+5sY7cPUd45RTHla0LT3NF2KdQyJ0XfVA3NoQgb3yMiNzvCExk29smnv6oty3dQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(966005)(83380400001)(71200400001)(33656002)(64756008)(2616005)(6486002)(8936002)(8676002)(6512007)(86362001)(54906003)(66476007)(5660300002)(91956017)(76116006)(2906002)(4326008)(26005)(66946007)(38100700002)(6506007)(53546011)(508600001)(66556008)(122000001)(316002)(6916009)(38070700005)(36756003)(66446008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zlCels0AwqQMRMnQRFpwJ/ZB+VhBGhhzXw5Ic0sn4Oc/QJQm6vNAnNBZJTnY?=
 =?us-ascii?Q?DM4//LxPq4++AkwHXFgRnKmcBouZcflqVHLijPJTlTDL35HNHp24ozPvjNb+?=
 =?us-ascii?Q?4ynJjQ/4X40FI5JXW3Co6oMOsy578IXFewUxQ/kGvgUT9Q2JJ67Qinl4q/MD?=
 =?us-ascii?Q?CIRt1p3ilCHDLSWay5RhlMQLGJ+BG7dO+2czypsK1focu3ZUKTxeD/Wx4ztb?=
 =?us-ascii?Q?hvmAMNtG8baqlw5GM9/hs/7PObiVKzgciuUZrKYBbq9uE4m3QMSWVSLsglzq?=
 =?us-ascii?Q?KcEQlOGJwDlAdesf/d0EPWEqLaHfwjJsSEPd2iMSl87xnCIcZWmVlQsO1EhN?=
 =?us-ascii?Q?OP2VU2QKlj1yng1g/dhPgMtm3t6xpNW+alK0+tVm8q9Oe2Z9xSPVOaG1VutW?=
 =?us-ascii?Q?doi5BFeG4gp819W6xM0zBxwknkXRJmPb6MQaKkyIN13lZShuqj6OhZRzqwk2?=
 =?us-ascii?Q?H7d2XM+M5aE/pmtlVR6EAiTASB6VGcDfLwOlJqwmjd4uhSAwXX4ATPLh7A8U?=
 =?us-ascii?Q?znqpUSeLHdK1I6fkoMg7ehgeBqMQglFBSBoDUkMP15og489y7fqGM2KGyDG6?=
 =?us-ascii?Q?HIibTare2l0uaZ2SQrFiGvfPz4O+fR5w9LD2eEZLvqBJMDtcUyvirAppvHBu?=
 =?us-ascii?Q?ArxUFDBU4o+ff2TvCTFR67BHMusG53LG308gNk6crkLUDLO+Hek+rppia8Hv?=
 =?us-ascii?Q?Abh4+AqU92AdayJSjR5bGK9G3fWOvSzvUBOVKEod+MA/JQvuSaXhz7lEWDTZ?=
 =?us-ascii?Q?leiI+DRd8tcfVY0rZwC/ouw3ApxeikaBq5wx8K//IdgZFJ+rX8zbKzfp1OLU?=
 =?us-ascii?Q?2qtIItIiYkCXccsl+BtdGRdPCNbWw/iPsUK1lNGhO7ODFbYoBx7mXTyAspv2?=
 =?us-ascii?Q?jDgP7hx9hLm0Bi4vKVPmWSTZgenuOyrGSh0aS0eUoasIrs3HeDklhE8YPVmC?=
 =?us-ascii?Q?jUXYWiK4VINSbAn22yiTqMkVZYMRb5APPrtjqUMZFUoyDdCzNrT9o01GadSc?=
 =?us-ascii?Q?eLUoQtyUzs9+e3JoGhekQvt0QBBsiFon6WebxmjEM1EVUlFSDZXJtkMvlvYi?=
 =?us-ascii?Q?X7EemTVo20jnPo6UKA86Y9FdAu31QdAheeSzUZ4WuKV3T06SZdfuKRIi8Oe4?=
 =?us-ascii?Q?6f3G0DPP7SBJ0geoK1x3l3em44RmgDSqxSeiSGSZ01AQUpsmATrUBRD4YWxw?=
 =?us-ascii?Q?SfVnfUAL6tJ9kTKVsQCWpxPaNWnA5OxzUy/w/hT3e2zKSEUfw10dMwwEj2Hw?=
 =?us-ascii?Q?opKqzGEHBfq5Y4/QkY+9B08+BpPi22Wmox2VDC31joHYWPcytNisKhRW1vVc?=
 =?us-ascii?Q?tRcpiXz7FYyo3hZqGpVlNgNNtzfzakpdzMvE1Z/tNGOyyAd25DEKlbJU1ixT?=
 =?us-ascii?Q?x6VGmknv2lwe0HCuY6qzVtiwn8rlM8TPfWo3Mv+TmAtSlFt3v4PrjBt059No?=
 =?us-ascii?Q?OWHMxuylNK4P8LWvTa6cHUA8KlzcZa403iemRcPxESY/+kGcfWewr8EGZlMi?=
 =?us-ascii?Q?omsqfBsfbVSD9q+e57aneuiV/YHTm/RLOBMsm5iORgs+Uhe0IJS3vFT9/I/d?=
 =?us-ascii?Q?s73z/li1B/wFUT2+U8kyLaHUve6yQ4ShUZEAeOGXLZ5n7754JUE2e35sl0Ru?=
 =?us-ascii?Q?1Lj5DhygQGKlLNTZrwEKVOk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E1357E23203CAA4A8C39170663D48BFB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e49edd6-840c-4acd-5a68-08d9a7173bcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2021 02:34:07.8631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6v5xWst7YDUlMgUNh3QJxdfMuiggh8iE0q7lHLty9wpF7/sBcteWDTAJ1BIZZThCasabGyd31jv67Wjw1Y6ukQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10167 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111140012
X-Proofpoint-GUID: 05H7PN-dedt2WFmVsUoyJBZOIWqUqcqC
X-Proofpoint-ORIG-GUID: 05H7PN-dedt2WFmVsUoyJBZOIWqUqcqC
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Nov 13, 2021, at 6:02 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> On Sat, Nov 13, 2021 at 07:12:44PM +0000, Chuck Lever III wrote:
>>=20
>> Certainly, the kernel could include a single set of base64 encoders
>> and decoders that can be used by all in-kernel consumers. See for
>> example net/ceph/armor.c and fs/crypto/fname.c .
>=20
> Not really, there are many variants of Base64 and different policy decisi=
ons
> that can be made: the chosen character set, whether to pad or not pad, wh=
ether
> to allow whitespace, how to handle invalid characters, how to handle inva=
lid
> padding, whether to nul-terminate, and so on.  There's lots of room for b=
ugs and
> incompatibilities.
>=20
>>=20
>> Because PEM decoding does not require any policy decisions, and
>> because the kernel already has at least two existing partial
>> base64 implementations, I'm not aware of a technical reason a
>> system call like add_key(2) should not to accept PEM-encoded
>> asymmetric key material.
>=20
> Adding kernel UAPIs expands the kernel's attack surface, causing security
> vulnerabilities.  It also increases the number of UAPIs that need to be
> permanently supported.  It makes no sense to add kernel UAPIs for things =
that
> can be easily done in userspace.
>=20
> They work well as April Fools' jokes, though:
> https://lore.kernel.org/r/1459463613-32473-1-git-send-email-richard@nod.a=
t
> Perhaps you meant to save your patch for April 1?

That remark is uncalled for and out of line. Perhaps you just
don't know what "strawman" means or why someone would post
unfinished code to ask for direction. I'll mark that down to
your inexperience.

Interestingly, I don't see you listed as a maintainer in this
area:

$ scripts/get_maintainer.pl crypto/asymmetric_keys/
David Howells <dhowells@redhat.com> (maintainer:ASYMMETRIC KEYS)
Herbert Xu <herbert@gondor.apana.org.au> (maintainer:CRYPTO API)
"David S. Miller" <davem@davemloft.net> (maintainer:CRYPTO API)
keyrings@vger.kernel.org (open list:ASYMMETRIC KEYS)
linux-crypto@vger.kernel.org (open list:CRYPTO API)
linux-kernel@vger.kernel.org (open list)
$

I actually /have/ talked with one of these maintainers, and he
suggested PEM decoding under add_key(2) would be appropriate and
valuable. It actually wasn't my idea. I shall credit his idea in
the next version of this patch so there won't be any further
confusion.


--
Chuck Lever



