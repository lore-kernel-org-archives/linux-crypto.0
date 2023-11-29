Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csgroup.eu header.i=@csgroup.eu header.b="FhR6efRe"
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2043.outbound.protection.outlook.com [40.107.12.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9B2BE
	for <linux-crypto@vger.kernel.org>; Wed, 29 Nov 2023 07:00:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlchnMDm7nPnsa4NV/UeM2aLbKPeECR8Rb6igxGJV0IwLeeJ1hXZvgpBUnXVIXNAk28O0t/cBsb0l4smzM0FTnZmVKcZ7KQ6HBXEyjjkTa3G5BSt8Uyu530Mqcdd9YOOMVhI/Ni8WvinbWEVZC92VNyZNEiHK7lHOBQzp0v0CUXZ/fXi76fK/iS4U5ulByF1DR5Eilz9hBfK7T4w5AclEw41w5M4eXZ3Ih5Uj7BxVAU6dXM8ZVn53QZJ0sNBQaRRgZZl/Cx6B4wBzFV9iVA3CowobM0gER2/zbCPxon7UH9bemSvrMGK4z4Ek5aGMWsiaXMSbLBzX+n61RG7c5IY9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBxj1IMtSDv+/yGNVPIA48t93j4T/n31k/RhMXQwBYQ=;
 b=hgmHuT5Kdpyf6SmKvRmtjXuUU8VAKsFsKXx5ACOjKk/UYaZVTvDw1mF+fuB2oAWkSXJ67ZuCK69deHXS1HtfeK3LyHxaaZGclaCBPnQM98iq3aqXv+B6oAwdxxHmKi8APvnSkM+ruzg0UrrLjiVTTR5vUF0ob9sc4Ll6f8Han6kmd9LyupYnle8dazwf+wmnCG/nLh402CqUH/z6JwA4ijOnVu91lc7RkWeFioEwrRft6CKKweGLjQFdLny4pgvFD46j9rRCjGzkY/rFHAYJ+lmL/iFiNfi1DgvdeRRLnDDBgEMUPxJBm8CLUh1TH2hjS88YNCx4lGnMEiaTA0umLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBxj1IMtSDv+/yGNVPIA48t93j4T/n31k/RhMXQwBYQ=;
 b=FhR6efReFnF2kgZVBTWMtLBMUUgYdYNbXNyIzb8sk/3J0R3NxoixGBL/sty3aw8NWI9O3GsiDT5ZFPLlrC9kh7AyIlwswFWd3AJHp2Pae2RbjLdOBFCB4Y29jLqqb4oeac9BA3lMEOpHeZiixnd/ktePHX2JsEJ5QYwb4WgP1w0O7EeKh7ceWC9ps+0RS26sw6XJ8ZZWzcj6Y9KKwen05mEfAGeFaFe6oUxvHmW9IdTGCs8wv8He7iqcZZax/qduEUE1HZCdH4JnPrbagVDKITOrLCptAcXODWs4IMmidV0zoBqdJqbfPz23kJZQnHbB937jxVcIkTgwnq7N9N1ejQ==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PAZP264MB2462.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1f0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.22; Wed, 29 Nov
 2023 15:00:48 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::5bfe:e2f2:6d89:8d97]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::5bfe:e2f2:6d89:8d97%3]) with mapi id 15.20.7046.015; Wed, 29 Nov 2023
 15:00:48 +0000
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Eric Biggers <ebiggers@kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 09/30] crypto: talitos - remove unnecessary alignmask for
 ahashes
Thread-Topic: [PATCH 09/30] crypto: talitos - remove unnecessary alignmask for
 ahashes
Thread-Index: AQHaBMBoquTFXu7PhEyn2D9t1nul47CRoCsA
Date: Wed, 29 Nov 2023 15:00:48 +0000
Message-ID: <1a63d090-02b0-49b0-8c6e-50d71010b0a4@csgroup.eu>
References: <20231022081100.123613-1-ebiggers@kernel.org>
 <20231022081100.123613-10-ebiggers@kernel.org>
