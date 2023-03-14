Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAB3C7618B
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Mar 2023 21:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjCNVUe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Mar 2023 17:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCNVUd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Mar 2023 17:20:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3907823A6F
        for <linux-crypto@vger.kernel.org>; Tue, 14 Mar 2023 14:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678828830; x=1710364830;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=ZFkjfPHg2hq5ah7w10x4QrRF/e0eREOGvDplU470vJE=;
  b=MPjdF0T7Z/QLltE8EfEcVxFym7DjJHBKdwS50fH+hZgBholwiTCox99a
   kHT+Po2wGwd2kAbqo7Gh0HrlHyjGghJ8FObklPsuc6vSO1+TES6LiGmuz
   ZizUjL1iWeF55XBk7mAcOsqCCjHBInGwEnvbxtz1Hf0QGDX0uevAn/nKI
   4gzsPDsWX0DS4AOHeaMjKTVLiDgxaiATHxbLFW5uYv0+/B30YfNZKf6Gm
   tP0B9pa8tcN8dS+8CKfyZzzuEBv6eXwMh+0OyY1gT+50nrIGJNukBEcHq
   PlgIDMfmFXzTTvtg1EzUAHRd2D7MV9rl2XQEd0/Vni+EmesxwcSsIPw3Z
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,260,1673938800"; 
   d="scan'208";a="204781880"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Mar 2023 14:20:29 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 14:20:29 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 14:20:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0OSJkzJRxxQGGxS6mGAQZTTBbJM7NFySOKt/U2psbtACS4b/ASK2Ya7NAEWPZo1SlVawPuG/JbTbIjBRSIPIKjlDocpWkhFft9QOqV1+uPef2pQhWpzjzyENTH+YOE3T8rpo12YeSG5xTqCn5Zm2bDJKWltnW6lq0deUZuvKG2WneoQ/1GPzyELVdDjBSxqm8jFpUWIsxtttsRMgWwxpIfW4memLP+zIWf6LdJk/PK/FpbTnE/GjScUqdaRsKnR+ktRUgcNlDO4Iye0jwOZ/H/Qht51gRq/RqIrrqwsMSYvSGwO0FEr0GJo53uMfIjN2jM4L4b72RVnWRNn+l7Z5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZFkjfPHg2hq5ah7w10x4QrRF/e0eREOGvDplU470vJE=;
 b=IlkJtrTOnekLe7DR7F0Px3nK3HxPvFc3cMVrXBgyJkeZSf0qbET5LBlEtuv0aVMmmJZFhhhetlI/aCH13hIO5yv9+qz1OZ7/ahxVOXtQh8OAP6Yy3tHbqQpxp3Z/ZsEALtiV0tWZRDg1Q1JKUpCni6vZVvJzZu4HOLbgy/r84C2tNW9B9JfHeiumIbwJHe5kDixhx15K2SkF0tL6mpxfFewcbWt6YwL0NR739RFnw6bQI6YgKYGJmU+yqtdq4OE/TZ1dMpad0hb8TaYnzLy98sCJ1l1wqk4PNExYVYJYpN8TLJ47mOmqqk3UXw+efRelMvCzkAq2Kba/wydTJfN47w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFkjfPHg2hq5ah7w10x4QrRF/e0eREOGvDplU470vJE=;
 b=T5LSJVn9fNtiq/XS+KqEs9BEc/hSQ/USs7vvHY293AJ53R84N57OK/oMAKDfX3+0qDRQDXhxFMCE66j/7wf4HYDeQ6KyIKUox/+jtFPG/6OTDSW5QQoFMXvA5xKnPX/7KpS5NM/Q7IAui8QSnvxDrBVnsXNxEa68DlWjVb3/mHY=
