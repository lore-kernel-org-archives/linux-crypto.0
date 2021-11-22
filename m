Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FBCC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 17:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239361AbhKVRLL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 12:11:11 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11762 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238230AbhKVRLK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 12:11:10 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMGrdLD024917;
        Mon, 22 Nov 2021 16:56:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=L3FOZu2GG1sQOFitlJ8CtO46nazSGD6W3pzIv2LS2sA=;
 b=fXDm7prhj97yUuZdMtjaaABjqLQfo0wAapY6KxGKnwG50h67jk9k2vHxDPSewaoe3MN+
 FNAgkJdbqsTh38ASMmuMxx7XhoTrWH0wniQUG2NoJc2ibKUBz0qi1o2qKUbejJG9LrW/
 yI9r5b4e9zc/EG2LYT82u7XpskTp3C0FnIhqXNOaX7pSXbWj5FN5dE0mRfUE5nFq+oTe
 kQb6F3jMhxUfkHahbBqKczEpRtDIuJlNfIgiRmg7YhMP0P0hj9KQvPt73lNBJFrU8t4E
 Tya1XWeYzzt+S3rFuGA0UKS7i65HZ0frlsi/QI5LHOy7sEqmqTeA70YJgGSf21E+UP8X JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg69mb7dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 16:56:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AMGokSu158143;
        Mon, 22 Nov 2021 16:56:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 3ceq2cvxfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 16:56:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9y3iaUXnuKuJgS1vtoI3aYRQlDYfvxWFxfF4GNTmQ0fBIj2WUbCaTtEgUhlYNg8qFedKMlyhYvCQU51Vngzv8dGLShjImt8g6HRC0XpMEo4FhFbBTkKLwsjY3P/Owe/+dKFfaKvvjtnRJh8/h7HJCI+c0SnUGOLYfJ1cUihAXWhT2QeBsE6WVpAbpaWub4AYWN7ZqAXgh/q67CPZarDERiXI3AQ9QbDR6lKc4qF0a2AFPawAyG6ny0RUBHJC32KkFOUNrcUf1224wEzyAX8yz2XWQ9Xf9HyURojDN5cXalgR5gWbH1ua4Dyrv/B3TZunouUOg1XtBW9iPBwXsAGUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3FOZu2GG1sQOFitlJ8CtO46nazSGD6W3pzIv2LS2sA=;
 b=gwvOG0GErNC54YwHG7a0lNr6jqjtpFQ927Dmdqmr8isMYwwzqODRoY46YnP8LyolMbrEJmE+yInaeZQxe+1Au/vwe1LZKucCzX7jgvyOMQIjWn4v1bo66Fy6aQTGQIvabXV/BetFq8bJaO/uxy7tzSonTobq8WzHt+PWsfQD2LjA4uex6/0K7DCv2k3qhntl+sMxjTedrbo1jnk/djBAaSTydCrSqdzTglzUYQsfWYwxihE4SvUfgp6gkFQivS8TRaRxcwrLliLOu/kssWIjo9KCUgVvVojih5pEt0AtqumQhiH3HzhMY2kHXJyC5Hf8v80XKZUTd7cU+ITytP3S/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3FOZu2GG1sQOFitlJ8CtO46nazSGD6W3pzIv2LS2sA=;
 b=RtxIsy70jTqfd9X4ioH5Kq8K2bzw0045nUiPk208336XecO+n8U18ZYw0Pqu+BAY7PDlzOPAAVoN8SBnfX4SzqFVQr6gojiPNcleW0j4Rax+30xzj0AvH6a31+y3ll15yzpuvTBGFnemV8gcjmGkyolAT9FqpI92rL56bN0ikQ8=
Received: from PH0PR10MB5660.namprd10.prod.outlook.com (2603:10b6:510:ff::6)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.17; Mon, 22 Nov
 2021 16:56:24 +0000
