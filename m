Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECB4E75450
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 11:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240603AbjJCLkF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Oct 2023 07:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbjJCLkE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2023 07:40:04 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2600C6
        for <linux-crypto@vger.kernel.org>; Tue,  3 Oct 2023 04:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1696333200; x=1727869200;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/UJY1hCJDGjrCmFEKcjcJGGYZAQ0NgDeuTcRWLsxd9k=;
  b=S8fGt6tOFurzegrA7jO8FFI6jUBLcFcIODMO8BMah2ErjPPzI84/gR33
   82ZGAlc01wp4s+olAF9F/d6Kt1RLEWTnkqexdkXrNes6+Ycbd6iKIoAbg
   QfnkBkqivT/FE17qmuP2pkA4CBwbt9Pwc/wCItIARY+Hp88amTnZNMHZG
   OcX+70mEP2ZxH9ub5uHvQv4rSH+35cu5U+za2fa7GzRxG5n776dERVaNg
   Tw2G+mIu2hjfkqvogea1mtSiKyy8ABHrmHWlNhZGrvTd4QrLFhbFSgZZk
   wrhJU7zobG0ZvLbRovyB0ZqIxQTIQSspwCB89sjJ7WtpVs8edsnTdIe6A
   A==;
X-CSE-ConnectionGUID: QmOnGb0gSl+Z98I76YtC9A==
X-CSE-MsgGUID: L67+6vITTOOmReoHfQlLyA==
X-IronPort-AV: E=Sophos;i="6.03,197,1694707200"; 
   d="scan'208";a="350943383"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2023 19:39:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7cSU7OPLde/2n224NFfgJgfzCqKxwVVO/aGhu6yWCYeZUrExOt6HkOZd/bUQ2M2rSQHAVS+WmTFFmbSt4bqbC3+CTpR1Zhj8DSes9jxK+GFKH14jEMXYd/YnUetsB7JmPYWQOJMOhSns26KGAsZn8y2q1yR81j2koZqXE7raOFwOjBKrHEIVPfpJE5el2IPD3mWCuhsZeq49lXl3kbGAvNkbB5NUkr8nHlGhvQ3TPxYNaTQnWYv+PJMch4E8OkjLtm9XBA2hNwAX8Sytwk091pWwthx0gY/zA9C3RCDM6RXduaOXte2D7bGpWr88frfNQuBmIZMWHpwBr21GKjpvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1TsqyGOW84h75nKUQp6vT7PoD+E9DLx057Arr3jbQ0=;
 b=PXT7iq7QDIFktaloJidr/wQhVVyo8wMLAKtH+/SGPw3PWPK7n9YoV8xTTWIR+XWs4LSdTSeKkqHHiLnZ6VxnfKik3+Nnm5pV6SrctykNm3uikxPwHXkJnDMrhrg7sAzwCx/MczWvg8bSwnoY7uBEhE1LdnXymgT98LCIvqxWc69oGAjMmeYvU9+EYbGVPwVxe8WK/36FEY5cbvkIXS2yI9u1qpPxZU82ZsEbsbkNTPeUywAHzvVMwQnVhM9+kaQN9+L6xCKe+8bHhEFnCimVzhw49GKZB7pFUbNNAfuqzhaAbFS/V336PDhDC92z/WI1weAjP2cN8t8IIYTQi7G7cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1TsqyGOW84h75nKUQp6vT7PoD+E9DLx057Arr3jbQ0=;
 b=wdpAWl2AeTp0zgZ84cijf622MUa1Qp0aqmYx8yZl/RIffgvUdFmmJLV9jq5/O+bbc2355g/HcPTYxXO7o5UV3QAOEZJZeuj51zVPjsR1moR0D1kv17D/aaqTpxN21U3okiHY7E/i1znEq6pnhPf9VuisraZM7QU4gGV6fpmG80s=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BN0PR04MB8127.namprd04.prod.outlook.com (2603:10b6:408:15f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.27; Tue, 3 Oct 2023 11:39:55 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e%3]) with mapi id 15.20.6838.016; Tue, 3 Oct 2023
 11:39:55 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 0/16] crypto: Only use common fields on skcipher spawn
 algs
Thread-Topic: [PATCH 0/16] crypto: Only use common fields on skcipher spawn
 algs
