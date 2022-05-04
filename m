Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36849C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  4 May 2022 07:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiEDHiV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 May 2022 03:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345671AbiEDHiB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 May 2022 03:38:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A9A2497F
        for <linux-crypto@vger.kernel.org>; Wed,  4 May 2022 00:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651649632; x=1683185632;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PRwgTM7QzELf7OS4DcMDKsgpTqPMmE7+Gr8+RKVHOpg=;
  b=NauKdcnD1L9fjJDZsEDn46JJwpwjkyiJGc0Q0UNBin8/6bCN/NAJk87Z
   jcj1u2ekNpMKwVIbUDfnfaFXvPC5tkIvP8vNmsIQKbQRvhqeha9FAApY9
   th8aHN1ettd/fbk1P5Sem0nL4ZMOVNyzARpOdUVvLOeH4NpKWZWmydMnj
   TgAu0QgO5c2cn3bWfwA+cFmnta5knVUwoRkYKt31yGVRTipY5mlerztK/
   NtXPyyEaLjBUgWi8YWDpYi/y0UcohIWzgIfEPMnLoHJoh75N7w6nsz6dw
   jJbgrN7ayxm0CdJCcKZPpz7xsHr1VMvuh6q1y9EuiZbBUFSJUFeOV2q+O
   g==;
X-IronPort-AV: E=Sophos;i="5.91,197,1647327600"; 
   d="scan'208";a="94495189"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 May 2022 00:33:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 4 May 2022 00:33:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Wed, 4 May 2022 00:33:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFcdPe8XHIh0+GSkgvqkZuzVN5MHuYAMF+/HPUnYMW20mr1eWOzUAQqINMJVw9kUE5fjSIpsf+S679wHq3FNk+ezTj3vSE3g73eenv/Ouo/HkrP804LQJ1KMneo/X/hcozyBI3Ra8AhA1n+GD7hJown3ory3Rh4ci/Q/Amzz22FlZmRLkOZvrqAkT1eQF4fel5JOlC+/cwvohzbgwLOLNoiAPtbpHEdDsBB1+pDR6TabwKDKQy0IU74cund6YQEuM8zqfwCj8PL1EYjWcELcPSwI0BWo0YO7t2V1T4Fv/9XK4+fxwqvcPo+apSjPUWkCjJPeyZCcb0xKaw8Qb8FEvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRwgTM7QzELf7OS4DcMDKsgpTqPMmE7+Gr8+RKVHOpg=;
 b=PoOU4lD/leXCPs1Dt0MRLfbNnFEOEd55He4EKFANYtjr5BSMTZ/nQKfdIKMI7QM/wvJ3ijMpGi50zX8S0DBuZ0fyFCNl8AoPFBciCcD2FnHjCtkoKEY+Oin6uqD6winyM7Koi3q+22tkO6MFQTlXC7ofsN9VNVzJh+aT+0YZVCixVm6ZmM6XPuVY9bb+pojFOxcSEM33OVu8UPkSsnSw33LGCkJHanRZC4X4a5MfMqyDKX00MbSMsRzWs0FlPG3/EqYuheQpCUp6lI11P1ZUFF50nmgfm9PvO9jgeA0nwR0qwcT/a8hXqTadIjaihoGuAG3kgs4vZqn300VKZ9m7XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRwgTM7QzELf7OS4DcMDKsgpTqPMmE7+Gr8+RKVHOpg=;
 b=BrtQ3jfP7mhJjhd5pAc5ZHroBUkWP90mZYO8jCZlT+cel8VWqwkQYQFoTVzhdAWV3w7pi1IC+vAKnhuNs7wJtnIRjItXUcHBGE9FW5Xr2WX59/Kn5oSzepuwSOJDbngDHDt5ElX4/DsrUa1XgL91DD6jiXhEVOQD7moPKBwOs4Q=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by MN2PR11MB3824.namprd11.prod.outlook.com (2603:10b6:208:f4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:33:45 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::8090:666c:ac80:be3b]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::8090:666c:ac80:be3b%9]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:33:45 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <u.kleine-koenig@pengutronix.de>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@pengutronix.de>
Subject: Re: [PATCH] crypto: atmel-i2c - Simplify return code in probe
 function
