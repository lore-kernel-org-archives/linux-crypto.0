Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3446C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Nov 2021 08:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbhKWIpA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Nov 2021 03:45:00 -0500
Received: from mail-dm3nam07on2083.outbound.protection.outlook.com ([40.107.95.83]:39361
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234467AbhKWIo4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Nov 2021 03:44:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXPMslOPtzNQ1X8GHKuemMA3mW/Kedxh1+fLrOMlBIeOB01MwZZFUtEnYL3Y7m1kh2KEWl5Bx6m8SlGhtJWHB4kmIOp2C0eXsD1FVS3xEhN2j7JZ7JqnG5x5tQ13lXJkV1Yb8D7BDys6rLMW7nF8cBeXt8ZY4w6gsbozb2EMEysuhF5PZni5LN+vVS3lDlcWmPFf+cYn+AYOSGs5sAbnY4+uHv7NRInf4xY/0szVVrPvk0GadeRJ0voRVBbOBxijctNjk6oyjE2cfrIZx461y+ELnVpywgw3ng3bGAfmribByMGq5XBLYhTkOCusvX6u/kDIh4rAc7YYqkN5ftmGLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7ACXWCYBeXhxQHHudDJ6tJ1OwwT0VyYZ8RHVayWLgI=;
 b=gzpr9u3nxnXRUBfhi5JKsryUVnexrfBu4rBv0rFSQItBaiqyoejLyW0GmwQRhrV5vamL6nwuAtMFXaf/Zd5DWhFU+We2ZNDHz4d9Vgwio7fW3Vk0cOHOFXj8q3SpDXHIKdbDqI6Ar63gxcH7OLLH8+klDKzqueDbwMTPsiRduMccJjcyt9Agz2lPUK+b3mF5DXBEoz3ApfkvwZ+tsv4iukgPtk8svrtV3JUlK6M1MTc08XftNLqZ9HjN7IfqHAQAHiCxTIkdFow7GlN2j7ieh4oBwAfI8SnQKbpJ+Ng2cGtlnFi2KqR1uMdzD2+eWCjgeXxMkmLZX0OfZb14EItPDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7ACXWCYBeXhxQHHudDJ6tJ1OwwT0VyYZ8RHVayWLgI=;
 b=G5jITxEQV4pXXNu96d7NpAdOGHwZk4eu78Okg3FuLamZV43egT3i0sbovcQgGTc9JmroQqwCjHJIdqrPq6SRWq0eRnlY3Su2xB5oqDU/EWkcFx3KfvS9BgJopYrsJlfyQ0CMA5Dsp5moKliyPtgWYpfpeOF2oaGSY/hg//nFzfZgD0ta410Xz1zmjqWQiKGgDeT3J4mLW4IJmSQxo6JGp0oGZ9bnK2D9vFy/dL+MWESI3MP3b3I/IfXX5W3NfqtFzKT8nnk8lOnwmMmuTa1B2nYoyEn2U5ULfwnkl2arbUCR0hcuMXn2NkHXc/YbvcMdgjUcPzXFWA/IPH0iJcVydg==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by MN2PR12MB4253.namprd12.prod.outlook.com (2603:10b6:208:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 08:41:46 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::6dd2:d494:d47f:5221]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::6dd2:d494:d47f:5221%7]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 08:41:46 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
CC:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 03/12] crypto/ffdhe: Finite Field DH Ephemeral Parameters
Thread-Topic: [PATCH 03/12] crypto/ffdhe: Finite Field DH Ephemeral Parameters
Thread-Index: AQHX33a4M2DqJJyNQUuRIf+sZi+2l6wQzPaA
Date:   Tue, 23 Nov 2021 08:41:46 +0000
Message-ID: <5cc1600c-690d-1f4f-04b5-180e2ac81cbf@nvidia.com>
References: <20211122074727.25988-1-hare@suse.de>
 <20211122074727.25988-4-hare@suse.de>