Thread-Index: AQHZ9avixrtf2pVW+0uG+quSLWPQT7A38TUA
Date:   Tue, 3 Oct 2023 11:39:55 +0000
Message-ID: <kjccevu7lyl6xwkz4lbgmzc72fxzbv5fpv74746hlncgptma5b@qkm3nxrx3wfb>
References: <20231003034333.1441826-1-herbert@gondor.apana.org.au>
In-Reply-To: <20231003034333.1441826-1-herbert@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BN0PR04MB8127:EE_
x-ms-office365-filtering-correlation-id: 7d5e0cef-bc96-4490-1453-08dbc40576fb
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gCwVKQwyw1w+bz4mvCbGJqSrn+0eSvqgonPErTBVJJStQFm+abteltBFOBSf+cInZ+HGT+86+3cBb5fIC4XKhYV31EKWDo2kBpdvRuzxDsPpWqaX3dHTVOjP/YvtEEqGXl1FnlJOgVXp+5CXyiALl9AT1QKAd312RCIVbw0kijvZxYX+eg8e6NoOJRbD/5Iu9a1DyybROY6rDyLKVeDr++JYfQUtwSvYuKUB28+56g87KgN8Cm8fyxBA0CeYgwdfYk7zhQROecP9TG0AY7fYcbKb/WThyE5EqGBUpt2T0YUoVnPsSrYMrDbqeexwB6pqpwvJM0YA5sGTNgGVfuX/0VC7wbJbB5Djq9sVHbbLLkBiVirkPXwadrk3eW7q82isHKY3Vjk51HXwW32ZwU2eKR3fmyHeLmyPm+f1WAQAmd36UYx37mdN8018EvRLN1zIXfWVJeO86KP8N8PXrMr5dJj+Zyd0m8z+ubmQHv2aSb7a5066T0CEiYaGGUt+FmzIgWqSZD4D9mGGrNKaR7G4p86AbflpaKsnz3NzFfOQX9xnNGvnQX6vXayg3VKqy2lvxljLFQTPpXHUgy3/pN8FedemSM4Ypj/Mqo5v2+KYnxs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(39860400002)(346002)(366004)(376002)(136003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(82960400001)(478600001)(9686003)(122000001)(6512007)(966005)(33716001)(6916009)(76116006)(66446008)(66476007)(66556008)(41300700001)(66946007)(64756008)(316002)(91956017)(38100700002)(83380400001)(26005)(38070700005)(71200400001)(6506007)(6486002)(5660300002)(44832011)(86362001)(8676002)(4326008)(8936002)(2906002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S9ER+MHvwLTfDEn51pn/JGWiyM37IdHNRtUgKhOeS93YDvAJ1DetSfwYEu+9?=
 =?us-ascii?Q?AnOpRu18jtEwxVMHYTGMpA5H8wz50Co3BA4ny8EhFLbCSk/FH6OLqyaZUPw8?=
 =?us-ascii?Q?xmBhoMXWypqyJSDqZqC5A91gwQuHXDbq1V/G+NaeJvJgTs6Qy3Sz00u4InKP?=
 =?us-ascii?Q?p5TlLIC550A/0UyE6LEKUcpqMLCPRkH+f3tNFENcKmKK4IuJFOooTqcmRj8F?=
 =?us-ascii?Q?IwtuYuFTSwLvQUnKnVzArgnzYQ+Fa18GJUkb4HDE3x5fSN35NTy8n5+8vh7t?=
 =?us-ascii?Q?hb7ZfeyrGy60oak/SauUE6tHd1m0ap8YpElaotEcm2okf5dFvv4g7GhKO28k?=
 =?us-ascii?Q?htNY2Sb5BugbPQIGLOrTCxjj9Y0eN60JO3J0PdQ88b6u8xgb34lkgM9EdOTZ?=
 =?us-ascii?Q?YMAPv8urjBdKer50R0f5CfygCatb9Q00fJ95KBmeaCT80kylZh0O0qmRfWZH?=
 =?us-ascii?Q?laUWyb1wttv07ojOHHw6Zu4gaOFLI6Qh71JmAK6YSXl+m1j09xSu5ulRt035?=
 =?us-ascii?Q?szZwEFIYlHS0r60AQi73+UsedtPhitLRkCcv0v5gLbkOL+i61lCW2vtq1++z?=
 =?us-ascii?Q?wjYZl4dsmeXmsDIcSAhzRmnIxjum+tA8vZwTf+yiSoPzkV9g6qtY1JFT9+uQ?=
 =?us-ascii?Q?Ha5FsyUVtByXZotwb2OpCuLYPmW2tTHenDvNQ7xT1VXrI7TTKATqtFBrmWsk?=
 =?us-ascii?Q?KyLtFeXTUQNCMuswrPU/QZDjOySS0j5dg+77G4xoRuYiaUrTmaA1VpRnDiIh?=
 =?us-ascii?Q?0JwlwpJe+08ztt7vMzIf4ZQj6zLfisZ4bWw3PEXcMFaJyIdV05EiI+zW5jzq?=
 =?us-ascii?Q?xnTcoec3IqlGEgfWoLeznTUMAYQG70cqTkJewJoF4ls8UV/ISMklUnL0TAcf?=
 =?us-ascii?Q?IaPnQi0utqMWDIYhZB5PNvkoj5apwAVg8Gg4iaG6SRJTAwdOYSsZLTDGXDuv?=
 =?us-ascii?Q?bKbaNQdx7E5Cqv+2G4yFeg6DbTv21vy+2qYFcBIQgrFb/x8Pxh3nZmA0DGh4?=
 =?us-ascii?Q?ebgLaKkwEvfXWTeYM9LVz+e7rf4IlL9nGhpdoCRbUMQcMhWNlQJzz0K+rPmd?=
 =?us-ascii?Q?iEQClGGc+irdJGcMcPQ53v0AqZlff0Xh06zqZkbIrSHRs4RELkfwZpVU5cx+?=
 =?us-ascii?Q?aVQns4zDC9fnyRHyBQnzeCnM2QhHShN+w58/YHzjxpxc793w2JVm2d/5IMbG?=
 =?us-ascii?Q?n/OYgu+xwDTYBKIFi1kUSWo4NBHKGj/P1j22Qw4XCSsPcoOLdDImVxlJjq3m?=
 =?us-ascii?Q?YvZTzMAbYm3kNoJeZ2+TZ5Z0kA/5Ce5V8WJTURfwa6o5Eo8udbq9/osZfYRN?=
 =?us-ascii?Q?5IZUMFs3kZzt99YXL8M/hoTlw/FXp59wOaAEaFqCSqB2djdUtF5wHe2y9IIp?=
 =?us-ascii?Q?l32IXehzW8DKU7JNpBVF/zvHIzQjTBOLW9IozEo01RHMz1x5kOlSYdLX3WCO?=
 =?us-ascii?Q?auAI6Ypqad1E/YAKQ4nXHzU+7QA9HOuDDWhzO2rw9TSdrmV4YrSoyVCS91b9?=
 =?us-ascii?Q?QdLH1AiB+ZJB+081omcJm4DclAUZtDVgbJSBTzMypLbHAAtjST0UMuNn1wrE?=
 =?us-ascii?Q?0XUn9cShevWiEWROr/LYQLPPUHNVwJJ47zo+j6koLHhCqu+qw/UoihgFWhtp?=
 =?us-ascii?Q?2UO8RiEg1X5tSSCLV0NE5PE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C4448852A10B774885BB106B3E34DFF1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eKLUIodZT1hAvQfgvSz+pj/dooiDqoTC1wY8beujKWbydtDIMBBU2hczZcZ0QfZDtV8KwmHGWwvoudOL3oQ3hJnF83P948mIvacvQePC/yBwfoBs3B794o4b38jg0c9P403NAiwNisHc4BMD3g41h9mo4s1BVd8n3Uoxya2EWTmSu90r/lnaOWNeVNKSj981lPgibDb9Wwl06uQEjbYXXOe2F4EAidP4N5g7lY2eiButRsc/EasW7txJY/3vNjggzz+9VXkBOAiFzeV2ueT2NvzHchcV6juPpSE0TUxKoQdKC+hiNx5DSvRBHBrVdlzFwRHofInb6CneArDrDTzG1NXtJnzkXIijkkzb3Mm9uv7A2r2jFBbNu+y99qYViPKYkb0u1Kv92EUIklbzy7BZN/oTOGqKPA//xezP8eJeCYxoQMVUD0RyUpjqk1ZZSpIYVOzU5dliTKcjyg16ok/Z3ydRpyg6B1EVIw1q+iJqX0rrY6Rxteeur1MmpY8ueb1JCWeixZbZV92SDWPEnLiaMEexlfPL6DbLz1xlIpfeGUz6rG0n9nZ4nPv78PDf3P+L2MbPdBQpVpoQJLA7iFJliNzc9kRDa1sgipd9icIY1U2VEjUK8WRoMSUdIeYI1HtTJ5A0i3YYYkseATWk53Wt4S8SGyGRAvM9BSpZT5T3wdDbro1HYpRICdQN9e6rI6rCGQvZv8f0JLE8PbCZ8OGB0rFZwqXrFCeq1eSrpoVEVNIrwibzyfpQrCiLWOORkeQjAnv7RPhyaCkqrzMXzHXlf9QobFYvrU9gOEqFImVEokZ0NJ384tk5SWd/FLneBiZHD3LGetQl+npwxdopD5hF8w==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d5e0cef-bc96-4490-1453-08dbc40576fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2023 11:39:55.2977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: amfk3btB9PNLs8bu5VwlZBTuhNHYHsdefgKEv/EdjZd0y+hAmZl+qrbF8Ncw1/FRuwe2nq3C1WitzbdJvNJn5HbkmWI85j3v1Rs9EX2yWQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB8127
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Oct 03, 2023 / 11:43, Herbert Xu wrote:
> The lskcipher conversion broke essiv.  The superficial reason is
> that it was missed during the lskcipher addition as it does something
> similar to cryptd by being capable of both creating skciphers as well
> as aead algorithms.
>=20
> However, this also revealed that users of skcipher spawns were
> dereferencing fields that may be specific to skcipher_alg.  This
> is invalid as the underlying algorithm may be an lskcipher_alg.
> Only fields in skcipher_alg_common may be used.
>=20
> This series adds the necessary helper for this and converts all
> users of skcipher spawns to use the new helper.

Thanks Herbert. I applied this series on top of the kernel next-20230929 an=
d
confirmed the failure I reported [1] goes away. Also I ran my test sets on =
some
dm-crypt devices and saw no regression. Looks good from testing point of vi=
ew.

[1] https://lore.kernel.org/dm-devel/4u6ffcrzr5xg6tzoczkfnuqy7v2e3w6243oxds=
u3g4uughh6go@6owks5linnxi/=