Received: from BN7PR11MB2657.namprd11.prod.outlook.com (2603:10b6:406:b1::19)
 by IA1PR11MB7892.namprd11.prod.outlook.com (2603:10b6:208:3fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Tue, 14 Mar
 2023 21:20:27 +0000
Received: from BN7PR11MB2657.namprd11.prod.outlook.com
 ([fe80::db4f:eee3:3e4f:c8bf]) by BN7PR11MB2657.namprd11.prod.outlook.com
 ([fe80::db4f:eee3:3e4f:c8bf%3]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 21:20:27 +0000
From:   <Ryan.Wanner@microchip.com>
To:     <linux-crypto@vger.kernel.org>
CC:     <herbert@gondor.apana.org.au>, <Nicolas.Ferre@microchip.com>,
        <Cyrille.Pitchen@microchip.com>
Subject: Crypto Testmgr test vector questions
Thread-Topic: Crypto Testmgr test vector questions
Thread-Index: AQHZVrrMS06LMeRJT0uiVBcTUQpkug==
Date:   Tue, 14 Mar 2023 21:20:27 +0000
Message-ID: <818ff5fc-08cd-4081-4bbe-d0a66ea7d477@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2657:EE_|IA1PR11MB7892:EE_
x-ms-office365-filtering-correlation-id: e70e70bb-c8e7-4772-c558-08db24d1eec4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6PLK8S7NoJzoIMt+2GZBVixv5ia/chtV+xZ5xJPmKOCZi8i7k3j1Z/bhKyuOab4uay/cfp02Me0juIbZmaWry7Rc1XpPeVUfR97/HF48fmBvs/ifDdKojfq8AUakq+KYKOpGoXeG/l3NdOpgr++EjuHAshaC7KrKhdHXKgeptG2HV6qC+mHgGzNrG3++gJOt1ftfmJC0+aYNdDDDI7/yhOTcOHvTVIeajC806SRYetjLhfFZze2fGsJxKqJPnJlgpvXE2xGMgpjaI3EGaOYoBjAuFzZlXpAl7dWAM/6ML3Du9aO3YVLMbUgbkiFtQzj+yPI5E8Zo0KwFoor8iizZmVm/HBAFET5PhGAssxhizxw/Vu++Jl4F8nLJO8qJkMavbQ+WCyxLgjdHMEwFkEm/i9DmaPozfoq0DPu9sVq00xAQtbHzJ04Ampehu+DAi/qePimf9SPC2e7B6izOTR3rz0N0+75+o/VKR+d2ewR8lFdJmWAwrI3Y7orLXni5S+ne5vk1NYUM1/iFVmzFxYr6DClwGA4vjhzudHvEPw4InL3u27k95cIqDLwYANov8b98vv+yl5MjHdpuUlHxCuwedPDc5uLaxaAt5BXlq7BfgvQ7c69+wDB6Uzd8g7xbtqJ4J0vDsW9GKGtWOAy6OYP/NfhRRJacWjSSqIOeYPuIxdzEcMqiSxRpkrP37E0lkTIsrZ89GLXDbh/uMXcFilAzXcjgmi3hwxnNN7BA3BErINI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199018)(26005)(38100700002)(2906002)(31686004)(6512007)(38070700005)(2616005)(6506007)(186003)(122000001)(8936002)(41300700001)(558084003)(316002)(76116006)(31696002)(107886003)(5660300002)(86362001)(6486002)(91956017)(6916009)(66476007)(66446008)(66946007)(64756008)(54906003)(478600001)(4326008)(66556008)(36756003)(8676002)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3hSZmlMOGdGYUxZWS8zZ3dPOEIvYUFHbDV1WHF5YU5iSzJYZTB0SVY1dE9m?=
 =?utf-8?B?bi9ENmVYQlc1a0ZOa3N0N1NVKy9YZW5vYU9MMTdGOCt0ZC9xRFEyMVFsK2Zi?=
 =?utf-8?B?R3VMUkxsVDdRSEhhcWhmci9LVXd5bm90S0hkODNwMVNCeml4RmNSSDVHQ2lQ?=
 =?utf-8?B?eWRGVTJJOHUvdnlNdzFtR1FGTkRZV000RFN4ZkVHK0krTUtsbk9zWVViYWNt?=
 =?utf-8?B?enFVaWw1MjRDci9JZ3lJVnExRFpzaXZ3eExMLzhkejVkYkQ2U0dURGpJSEhH?=
 =?utf-8?B?UUlyN1hZOFFpd1hsVGY3ODBES0dGV2FFdlNPRTBXb3FpWTVHNHM0ZTdyVTUr?=
 =?utf-8?B?TngxWGZpRDVsd1NEMGtNNFkrMVRyRCtZaXRlMmltUFByTHJHZ1RLVUhvdVA2?=
 =?utf-8?B?RkY4L0hSMnplSXZFMGhkaWFWSmJjTlp0R2I3R21uaU1kL1M1ZXJBT3oybm90?=
 =?utf-8?B?YzZyL2toeFBCTGMyQ3hWcGpjNUwxaXAwa0tMa3Z3UzFWTHRSU3VHQU5JZ1Jz?=
 =?utf-8?B?bFlTei83LzlSZnBQVWpmMDlCTjY5QUpLYy8remFwMWVsK1FjZUE0dXpJeVZL?=
 =?utf-8?B?L0xxT01mWDdhc29QSUgzNklRS1J4NVEwaFdkTXFaOXd0UlJWc0dsVW82QkRi?=
 =?utf-8?B?MHFRejRnOUZzNXppRGZtdkVXRjlDMnptRzNOeVdtRWROeXF3SFJScUxlZG5v?=
 =?utf-8?B?TEgyQ3YrUUlhWFM3U2lYMEtibVdzTWFlZUttWG95RVJBbEkxclBzNDAwSTQw?=
 =?utf-8?B?WHZ5UnFzZVJWOGdJNjBjMzZ4bmUvRmptK3d5cVA4NWVLM0I2ZjNSRDhJVmNW?=
 =?utf-8?B?dDBSRHgzK0Q4R3l0NUZmMzJNSnozclpMejJFZWs3SkxsckdPNzFvNWM3bEN4?=
 =?utf-8?B?aUl6aGdsRGRqVm9XSTRXOVhkRmRPUXlxUG84MDl5R0g5VEFKYnVEOVNoQjRn?=
 =?utf-8?B?ODAxQjQ4cmFGUEdWRGliVlhFN3FiUENJR28xK2JZNFFPSGdMdEk4Z2lobUlK?=
 =?utf-8?B?YVNJdFFkenVYSGRPTU9uaFhXZHc4dFdGaXJrNEF5a25uWmhxMzNNMkhmL3I4?=
 =?utf-8?B?ajVDMzRaN3U2L1g2SHpRdk5kRjV3K2lQbzk3cU9xa256bWNZRXpUc1dhdCt3?=
 =?utf-8?B?VTFwd2k0RDQ1d1krVzQ2cXpaVWRMKzRPR1lHOHI2QkNZQVBqRjVPOFc2T0wx?=
 =?utf-8?B?Vms2Y0E0Qjd0NWE4TnBlUlpZdmhCTGprZ3RlaXJJbzFmS2UyUENBeDY0ejJr?=
 =?utf-8?B?UzZCZXZpeCtzYVF4cStCSTJyMm9kcWFsMVQwL2FacEVUbFhhYzNTWFNzS0tq?=
 =?utf-8?B?d0JUVHhGYmlOc3RPQW5xVmp4TXZsR015UGxZMXU2Q2xOSVZVblBMUU9IQ3NK?=
 =?utf-8?B?dEJVOGNaZHpwSkdMeHFZZzRMdEk1NG9WT2dJaTZLNGc0bGZ6WXlOL1IrMkph?=
 =?utf-8?B?ZHA3aWFZR1VsNy94TG4xR1hFTWwxTVJLb3o4ZlU0Ri84Z2Q0UGpvYmIyNU9u?=
 =?utf-8?B?OGl2cWtzRWVqSHR6NjlnWjZBL2o5Y0lrUFI2clhLR0toTVR3VTVpTXZQYjFs?=
 =?utf-8?B?b0FzSGgvZ1VNWTZnVDFuaTI5VDJSK3hybzVBNUVzeENIU0J3RUkyeEgySVJQ?=
 =?utf-8?B?c1MrN0dCL1hpSk9ObFIybDBma0RPcUxEdkFLaWlXa1dqZEl2ZzBJeHAzdDdT?=
 =?utf-8?B?clF5SFZxazluQS93QlhuWXlUNHdhV0F3bit5dTVHVEhJR09zc0g3amovQlZO?=
 =?utf-8?B?ZFZ4eGFoeEM5MktMZ2o3MTVaamg1NjRMVDdsWERlMllTREoxbmFyd0RUTUZO?=
 =?utf-8?B?QUZTN0RSSWhveVJWdGFxSWhXakg4QUlKa3VCeHVuaW13cVJSZzhpYkF0b0p3?=
 =?utf-8?B?enhuc0szVVhzWkJxR292OTFDVUxtRjZITlloZERtc2JsYVFnZS9PK3dsQVNP?=
 =?utf-8?B?OGhXd0V0ZFNXM0RmcWV5dWZRbzN6bUR2VituTjhsYWV2ODAzOFpaMVhKMGx3?=
 =?utf-8?B?UTJiejFaOG4vdmtzb25JTG5FT3JMV1I3VWZ1ZFZub0taOXZxL0Rtc3Y5OVQ2?=
 =?utf-8?B?ZE81bDVXYSswYWVEV3ArVXhEc01FTmRLN1hCK2ZVWXpQb1d2Z2ZSYjRpWjhj?=
 =?utf-8?Q?YotuqHXIPImLvaKqDOjOkZ7PG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F7B87ED3ED5D24387207F19D0C1C6CA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e70e70bb-c8e7-4772-c558-08db24d1eec4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 21:20:27.5382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0w7sEsjyjr72vz2FvhZBEIp1OdIu20ics1xULmISTbANC8VBRhnkVDBzGszDXKr+J0pfoGxD9LXwMhfQNAXyOckce9GeRIS6w5jGC13QxA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7892
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGVsbG8NCg0KV2hhdCBpcyB0aGUgZ29hbCBvZiB0ZXN0IHZlY3RvciA0IG9uIGFsZzphZWFkIGF1
dGhlbmMtaG1hYy1zaGFYLWNiYy1hZXMNCnRlc3RzPyBJIGFtIHRyeWluZyB0byBkZWJ1ZyBzYW05
eDYwZWsgYm9hcmQgYW5kIG9ubHkgdGVzdCB2ZWN0b3IgNCBmb3INCmF1dGhlbmMgZmFpbHMuIEkg
YW0gY3VyaW91cyB3aGF0IHRoZSBnb2FsIG9mIHRlc3QgdmVjdG9yIDQgdGVzdCBpcyBhcw0KdGhp
cyBjb3VsZCBoZWxwIG1lIGluIG15IGRlYnVnZ2luZyBlZmZvcnRzLg0KDQpCUiwNClJ5YW4NCg==
