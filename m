Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74507C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Oct 2023 14:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344545AbjJaOxV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Oct 2023 10:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344518AbjJaOxU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2023 10:53:20 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E98FDB
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 07:53:17 -0700 (PDT)
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39V8C2J2018846;
        Tue, 31 Oct 2023 14:53:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=yJLKGx0IUbgRIVO+1RFwSJdCYeCaB3DK9EMnY4J10/k=;
 b=LqApjkWnD3qhDawUcTiNEAejyqUsBCw81lNie6E/Okpt7vJRqerwyTqaQY3jx8C67gpp
 Hjt0SyCEv/LLYW8QccwgMVDx+5Yxw33c0G8AhmshEibcJXvBIxMHqGMitLu7Z+3AM96G
 8wKl5ZrtPWrf+EhoVD9Gpllday7+4DukDxU5Ua+nqjLZPLoVZlg8YmkxmTlntzx7PFTy
 0pQqf6r2kvdsMv2H0F6NsFtXklKeAfXJ9JdNUGUyxovWgi2wQ0emRImAi82zkFRFoZYl
 ttfsIhJninCi/+4T35Q3AWp70cc8mw2G87oTvO329TaYI7j9MnqGaPfa9aGyob0sg2/9 JA== 
Received: from p1lg14879.it.hpe.com ([16.230.97.200])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3u2wuvd5vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Oct 2023 14:53:06 +0000
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 99CAD132C0;
        Tue, 31 Oct 2023 14:53:04 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Tue, 31 Oct 2023 02:52:56 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Tue, 31 Oct 2023 02:52:55 -1200
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Tue, 31 Oct 2023 02:52:55 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXM7chaUMAU6bjfQJe2WRfuITVYB0RK0njXXDLc42gfFD1jy/v+gSwAI0p1ONx3UXrx18DFdjRDZICSJyw0K/aBZ7UsTUZbuKnI2QzOrR6+JTFEN0HlGYaqZs3C33UqChN7wKbfUYkSzEsSTaOJYW8blLX/lBglo7FAjl/DBnldIYs0wKMR4eKWp6UmKw2L4qHbLasOjAOslMs2Ijje2r6xIM5m2XOfyMX4rYJS+/1XLUj7UdXevHsXN9Ei2FMljy41HkBCxDoZj5nhA9KxuZy1aLGxpF225r/syz5wPclUCv4p6RP/M3CxMK1hGQe6gzrYAKmaIdVIxp6LwdXXi8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJLKGx0IUbgRIVO+1RFwSJdCYeCaB3DK9EMnY4J10/k=;
 b=bx3aE9wL8ESht4C39/WJrlKtFp6iT0anJeK7co/idXLzeeH6Tz4DZzuUBq+H/U9JUOcvti1P6bSGf2niFAEdVEzVMOIGqRvQQG4jplQC18eYjNn7OUBOnLbACtbiX4iOo+kG9H9L7ba48vA6bwcZWxygbnUZdj5hUNZfsYU+ulu5up+arjnWABsmtySODD8Y/7fS4J24F7l+Zk+C5siWSfbQjHzu4cHD7BBbQ8lk5GRudAhkLI2EPVEkRYaooT9+GWdTlHwj/t7a8y/HWkk0Gy1v0JHmD26Je0tTx2Y/6vENhsv/hwlMd2iHEbQlsyJZbDmQApnXMHUkASkmJ+bvrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by PH0PR84MB1479.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:172::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27; Tue, 31 Oct
 2023 14:52:53 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::142e:16d6:da8f:c983]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::142e:16d6:da8f:c983%3]) with mapi id 15.20.6933.026; Tue, 31 Oct 2023
 14:52:53 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Roxana Nicolescu <roxana.nicolescu@canonical.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH] crypto: x86/sha256 - autoload if SHA-NI detected