In-Reply-To: <20231022081100.123613-10-ebiggers@kernel.org>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PAZP264MB2462:EE_
x-ms-office365-filtering-correlation-id: a1779188-b60b-4161-bece-08dbf0ebf8c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 04diFXX5HMTwbhJFH9XTPzHvM/weLiFsqtwrhoR+SyirD/wuTwkSpMNzG0yhTj7H3DJKkKg7W2zZaXeOMVodsDEIyt8gdWO9cPbk2DwGMqnIU8sTmyADSV7iBLqpovMnj6xZdam0XC1zBqXJUb0+n7S9aZGESP8eC06QgNLHQ+d03q18bnQmmNjhFEORLE2X9yz4R7vSZcair314IMlePlFCWZTQU+LQHGz8H7bcAyUzO6SUJMIx4iPTqTOR9YVq3kyvjDn8Z83f9wOu4qRtvlbCZUJPRTHtqDUghR79AeynZQErkwW2PdoDt5lwzdYo2mTUUugaCXhsG8I9lI47Wh8/ci9YDASCvbQCkURnoeZMGBUWSqXXCTA/0jQq7LTnwQt0OYLx1dw23tMouaVklpE27vLltc1UFqTTlAivvCquLy9J8BByzySByNWHP7DONQr5EAcecBoUynus9rKVDbb6+G2xxUVm6jQ5vWrQZWAscqXRYXFB2oxftpNzYuZREDdqcPkHNwXmZddmnPS/b7XMq4A+1hiyr9/lAC6jbOHmc0PklgOz19zbr8A1RaZsDOxcq043SrLq1yIpwqp5WGYpWW8mS7pCTNHJNpXyfOtaRy3XAR+58BzUfWnRfy2DYA8EuwXRqOldBkxAXA1tssqsrWgZ3svMue3h/mqmb/3prb9yNxREkAlf8UWWM/QA
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(39860400002)(346002)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(36756003)(38070700009)(31686004)(44832011)(71200400001)(2616005)(6512007)(6506007)(478600001)(66446008)(64756008)(110136005)(66476007)(66556008)(316002)(8936002)(2906002)(66946007)(8676002)(91956017)(76116006)(5660300002)(26005)(6486002)(83380400001)(66574015)(41300700001)(31696002)(38100700002)(86362001)(122000001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cXM2RzQyS0Rna0NmR1liSjJIeWlJb3MvVGQyMnVtUy9vY2dubmFDanRYVlk0?=
 =?utf-8?B?M0NIZXFaVFUvRmJWeWs4eWpDRXhhOUtpS3RaUDhneFZUeFR3ell2ZW1QRjlk?=
 =?utf-8?B?SjFyNENySDZYV2kxb2p6Q1ZqbWJ5bnAyK1lHMXZIRGNBVnVxeVpGOHp5VzYw?=
 =?utf-8?B?SkJDRnRpN3hjc3BuVkxETngvY1N1bzYxZTJIRkUxVHVvRmlESWswbi9UK1di?=
 =?utf-8?B?bEU2TEpqVm5ZK2hkSm12RzJnMzVobHlObjlUUmNRdFdlODZTQ25GQ2Y0aFJS?=
 =?utf-8?B?WG5MQ2JkVDh3RXZvMEdoa3hTdWxtdWxZd2FWSURWSnl5Z2UxV1MzNWJQejdH?=
 =?utf-8?B?QUs3czEvRFp3QjFCYnZLMkM2WE9OK2lEdUFFWHBINDZldkdIVitjN2JaaE52?=
 =?utf-8?B?VW5EV3RqbWdKVzY1UHdYZXRLcDFwZ1ZSNTFIc0RqTjZhLy9RVWZCZFd2Wjdr?=
 =?utf-8?B?RncvZzdSalpMb0phUkZJOUtTVWdjNGVqWkFSNXJjTlJsODFSUlFwSkhzaHNU?=
 =?utf-8?B?ZnB6WFVXMmdMNXh0QVAyOW9uZWhiOFNaUTQwZjhhRkFUeGJtUWNyQkU5OEg0?=
 =?utf-8?B?VW03a3V5b3B6Y2pGZHFCVFZkdEhaVTd0MW5BeVRoM2RrM3lFeiszekRkZkc0?=
 =?utf-8?B?bmFhV21YaXhOVlFIaGxRQ3R3b0RHb3ZYeDJZRGRjZm1HdENhbU8vOWx0WVg3?=
 =?utf-8?B?WjRjK3lNTXBvVXNtQUpsOVhBUHpUcWtLbEx0c0ZCd0pKSkJJV0F5ZjNZdGxa?=
 =?utf-8?B?bWF4OTYwWUhBMVRQTXRoYlkvaWZPaUVYOUZ2WFl3WFRVeHpBU0IySElNUVhu?=
 =?utf-8?B?czd0a0tGWFBwR0FzcGdqZUNYWVhpQVJOSzNQeTROTE9rbHZFVU11R2QwemYy?=
 =?utf-8?B?bVY4VFdlZmlVU0JHVmVoTlBkc05rcjFpV3RUTEhnRDk5TWdmWXFpRVc4bWVh?=
 =?utf-8?B?K0dFRE1QK1VvcXFsWlBncFZ4NEx1V250TWZsL081ZkVDcjg4c042Yy80NDU0?=
 =?utf-8?B?RkUwZXlST0xtajJvTFFuNGpON1hmNzk1ejVCd2laQWdMcmd4UnBHOEhscXRL?=
 =?utf-8?B?OTIvTHp1RUpsb2dWQUZvMVNQbDNtN05iWlhlVXgzNmNHaHBRMEVyQjZZK2cx?=
 =?utf-8?B?MlJTTzVoeER2WEhtY0FGWVh3MHhCSVBmcVl5WUFXWmxvT2pwdlBLSS96eGFJ?=
 =?utf-8?B?M21PZnQvUEhqSDcvMjVTWjVPQTVLSzFlU0d5UUw4MXdMT2U3aS9WOC84UWNN?=
 =?utf-8?B?dDlDdHVXZGFEQWVoSW1pWGpMdlVPMndkazJPS3N6T2tMRDUwZ0RSWkFEY2lJ?=
 =?utf-8?B?Z1VlVEVsaHVuR1pnbjRKaHlrbkE1L2ozMnpNeVJOa3V4bGNIR29DNkFldEpa?=
 =?utf-8?B?SFhkdWI2QnlISE4wblVKY3hUQ3ZabmdZMFA1VnBPOFF4ejVLdW1hMnRVOEZs?=
 =?utf-8?B?cnhQWXo5Q096Vlh6bmMxLzhJTWkxZFQ0dUdOclpHN1UzYkdCVllNZDVxVjkv?=
 =?utf-8?B?UDFCVkR6MzF3NHdLL2pROHlieEUyWDlvUzVha0FlaThHNGRTUnNCU2dValVo?=
 =?utf-8?B?ZFdSV1ZSeFBlbjlpN1lTdUM3VmJ5TjNlSkU3Mi95MTIzZktDcFczU2JreVlK?=
 =?utf-8?B?QVgvdyt4d3dtSnFhbzZhbFo1RitpVkJnay9GMHFEMlRWZXp5YWF4WDBTRzNT?=
 =?utf-8?B?QnZSWUpEckJiRTVUcEtrbHVVOFIwYnZRSGxGalYwWTlUdTZJRU8rUi9tbmR5?=
 =?utf-8?B?cWRpVDArNVVmZ3pjY1JXRWpRbVZ3Q05zQm9RQlFHT0VZaUVZYU1IQWVHMGFa?=
 =?utf-8?B?VEtQTGQrZXJYMy8rM1JHRXNwSjJsemU0UW1FcmJuY1BQUE1PZ2tvMFBFU0Qw?=
 =?utf-8?B?cm4vWDJ2OVpXcHVCNmduT2cwTHhNSnZLL0kwVmc0WlljekRpRUU4bWY4Q25O?=
 =?utf-8?B?b05QOE1ZZW0yN241UnNQRzc3NHFoNTIxa0ZYdmcrZFRvMkdwK3hXVjJyTW5X?=
 =?utf-8?B?SjFGc3M4b0xlb1FLaGdMbTgxMjZNdkFIWFJDTDBxVGk4MTlGZCtmdU5UZFor?=
 =?utf-8?B?MlpWZEZNbUdsdmxlcWtqWFV0VE5saFYzMkpTQkJ1dlNZazR4Uk1lMXl2TGEr?=
 =?utf-8?Q?DfGeLwHThTdTMPikB7rsZuAP9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFC4C154E142CE43817B4D73B6E33C57@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a1779188-b60b-4161-bece-08dbf0ebf8c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2023 15:00:48.4707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LByPXjVXz3T+9QBsPfP9FjWm4fmSkUoTe8sV/Vd3zLSho6/6/TjSMTAVy6yEi1z3ovhrF9zDGrkiKcrGwiIscgus2WfC7M/MYDKtDjkk0iM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAZP264MB2462

DQoNCkxlIDIyLzEwLzIwMjMgw6AgMTA6MTAsIEVyaWMgQmlnZ2VycyBhIMOpY3JpdMKgOg0KPiBG
cm9tOiBFcmljIEJpZ2dlcnMgPGViaWdnZXJzQGdvb2dsZS5jb20+DQo+IA0KPiBUaGUgY3J5cHRv
IEFQSSdzIHN1cHBvcnQgZm9yIGFsaWdubWFza3MgZm9yIGFoYXNoIGFsZ29yaXRobXMgaXMgbmVh
cmx5DQo+IHVzZWxlc3MsIGFzIGl0cyBvbmx5IGVmZmVjdCBpcyB0byBjYXVzZSB0aGUgQVBJIHRv
IGFsaWduIHRoZSBrZXkgYW5kDQo+IHJlc3VsdCBidWZmZXJzLiAgVGhlIGRyaXZlcnMgdGhhdCBo
YXBwZW4gdG8gYmUgc3BlY2lmeWluZyBhbiBhbGlnbm1hc2sNCj4gZm9yIGFoYXNoIHJhcmVseSBh
Y3R1YWxseSBuZWVkIGl0LiAgV2hlbiB0aGV5IGRvLCBpdCdzIGVhc2lseSBmaXhhYmxlLA0KPiBl
c3BlY2lhbGx5IGNvbnNpZGVyaW5nIHRoYXQgdGhlc2UgYnVmZmVycyBjYW5ub3QgYmUgdXNlZCBm
b3IgRE1BLg0KPiANCj4gSW4gcHJlcGFyYXRpb24gZm9yIHJlbW92aW5nIGFsaWdubWFzayBzdXBw
b3J0IGZyb20gYWhhc2gsIHRoaXMgcGF0Y2gNCj4gbWFrZXMgdGhlIHRhbGl0b3MgZHJpdmVyIG5v
IGxvbmdlciB1c2UgaXQuICBUaGlzIGRyaXZlciBkaWRuJ3QgYWN0dWFsbHkNCj4gcmVseSBvbiBp
dDsgaXQgb25seSB3cml0ZXMgdG8gdGhlIHJlc3VsdCBidWZmZXIgaW4NCj4gY29tbW9uX25vbnNu
b29wX2hhc2hfdW5tYXAoKSwgc2ltcGx5IHVzaW5nIG1lbWNweSgpLiAgQW5kIHRoaXMgZHJpdmVy
J3MNCj4gImFoYXNoX3NldGtleSgpIiBmdW5jdGlvbiBkb2VzIG5vdCBhc3N1bWUgYW55IGFsaWdu
bWVudCBmb3IgdGhlIGtleQ0KPiBidWZmZXIuDQoNCkkgY2FuJ3QgcmVhbGx5IHNlZSB0aGUgbGlu
ayBiZXR3ZWVuIHlvdXIgZXhwbGFuYXRpb24gYW5kIGNvbW1pdCANCmM5Y2NhNzAzNGIzNCAoImNy
eXB0bzogdGFsaXRvcyAtIEFsaWduIFNFQzEgYWNjZXNzZXMgdG8gMzIgYml0cyANCmJvdW5kYXJp
ZXMuIikuDQoNCldhcyB0aGF0IGNvbW1pdCB3cm9uZyA/DQoNCkNocmlzdG9waGUNCg0KDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEJpZ2dlcnMgPGViaWdnZXJzQGdvb2dsZS5jb20+DQo+IC0t
LQ0KPiAgIGRyaXZlcnMvY3J5cHRvL3RhbGl0b3MuYyB8IDIgKy0NCj4gICAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL2NyeXB0by90YWxpdG9zLmMgYi9kcml2ZXJzL2NyeXB0by90YWxpdG9zLmMNCj4gaW5kZXgg
NGNhNGZiZDIyN2JjZS4uZThmNzEwZDg3MDA3YiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlw
dG8vdGFsaXRvcy5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL3RhbGl0b3MuYw0KPiBAQCAtMzI1
MiwyMSArMzI1MiwyMSBAQCBzdGF0aWMgc3RydWN0IHRhbGl0b3NfY3J5cHRvX2FsZyAqdGFsaXRv
c19hbGdfYWxsb2Moc3RydWN0IGRldmljZSAqZGV2LA0KPiAgIAkJZGV2X2VycihkZXYsICJ1bmtu
b3duIGFsZ29yaXRobSB0eXBlICVkXG4iLCB0X2FsZy0+YWxndC50eXBlKTsNCj4gICAJCWRldm1f
a2ZyZWUoZGV2LCB0X2FsZyk7DQo+ICAgCQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCj4gICAJ
fQ0KPiAgIA0KPiAgIAlhbGctPmNyYV9tb2R1bGUgPSBUSElTX01PRFVMRTsNCj4gICAJaWYgKHRf
YWxnLT5hbGd0LnByaW9yaXR5KQ0KPiAgIAkJYWxnLT5jcmFfcHJpb3JpdHkgPSB0X2FsZy0+YWxn
dC5wcmlvcml0eTsNCj4gICAJZWxzZQ0KPiAgIAkJYWxnLT5jcmFfcHJpb3JpdHkgPSBUQUxJVE9T
X0NSQV9QUklPUklUWTsNCj4gLQlpZiAoaGFzX2Z0cl9zZWMxKHByaXYpKQ0KPiArCWlmIChoYXNf
ZnRyX3NlYzEocHJpdikgJiYgdF9hbGctPmFsZ3QudHlwZSAhPSBDUllQVE9fQUxHX1RZUEVfQUhB
U0gpDQo+ICAgCQlhbGctPmNyYV9hbGlnbm1hc2sgPSAzOw0KPiAgIAllbHNlDQo+ICAgCQlhbGct
PmNyYV9hbGlnbm1hc2sgPSAwOw0KPiAgIAlhbGctPmNyYV9jdHhzaXplID0gc2l6ZW9mKHN0cnVj
dCB0YWxpdG9zX2N0eCk7DQo+ICAgCWFsZy0+Y3JhX2ZsYWdzIHw9IENSWVBUT19BTEdfS0VSTl9E
UklWRVJfT05MWTsNCj4gICANCj4gICAJdF9hbGctPmRldiA9IGRldjsNCj4gICANCj4gICAJcmV0
dXJuIHRfYWxnOw0KPiAgIH0NCg==