Thread-Topic: [PATCH] crypto: atmel-i2c - Simplify return code in probe
 function
Thread-Index: AQHYX4lJm+C45UqPAECdW5T3tKviUg==
Date:   Wed, 4 May 2022 07:33:45 +0000
Message-ID: <0d6da365-e41b-e9e1-0499-fc57a32b1064@microchip.com>
References: <20220429140349.215732-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20220429140349.215732-1-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b642d08c-642b-49d3-8342-08da2da06c0d
x-ms-traffictypediagnostic: MN2PR11MB3824:EE_
x-microsoft-antispam-prvs: <MN2PR11MB3824048BA9EDEE121C0A9E3887C39@MN2PR11MB3824.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0MVLd349rDfh/mWnDCrFXyp20yQwO7Lzs00S+eMEAK98la7rwt90MpKfnXYSPNx+1nypdEVtGPTzZxhutnvkdLm+m1vi2qtitSiJhbxx83WfFFDpXSAH+T1nWS1EBaRDNTIaCGwM+4wTjChE6Ux7tclG/iNMwi4fdPpG7f9n84YlTP3zPhT4z25vRRuxVCthZ276jgoYZLpK96+IMr62wqKI5/KV43kwdLYVGejk63cWUEJa00iHGi01KxOuBFAew2nBIia6f/iBqa1dM+kd5stMzxzOXUVLPRIPAo0+hQIiq7IfvzWi59CKHb/41TtVtAlcyyTmwVaYRUwZC8+VgrnBD26ytyosArZM7leOk9LKRW8/tb0pUebJ5AZ1yQbG5lzNdIARCl0+4YD2Ql2BcdawxM9rGHWgOySLcLhyzySoSzVKWwlywzX69N20JnPOKVzTkgmBMaP4Naeq94Hp5vXz/1B3vfp1BKjMb9+uHBaUktAGYWNnY6SwI3vPTCVP7mo4UfwFgrsRoIW2vqEJYBFbV83fhK8CQmdvXcqFmimW/Lmpl1Wwf03MSpLNspO+ryzuGfMyE9DdbiRSaObWzjffhLifmxwwVrOwLxCBNE4STtX0Tq7rz+fRf1xNmDafqg6F7icxmSqhgLbUbOe0uMDEDzQ/zxDyGh9hilYjbmHJXSuhDKnyFB/KLXWEUKqovHFA0BgJFLZLmdm//YNi4CdjfSn9LJ0VZlLoGNkROEhlwH7oU7p1cFln707PSfhDQgHXtXONg74JUT5yA2oBPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(86362001)(53546011)(6506007)(31696002)(26005)(8676002)(6512007)(8936002)(6486002)(122000001)(38100700002)(38070700005)(508600001)(71200400001)(36756003)(4744005)(5660300002)(76116006)(83380400001)(91956017)(66556008)(66476007)(66446008)(64756008)(66946007)(31686004)(4326008)(186003)(316002)(54906003)(110136005)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkllbXdDeEVSS3B0V2tDbG9ubnBPZWQveVdITm5hNkxNb1dORXh5NklWVFhQ?=
 =?utf-8?B?b1MxeXFCU3BlMXlzUnR1YjFveDhMa2dnbzByTjNBUzRvcXFjUWM4bmY2ejRh?=
 =?utf-8?B?UWtxLzdwdHRLUzBIcWZqaVZQRlFva2lUNk9oek1KcTJlV2dSVW8wd2M5ME10?=
 =?utf-8?B?aW1sdExUZjAzTFYrQ0wzWU9XYmhLSnQvTFpreXNkald1SDFPb3JkNS9ETVVO?=
 =?utf-8?B?TzdLSTNLWHFzaFlsYW9HWmRWYUdSMElpaWJJTFltQ2Izek5VTzczWDdjb1R5?=
 =?utf-8?B?bzErSlhwdk83T0RGRW9OR0ptVjNMWlRxN1pYSnRlRnlHcE1lekZSOVJiK1Zu?=
 =?utf-8?B?UGJ2bCs2QmlYVWEyOWRPUXBqTkdVeDhmVGE0TTFuOUl4emtLMy9qMnpGOVo0?=
 =?utf-8?B?WDkxN1BZOHRJanQva2hOSldSVFlHd21aSC8yRHhwUU9ub1RBVlZpc2YzQWJp?=
 =?utf-8?B?d3kycGl2SDRLZFA5MWxDZUhVVW1wdmJtaHEzTW92akhFdDFVeUcxMm5aQjVZ?=
 =?utf-8?B?NTBTaFJIbWRZMTM1a0NkNElTYUhGZFFrNzdPYmVKZU1YYks4L1JNaXJvb05B?=
 =?utf-8?B?SnpuYStJakpEVUx6cXFVZG1JSVNJakxROWFMVW15OWx1U2d4YTZIWkxEM0NP?=
 =?utf-8?B?aVlzaEp2UlBZdno3U2psNEtuWUZ6VzlEVHhzWG1pdW41QmNxUGZoQWRyc08z?=
 =?utf-8?B?M0FDcHV6d0NHcDN1VlkvclBkS1BYNkNSdEZ0dFRLdis0RHNMTXJ1dEdkcHdH?=
 =?utf-8?B?cHpERDNTcE5ZR2N5ODRnOG51MnRzR2U4L1dFNjJlUVBNemwwcHRzelNMYVlv?=
 =?utf-8?B?Z2tVNjlyUFFFait0YzUwdUt5RGlMRXp4bC92aHVHaitSNVhZZm5uMXR0Vnhv?=
 =?utf-8?B?VlBSdnpWT3c3R0pjb1BaK3c0anBTTW4xYVp5OHh3QTdKeUtUd3ExcDB3N2hC?=
 =?utf-8?B?d1dqclJOMTZ4NjlTaVpuY2NEdlNqc2ZSUEFucmJHUGpLOEFWQkdTaWRkb0Fi?=
 =?utf-8?B?VHF4aGhMckVyNk1HOGxVZEorWFpyZndUWDgzS2pkSzVBMHpqaFlJV2hackFl?=
 =?utf-8?B?VURxa2x3TitzQVY3czRLQmlreWV1djdEdGY4dStwVTVTdTNBM1FkZXRmcHZQ?=
 =?utf-8?B?cFhtZUZiTGJXcnl0alN5MmxXNkhoZzZpeGRFR05YSFJqbVp6Z1cxOXMrWlRV?=
 =?utf-8?B?N3ZlVjU0ekJQMjBIOWRFTW1VSy8zZzVGTkloV3o1c0RWZHVoNzREU1p4c1pC?=
 =?utf-8?B?cFUrY203ZnJ5V2tTMEdycWxWL2JHSnVGOTVqSk9meDRSdEZ1VFBMUDdxSFNN?=
 =?utf-8?B?dHRiZHN5ZGFGMlFPc0ZmYjRBS3lqK1RHTUZlZEZXdGVManJOMEhGZ1RNTFhB?=
 =?utf-8?B?RVRiclZhYVFlbTFFdTRmVUo3Ny9oaEF0d29IWXE5SG1TRG1vRXd2bE9XRHdN?=
 =?utf-8?B?d0N1ZDg0S3JBSEU2U0h2V0UxK09CTVpTYjJpZHBJcnFiUzJvTGlaWGdNdi9S?=
 =?utf-8?B?UUdCZHNDQmQ1ZE1FRS9Xelk0WVhoQktKaUpMcUM4M2w5MmNMMUtRZmlkNE1v?=
 =?utf-8?B?eHh1WXJaNk9uWjhnY2ZkcjZURHR1YmdxaURRazMrWmpHcXhxNkxESSs3dUVS?=
 =?utf-8?B?NGxRTnBsdWlhb3RCemVHMlllK0JMOEdPQVFVTlpRdnpza1JtcjNnVDRjK1Yz?=
 =?utf-8?B?a0pnQUlJcGNoRTVOb2dNWnNaanB3KzFkTE9xSnBmdkdtSzRxUjlwa2lhNnBV?=
 =?utf-8?B?RGJiWkZVcWhuSkpVSlp1L0pWbFJVUDVlYzhyNHJLbUp5QU9rV0tzdkxCemFi?=
 =?utf-8?B?VWlBM2I1bjNvNEJSK2ZkYmpnNGtGTGJqNGNsbTd2T0pvejNwK2JMRCttSGxY?=
 =?utf-8?B?TXFkZHZwdTBKVlNzSjBvbU9EV1RtdUxWcWlJTVk0YVA3RnQ5M0JFSGh5Y3Yy?=
 =?utf-8?B?K3hOb3pUM3NEdHV1NWVxSmV4VkJKVlhpOEJPOW4xcHhDTlE5eklEbC8xWFBR?=
 =?utf-8?B?SXF2bkVxYUVmdjRHSWtqR2VSVFlralROMXZDY2pRNTlWT1M1V2ZxVHEzaFRN?=
 =?utf-8?B?cVorNkNkQWdEUWZSWVZaN09WYmhlcjRQOTh2aUhOeFc0dEw4ek92ZCs0S1Zw?=
 =?utf-8?B?ZU1CMDUzSEZKR3U3TmN2NmxmYzZtVnRsTEdEaWdXUTBFbC9wQzFFeHhBOFMy?=
 =?utf-8?B?aW45RFVQVnJxZG84dlREQmsveVJvWHB5M2ZmaDY3MWl6NVFRQWw2MDVORDBk?=
 =?utf-8?B?WE83cW8rc0NhREIxbGZYSmk2cnlQaTRWbjgyZzRPRVN0VkFBSGs4YnAveWJ5?=
 =?utf-8?B?cndRNWZPSnpYSm40MTExazh6eWRnSVY5NklhRGVtS0QvZUwzTExFa0RsWWln?=
 =?utf-8?Q?N6DqVuRWI1DocrEw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A83B7306BE2824A987D7701E65E7F74@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b642d08c-642b-49d3-8342-08da2da06c0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2022 07:33:45.6876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /G2fAdBBnvshDKahVKLg0HS4K5sFQom4ioMSIUg1F/VnFCU9DTHAZe+3AXm+7Kw8U4JOLZx74+rjS6+hZBwCgUivNX+LFlNWHIyMmYxJ2uE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3824
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMjkuMDQuMjAyMiAxNzowMywgVXdlIEtsZWluZS1Lw7ZuaWcgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gVGhlcmUgaXMgbm8gc2VtYW50aWNhbCBj
aGFuZ2UgaW50cm9kdWNlZCBieSB0aGlzIGNoYW5nZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFV3
ZSBLbGVpbmUtS8O2bmlnIDx1LmtsZWluZS1rb2VuaWdAcGVuZ3V0cm9uaXguZGU+DQoNClJldmll
d2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCg0K
DQo+IC0tLQ0KPiAgZHJpdmVycy9jcnlwdG8vYXRtZWwtaTJjLmMgfCA2ICstLS0tLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvY3J5cHRvL2F0bWVsLWkyYy5jIGIvZHJpdmVycy9jcnlwdG8vYXRtZWwt
aTJjLmMNCj4gaW5kZXggNmZkM2U5NjkyMTFkLi4zODQ4NjVlZjk2Y2UgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvY3J5cHRvL2F0bWVsLWkyYy5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2F0bWVs
LWkyYy5jDQo+IEBAIC0zNjQsMTEgKzM2NCw3IEBAIGludCBhdG1lbF9pMmNfcHJvYmUoc3RydWN0
IGkyY19jbGllbnQgKmNsaWVudCwgY29uc3Qgc3RydWN0IGkyY19kZXZpY2VfaWQgKmlkKQ0KPiAN
Cj4gICAgICAgICBpMmNfc2V0X2NsaWVudGRhdGEoY2xpZW50LCBpMmNfcHJpdik7DQo+IA0KPiAt
ICAgICAgIHJldCA9IGRldmljZV9zYW5pdHlfY2hlY2soY2xpZW50KTsNCj4gLSAgICAgICBpZiAo
cmV0KQ0KPiAtICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gLQ0KPiAtICAgICAgIHJldHVy
biAwOw0KPiArICAgICAgIHJldHVybiBkZXZpY2Vfc2FuaXR5X2NoZWNrKGNsaWVudCk7DQo+ICB9
DQo+ICBFWFBPUlRfU1lNQk9MKGF0bWVsX2kyY19wcm9iZSk7DQo+IA0KPiAtLQ0KPiAyLjM1LjEN
Cj4gDQoNCg==
