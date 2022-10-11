Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE559C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Oct 2022 15:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJKP1P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Oct 2022 11:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiJKP0x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Oct 2022 11:26:53 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E32B14E3
        for <linux-crypto@vger.kernel.org>; Tue, 11 Oct 2022 08:17:58 -0700 (PDT)
Received: from pps.filterd (m0134420.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BBvMXp030401;
        Tue, 11 Oct 2022 15:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=+zz5QfXnENUK7or0DDBFmrdK7EwDzIc7surEoNm/jNU=;
 b=CRR+dDZanEG8NM7y4hOEYABvP0y6E0Yc4fTZzh48xEs/+eZFtWuDjY37GP542ngMVZW+
 6yiXNTxe75J9qcmKDGJJp2Bl497sd5AjUENjkJFJHypGr9rWvmDYkoz+zKZtLQ3kG5uB
 twmO9HiDcHdKNAKbrRkph9VX+joCJk28yU2gHt8uHOSEgDniTW2YfJQnE5NiIhbvcSGe
 f96UI/H1WmFI+oo26iq9fR/zZ6Kt+9PgJBhx/uWMj6wK+xI6ARs7nUsoEyXu0eCpHq8S
 9Ux5h+4U5RTJyn4zujNtoCYQy9z5pK3aq6HZVTMS6QaO6B93NzZm+W/OFUKkOjxHUj44 Vg== 
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3k57xtj3n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Oct 2022 15:16:18 +0000
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 729EA806B5B;
        Tue, 11 Oct 2022 15:16:17 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 11 Oct 2022 03:16:16 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Tue, 11 Oct 2022 03:16:16 -1200
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 11 Oct 2022 03:16:15 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWCheu1s8HMse0qvTmG29pJ+8Ep25UEzulv0+ihGSnLxgyhEVZpIZo6I7EBfaYZmoMvjg8QBFgFOeZfziL+0hGb9Y4L3FX6jLqqRxlellg1svZVssVXhTTmKlQTEmuZVwwvkx4Xq/8RYSjj/6VD7eWZUpi+zXyZp1UPVQK2qvW8Pgn6PWeBlevfmqNodxrDmnqlnyIWE59xcQAVDYBDS5NsIrJeuxFyV8kJsK6PbCueJoWXnhPWqPWovQnheHY/h0zg3mLix9oJ8KwyVCxRfeXChEmMK+hmuWBaiFrq9VDCwm+9LdbOVN8TKfn6AsS192p2jRcyA3sIG7WraOL1CFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+zz5QfXnENUK7or0DDBFmrdK7EwDzIc7surEoNm/jNU=;
 b=Wt33vDvj6lBJGedlAg4Mv1Xzt3XMBUxiKwzFr+Jh4RrLkdHwcOlLa9/MqESs04DyXqIL50huogK5eCJWXrdSK3wR2RdvsqyQlnUJpbFX0CoLrqs9EJRXFJurtPnmijKu0tOuDVK7FlSOTM6tOgGFpmiBOUdmUZcfAlDoxVKBq4A4e17VU6TDvZDpWQRCfHiXAzs4jb5T4ORqxfSGpKb4pBLNZPSa/X3Yatw3qraOb2Qpod0F447jJ2zSsFjMrNHqOeu39RVwBSAYU2liwcCrGvknZFrk/DYrzwOcbkjyESrYOmWbnmlN9EueIyIPxZAZ/0ZS1wFcltAdNq0sdxvTOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by SJ0PR84MB1700.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:433::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Tue, 11 Oct
 2022 15:16:13 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c023:cb9a:111f:a1b2%5]) with mapi id 15.20.5676.032; Tue, 11 Oct 2022
 15:16:12 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Ard Biesheuvel <ardb@kernel.org>, Taehee Yoo <ap420073@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "ebiggers@google.com" <ebiggers@google.com>
