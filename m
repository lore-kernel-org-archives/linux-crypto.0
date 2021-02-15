Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0B0C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Feb 2021 12:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79D2964DEC
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Feb 2021 12:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhBOMx5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Feb 2021 07:53:57 -0500
Received: from mail-eopbgr20128.outbound.protection.outlook.com ([40.107.2.128]:52325
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230456AbhBOMxb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Feb 2021 07:53:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6U5t/eIQfK0S5wwAJpuyThyFK/vsjy2sRBxW9ui4PjaciTvzKtezGdP1Al4p26ZFj1HuDY9w6XQX/8uEESG+FkSJexPvlIZM3e9PvgS67WrlOYcbKluqyq44HfuKl2UWpypGr9Ihfe4EXXhxlMCedtu1qmeNCWjXEunnCV/DZ6Ue+j3vgJkgyEUbuAaxw08LnBL4QREsmAQLItsNv3r/2fdJjqZ2q7w+3NI+SIWd66K+my6H/Rb4nljtf6F0a6nLOedC/dwK2/UPvKVqNLz8quXtcehmyJrYuwMzrxhM9FfVpCoZ5ke+0XnmCyEdhv0N7uj+zMD3Z2BQBaAj2UweA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/upXFrg4tWd+jfdGiQrzMXYiaGC68t2I2alvbkAl31A=;
 b=T5qkpl4iujfXRG3AE2gdait74lu69vu0H7ISnQNDPt5ibDU9Zi4oQwYIlvJSowUqpt7VjLdx76cyTOZKHW/bfYsXR6j8xwhqp+Li0iNesbJNs+JEpSqMA+o3wo51/Lm4DevdSnCyktogAolkni4eK/Wzv9no8sAZdpp3dyZgI0di66POEB+fd55xb/yEi/BMxijDVLvUGDVhePY6nWNhu7iE4TyTLan+2T/XzvQe8Yy4xeQT2eOXowTZh/I0Ml9idWXlSFLeG5blbv1A75F30Lgln8Nd6ThOZlPhY7xps1srGdkU5pykUv7dkOpFT4A52MNUwQ7osf3XquPTN7Uiog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hitachi-powergrids.com; dmarc=pass action=none
 header.from=hitachi-powergrids.com; dkim=pass
 header.d=hitachi-powergrids.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=hitachi-powergrids.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/upXFrg4tWd+jfdGiQrzMXYiaGC68t2I2alvbkAl31A=;
 b=icaVLfmnMdZSggoVO0L/SOY+ecXWQOBNr0eOR4NAW2NkNm2GMoLoYujBCDQenjZGd0TUazBHilQKtLc9HJZgxwl7P2MtJ6aXJ38plPH42C9oP68xg5H/2n6aHs/jkk1hw6GFq4M2MW4N/Th413wfA5/MoMdYhgQLhA6dUP84LMA=
Received: from AM6PR06MB5400.eurprd06.prod.outlook.com (2603:10a6:20b:85::31)
 by AM6PR06MB5495.eurprd06.prod.outlook.com (2603:10a6:20b:99::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Mon, 15 Feb
 2021 12:52:41 +0000
Received: from AM6PR06MB5400.eurprd06.prod.outlook.com
 ([fe80::dd3e:69ec:a4e4:5c7d]) by AM6PR06MB5400.eurprd06.prod.outlook.com
 ([fe80::dd3e:69ec:a4e4:5c7d%7]) with mapi id 15.20.3846.039; Mon, 15 Feb 2021
 12:52:41 +0000
From:   Luca Dariz <luca.dariz@hitachi-powergrids.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Colin Ian King <colin.king@canonical.com>,
        Holger Brunck <holger.brunck@hitachi-powergrids.com>,
        Valentin Longchamp <valentin.longchamp@hitachi-powergrids.com>
Subject: RE: [PATCH v2] hwrng: fix khwrng lifecycle
Thread-Topic: [PATCH v2] hwrng: fix khwrng lifecycle
Thread-Index: AQHW05qFV0ZE+WiQXUGvKi1k/RGcnaoU8hoAgERxIBA=
Date:   Mon, 15 Feb 2021 12:52:41 +0000
Message-ID: <AM6PR06MB5400DAFE0551F1D468B728FBAB889@AM6PR06MB5400.eurprd06.prod.outlook.com>
References: <20201216105906.6607-1-luca.dariz@hitachi-powergrids.com>
 <20210102211720.GA1788@gondor.apana.org.au>
In-Reply-To: <20210102211720.GA1788@gondor.apana.org.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=hitachi-powergrids.com;
x-originating-ip: [31.10.139.103]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f25386e-cb7f-4209-a660-08d8d1b094f1
x-ms-traffictypediagnostic: AM6PR06MB5495:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR06MB54958AFCDEC22092BF45F562AB889@AM6PR06MB5495.eurprd06.prod.outlook.com>
x-abb-o365-outbound: ABBOUTBOUND1
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yOKLZ8jkYgdE2CvZVN3MKVV57/AOQpM7GhG4rPI/gB2ODqYZozUxPE2j1Dry72MdyPFr8NpQqgN2DLbAOxRvYvzCnXPhsykPCamaHSVuqpLLQEof+R/7vzL5Ptv8UF1p+7jju7ysDfmT60BN6tXHg1kZN1ZNhaCy+3d8/ntEukMlXR2UcGM5AOvjMs3o9DFNiNvoLIdCgYrW9ntoDU/cjMv9TtADKiJ96GTy+hHcvuEW5ynzwZrrND9hIYHZzWcAxnEhFIpTaFi9SRYNST+tHgYyeuEH9yLlwgngo5bLcrJusyVr3tjj1EqT4TZinDFiqG0w/OXSgoJIIs35cbyU5c6ZE+HBVH+cbRK78almN0M7MY3WJVqlLa1NKHlU/vtTWFgc+8rMafly0WT2kZJn0yhA9AyC9Fh/06NHGiW4YRYKomR5nOFGSm66SarGshe3IYe2C2MElAQawugdu2m6FJw2B9eg9ytogy9lEHpzMFsNPCyO6IZFdtrwGEDB/GWjOhBYKG67YLF2QwRdmf2CQRS4VfTgEXbUWVEc9rlYUQ6zdj1iwk0yl8F57LeLHryc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR06MB5400.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(6506007)(55016002)(71200400001)(52536014)(8676002)(2906002)(4744005)(7696005)(8936002)(44832011)(5660300002)(186003)(26005)(86362001)(4326008)(316002)(9686003)(33656002)(66556008)(66446008)(66946007)(64756008)(66476007)(107886003)(6916009)(478600001)(76116006)(54906003)(40753002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Dt3yDIzTdlw06u9AQAhipFYytj4qQVpHQa9FUM77l8Fcgfcj4K4PM9aTNaDD?=
 =?us-ascii?Q?SSxFeuvhJTqiTtlpgqPbja6rafuDc+bzcjh4URDpEHMmZhDDNy3yUiogvrMV?=
 =?us-ascii?Q?zwBXd46IujBanNaFoaGxri9+J/PY0uGDpAV7lr7er19WLlNB+x+f+gcOfYUL?=
 =?us-ascii?Q?0CpO1bskJ7ZCvCkIfrgtpOgfdVkMWbupfrGx28Sd0Jfb/FhRs2TAD8gsnEgk?=
 =?us-ascii?Q?W92ovFhWQVMiOnaBlzAcrYnPVCMwZccqy19+aNfejdIPaNPlsVzjgUewMuwE?=
 =?us-ascii?Q?Jx0Nv88oy4BwufV97w/Ubt5DiLORuqUXxVT6Kka1rqw+oSSEBe1gBSabeSXB?=
 =?us-ascii?Q?9g5kmCNn3dkIDTPWidoZxFeTmZLL64v5BD5DxvpHqSn8SMt6zGLLRKTguAPn?=
 =?us-ascii?Q?jIEyKuIe318ewZYrikjR2zwlkqcm4g2cIA7/emWUuWKbtf6drMbeMv2tJcwg?=
 =?us-ascii?Q?NyZC/xwwV9urCMmM0oVrE+j+0Z9Xetg2+Ks6BNymkdg2WqLIGyxDZ2xLRY76?=
 =?us-ascii?Q?NGGiJFW2YtjvWU+CWZx9PIg5pkLUnB2mmM7OHVYB1QswmbSjPdmqxvfd0TPL?=
 =?us-ascii?Q?GRZHk4Tq5peG6z57nOcVH9FsAjPiDNwAHu8eYbXUrUXj0UDyfWRQ1JI+XnUK?=
 =?us-ascii?Q?m8zvWsqPWsasVjH5XbyxQQGHLXQmsfz7Gk/QyuTA71PuxAyHcFFtWIKWp8Yz?=
 =?us-ascii?Q?uP7xshRqNA/NIduPk9LhpbgZAckSCa8bsFUwnaSaOtp6G+JkCphkhxIkzv1X?=
 =?us-ascii?Q?NuquPR5MUOWVxh6P6HHdNhY3hRUAftHHFzrQkmp5lV7lQwgIM8tqxp7tPgsl?=
 =?us-ascii?Q?Tlve6FhgIUdZU3ah0cnf82698CUrNeZO2cg9akBT7pIUsEqHEo+INsI6IOOt?=
 =?us-ascii?Q?ZsiMBaCTD2o5O82juhQIRJDHmq4e+d+VqHRLRFqlvP7JeMw+vpvDP48/QGX8?=
 =?us-ascii?Q?knlNuzOoY8/Eft4HHBtFcCcZpCGo6kZrsWtLjpiWj0PN883KZgIRVibDtrEv?=
 =?us-ascii?Q?PE0h5LjODj9Qd/5Q6CjMv08dL1UM09df8wEL9sXe6slpSsKKDv/Eha8JLFMi?=
 =?us-ascii?Q?K/Wg21z9hjBQdtSIQXYeNzhjd8gV/+i13npN6oGZ4/nES18Ta+XNMt5X0jJ6?=
 =?us-ascii?Q?2UpsBqjETeDAhgOcXe8nAhOVpKnvSR7ALSkKG1I5WMY0PrHrOKKIILRj4U4G?=
 =?us-ascii?Q?8R2yKcQFGJFtZkVhWYx/eIQ5DgveV2i+drlWm2OELOKmE0mQyZeWhK3ORveI?=
 =?us-ascii?Q?P7NuFppybSym2F1Cclwa/l3XjClO4/9R9gZZj7MwU65X38Xu3HaqETnVqQbJ?=
 =?us-ascii?Q?n1qyTBLBGwpa0XUjQb4vKZ22?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hitachi-powergrids.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR06MB5400.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f25386e-cb7f-4209-a660-08d8d1b094f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2021 12:52:41.5119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fxi7u1Me1sYsu0mG+OuY9X3W1r2tCpvYiOYxre/9D9vxcLpI/mF2a5jNyz86BO/pKw9pJ0aNtEVXpe0Jf9FdrSa00Ts18sxXvt7sT7TYw5NhARgRvbRXXNi3AYYW0NfZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR06MB5495
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>On Wed, Dec 16, 2020 at 11:59:06AM +0100, Luca Dariz wrote:
>>
>> @@ -432,12 +433,15 @@ static int hwrng_fillfn(void *unused)  {
>>       long rc;
>>
>> +     complete(&hwrng_started);
>>       while (!kthread_should_stop()) {
>>               struct hwrng *rng;
>>
>>               rng =3D get_current_rng();
>> -             if (IS_ERR(rng) || !rng)
>> -                     break;
>> +             if (IS_ERR(rng) || !rng) {
>> +                     msleep_interruptible(10);
>> +                     continue;
>
>Please fix this properly with reference counting.

I thought a bit more about it, but I always find a potential race condition=
 with kthread_stop() and the hwrng_fill NULL pointer check.
In my opinion the thread termination should be only triggered with kthread_=
stop(), otherwise it might be called with an invalid or NULL hwrng_fill.
Am I missing something?

Thanks
Luca