In-Reply-To: <20211122074727.25988-4-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 331ea394-055b-4fbe-3687-08d9ae5d15b4
x-ms-traffictypediagnostic: MN2PR12MB4253:
x-microsoft-antispam-prvs: <MN2PR12MB425301D1CB63C12E6823E917A3609@MN2PR12MB4253.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hbRDMCn6ynZVViA9uc5nyBfwUQiGl6kcQqfQFgv1h6ApSFPxtauy9ifD597EwDQcMvsmxZmz3Hf23TqyLn+RKTApiAwO1AVLbF5lw6bh1XTAlStA5HWB/QjvPPHXKjlwXvlJD4jXivvFVh3Sq2vOSMUUT5emwlBCoL4ict2pWf00jRnEqTp/NiGQgBsQxg7aDLKYAnteLc/89n0nJM/39GMsEYDmahVPIWPVcwLX76DeEgAx5mfes1zMtAg7ceIybAvui9TVEBhxn0wNegO9Nsqnej5w3OYrMirsC+J4YgAAARqxsIkyI1uhlDBIC5jsRYn6mdVKaH+A2MLAqsBYtYmEqNYwpHPzxi7DR/X4w0KlCOP89jkHeXSa3UV4gZ9c0JCSInsAY1aD/DKDmu4nudEp49iuJVBLOHMDYP+6wBJkb4H2SbmI7jftOqu1nsozBvg4xaNjWoEv4Mb9HC6XFXt9GmmgqP9rnkKgsh4VRtPkmTM1upHNcHcnoEmfJl6dEiq+4ac8kI+/wSpHtZzzhCNS6lQG29GlTj5NchCMbhAx+z1zr3kRffgJWb9Xuo4rUJzh1sS1U94ezoEfMcBREEUn11cft//bVhLCaFh9Z7HECsAMsuIkdAy6xuD1CwLjTA0IRfRKxReddiW6fqi0ntImmb9FBBd3bWMZLgWzuKYdnYVbD8CL005N6yWxGYJM5pCCJHIuyRoGLIONwjywmgPT3MPM3szfqOjRduu+4rPgvZMCoKDz7T7884wSf3UZB5XwCWTBAGusbsOayLvLiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(2616005)(508600001)(66476007)(71200400001)(86362001)(91956017)(6486002)(31696002)(66946007)(64756008)(53546011)(186003)(5660300002)(4326008)(316002)(76116006)(558084003)(122000001)(2906002)(6512007)(8936002)(110136005)(54906003)(66556008)(8676002)(38100700002)(36756003)(66446008)(31686004)(38070700005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UE1Na242TVpEL0hNZWYyTFhQS0NkWVhyOGY0OFd5MkVRalBRZ01wS2lOa3hp?=
 =?utf-8?B?NW5xdVhJRW5IWE9ob3IxaERiMStwaXc2NUp1VlMxZFExdnd5SEttS0h4QWtX?=
 =?utf-8?B?SnEza1NwaXU2QW9EdStLTVJnNGpJRFZvTVhwTWpURTZSczJLcUJFOENrNHpz?=
 =?utf-8?B?SDVad0hUL2FGc20yYUFXK2RDUG12c1UvdDVubnVmSS9tMWdzT1dEN3pRWkZK?=
 =?utf-8?B?L25xdUc3b050RGQwSDN6bE1yTUtwOHJXNDczU2hTVlErWmttL1pXRjdXM2dU?=
 =?utf-8?B?aVFLLy9PYmpvQVBYSit3M2xKRktxZWpOeGU1RDdsL0NhcG01WW80RVBmUkFT?=
 =?utf-8?B?VGdld3RqTzdXYXlqUWtNUCtaKzBBRE5LU015MEsxcmpPSmxvWDZRWUFGdzVy?=
 =?utf-8?B?QURTVmJGTmI2NzAvNHlVTDJoYnlqOWE0bkxNSWFaa0I0SEdVbllReDR0TVdK?=
 =?utf-8?B?TVVXek8vUGlaU003bUhYbEtqWGFRdlNjVUhickFkeXpKRW90eU0zRlZSS0pB?=
 =?utf-8?B?c0h1NTU0bldjNVVTRDdxK3pSU3BtcXJUVG1XNWdSV1dxeDhIbDdqYXRwT2hz?=
 =?utf-8?B?T296eCtDTndFK1FaWjNhaG5QT2dYZzBFZklRN1dpV05aUGN0R1RYdlF4NnFP?=
 =?utf-8?B?OUY0WGJ4a25rbm0wdXBvclZzNjdqd21qbVp6ZkE2aytRTk10ZjNQdnlpQllX?=
 =?utf-8?B?a1BuckhsbVJ3R29aYytnbW1CTHk1RHFXVWJoMkFzU1d6V2dLSFkxallIL0pC?=
 =?utf-8?B?YTJNeDNUNkkwd0JHKzdhRytCL0RRLzVSSXR0SEd0TXpzTzhhOFIxdk5qKzBS?=
 =?utf-8?B?czRuUEZKQWlVZU8rVXlwS2VnOE5OTXovSmZCTDIrSFl1WXFkRXVsSGN4a3Jh?=
 =?utf-8?B?b2tFemVoUWpDRWN0MWNUM1RBZWt4RE9GaVliRWdCQUdQNTcrUk1iSkZ6ci9M?=
 =?utf-8?B?ZmQ3cCs2YkROTDJEeGZ1NEgzWWNXRGw1dG1Jb2hWcXQ3ZTd5T1RqQ0t4NzAy?=
 =?utf-8?B?UUVIU3RZU3JUVGdCcWptd2E0VG1RZElmNFZEeGVmT3JnaWpOeTIyLythVU11?=
 =?utf-8?B?VHJ4dDNkL1FSWXhFZU5YbWVrUnd5alh5WWxhb0tjTmVCdm4wR3dRWTdWOVBC?=
 =?utf-8?B?REsrczhxWnVaeTlPL3JoT3REYzdTemxLdnRmejkxOGEwd3NYUmlveU9Wc0NZ?=
 =?utf-8?B?UUFMb0FES3A2WmN2djh6WVE4Um9oY2pBRmo5dXJoUGJRMlpyZmoySUxRWXcv?=
 =?utf-8?B?MWlFMmgzNGY3R3BMbzhZZmlVRGFadHAyM3ExaElnZHEzQVkyaDRzSkhFeFFT?=
 =?utf-8?B?b2NDOFpWN1ErR1NGeFVaOEIwS3Z2aWQ4bXhGRlZxR2tENmRTK2Y3c0VoSnlr?=
 =?utf-8?B?cFdxUXdseTNUOEhXeTJmWWZLZ1h2blk5MTEzblhiQ0F4ajZMcjRMcVIwT3pr?=
 =?utf-8?B?cDdWNGlVWmJhTytMNnVZcjdJUG13ci9Ea0x2alUrMURITytuWFZNQkV3VXdH?=
 =?utf-8?B?L09LUEpZNUZMakVxR2g2b0hOSlc5cklCTDduL2pQamhrRHdlL3ErQVRTdWdz?=
 =?utf-8?B?UEpxSFdmVDZwTGNvLzBiYkNzV1p3NjhjQjhqa0lEa3lMQ2VFTlNyb0FBRHJo?=
 =?utf-8?B?dGRvWjduekZ3Q05ZaFhOZ1BnSUJCZmd1RWJVK25RaE1yWE5BV3NBblJJdEJJ?=
 =?utf-8?B?SVJ1WmtSN05LTklmV1NUYlhjMDM4V1FDakdSYTN5SkNkeHdQWGFhN2R5S0NY?=
 =?utf-8?B?VGQ0bkgyaElxM2hBTHZUQjdhOVdYMS9jMUl4TmlnQUJNT3BQRnJBNk1JQlMx?=
 =?utf-8?B?dFZNM0N0a3hTNUQ0YjN4bnF3eGY0ZHVxYTI4eTBJOWw1YUwxQzVPN2tOdlBn?=
 =?utf-8?B?bUVMaFFxZ2FWUGtzUU5WMlBOWldIY3NYd3I4aStma0NWeGQxcjZjK1VDUVlL?=
 =?utf-8?B?bUpZWW9wclRzRGFMZlV3MmhHdUs0R3lhcUxCYkxTVW9VTFR5eDdzYVFubUpE?=
 =?utf-8?B?V1NaZCtsK3RiWE1CQXpXZXdxdFdFRUI1bHU4YU1rSVA3UUVmUW5UbXJ1bGhI?=
 =?utf-8?B?RXNWeFhTcENUd3NXTDdYSGczdjlGMSt6K0k0TUJaNVpaVjhwVzZET2ovYUdv?=
 =?utf-8?B?N1ZocGhrSTZ0TGhxNTdxMndDNmtoaDZ6UkFOWW43VUxDcHpybXdkbGR6VkFs?=
 =?utf-8?Q?iMtSdBhXwZGZHjFVznGzAUHB+EqkRQ6cJ6mh2wEYuIe4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <42E697CBC4A5574FBA0A2073840AAE17@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 331ea394-055b-4fbe-3687-08d9ae5d15b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 08:41:46.8639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dHnENeexzuDb4L5c771T+MiU05jpZw4oe9EjJX1WItXMjyrCgPoa8kB+WTamdZdHnxGzvRC9vTSqLCRSm2IPwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4253
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMTEvMjEvMjEgMjM6NDcsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToNCj4gQWRkIGhlbHBlciBm
dW5jdGlvbnMgdG8gZ2VuZXJhdGVuIEZpbml0ZSBGaWVsZCBESCBFcGhlbWVyYWwgUGFyYW1ldGVy
cyBhcw0KPiBzcGVjaWZpZWQgaW4gUkZDIDc5MTkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIYW5u
ZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4NCj4gUmV2aWV3ZWQtYnk6IFNhZ2kgR3JpbWJlcmcg
PHNhZ2lAZ3JpbWJlcmcubWU+DQo+IFJldmlld2VkLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxoaW1h
bnNodS5tYWRoYW5pQG9yYWNsZS5jb20+DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBD
aGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQoNCg==