Subject: RE: [PATCH] crypto: x86: Do not acquire fpu context for too long
Thread-Topic: [PATCH] crypto: x86: Do not acquire fpu context for too long
Thread-Index: AQHY16zBFmM7SwmJd0SQI42PUTup5q39qv2AgAATNYCAAJL7sIAFLlCAgAFSKxCAAM1MgIAA4KgwgALKpsA=
Date:   Tue, 11 Oct 2022 15:16:12 +0000
Message-ID: <MW5PR84MB1842A321C785BC0DEF490A31AB239@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20221004044912.24770-1-ap420073@gmail.com>
 <Yzu8Kd2botr3eegj@gondor.apana.org.au>
 <f7c52ed1-8061-8147-f676-86190118cc56@gmail.com>
 <MW5PR84MB18420D6E1A31D9C765EF6ED4AB5A9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <CAMj1kXGmKunh-OCvGFf8T6KJJXSHRYzacjSojBD3__u0o-3D1w@mail.gmail.com>
 <MW5PR84MB1842762F8B2ABC27A1A13614AB5E9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <Y0JoDWx0Q5BmO/wR@gondor.apana.org.au>
 <MW5PR84MB1842FD77B90B1553367235CEAB219@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <MW5PR84MB1842FD77B90B1553367235CEAB219@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|SJ0PR84MB1700:EE_