Received: from PH0PR10MB5660.namprd10.prod.outlook.com
 ([fe80::edf9:9b48:57b3:2a20]) by PH0PR10MB5660.namprd10.prod.outlook.com
 ([fe80::edf9:9b48:57b3:2a20%8]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 16:56:24 +0000
From:   John Haxby <john.haxby@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Stephan Mueller <smueller@chronox.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Tso Ted <tytso@mit.edu>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>,
        Alexander Lobakin <alobakin@mailbox.org>,
        Jirka Hladky <jhladky@redhat.com>
Subject: Re: [PATCH v43 01/15] Linux Random Number Generator
Thread-Topic: [PATCH v43 01/15] Linux Random Number Generator
Thread-Index: AQHX3vewWy39tI151EiqhdM1dyRTOqwOlDWAgABzKYCAAAewAIAAtsMA
Date:   Mon, 22 Nov 2021 16:56:24 +0000
Message-ID: <DBF8E8A8-9968-4E81-8C6E-7BAD0C3F39FA@oracle.com>
References: <2036923.9o76ZdvQCi@positron.chronox.de>
 <4641592.OV4Wx5bFTl@positron.chronox.de>
 <CAHmME9oaS4TOpk7rQ73BRKeVLjMUNyt6EFyeOX=hZSkFBPDu0g@mail.gmail.com>
 <2560758.ogP2UNPRoF@tauon.chronox.de> <YZsyZua9T8DD6JF5@kroah.com>
In-Reply-To: <YZsyZua9T8DD6JF5@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81ca20a9-ea5b-4750-dda3-08d9add904c9
x-ms-traffictypediagnostic: PH0PR10MB5563:
x-microsoft-antispam-prvs: <PH0PR10MB5563E242589F148D0B98C56CE49F9@PH0PR10MB5563.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nCUhSdohRhnfD+xkjYp0dhCaZL4CaPhrYTCQgEJlnrLsRM5/YVB4jKQ3RNiFeA2TGyRzTFnxGrqnITKExFv1iLdYSUaKE4qeMT33WbP98YKkLwscbLVOMg42cqlxUWz8j1eBtZSty01Lb/+D5lE2Wh6x1livujbTD1IQI4Q1vYw5Z0K0eSm1wC9zQlEdYJbuaW3gPRi4vVGJnYkvSYf4F5xfYecSserxXrujXhbbTzK2EPK5BG9vm9DJWWo/I9sKoWRLYyveFzZbpL6go5oDg2uO8PXTa5N0ZcYPaJlo9JaYuJzkagX3zbJ66PaS3EscW2V3ZB2m0nF9QXiHgHihnNJI99CEjEJVyodoFP3WYIUE6Iolyl2xK/wnJxBJtLkx5LhPTHN6LIPM3tPmy4kxWQY2VMfQRMc6UtMoxWVqtDbfZCYsz7GCrfvh9DnbTXc5NyqiNDZUidLDFI0zoZChX5S9y12gnv/gtmifHFOOeP/nrVuXytVh9cT/RhvFhwmd8yFHLT8vZyhrnVjZblJqjUqCpeMx3zAePHIAeccORyrHFO5C6+pbmGhn3yFdOroX3vA2yEHG2tYU0z1UFs3+lSIiCO98X1LxEk8S4MTLzfmJdT04SW110uPbi6PW4eF7BmztUeIKQe0MlTrRUxxgGfSMXo0EFRrmuOZMvlEHewmSdzcwufeUZFicfsIA5NjUlbEcqsJP87YkIrRs/nspcEis/YA7dPdO61jhl5NEot8Tn/5MpiFnBg6smLtBcqOK4q6BnWnu4KimLMdFE6KVj19fN5LOcnhrtUNeSdy6BMp8s845nT4V3FpdY/rZFRcOKUQVr6kwLdMKr0e1fAIewA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(5660300002)(186003)(6512007)(66556008)(99936003)(4326008)(44832011)(966005)(122000001)(66446008)(36756003)(64756008)(2906002)(8936002)(7406005)(316002)(91956017)(66476007)(54906003)(53546011)(6506007)(6916009)(38100700002)(38070700005)(66946007)(71200400001)(86362001)(7416002)(2616005)(8676002)(508600001)(83380400001)(76116006)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QPA06ysDG7fgPtgAeyF6XKpMWiTu7Q/+6HUwjekkOH7QUL1y2MIMW0N/FgZF?=
 =?us-ascii?Q?c6K8kA8G7Cvcabb0G0eUxyv3BLtv1ugrrcUGn8FG8DWCRGusEWAIe+985NbP?=
 =?us-ascii?Q?+j7HJJeqO7E0KeCfUNpCxBLTZNTU/AB+GKguYBKJ9sfoU48I9odLLU9nuGdC?=
 =?us-ascii?Q?YYdJOaCB60rjPugzhDg/zkyJb3MfT8RYKcojpyx21Izo5alsjZM/OWSXql/y?=
 =?us-ascii?Q?dyhHr/otIoW658sZfpuAm4oV4/VJqLKR+B2DSqgUbJOEyq2WE+wt3xaTWigt?=
 =?us-ascii?Q?fC6XJ9aDic11LXSGvtbj6TpmUPWIwq796K7q8NaPsR645aBPjRN0HBQD/qxc?=
 =?us-ascii?Q?H/4vzb9H515F9FgZSbR94Isyfb/2n+xA+A0cvLohSP3mLnpMKr+fp8d2jHBa?=
 =?us-ascii?Q?zcCuxlTB+f8kZMRzsX2ehFxo7CmQqdj+GNeyzn0wQES5hWe+dD/6Jx08hrnB?=
 =?us-ascii?Q?FAP5B1L1qdmnOS5TAC6fgYMFpPFkzfl8Qzcu3KF26PDEqTOFKih7ZYCeS8jD?=
 =?us-ascii?Q?HOW+Q0Rj0dgtG9SS84s2DWFMlj9+Wt9M6PQVEbfSYI65kuf18eGi943C6W1s?=
 =?us-ascii?Q?rQGgRRZPXYxtejatT7F9oiPAx2HdeYfbytg8WGV/e9OPZrS7h2RmoAtBV+ab?=
 =?us-ascii?Q?3T051kl6VldlbbivH/T64D6ZZGzOwGLSrQ7Bop0nLZEjuUQRzwSOHylsbO/3?=
 =?us-ascii?Q?PcfvJKU7ebGYw8yb4NflG4RrvagsyiG+WVvvgHWRJomqXBQBM0bjRCCUmZLa?=
 =?us-ascii?Q?xACTvjEFh6UDcpqP8i2t6Kb7O1fwO5KOVyMAx9tp8oegbzlAifgQoR+bPXQf?=
 =?us-ascii?Q?Ftp0DnjX3SOPCD7mUzarzC25fHY+mWHk+GYtmpN6uXgoMcmJ61Z4jUHI5OBX?=
 =?us-ascii?Q?fHZFy3P6mQ/33o3pBVjG9Wz4+58gv6TuMTPu7pNLKnKYNRxxvxPyTeD5V+lm?=
 =?us-ascii?Q?Fl5tVIoqkHYbeePCZst0rnS13cr/rIdCuCDW7Lqe63KOmOpOZHXpAkq/A2ct?=
 =?us-ascii?Q?ho5Vd2hBgZCounWUj0yqeJvlebz++p5p70RP9dsEkHDr7rAsxU/yOPhWJC2U?=
 =?us-ascii?Q?7Ymdr4IZ/SMQGDu5eYZCaS4gk/9vjRbWAXVqi5AB8oyfprtLQt2AFzWCvsvL?=
 =?us-ascii?Q?tvHJKxXQD/FwoioPGshk6l36RHV+enEbq7DVWQPPolw2x89O40o4Ss4rCMQd?=
 =?us-ascii?Q?uTzzBJVQ0gXLu/4ukogbv9VzY8sLOGm4sMeeq5/Z/m9CsKvIzs2PzX8qtrOM?=
 =?us-ascii?Q?rueuaxL4v5n8h0/yRcH1K5jX/gKiRT2T3h1q5rxLgLfV9gIBwuo/tEJOXsBZ?=
 =?us-ascii?Q?MWH21yh71sWjkzewOnnLp6jO4jiDssJxuA6QT9xKT/tJ6gCtKTnDUZ+TufU2?=
 =?us-ascii?Q?fnXuUOm8+oMyNXzEmZISB5Qs5EbJ29BEZnjRjxA7JqemJGCkZbeTSuV+r8hP?=
 =?us-ascii?Q?O7L5YiMSOL2yiosS3rRlIDtiL4Vcqld/T1XVWOQOUXKePpaJX51QM1zx+soV?=
 =?us-ascii?Q?D8xE7B9L1iDdflhBVnN5D32v0y1VfFapd5dy80+GukEg4iUyOuTt3IkjQE3U?=
 =?us-ascii?Q?DpQoEX4MgPxagNrju5lYRwAaUOY4TFQF98LV6qQFMCCNliYNVlRqpJLpnruV?=
 =?us-ascii?Q?qWGaIC5ad0CfJUmHaKrchVuN6wHr2/2GMtRjD59ZtneLC06oa++CQ/5Oy6aA?=
 =?us-ascii?Q?bwUb5VLmGGzpQsIhcVeZBs90/JM=3D?=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_9F5EAF58-C5F3-4D88-93EB-779CDF09FF15";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ca20a9-ea5b-4750-dda3-08d9add904c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2021 16:56:24.8088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lns60f737IKgUtatkQLDmeo2vOZX020AGAF6ZmIBceJB/viVnT1X3jYd7mYj3Z6cYksu4RmKV0GTE4DadsIOWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10176 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=940 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220086
X-Proofpoint-GUID: btFop3_DQ2U1Tb3M6mKwK1urQNNCW5Vf
X-Proofpoint-ORIG-GUID: btFop3_DQ2U1Tb3M6mKwK1urQNNCW5Vf
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--Apple-Mail=_9F5EAF58-C5F3-4D88-93EB-779CDF09FF15
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On 22 Nov 2021, at 06:02, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> On Mon, Nov 22, 2021 at 06:34:43AM +0100, Stephan Mueller wrote:
>> Am Sonntag, 21. November 2021, 23:42:33 CET schrieb Jason A. =
Donenfeld:
>>=20
>> Hi Jason,
>>=20
>>> Hi Stephan,
>>>=20
>>> You've posted it again, and yet I still believe this is not the
>>> correct design or direction. I do not think the explicit goal of
>>> extended configurability ("flexibility") or the explicit goal of =
being
>>> FIPS compatible represent good directions, and I think this =
introduces
>>> new problems rather than solving any existing ones.
>>=20
>> The members from the Linux distributions that are on copy on this may =
tell you
>> a different story. They all developed their own downstream patches to =
somehow
>> add the flexibility that is needed for them. So, we have a great deal =
of
>> fragmentation at the resting-foundation of Linux cryptography.
>=20
> What distros specifically have patches in their kernels that do
> different things to the random code path?  Do you have pointers to =
those
> patches anywhere?  Why have the distros not submitted their changes
> upstream?
>=20

We (Oracle) are carrying such a patch at the moment.  We want this patch =
to be a temporary workaround simply to get FIPS certification in the =
current kernel.

We're carrying this patch simply because the certification requirements =
changed and this was the quickest and easiest way to workaround today's =
problem.  It won't fix tomorrow's problem and next time we, and others, =
attempt FIPS certification then we, and others, will need a different =
/dev/random because neither the old one nor our quick and dirty =
workaround will actually be acceptable.

The commit we're carrying at the moment is here: =
https://github.com/oracle/linux-uek/commit/5ebe83413c7573d566e581461bc95f9=
f139c5d4d -- you'll notice that we have a different RNG in fips mode =
compared to normal mode.

We really don't want to have to work out a new hack for future FIPS =
certifications and I'm sure no other distros want to do that either.

Personally, I'd far rather have any fips-certifiable /dev/random drivers =
be in mainline where everyone gets the same thing.  I don't like =
carrying out-of-tree patches like this, it's not healthy.

jch


> thanks,
>=20
> greg k-h


--Apple-Mail=_9F5EAF58-C5F3-4D88-93EB-779CDF09FF15
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iHUEAREIAB0WIQT+pxvb11CFWUkNSOVFC7t+lC+jyAUCYZvLtgAKCRBFC7t+lC+j
yP09AP9pwIKmNQRjv+XK88yZQp8qcSqUa5KApJgORWU9Zv5w2wD+JK/OinXAN6nw
Sz0VLGuXGQ6D8F4NdK6b+9RcOBc0GHo=
=1QIx
-----END PGP SIGNATURE-----

--Apple-Mail=_9F5EAF58-C5F3-4D88-93EB-779CDF09FF15--
