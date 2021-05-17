Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0C1C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 18:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AE8A61166
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 18:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhEQSXO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 14:23:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:18094 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229734AbhEQSXO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 14:23:14 -0400
IronPort-SDR: 3KAM23y2WBl7EfENS351fjV7quyJlzC151Qu2zIYe2RdLLNkyeFQBuZKrh6kbCVbpIZvWKb4wz
 sMV25BGimW0A==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="197445864"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="197445864"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 11:21:57 -0700
IronPort-SDR: wrYbsUt4YEANVuu96b/tZK4KmW99S8ZgQoWH3S9vEJCKz8iDkqnolTcKY+9Ols4chAeQ+pc59o
 QY/CL72PkDCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="541408428"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga001.fm.intel.com with ESMTP; 17 May 2021 11:21:57 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 17 May 2021 11:21:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 17 May 2021 11:21:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 17 May 2021 11:21:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsVFXJ+HzqicPj5vvrUf+nT7tBRtN2xOr0d6wIPO4uiWhvPBpXPT5YoAOWYihr5yY3Y67CwadylkHs5FVIRwfwnQ+zDIm1I5tHL1QDC9GD9q3Xp7AQ132PHbYVTlBDxFMLbGWo/ymTZODhWoU1DZbpa9u+Jb9P4cdb/ukZlsvx+Im2pA+R7tlSoRlYiANUsnxFhqg2Gxit1CJYbtgeWRth6HwCU+S2cc86isUVM/XiKJdfeS4JqElHp11WuXwFN2ji4YP1SD4r+ltWeFg9/fU0/Z0n+d7MmefRxIOokQKe6Ws8gDR8cZFv4uM0osYYOtb2VZE8eQ0PKSJ0SqBubO2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFuLyFt6nvup8jA+gW3wRJog9fEkKavL/El607K3UaE=;
 b=XnNuKLJBYnncwklYJf+h6oHSLdKBQU7OWJG5FHP4HcxnCb4JYhP4miZ28XHw/MreIFxqf8vAAtxUpMaqsF1pwOetRdqGxpak5wuSxD7Td+l1lqIhTMKfe9yOteyVMKC0WVpTv3RiWWq+Hl7zP4YAwaM0fCb8GOFF1X4PSwGN7jADrLAM49TnY5rBQSC0rNDRVOW79eiXto9r2V1IObb0TTgJ4vSPmahzvreEkzVqhcVH3Y59vG5rMGJhNOmDxVeILBa3Dhvnn1Vk1CBNvAFDhqpsOthdlcXLxVyFweH3e0WuYyQJorJIzcVdmnh7xhpSLelBBJiD9oSrWbUx+RBInA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFuLyFt6nvup8jA+gW3wRJog9fEkKavL/El607K3UaE=;
 b=eCcunUxsnTtDveJBNVdYgCbvZ/tja3Z5bTeJlpiyAFYO9jGCDqOdoLq+cpin9YZ3XYtg6I1GZqmeYjNsQhXbjQM6OIQoppiZGfK4mwrnfgv+mokijlvg7IjlVtjWJE6EVKpKdFypSxgHdXMvHxEY1g6XH5mcksNcbGHu/G8xKgs=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB4823.namprd11.prod.outlook.com (2603:10b6:510:43::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Mon, 17 May
 2021 18:21:55 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::8878:2a72:7987:673]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::8878:2a72:7987:673%5]) with mapi id 15.20.4129.031; Mon, 17 May 2021
 18:21:55 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 00/11] x86: Support Intel Key Locker
Thread-Topic: [RFC PATCH v2 00/11] x86: Support Intel Key Locker
Thread-Index: AQHXSP6hgf4aXmFhiUuqBU4d/omVPark1qMAgAMqZgA=
Date:   Mon, 17 May 2021 18:21:55 +0000
Message-ID: <C08CCADB-864B-48E0-89E0-4BF6841771E8@intel.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
 <9f556d3b-49d3-5b0b-0d92-126294ea082d@kernel.org>