x-ms-office365-filtering-correlation-id: 94f15750-9e82-41c9-397e-08daab9b88bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BthjgiJVGdpN+K6AN75fMBPm+RwjEbbgBHC7WhFDtaV+ThpJJe6tDRAw9oJ9+SmaT2QFoxPRpTV5/gdoTzvKdD1Sw2vrZNH5SmuDyvNB+YY5unGNsEMGT2VpTRK3+jN4ekRfcI16Xb+2wTPm5ooVd5a/OqOYZ7XDwmnDrB2g5HqkHV3TU4nfRtrVo/IP0SNroIQ2K82NwYxOtFBNLfh5VgHhEq8kwhYLUCVgFVlAhCAsKNOAyDEvhSBUYdm04lOTiItJ1eVePqYYcEWxLKztMYZE7bgFgDG4/O6Z9UNpv8Y4qhnSO2s8n5IOEXWAhsw4Qpa7y5tjzj0DL+zTJK49D1/bvcooWs8gr+wDwjlhPDb5hKTgq5PuqD5ImfU5Gd+vUuXC5xRS4Xm0Yq3Z8TRo53WXEwWFVQNU98f9TXtPkOEvfBp/j66UsfJ4fFR39lNZsgMsj2JwOORtCVSSQw7PGBTYvo78zEFlnA/dKhLtS0mExQPL103f+V3cG4E6C1XKe+JApmWz15niyRE4Q9dRF6ZlLppmfwMz5OomOyEbcy5TypwNP3Rxr5oXVXZpFJGKxrWNZZKh+kkhNb/6tMNsIU0sseVmt1O5Ce8ME2s17qOffZyGqQeI7UXO8scAjLOyl57tTn6l9JzUHf6G7y3xmftnLTyD/ovWlWmiWJDC7tpIhForA5KX4rx9R0pIS4Y2CT92VWrHSaDq8dCadd/xyNoEr2kqXbNt4EeOSuoc1IoNF5RYR3E7w+Zc7EIAhUcRi4HSIfNX/LTf6xQe/dGjcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(26005)(9686003)(55016003)(316002)(122000001)(38100700002)(38070700005)(71200400001)(8676002)(110136005)(54906003)(7416002)(82960400001)(33656002)(86362001)(83380400001)(7696005)(186003)(478600001)(6506007)(66446008)(5660300002)(64756008)(8936002)(2906002)(52536014)(66556008)(41300700001)(66946007)(4326008)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P89Ykz5bntIHo3zoXCLNMyY+vz89rE5JfH0OlJMXTOAyXtI1dTE05QPRKLyB?=
 =?us-ascii?Q?DULymV+KydNJw4oZ5pCAlZKrzXOOcXNz/Pryeu/4cEyi3ZVEf+BWiqQdX1KG?=
 =?us-ascii?Q?gROZ6OGx5BMHAmcRkH4ydFsXq527zqgrCdsYOXjy5gl7aVU8Q7dlmGHTq9aa?=
 =?us-ascii?Q?RsTIYI8bTt0LXBb6ecR8LuR/a6kR7Z6YqmfOsTDw1ldd7dhBNYgcWuFc6aC2?=
 =?us-ascii?Q?V1yH+wphdXE+IPMv6NpD9j+QpwGrKuybNqHhzDKd90j3sj2r0Xqc5hZFIyKm?=
 =?us-ascii?Q?Ms6vsFgLgJpEkZD8B3LFfiREX+wztD6WDgVB5RWJZ2b0rmJYOGWS7pRLIlnF?=
 =?us-ascii?Q?Aux16dbm9ZbM7IlSAQZCFlPp2xKEjAXul60gfDwoGOtKVBt1WGnCDvznl+R0?=
 =?us-ascii?Q?ewn/lA6HWKRmkAgfp0NXiGufBQNtF6wxsxkVKu2cMSnZJuYev8tGeYrpaI/Z?=
 =?us-ascii?Q?31Cfu2aB9A8lPh6h58n5IOUCFGM9dY0s45o39wEoHzhxyhC8qt62UQ0ldAui?=
 =?us-ascii?Q?apoGxQNa4odhBy4YnpWTLkize7YQ3Qqp3Qu8M1XQiYHGS9FKHlSIcPNc9Jh4?=
 =?us-ascii?Q?FWdmesZjKihgsXYDA7JqOZOhbx0mHUjG8lhRdWAYBc439k/bf79MisQAI6i2?=
 =?us-ascii?Q?MBmRcqqBrrE5MQEeKAoG/jIKR1KbH+GZS12S8FHYoUP+eKZI2YbcdfaestIy?=
 =?us-ascii?Q?HKH3WoGJ0AzKS4YZ1vqSyUJ/37Evamn6p0UsnMOv2S9q1mNaFw+4XEPXP0qx?=
 =?us-ascii?Q?Z+LX19DSRXmUOUGxp4DaoYTLSp8vC0a2iIg51d78MROQQLhGc2pO1+w1fQNP?=
 =?us-ascii?Q?MprXpwY7zdSYJKgo9y9muec59oKKokdoWjSwGVP0XM+WqFIoaRZZM3GdBbue?=
 =?us-ascii?Q?oMdv4qQKo/BSLipBx3paluIe5RFw7RZhjofvE6XoB2qi1AAhxeCNf/PGfg1w?=
 =?us-ascii?Q?9S5Eyg2wQ/FsA13whIZlMpLv8E+NihACCrSbEI8OHbviA5r6yvfmb8D5PwQZ?=
 =?us-ascii?Q?Cxr8z/O7FvmQpj8vwSI0R4q5a4WnatuKOuT4nS8X2jTvtFD7SFQ/zKWUKLg9?=
 =?us-ascii?Q?UHsZSOw0mKiHG+4Ph5ocmsctemAodoZd8k40hE7wyESFQ2TQSvScN3kLxWOi?=
 =?us-ascii?Q?VPfzqhDiDd4ELuGEq6p5NuhOcP8xKNGClSOnpadNuqDqpuO2ESJipNPqVLbt?=
 =?us-ascii?Q?KPPj5gBfaozXf5U2Lg2zQGwS2oMH3fjHLZWKb09A8nDcK3GqkUeMpFY+820G?=
 =?us-ascii?Q?xH+TQR6gIUFqGvx6CpDqM9ZKAyHIx+lEqNbHH3IcXtYDtb7ylNjAPG4V9WI6?=
 =?us-ascii?Q?zMYPwYEBU3p36AZcxueOZUQPIXD8oWgX8u7qQoTW+/xVqwOVsIWlTzGnCZVv?=
 =?us-ascii?Q?g7YOgOfBO6vBAX17l9bNAerkxb+3E9wWUz36PxbMmv21ScnQ0b1KFq2Fx+ug?=
 =?us-ascii?Q?c9kX2vmEjhQKPh3ePNrySiZ+3izQfddSFOdEvdTsd/qnfAZKfpGiTF8XoyjU?=
 =?us-ascii?Q?MjXPpfrFZBteogTqo2qCJJAfIreq2XyiMfkbE4GkYnFEWuscr92/Y8zpE7ne?=
 =?us-ascii?Q?x0UEbnITi8WWSlZZ79g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f15750-9e82-41c9-397e-08daab9b88bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2022 15:16:12.8704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nrQb9FOBcK1M0//vetTx1ncmUaFMDl3OByT3o/fI7CySgAwt9wx53sa0sWSK2Cmw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR84MB1700
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: krmPqojRjyXqzy7bYZfPCPSD1QtulGYa
X-Proofpoint-ORIG-GUID: krmPqojRjyXqzy7bYZfPCPSD1QtulGYa
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110087
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> > From: Herbert Xu <herbert@gondor.apana.org.au>
...
> > On Sat, Oct 08, 2022 at 07:48:07PM +0000, Elliott, Robert (Servers) wro=
te:
> > >
> > > Perhaps the cycles mode needs to call cond_resched() too?
> >
> > Yes, just make the cond_resched unconditional.  Having a few too many
> > rescheds shouldn't be an issue.
>=20
> This looks promising. I was able to trigger a lot of rcu stalls by settin=
g:
>   echo 2 > /sys/module/rcupdate/parameters/rcu_cpu_stall_timeout
>   echo 200 > /sys/module/rcupdate/parameters/rcu_exp_cpu_stall_timeout
>=20
> and running these concurrently:
>   watch -n 0 modprobe tcrypt=3D200
>   watch -n 0 module tcrypt=3D0 through 999
>=20
> I am getting miscompares from the extended self-test for crc32 and
> crct10dif, and will investigate those further.

