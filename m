Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326CBC1975A
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 03:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF0620724
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 03:20:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kw5ce2rF";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="XUxDXv+s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgCWDU7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Mar 2020 23:20:59 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41096 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726979AbgCWDU7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Mar 2020 23:20:59 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02N3Fd0q020314;
        Sun, 22 Mar 2020 20:20:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=0DqpOqSJVg/wDchK7J3ORdiyBQc0vKnS+itOJ5AhdP4=;
 b=kw5ce2rFYzPqXr3/1i5yeqgsNBT7EAe/1fnvSdTr9hsQpXe6vVEgB187Jh7H/IaJ9CHg
 SvVDj3SpaLOtIA+bErF+0LIH59v+flA+ExV36uWgaLKfqmOCkQLQOCIEn4pzO5BRjG8C
 Me91o3EQ1VqmuALIMXidpChB5nuh5SXybWMwioI5aj6ZRUfDgRUrVMrYYhc2zM97rraE
 /3iraxGBxhmqa7q+uquKAy82W13QG2ypNEBl6XxhY9vIpMUmigEufEmT9nGRPQ4tBoqS
 kE3bc5JfGQOwC4x/mFwUHlp4hvnGTqn38AsmRczsD3kUyEm8ukQuxOp1i6Uz4550JVf8 fA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9ncyxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Mar 2020 20:20:49 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Mar
 2020 20:20:47 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.57) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 22 Mar 2020 20:20:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKY7RqF2SXjIkWT7vZI9cx9s5WuF3P26QhCe7Wx1oPCjq55HWbFJgeTr3q0fo24iiuKBvCygnbR/St0mT/x4o+bikXqqnI3Ey9Ue7+bJsh4SHX/8tOvxEy3JUr+hZnKMc1/dcNuioLaBufsj0BqNLj0aUpyzGFAc5W5C3mpHIvk2y6sVzTZvpaffa/wd0puAMn0JiixH0pmVL3rTH6rZL+9R2rhIZBQRYD8zuEXRZvYDFzBaAiE4MDmV2JfNUqFoTSTPUNzIDUuWuXyAoC/RYgbVXeEtNnfRi5uLlh+P2s3tGlLBggklFErIv0MQoHOpL2GaPKPU+Or+5gcxM456gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0DqpOqSJVg/wDchK7J3ORdiyBQc0vKnS+itOJ5AhdP4=;
 b=S4HIrgsXtFFTxrjZCQFaaTJnKE5EUx41btG5tfb9i1VlDFWE03LB69NStIPyXXZ//nZxnIZGD32Zu7M61pAzA/8dv3hDnmQrzuFTGIVpZ/vV4ajyqaOrSZ8SRb4Yss5TCzqS4QKn/PmXIWBy2L0U6NHgeJOGTGBNNC8PLsu4xly7O9UGc2u4P+93vpHR2YIR/n2es5VkdkGXgEScTe3qg4TT9Cqbdrrjgyf2klU22hs51NYSIdLYmKrpiSHVvM0AlTKMc2uDLfAHgazoSCWigSccaXnfoD4dIorMPe3f+zew4v73saFmZu4NXpmZYnYpMLA14h2pcIL83qHc0j5wTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0DqpOqSJVg/wDchK7J3ORdiyBQc0vKnS+itOJ5AhdP4=;
 b=XUxDXv+sEuE2AHFgkWTpqWUMtgs24GZjVvCF1J7+Y33n85b6zhHpDd8NleVZM4MKJckuSyIE0Uf1FI6mIwdZzQ0+YMXr5SL4kBQ55R2BQF08Pwd2IHZoTz6NBb9RPxc7/T+LI2Id4zeqkO59M4FFdKiLD1fCLFHD8IsUtguApfg=