Thread-Topic: [PATCH] crypto: x86/sha256 - autoload if SHA-NI detected
Thread-Index: AQHaCicmZVMxCgObPEK5838Zzgto+bBj5VuAgAAX9FA=
Date:   Tue, 31 Oct 2023 14:52:53 +0000
Message-ID: <MW5PR84MB1842C4652CCCB7738AE7FA4BABA0A@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20231029051555.157720-1-ebiggers@kernel.org>
 <34843a86-6516-47d2-88dd-5ca0aa86a052@canonical.com>
In-Reply-To: <34843a86-6516-47d2-88dd-5ca0aa86a052@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|PH0PR84MB1479:EE_
x-ms-office365-filtering-correlation-id: fc5d21df-d2ac-426d-32f6-08dbda210f70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mnFAWnv3P0ZuOYHR+gwWvxFE9mhwpr39dAc+JluhrY/Jv2F/VqNmzXEb0iJ7gXrJbzEemker1SunE9UefQSR4K4OounKZ2TzbyUyg7NkWdtT3bb8elSYmS78Z2FuOaniPycW46jUSNoxFd1iTO+6vyH/o2/6OC2QH9wANYm4Jlg9YLtXYSIdZXLdeyV59RyXmWcTrtzkfhLjt9euseA0N7xs+b9p4C5b+/niLvT6p/uOatXW74iW3b4VTvOMLiU9HPN4awv7rcd7G8/LL7oC8CA77DURHev0SNJgu176lCaJksedpHVtU9TMNx/1jkNY6nI8kGnzu0NZiN+8lcH6Q/9gWhy7G6WNz7Fn0WzS62v73tZQIRtoZeKb1ZzZ9Retv2ut2jOwxayQqBYZys3dZ1eM8+mvzCHx6EsBP6kIQlB9T7CIjNvp2ibrw70AooC5bXyuoK0/qglOLSti7gV4/n/kEe5643CfTGNIXPvc60jJwyBsOZwW0xDREYmXnn+PTLxL6r0c1dwucmgFWhEp3dHnFahDQIMMhjmHGCc8eWdHMlS87NMH3OiwlKI69p5AGbeVyobHfiXI544YjLrCgKo9l8PXRVq2wmvs1aZygEQK4gY+3GLhDQcYu70eILY+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(346002)(376002)(366004)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(2906002)(8676002)(8936002)(52536014)(66476007)(66556008)(110136005)(64756008)(76116006)(66446008)(66946007)(316002)(5660300002)(55016003)(478600001)(41300700001)(71200400001)(9686003)(7696005)(6506007)(26005)(38070700009)(83380400001)(53546011)(82960400001)(122000001)(86362001)(33656002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVY3MHl4OGdIcEVJTnJUS2JGYVkrWSsvZnJYN08wQ3drWnVaL3paRzg3d2pW?=
 =?utf-8?B?SjdJVERkaE4vR3I2aDRmTWVOa3h6c21nbzhBNFZFM0lTeGVVUDUzSDZHcGQy?=
 =?utf-8?B?R1dLYWZCRmt4a3U4YXJyM0RaOHZuVjhtTWJOSlREaFM4YjRWQ0Q2UjZlNnFr?=
 =?utf-8?B?MWovMFRWVUFCOGR6MVRyYVAvOTlGYm5idkZ5dlF3VkdFbmNJWkY0QWFNMzVq?=
 =?utf-8?B?bEhCTFBqRFRIZk81b1NINk0rU0o1QnU5VVQ2RGVtS3A1SC9UbXFGamZGc01y?=
 =?utf-8?B?RzhsQlZQZExuMDRZQVlyaElyVk53ekVuRnVnb1o0ZjNISDNTS2VZNHFyVi9V?=
 =?utf-8?B?dENkMGt4SlBXdFp4VEdZOEMxdmlzTVF0dFZwbnhBbjlpMUgyYnhuK3RSMk5D?=
 =?utf-8?B?Z0ZtY3FHWXNOVk1FdGlaK0RONFlaQjhSZnNqclZ2RDZUOXNnUmdCODIyMlQr?=
 =?utf-8?B?UFM2aHFPMHBnV2k3TmM1Zy9sMGV5OVB2L3FuMC9DMWdnUC92d0xzRG8zUFZE?=
 =?utf-8?B?QmZZVEdoditVRjM2dmU0Smw1YTA2cXRxSWdNTi9TUzB6YlZmc202Mmg0VGRO?=
 =?utf-8?B?d3Q4aERLMTZiZVlOcTVjNzdZNCt6YjBST0NxUFM0ek1tZVdoN0VvZVg5Tmt1?=
 =?utf-8?B?aWtJYW1WSWVQU0JnSFZ0K0FkMStaUENNN3hRZkgwWGl2dWlDMTBaM24vakFS?=
 =?utf-8?B?RGJhSHF2cWhNVTEwaVdJWDlNUk9hRGVLanJMbEh3THowS1hFMVJlWFIrN2hM?=
 =?utf-8?B?UVZOR0VJYTRPOU9JZHMwbmpSVjFKdjFySk44Mng2Ym1Xb28rSTFoWTZDTTZp?=
 =?utf-8?B?c1greElmZ3c0K2F6WVZtOGZiaDZSdXc4Nmx2bm5Qemd4UnhDTUNuRS80ZmNl?=
 =?utf-8?B?cmc4ZXdTZWhBTHZlWjdFTjYzWWphQVhNNEVuM2hJMUN2enhlWlpBK1llNkdN?=
 =?utf-8?B?c0o1MTJ2N3hyeCtIZ1UyMDhMY09ET1NJVmc0bjkxTEtDYzN4YVZraHZkMmo2?=
 =?utf-8?B?STRpRXVNOXR0eGNzSFlZLzVpN2E0ellLSGE0ZGliSjV2QWFlYVNOUjM0eVVw?=
 =?utf-8?B?VzVZTHdWZThHYTFvelN3WHFaQzNUMVZ0elhQR1Jpb1BiaDRCOFdZUy9CMERh?=
 =?utf-8?B?cUxlL1JLWlZ1YW0vVjlaVUVQUnJxSEI5VG5rdUJuZll3TTBRc0tWSjkwcElr?=
 =?utf-8?B?WVVvZGdkVjJ5cEhLNlZOWDQvVjhJMUFRYWpmdXQ1NmJxRVlydktKWExNa1h5?=
 =?utf-8?B?cjd2RXljYkpjaVB1dm9SaUdnNXpwYTVLc1oyY05BcVlEblorZTlnUFdIYlNl?=
 =?utf-8?B?c2lRKzl2YS8yb3JvWWNRTHd5OTFoUmsrS3pWVDBuOVNoUXRJcVJaNUpxUy95?=
 =?utf-8?B?VTR0S0Zvc2VtN0d5UGVGbDhweXZWQXpNU3I0UTJ1WDNXT1pKOS9NeVloK2dG?=
 =?utf-8?B?dUhtZEZ2ZittSm9memh3MTB5T1RLckp3T1U3RUkyWGtSRTBHOHNXSDBVVmpE?=
 =?utf-8?B?Y0llV2pEWkRGd2RheFVveTRqcGZUendKSUdZV09HWXJOV0VvTkVlcnh3WEJi?=
 =?utf-8?B?MDN1MmkwZytyUS8yQ2dQa2ZNRWRWdGVIQkZ2dklOYUtpZUdoUmpSalVka0Ur?=
 =?utf-8?B?c21MYitXU0M5M3NZdkdMZTRRV0w4Vko0UTBIby81ZExtNGswemNjeTZ5UnZH?=
 =?utf-8?B?SnVWRFFEN29rVTNFMXhkNXN3RFFNN3JqUlg5eW9XL2pBU2hNVVRLa0xSaE5o?=
 =?utf-8?B?QkpvREF3RVEzclhESWN4ZGNsRDZFdm41VGlmWG5ieXlTcGxwMkpxM3MzQi9h?=
 =?utf-8?B?WCs2UytXaktDVDFBYzNyZFY3ZUE2UVJBaVRVOXpOb0FaZklZSVhsSUk4cStP?=
 =?utf-8?B?TkNQQ1pvSkIxUUxEMnVQdXNadG1ZdXNmQ283NTNsYUdrVWJ5ckFhNEVWZkFN?=
 =?utf-8?B?ekt5TG9DWTlyQmg3MWRWNzJtRU1zWGlqRkhHOXNvV1EvRDIxZkcrVUpwWis3?=
 =?utf-8?B?MElRaGdSbzZ4ZXEzRWdyOHY1bk5mMFBzU2tqMlY4ZXd3WURnOUdac1pEYm1u?=
 =?utf-8?B?aGRnU2FjVkJlMWFnRjZDTElJUVJIV2xiV3VWN2M1Tk9NUmUxWWo0aStZRVpu?=
 =?utf-8?Q?f3cA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: fc5d21df-d2ac-426d-32f6-08dbda210f70
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2023 14:52:53.0517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wd2nMqrJ3ai35WExKMe2+hNxQSr1gqMFnrve26d/h3c6Suz2NHuKH9KYtqrypN/a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB1479
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: KtsaAW3n6NmXaTf5B38Fq2wiEX06SfJN
X-Proofpoint-ORIG-GUID: KtsaAW3n6NmXaTf5B38Fq2wiEX06SfJN
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-31_01,2023-10-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 clxscore=1011 impostorscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2310310118
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSb3hhbmEgTmljb2xlc2N1IDxy
b3hhbmEubmljb2xlc2N1QGNhbm9uaWNhbC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE9jdG9iZXIg
MzEsIDIwMjMgODoxOSBBTQ0KPiBUbzogRXJpYyBCaWdnZXJzIDxlYmlnZ2Vyc0BrZXJuZWwub3Jn
PjsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBj
cnlwdG86IHg4Ni9zaGEyNTYgLSBhdXRvbG9hZCBpZiBTSEEtTkkgZGV0ZWN0ZWQNCj4gDQo+IE9u
IDI5LzEwLzIwMjMgMDY6MTUsIEVyaWMgQmlnZ2VycyB3cm90ZToNCj4gPiBGcm9tOiBFcmljIEJp
Z2dlcnMgPGViaWdnZXJzQGdvb2dsZS5jb20+DQo+ID4NCj4gPiBUaGUgeDg2IFNIQS0yNTYgbW9k
dWxlIGNvbnRhaW5zIGZvdXIgaW1wbGVtZW50YXRpb25zOiBTU1NFMywgQVZYLCBBVlgyLA0KPiA+
IGFuZCBTSEEtTkkuICBDb21taXQgMWM0M2MwZjFmODRhICgiY3J5cHRvOiB4ODYvc2hhIC0gbG9h
ZCBtb2R1bGVzIGJhc2VkDQo+ID4gb24gQ1BVIGZlYXR1cmVzIikgbWFkZSB0aGUgbW9kdWxlIGJl
IGF1dG9sb2FkZWQgd2hlbiBTU1NFMywgQVZYLCBvciBBVlgyDQo+ID4gaXMgZGV0ZWN0ZWQuICBU
aGUgb21pc3Npb24gb2YgU0hBLU5JIGFwcGVhcnMgdG8gYmUgYW4gb3ZlcnNpZ2h0LCBwZXJoYXBz
DQo+ID4gYmVjYXVzZSBvZiB0aGUgb3V0ZGF0ZWQgZmlsZS1sZXZlbCBjb21tZW50LiAgVGhpcyBw
YXRjaCBmaXhlcyB0aGlzLA0KPiA+IHRob3VnaCBpbiBwcmFjdGljZSB0aGlzIG1ha2VzIG5vIGRp
ZmZlcmVuY2UgYmVjYXVzZSBTU1NFMyBpcyBhIHN1YnNldCBvZg0KPiA+IHRoZSBvdGhlciB0aHJl
ZSBmZWF0dXJlcyBhbnl3YXkuICBJbmRlZWQsIHNoYTI1Nl9uaV90cmFuc2Zvcm0oKSBleGVjdXRl
cw0KPiA+IFNTU0UzIGluc3RydWN0aW9ucyBzdWNoIGFzIHBzaHVmYi4NCj4gPg0KPiA+IENjOiBS
b3hhbmEgTmljb2xlc2N1IDxyb3hhbmEubmljb2xlc2N1QGNhbm9uaWNhbC5jb20+DQo+ID4gU2ln
bmVkLW9mZi1ieTogRXJpYyBCaWdnZXJzIDxlYmlnZ2Vyc0Bnb29nbGUuY29tPg0KPiANCj4gSW5k
ZWVkLCBpdCB3YXMgYW4gb3ZlcnNpZ2h0Lg0KPiANCj4gUmV2aWV3ZWQtYnk6IFJveGFuYSBOaWNv
bGVzY3UgPHJveGFuYS5uaWNvbGVzY3VAY2Fub25pY2FsLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGFy
Y2gveDg2L2NyeXB0by9zaGEyNTZfc3NzZTNfZ2x1ZS5jIHwgNSArKystLQ0KPiA+ICAgMSBmaWxl
IGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9jcnlwdG8vc2hhMjU2X3Nzc2UzX2dsdWUuYw0KPiBiL2FyY2gveDg2
L2NyeXB0by9zaGEyNTZfc3NzZTNfZ2x1ZS5jDQo+ID4gaW5kZXggNGMwMzgzYTkwZTExLi5hMTM1
Y2Y5YmFjYTMgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYvY3J5cHRvL3NoYTI1Nl9zc3NlM19n
bHVlLmMNCi4uLg0KPiA+DQo+ID4gICBzdGF0aWMgY29uc3Qgc3RydWN0IHg4Nl9jcHVfaWQgbW9k
dWxlX2NwdV9pZHNbXSA9IHsNCj4gPiArCVg4Nl9NQVRDSF9GRUFUVVJFKFg4Nl9GRUFUVVJFX1NI
QV9OSSwgTlVMTCksDQoNClVubGVzcyBzb21ldGhpbmcgZWxzZSBoYXMgY2hhbmdlZCwgdGhpcyBu
ZWVkcyB0byBiZSBpbnNpZGUgaWZkZWZzLCBhcyBkaXNjb3ZlcmVkDQppbiB0aGUgcHJvcG9zZWQg
cGF0Y2ggc2VyaWVzIGxhc3QgeWVhcjoNCg0KZm9yIHNoYTFfc3NlM19nbHVlLmM6DQojaWZkZWYg
Q09ORklHX0FTX1NIQTFfTkkNCiAgICAgICAgWDg2X01BVENIX0ZFQVRVUkUoWDg2X0ZFQVRVUkVf
U0hBX05JLCBOVUxMKSwNCiNlbmRpZg0KDQpmb3Igc2hhMjU2X3NzZTNfZ2x1ZS5jOg0KKyNpZmRl
ZiBDT05GSUdfQVNfU0hBMjU2X05JDQorICAgICAgIFg4Nl9NQVRDSF9GRUFUVVJFKFg4Nl9GRUFU
VVJFX1NIQV9OSSwgTlVMTCksDQorI2VuZGlmDQoNCj4gPiAgIAlYODZfTUFUQ0hfRkVBVFVSRShY
ODZfRkVBVFVSRV9BVlgyLCBOVUxMKSwNCj4gPiAgIAlYODZfTUFUQ0hfRkVBVFVSRShYODZfRkVB
VFVSRV9BVlgsIE5VTEwpLA0KPiA+ICAgCVg4Nl9NQVRDSF9GRUFUVVJFKFg4Nl9GRUFUVVJFX1NT
U0UzLCBOVUxMKSwNCj4gPiAgIAl7fQ0KPiA+ICAgfTsNCj4gPiAgIE1PRFVMRV9ERVZJQ0VfVEFC
TEUoeDg2Y3B1LCBtb2R1bGVfY3B1X2lkcyk7DQoNCg==