The assembly functions for those two do not handle small sizes (unlike
crc32c, which handles all sizes), so the new do/while loop needs to
use larger steps and call the generic function for any leftover bytes.
I've corrected that patch.

> After changing tcrypt to call cond_resched in both cases, I don't see any
> more rcu stalls.

This ran cleanly with a few nights of testing with=20
   CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy

which compares the accelerated implementation to the generic
implementation under randomly generated test vectors - a very
helpful test suite. It only works with data sizes up to
2 * PAGE_SIZE, though.

With the cond_resched changes, rcu stalls are gone with one exception.
If printing of Call Traces is triggered for any reason, either by a
test failing (e.g., because of the CRC loop bugs) or by using a SysRq
trigger like:
   echo l > /proc/sysrq-trigger

then the very act of generating and printing the Call Traces can
trigger rcu stall messages. Examples:

  Oct 09 14:56:39 kernel: cryptomgr: alg: shash: crct10dif-pclmul test fail=
ed (wrong result) on test vector "random: psize=3D4303 ksize=3D0", cfg=3D"r=
andom: use_final src_divs=3D[<flush>95.43%@+4, <flush>4.57%@+6]"
  Oct 09 14:56:39 kernel: cryptomgr: alg: self-tests for crct10dif using cr=
ct10dif failed (rc=3D-22)
  Oct 09 14:56:39 kernel: ------------[ cut here ]------------
  Oct 09 14:56:39 kernel: alg: self-tests for crct10dif using crct10dif fai=
led (rc=3D-22)
  Oct 09 14:56:39 kernel: WARNING: CPU: 55 PID: 10553 at crypto/testmgr.c:5=
837 alg_test.cold+0x3e/0x124
  ...
  Oct 09 14:56:42 kernel: R10: 0000000000000003 R11: 0000000000000246 R12: =
0000000000040000
  Oct 09 14:56:42 kernel: rcu: INFO: rcu_preempt detected stalls on CPUs/ta=
sks:

and:
  Oct 10 19:45:02 kernel: sysrq: Show backtrace of all active CPUs
  ...
  Oct 10 19:45:03 kernel:  </TASK>
  ...
  Oct 10 19:45:06 kernel: rcu: INFO: rcu_preempt detected stalls on CPUs/ta=
sks:

If there are no WARNs or call traces, then there are no rcu stalls.

So, we should be aware that commit 09a5ef9644bc0e1 ("crypto: testmgr - WARN
on test failure") might introduce additional errors.

> BTW, the way tcrypt always refuses to load leads to an ever-growing list =
in
> the Call Traces:
>=20
> kernel: Unloaded tainted modules: tcrypt():1 tcrypt():1 tcrypt():1 tcrypt=
():1
> tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt(=
):1
> tcrypt():1 t
> crypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt()=
:1
> tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt(=
):1
> tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1
> tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt(=
):1
> tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt(=
):1
> tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1
>  tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt=
():1
> tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt(=
):1
> tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():
> 1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcryp=
t():1
> tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt():1 tcrypt(=
):1
> tcrypt():1 tcrypt():1 tcrypt():1 tcrypt()
> :1 tcrypt():1 tcrypt():1 tcrypt():1

That was already noticed and a fix has already been posted for 6.1
as commit 47cc75aa9283 ("module: tracking: Keep a record of tainted unloade=
d
modules only")