In-Reply-To: <9f556d3b-49d3-5b0b-0d92-126294ea082d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.189.248.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d31c9aad-d835-49bf-d38a-08d91960a696
x-ms-traffictypediagnostic: PH0PR11MB4823:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB48237876AE5DCB7B26D3E341D82D9@PH0PR11MB4823.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bBp/ewH7uKn7g2mPyYo8Dm6NG+vPKQnV75fLnYe8E0VDS7apGEiOjMPD3yTTqXdfHaY0nCc+INS5L8S5FkQqFe2mEYrOlrlODcT7Vv1PEYNpEBT0I6reR1/FPDtEZYEsArpJtkz6dETOJjLFMRWe5/p1ZSizQbcQ/f6HoT/VvP2mi2xNzh8JrVGM5rMdb9HWAX7zMtg7QqeOciXZI+ZcVdbpwXo7xJxwiqMBeeMQJHnAFcjakqRntYHErTAgAGwqz9tpqCJBemiGhOvai8akUok75nc4N0JC9T5Kw1SFHDePC82AYfB0ybsWuHVVqsrBzp6OCeCrpQ1z8ZJCiEwmnbZMzoCautE+2PwI49JTHNpf+OMAJUhRiQh7FCAUf4EFvV3bZ/zA7iOY+auDgMRQ+7l44a3s9YJTm1ei0+k0BDUNC9Nh63gq/NMgQU4XXIDce2Dhnrwwo2QtuecM1cziTney04ycxVA8muZXmTHJxQglMCJY+7fWgHRVlIbZ7oRdIiHBKDM7iuCYxPMQG3WpkKOBVeEX76ZpPyNIYPfdnIuECvZdfixYjPn6rTrxUpoFG4a8CivaExb1Ly7jReZ/XWW8KUIqZ+mOhRkFjNADsHjlP/8acz6wcklUTFSA1Q2U9yhe2OlvzB+D1brR5SauYhBHUf2mLzX+gGG1vhzMligUX5rVT75xv/OPygxNkGkTuSjpNRVLBkeoW9cyFAotQpIEs9BaWOj14v5kLTkvrK/ZQLdbwpM+w1WqFTpYQxiyRSkXhPfzOXHDx9SR93ONaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(346002)(366004)(39860400002)(66946007)(66476007)(316002)(66446008)(66556008)(36756003)(6486002)(64756008)(38100700002)(76116006)(8676002)(54906003)(86362001)(2906002)(8936002)(478600001)(53546011)(122000001)(71200400001)(186003)(83380400001)(2616005)(6916009)(33656002)(4326008)(26005)(6512007)(6506007)(5660300002)(966005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dXNZcHFZVjNqMlN1bjZ5WElOUENFU1YvTHl4eDBtNkNlWVU4TkR2dERBaTVP?=
 =?utf-8?B?MUNVYlFGT1ZBVDA2T1hKbVRjV2dYNTMrRWxKbGNJQ24xdUxnem5KZmgxL1F4?=
 =?utf-8?B?Mnk1UGJMWVREWDkxSjRBVHAwZm5VbzNlVlJWMXNULzFhaHI4OVhPdGloMHhB?=
 =?utf-8?B?NTB1VklkMHQwNmYyazJXZEx5bWFLUkFZVloxQTZqUy94TkhJOEVMT2o0dHJl?=
 =?utf-8?B?ZTNwT2szUGVVOHFkOGxzbVkzRU8xeHkzNVZGNzFXOWhkT3FrMEtSK3lCSEty?=
 =?utf-8?B?MThnMkNmQXhlMFhmajlvWGdqRkVIQXdoaThjNmtZVEFEaWRjaFJoS3g2bXUr?=
 =?utf-8?B?RVIxQ2xIOUdoa0h2WXBUL0NvNWJaaUY1c0NicWtDeGFPWmc1Nmg5NlJnejEz?=
 =?utf-8?B?RlRhOGxwMnhSaDQ1K1NUa0tRRVg2M1VOdHozZXgwUFZQTXpXOVVwRkt1VEZC?=
 =?utf-8?B?VGZTb2NIQ0ZjMnl2dUhpem1EYytRN3NEeUk0QmphNm5TaENPUjE5UTI5Qmpj?=
 =?utf-8?B?bG44RVFJTkdGT25lNFFmNEpoYXhCTW1CQnBIZ1hoSlFTRHhDNnN4cUFWNGkv?=
 =?utf-8?B?MEF5ZjNyNmVLWUMwK3RIQkEwbXUwYVIzUktvdTQwWmxjaVA2a2NGTzBsSTln?=
 =?utf-8?B?MGhuMi91WDdIVi90QmNKQUFKVEx5Y3VDYnEzNDhMV09yditiYTNuM0RXUE5a?=
 =?utf-8?B?UjN6Qjc0dUplekpkaE9KOGsrZWxSd0hSeFZxNHlQZmhwMVpsTlF0cW4zTWtw?=
 =?utf-8?B?T2F1ckdlNnV0aVlpNS8wSllUTURwbnpLYkFDV0NKL2dVMWFTcWkxVXVmM3Fy?=
 =?utf-8?B?VVp5dXFXczZxWktsLzBkWWQ1cDBnaDBTQlp4cE5uMVJqUExIZXIraVpCcm1v?=
 =?utf-8?B?YUNaVStxemttV2xzRHNNOEtRb2hQQlNHZXRleWc4TEZCaFFvZ3lpWlZxVjJi?=
 =?utf-8?B?T1NSWTRNeGZzQTN0WHI5Rm56U2w5RTVpdVgzWEFwY0xzVHpqLy9OZVVYSkhj?=
 =?utf-8?B?ajJCRkRDQ2pkWVZYVU96eEVPZGI5VElZczdrSm5PclR3dzN3WldKNzBrYmw1?=
 =?utf-8?B?QWd5am1wUS9ac1k5c3ZLbzBmSHJ6M2FCVm9wd29PcjZIRVV0RWVqbkt6em82?=
 =?utf-8?B?THM5L1FOcWQ2VWJLQWFiVW4zUDV2eXVDUmhnL3grUjJFL3pPNVJISEZYai9M?=
 =?utf-8?B?ZTI2dWQrQ0VzTG9RbEtxTHZURUZJRGZaQXRqMEYwbDk3Z1RST29XS1dQRFc1?=
 =?utf-8?B?cVdYWUJ1ZGN1RmUzRFM0Y05sZmwrTjA4RGMwc2VtTmxndWNpay9wczhSeEx1?=
 =?utf-8?B?YlgwRis5ZGpoem1iUXJuU2VldTNqVjFiUlp5Sm9KNm5BZTd6NEZ3RlZpZlZa?=
 =?utf-8?B?TE9JTEdkTytrUU9McUF0ZGs2NmRlWFZyQXlHSDhwc293dFpwcHNoT1dlOWdx?=
 =?utf-8?B?ZjNQbjhkRjFkazVkTXhiYkNKcDlXMUNoWFhGWGhjR3lUNXlldXVYYnZRNmpS?=
 =?utf-8?B?RkN5THc5ZmlhbUprWTNMZTN5WTI5YVpCblkrZXdSeWdwTGovRzJyd0xLeDZR?=
 =?utf-8?B?TTkzNTRRZFNOWXB3SS9JekRwZlJianRkZmhIeFE5M2Zpc0gxaUFGNXE3V1VT?=
 =?utf-8?B?eWFTRmJMUDVVZTRkTm9zQ3NGZGZ3eWFzYm9EZmVYajNoVFMwRkRxWGtGTUNG?=
 =?utf-8?B?OG5xVnE1Q1daSnFKd3hveHI1dGpBVVovd1VaTVNSeEdISEJoMVRCSG5uRWds?=
 =?utf-8?Q?8Ptr/f+EmgLgMVax6pPVdadGpVNqKZUWbN3OT8e?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A5079F7C5B1CD4DB74F81C5E38AB126@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d31c9aad-d835-49bf-d38a-08d91960a696
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2021 18:21:55.0928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4fGoqNr3J5OdytZK/Ejt3GP9j2gudGpOyTCPTuVXPIpb099zp3lFoAsH8MgdYrplMdH+q7+a5TdSrjw1vCTjUWUT/upGh3hcodJ/FNJwvXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4823
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gTWF5IDE1LCAyMDIxLCBhdCAxMTowMSwgQW5keSBMdXRvbWlyc2tpIDxsdXRvQGtlcm5lbC5v
cmc+IHdyb3RlOg0KPiBPbiA1LzE0LzIxIDE6MTQgUE0sIENoYW5nIFMuIEJhZSB3cm90ZToNCj4+
IEtleSBMb2NrZXIgWzFdWzJdIGlzIGEgbmV3IHNlY3VyaXR5IGZlYXR1cmUgYXZhaWxhYmxlIGlu
IG5ldyBJbnRlbCBDUFVzIHRvDQo+PiBwcm90ZWN0IGRhdGEgZW5jcnlwdGlvbiBrZXlzIGZvciB0
aGUgQWR2YW5jZWQgRW5jcnlwdGlvbiBTdGFuZGFyZA0KPj4gYWxnb3JpdGhtLiBUaGUgcHJvdGVj
dGlvbiBsaW1pdHMgdGhlIGFtb3VudCBvZiB0aW1lIGFuIEFFUyBrZXkgaXMgZXhwb3NlZA0KPj4g
aW4gbWVtb3J5IGJ5IHNlYWxpbmcgYSBrZXkgYW5kIHJlZmVyZW5jaW5nIGl0IHdpdGggbmV3IEFF
UyBpbnN0cnVjdGlvbnMuDQo+PiANCj4+IFRoZSBuZXcgQUVTIGluc3RydWN0aW9uIHNldCBpcyBh
IHN1Y2Nlc3NvciBvZiBJbnRlbCdzIEFFUy1OSSAoQUVTIE5ldw0KPj4gSW5zdHJ1Y3Rpb24pLiBV
c2VycyBtYXkgc3dpdGNoIHRvIHRoZSBLZXkgTG9ja2VyIHZlcnNpb24gZnJvbSBjcnlwdG8NCj4+
IGxpYnJhcmllcy4gIFRoaXMgc2VyaWVzIGluY2x1ZGVzIGEgbmV3IEFFUyBpbXBsZW1lbnRhdGlv
biBmb3IgdGhlIENyeXB0bw0KPj4gQVBJLCB3aGljaCB3YXMgdmFsaWRhdGVkIHRocm91Z2ggdGhl
IGNyeXB0byB1bml0IHRlc3RzLiBUaGUgcGVyZm9ybWFuY2UgaW4NCj4+IHRoZSB0ZXN0IGNhc2Vz
IHdhcyBtZWFzdXJlZCBhbmQgZm91bmQgY29tcGFyYWJsZSB0byB0aGUgQUVTLU5JIHZlcnNpb24u
DQo+PiANCj4+IEtleSBMb2NrZXIgaW50cm9kdWNlcyBhIChDUFUtKWludGVybmFsIGtleSB0byBl
bmNvZGUgQUVTIGtleXMuIFRoZSBrZXJuZWwNCj4+IG5lZWRzIHRvIGxvYWQgaXQgYW5kIGVuc3Vy
ZSBpdCB1bmNoYW5nZWQgYXMgbG9uZyBhcyBDUFVzIGFyZSBvcGVyYXRpb25hbC4NCj4gDQo+IEkg
aGF2ZSBoaWdoLWxldmVsIHF1ZXN0aW9uczoNCj4gDQo+IFdoYXQgaXMgdGhlIGV4cGVjdGVkIHVz
ZSBjYXNlPw0KDQpUaGUgd3JhcHBpbmcga2V5IGhlcmUgaXMgb25seSB1c2VkIGZvciBuZXcgQUVT
IGluc3RydWN0aW9ucy4NCg0KSeKAmW0gYXdhcmUgb2YgdGhlaXIgcG90ZW50aWFsIHVzZSBjYXNl
cyBmb3IgZW5jcnlwdGluZyBmaWxlIHN5c3RlbSBvciBkaXNrcy4NCg0KPiBNeSBwZXJzb25hbCBo
eXBvdGhlc2lzLCBiYXNlZCBvbiB2YXJpb3VzDQo+IHB1YmxpYyBJbnRlbCBzbGlkZXMsIGlzIHRo
YXQgdGhlIGFjdHVhbCBpbnRlbmRlZCB1c2UgY2FzZSB3YXMgaW50ZXJuYWwNCj4gdG8gdGhlIE1F
LCBhbmQgdGhhdCBLTCB3YXMgcG9ydGVkIHRvIGVuZC11c2VyIENQVXMgbW9yZSBvciBsZXNzDQo+
IHZlcmJhdGltLiAgDQoNCk5vLCB0aGlzIGlzIGEgc2VwYXJhdGUgb25lLiBUaGUgZmVhdHVyZSBo
YXMgbm90aGluZyB0byBkbyB3aXRoIHRoZSBmaXJtd2FyZQ0KZXhjZXB0IHRoYXQgaW4gc29tZSBz
aXR1YXRpb25zIGl0IG1lcmVseSBoZWxwcyB0byBiYWNrIHVwIHRoZSBrZXkgaW4gaXRzDQpzdGF0
ZS4NCg0KPiBJIGNlcnRhaW5seSB1bmRlcnN0YW5kIGhvdyBLTCBpcyB2YWx1YWJsZSBpbiBhIGNv
bnRleHQgd2hlcmUNCj4gYSB2ZXJpZmllZCBib290IHByb2Nlc3MgaW5zdGFsbHMgc29tZSBLTCBr
ZXlzIHRoYXQgYXJlIG5vdCBzdWJzZXF1ZW50bHkNCj4gYWNjZXNzaWJsZSBvdXRzaWRlIHRoZSBL
TCBJU0EsIGJ1dCBMaW51eCBkb2VzIG5vdCByZWFsbHkgd29yayBsaWtlIHRoaXMuDQoNCkRvIHlv
dSBtaW5kIGVsYWJvcmF0aW5nIG9uIHRoZSBjb25jZXJuPyAgSSB0cnkgdG8gdW5kZXJzdGFuZCBh
bnkgaXNzdWUgd2l0aA0KUEFUQ0gzIFsxXSwgc3BlY2lmaWNhbGx5Lg0KDQo+IEknbSB3b25kZXJp
bmcgd2hhdCBwZW9wbGUgd2lsbCB1c2UgaXQgZm9yLg0KDQpNZW50aW9uZWQgYWJvdmUuDQoNCj4g
T24gYSByZWxhdGVkIG5vdGUsIGRvZXMgSW50ZWwgcGxhbiB0byBleHRlbmQgS0wgd2l0aCB3YXlz
IHRvIHNlY3VyZWx5DQo+IGxvYWQga2V5cz8gIChFLmcuIHRoZSBhYmlsaXR5IHRvLCBpbiBlZmZl
Y3QsIExPQURJV0tFWSBmcm9tIGluc2lkZSBhbg0KPiBlbmNsYXZlPyAgS2V5IHdyYXBwaW5nL3Vu
d3JhcHBpbmcgb3BlcmF0aW9ucz8pICBJbiBvdGhlciB3b3JkcywgaXMNCj4gc2hvdWxkIHdlIGxv
b2sgYXQgS0wgdGhlIHdheSB3ZSBsb29rIGF0IE1LVE1FLCBpLmUuIHRoZSBmb3VuZGF0aW9uIG9m
DQo+IHNvbWV0aGluZyBuZWF0IGJ1dCBub3QgbmVjZXNzYXJpbHkgdmVyeSB1c2VmdWwgYXMgaXMs
IG9yIHNob3VsZCB3ZQ0KPiBleHBlY3QgdGhhdCBLTCBpcyBpbiBpdHMgbW9yZSBvciBsZXNzIGZp
bmFsIGZvcm0/DQoNCkFsbCBJIGhhdmUgaXMgcHJldHR5IG11Y2ggaW4gdGhlIHNwZWMuIFNvLCBJ
IHRoaW5rIHRoZSBsYXR0ZXIgaXMgdGhlIGNhc2UuDQoNCkkgZG9u4oCZdCBzZWUgYW55dGhpbmcg
YWJvdXQgdGhhdCBMT0FESVdLRVkgaW5zaWRlIGFuIGVuY2xhdmUgaW4gdGhlIHNwZWMuIChBDQpy
ZWxldmFudCBzZWN0aW9uIGlzIEEuNi4xIEtleSBMb2NrZXIgVXNhZ2Ugd2l0aCBURUUuKQ0KDQo+
IFdoYXQgaXMgdGhlIGV4cGVjdGVkIGludGVyYWN0aW9uIGJldHdlZW4gYSBLTC11c2luZyBWTSBn
dWVzdCBhbmQgdGhlDQo+IGhvc3QgVk1NPyAgV2lsbCB0aGVyZSBiZSBwZXJmb3JtYW5jZSBpbXBh
Y3RzICh0byBjb250ZXh0IHN3aXRjaGluZywgZm9yDQo+IGV4YW1wbGUpIGlmIGEgZ3Vlc3QgZW5h
YmxlcyBLTCwgZXZlbiBpZiB0aGUgZ3Vlc3QgZG9lcyBub3Qgc3Vic2VxdWVudGx5DQo+IGRvIGFu
eXRoaW5nIHdpdGggaXQ/ICBTaG91bGQgTGludXggYWN0dWFsbHkgZW5hYmxlIEtMIGlmIGl0IGRl
dGVjdHMgdGhhdA0KPiBpdCdzIGEgVk0gZ3Vlc3Q/ICBTaG91bGQgTGludXggaGF2ZSB1c2UgYSBz
cGVjaWZpYyBrZXlpbmcgbWV0aG9kIGFzIGEgZ3Vlc3Q/DQoNCkZpcnN0IG9mIGFsbCwgdGhlcmUg
aXMgYW4gUkZDIHNlcmllcyBmb3IgS1ZNIFsyXS4NCg0KRWFjaCBDUFUgaGFzIG9uZSBpbnRlcm5h
bCBrZXkgc3RhdGUgc28gaXQgbmVlZHMgdG8gcmVsb2FkIGl0IGJldHdlZW4gZ3Vlc3QgYW5kDQpo
b3N0IGlmIGJvdGggYXJlIGVuYWJsZWQuIFRoZSBwcm9wb3NlZCBhcHByb2FjaCBlbmFibGVzIGl0
IGV4Y2x1c2l2ZWx5OyBleHBvc2UNCml0IHRvIGd1ZXN0cyBvbmx5IHdoZW4gZGlzYWJsZWQgaW4g
YSBob3N0LiBUaGVuLCBJIGd1ZXNzIGEgZ3Vlc3QgbWF5IGVuYWJsZSBpdC4NCg0KVGhhbmtzLA0K
Q2hhbmcNCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMTA1MTQyMDE1MDgu
Mjc5NjctNC1jaGFuZy5zZW9rLmJhZUBpbnRlbC5jb20vDQpbMl0gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcva3ZtLzE2MTE1NjU1ODAtNDc3MTgtMS1naXQtc2VuZC1lbWFpbC1yb2JlcnQuaHVAbGlu
dXguaW50ZWwuY29tLw0KDQo=