Received: from DM5PR18MB2311.namprd18.prod.outlook.com (2603:10b6:4:b8::27) by
 DM5PR18MB1355.namprd18.prod.outlook.com (2603:10b6:3:14a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Mon, 23 Mar 2020 03:20:46 +0000
Received: from DM5PR18MB2311.namprd18.prod.outlook.com
 ([fe80::e53e:45ba:197b:84cd]) by DM5PR18MB2311.namprd18.prod.outlook.com
 ([fe80::e53e:45ba:197b:84cd%4]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 03:20:46 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "bbrezillon@kernel.org" <bbrezillon@kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 0/4] Add Support for Marvell OcteonTX
 Cryptographic
Thread-Topic: [EXT] Re: [PATCH v2 0/4] Add Support for Marvell OcteonTX
 Cryptographic
Thread-Index: AQHV+S05rH1l6PXlHEqfmA0xItJTK6hQ/1qAgABWxrCAAbCvAIACg6OA
Date:   Mon, 23 Mar 2020 03:20:46 +0000
Message-ID: <DM5PR18MB23111DB74B74BED1E08E0DD3A0F00@DM5PR18MB2311.namprd18.prod.outlook.com>
References: <1584100028-21279-1-git-send-email-schalla@marvell.com>
 <20200320053149.GC1315@sol.localdomain>
 <DM5PR18MB231111CEBDCDF734FA8C670BA0F50@DM5PR18MB2311.namprd18.prod.outlook.com>
 <CAKv+Gu_G4=Dn+6chjk1dQFMXm1aGU8QQZMmy94L5LicmR3itKQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu_G4=Dn+6chjk1dQFMXm1aGU8QQZMmy94L5LicmR3itKQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [115.113.156.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98e87688-3a1a-4c08-9980-08d7ced92da5
x-ms-traffictypediagnostic: DM5PR18MB1355:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB135595D07694CAE74EF74AD1A0F00@DM5PR18MB1355.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(396003)(136003)(39850400004)(199004)(52536014)(6916009)(81166006)(316002)(55236004)(54906003)(55016002)(9686003)(64756008)(66446008)(33656002)(66946007)(66476007)(76116006)(66556008)(7696005)(478600001)(8936002)(81156014)(8676002)(186003)(5660300002)(4326008)(86362001)(26005)(2906002)(71200400001)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB1355;H:DM5PR18MB2311.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hBmz9Sxg/JiBZds0clcTZH9KEbw90ZK0+XWRu1x4aXoXZNiFins8ysfwKb/U57o17IhRTFuA/Al2c0+2jSp5smBLQkyzjoAmolxKqy1adCOEWxgxjtrGmDOv6xOdMn+zfNoBh6FN/c8UvHlRS427MfrXwu/7eyr5gk4VO0cglGxRIjgeu1ek1UwhP/s5o0CJXojeutaFqaQTrehqPg8jrVrJ8zPuKDBjVHPBovy4YeCINJC7IVAVxZ/qjfz+ZRc26l6JpZa4vgixMD+L+n/SXoSFHka0er5ohA/eyRi4V+Ps4nWIjZU4VxYqEZbSt2TDLwYauIU5tgv/9loMK5GbgAmDFL3LR/o1btzvFILk4Cf2K48JA62VqybwBWCfHYa8zb56vow7eduyFLf9V8tXfPAvITMC/6jW5/O8Xo4stJgR5Zuu24P1sF6HNEy02myK
x-ms-exchange-antispam-messagedata: 2iTvC6sYcwHySKjwzpx5mgc9ugIxh0NHXzvvQHLAvTSvtB4hnxTPR9noB4cYSES38vePg1a9/bMtcFms8/VhnP7SW/MLXy+UIsTxrHSu/WkDn6Nq8iH16BUdou9E28u7wO2dTYdyqi5FkdFRffDXiA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e87688-3a1a-4c08-9980-08d7ced92da5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2020 03:20:46.3588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RrCTm3mcGH6y813o4TxbnaKnECTsoZ//OrD4RlFuNtTspTg6y9AomUMIR6NzvI5/TIGdZXoMlLSVHF0KnSvqsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1355
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-22_08:2020-03-21,2020-03-22 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBPbiBGcmksIDIwIE1hciAyMDIwIGF0IDA2OjQ3LCBTcnVqYW5hIENoYWxsYSA8c2NoYWxsYUBt
YXJ2ZWxsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiA+IE9uIEZyaSwgTWFyIDEzLCAyMDIwIGF0IDA1
OjE3OjA0UE0gKzA1MzAsIFNydWphbmEgQ2hhbGxhIHdyb3RlOg0KPiA+ID4gPiBUaGUgZm9sbG93
aW5nIHNlcmllcyBhZGRzIHN1cHBvcnQgZm9yIE1hcnZlbGwgQ3J5cHRvZ3JhcGhpYyBBY2NlbGVy
YXJpb24NCj4gPiA+ID4gVW5pdCAoQ1BUKSBvbiBPY3Rlb25UWCBDTjgzWFggU29DLg0KPiA+ID4g
Pg0KPiA+ID4gPiBDaGFuZ2VzIHNpbmNlIHYxOg0KPiA+ID4gPiAqIFJlcGxhY2VkIENSWVBUT19C
TEtDSVBIRVIgd2l0aCBDUllQVE9fU0tDSVBIRVIgaW4gS2NvbmZpZy4NCj4gPiA+ID4NCj4gPiA+
ID4gU3J1amFuYSBDaGFsbGEgKDQpOg0KPiA+ID4gPiAgIGRyaXZlcnM6IGNyeXB0bzogY3JlYXRl
IGNvbW1vbiBLY29uZmlnIGFuZCBNYWtlZmlsZSBmb3IgTWFydmVsbA0KPiA+ID4gPiAgIGRyaXZl
cnM6IGNyeXB0bzogYWRkIHN1cHBvcnQgZm9yIE9DVEVPTiBUWCBDUFQgZW5naW5lDQo+ID4gPiA+
ICAgZHJpdmVyczogY3J5cHRvOiBhZGQgdGhlIFZpcnR1YWwgRnVuY3Rpb24gZHJpdmVyIGZvciBD
UFQNCj4gPiA+ID4gICBjcnlwdG86IG1hcnZlbGw6IGVuYWJsZSBPY3Rlb25UWCBjcHQgb3B0aW9u
cyBmb3IgYnVpbGQNCj4gPiA+DQo+ID4gPiBUaGVyZSdzIG5vIG1lbnRpb24gb2YgdGVzdGluZy4g
IERpZCB5b3UgdHJ5DQo+ID4gPiBDT05GSUdfQ1JZUFRPX01BTkFHRVJfRVhUUkFfVEVTVFM9eT8N
Cj4gPiA+DQo+ID4gWWVzLCB0aGUgY3J5cHRvIHNlbGYtdGVzdHMgYXJlIHBhc3NlZC4NCj4gDQo+
ICp3aGljaCogc2VsZnRlc3RzIGFyZSBwYXNzZWQ/IFBsZWFzZSBjb25maXJtIHRoYXQgdGhleSBh
bGwgcGFzc2VkIHdpdGgNCj4gdGhhdCBrY29uZmlnIG9wdGlvbiBzZXQNCkFwb2xvZ2llcy4gSSBo
YXZlIG92ZXJsb29rZWQgdGhlIGNvbmZpZyBvcHRpb24sIEkgdGhvdWdodCBpdCB3YXMgQ09ORklH
X0NSWVBUT19NQU5BR0VSX0RJU0FCTEVfVEVTVFMsIGFsbCBjcnlwdG8gc2VsZi10ZXN0cyBhcmUg
cGFzc2VkIHdpdGggdGhpcyBvcHRpb24gZGlzYWJsZWQuIEkgaGF2ZSBzdGFydGVkIHZlcmlmeWlu
ZyB3aXRoIENPTkZJR19DUllQVE9fTUFOQUdFUl9FWFRSQV9URVNUUz15LCBJIGFtIGdldHRpbmcg
ZmV3IGVycm9ycyBmb3IgdW5zdXBwb3J0ZWQgaW5wdXQgbGVuZ3Rocywgd2lsbCBzdWJtaXQgdGhl
IHBhdGNoIHdpdGggZml4ZXMuDQo=
