Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAB7C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 19:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8A1364E9C
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 19:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbhBHTph (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 14:45:37 -0500
Received: from mail-db8eur05on2068.outbound.protection.outlook.com ([40.107.20.68]:50912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236389AbhBHTpQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 14:45:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcDT/1hlWy031dRiM12K7Xc6tZUYA3zvsvNxjpl8j2c9YQiNUCzv2I+J4snHcvtTI1pK08af6NZaWoQoA6O0E8IB7W7ulaxddffxsrlVVbA1T7xmWwL/s3T9qYflSLU+1z1+nlaDgLu+bsb29e9mrZ/UVN0VRLG/Cm1vG9atayAufy7ooCVXIlE44Rl4l9bVFgx56h60sUM7LiVWufeshFgWBWUADmWmxxRVN4a5qI/GkvloFEfdWwraSZCRp7hocSZ0LV/rKdBS+RQ3ASNkeHbm4tbOxz0hgWxCOOKndM6LB7ui5+n8YK8vRqDu+nAFe12exkQDVrykvS+V36o1lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPbfCAZFYrrPBwK9T6p+C3LyGobJJ+JaRhlHtW8BWlA=;
 b=keUyJ2PnJN+31evstp78HvpdyxtWuuRZXsXmvVK9M/YZ0Py0SUuF+CIRRhSZCMb+keHZqq/zPuTGzv/FXMXpdHgFkJ+gOPpVX+4Kp61krlwPXqVim6kO7vFxXJBOqglQK/Suk3i3axgg7iXsY+iR6w5sal10mI6jiz/7kYkQ1w0aC6eNmDr5bcIij/t9oPmWkiq1kvO7QUwWbAUebVJVZYD7F3++SmhFO2jguSWVUP8qULhDNYE/Hu5ntN82Fk9yOGM+SeobWARGgI+u68pwTm4RdKwOC589oYSSf+NIb26fkgMnrTw56poWUEDP///AdNNJLZ75Ja0yuHVFABUYtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPbfCAZFYrrPBwK9T6p+C3LyGobJJ+JaRhlHtW8BWlA=;
 b=YQ9p+ApA2lSj7jatmZdVAtYl2N5163dUJTB+gDJatFMYESyUscB4EvpeDaDf59WeYsiB8+jTR5yJ5GmL6t36PVrg2pH47TzcPZdcNdN9ZcWQrEeCjSBKTtkXUz1CT4FV7zLAHQ3/vPVvTRg6mfE72Wavwz6yiXrwwW9llUVSXnQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5040.eurprd04.prod.outlook.com (2603:10a6:803:60::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Mon, 8 Feb
 2021 19:44:27 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::f02d:1e2b:185:c4e1]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::f02d:1e2b:185:c4e1%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 19:44:27 +0000
Subject: Re: [PATCH 14/20] crypto: caam: caampkc: Provide the name of the
 function
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
 <20210204111000.2800436-15-lee.jones@linaro.org>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <8cf9a971-26e9-a9f1-d887-c64815e81aaa@nxp.com>
Date:   Mon, 8 Feb 2021 21:44:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210204111000.2800436-15-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: FR2P281CA0029.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::16) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by FR2P281CA0029.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Mon, 8 Feb 2021 19:44:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fbecbcb0-b604-4143-fec0-08d8cc69f1a4
X-MS-TrafficTypeDiagnostic: VI1PR04MB5040:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5040D0D045EE7783B5AAEA80988F9@VI1PR04MB5040.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zHiO574tFfKedqjbd39Vq1OvdSflaoVrmapcC8GKrO5FRYguMq+j5AhVgC1fA964RTyQV4zWexXYn6ZJAfcoptlc5AQMuumpTIQ2Q+eozBC+b6KySqHFn/fgrmfsoYJS6xHwUpqhtwJr8ZAbuoLQNjogXj2pJ5ej6Pl5iypEtdAoHnnSKlXCEactqplzv26SuoV5l0N+Fc6e8nGuCKy6oGcriyru9Rg+Fh+hlNf6EuKAucSLSLKCOYUOqqXwZIrdrOqy0L0rV5nUEl8qxYPeygwmoc81Us26z0LVievyywpwwIXLrF2aeJ19CgLi7mOS09vJ6NtCeKiJ3isMYhGLp3kZmchLckk7Dyr7qBhg+25cifvLA+RejnPrrugRcY179fQBBwoFG71Tlx4CHGsktobOyNNhR9fpDZp/QMDFMXuFhry9F9qCY2/t0Vy/rf2dHjD/ZIykwi9y9SnAVv2XeSBUdmaDNJ3OTuQ4MRD1VuWNg22e73YqUuEiSWla/wtUEJ6VovHXfuC7VTNRxCPTTOKXB+N6FFWcsVp1yuiKGdOsru26WOBXDcg5hm1L7Hs5xi3MydBxskc/WYQJfZOBGFIFKhkCHfB5l0hZtSguTQw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(54906003)(6486002)(2616005)(31686004)(2906002)(5660300002)(66476007)(4744005)(66946007)(4326008)(8676002)(16576012)(66556008)(6916009)(53546011)(83380400001)(8936002)(16526019)(186003)(26005)(956004)(86362001)(31696002)(316002)(478600001)(52116002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OW0wZnhrWHBzWUtlL1NldHBoRTlzbnNOM2tJMWwwa05BbjlGMmdYQU9jZzcr?=
 =?utf-8?B?cnMySk5Tays5cmNjOHlIMXRxUjMwUjgyY0JlbVJOUk5BNzFSRnZoYktvM3hi?=
 =?utf-8?B?Q1c2RjlQUkkxc0V3dExLbWplUUQ4VnhaU2R0Qk5NaCtuVzg3YjUyTnNqMWNm?=
 =?utf-8?B?Z1QxaEhWaWJhNGM3cU9OSUs5Qk9NSW1lN2RlQ1llWURUT3J1ODBTY3RhQlUw?=
 =?utf-8?B?RkRIVmYyaHNkUlFaV2s0bDVQVEdqdFF5VWp3ZkQrbHQ5UUR1ejY2N1Y5Um1L?=
 =?utf-8?B?OGQweEFFTFFIZXJaMDExNnBnS0pmL0hWa1NVUjNZSmpDbDY5R0owRlBKTEda?=
 =?utf-8?B?UmtkaEx3RlVDcUFSVEtPazFaRThlZko1RGFoODcreUdvVWV0UW5ab3RnMUFT?=
 =?utf-8?B?STQ5ekhEZnVJUjBScEZabjhUNHhKbHk5azJUK1NnU0dLelFlcXZ6SDY1T2hK?=
 =?utf-8?B?ZVV4bnJvTFBCSmZibWMxbkRqUnZ4R2JOWFIvbURVRnlGRHB0aXhPUnl6NHBF?=
 =?utf-8?B?NklicFhaWFU0d2RZYXNOSDJzajAvOEpoeUtCaHVNQmg2WGFIVkJZODBIN1ll?=
 =?utf-8?B?MlByVzkvbE1sK214aWV5OHlLaWpSMXB4ODg0N3dUc1hhTDRtQnRPYm4zODVU?=
 =?utf-8?B?ZGpCWm1JakhBOXIwVTNBMGFhN3ZNblBETWZrN25UcjBNRHdSL0sxT3p6YVJX?=
 =?utf-8?B?UGIrT2w3SGJzQ2VIMm1oQkcwSngyS2UxMjlyM0NpTmVjYy8xNE5ibjZsRWdI?=
 =?utf-8?B?UmQwNFNaL21VSnlqUUFrT09kNWJLbFhuSWVjUEw5NjJPM1ZZa2VUcEZBdldx?=
 =?utf-8?B?RFFMVXI1ZDdLcElvVVdPUDk4WGN2NHYxOHVvMGUzU2FLcDdVVVZOcGdvdGpE?=
 =?utf-8?B?RDNiUjMvUzB4S3VnV0kwY3BnMzUrVDVFTkkyVWlCV0J6VEZrNUlJNmdDRG84?=
 =?utf-8?B?T0UzTEpCZVB2WnczV2hRRnpnRUJibzdGdzA3TE9wQXNCTlZLV1ArYmp2R3pL?=
 =?utf-8?B?emx5K0pUejZ2bTluZzBXZXZWMloxc0FzWXJyOEVLaSt1TkE0TEJNYVdJd2pn?=
 =?utf-8?B?QXdubXdqc05tdzBPaVNoV0FWejFjWmVHVzArNkpwMlhJU0tqNXNDWXFXczNN?=
 =?utf-8?B?cW5kNWsvSGVtRG5iTGo0SERFeFFjRi9sZmh3VnBIOHh1b2RaWk5vN2xQMGpj?=
 =?utf-8?B?Z0VyY2Uvdzk4cERpZWRtNStsRi9xbmFlOWNqdE96RmkwZFMvSlVzMVdlMWFP?=
 =?utf-8?B?YlJCTXdTNHlNMHoxTjBybFNOYnYrZVlBeU9jam1ZTjlRdzdRd1JWNUVXYXVh?=
 =?utf-8?B?a3hJWm5KclAvYkkzRitMdDJrdkg1OE5WWHJGN2cwTk1meWhQZXY0UFMyMFNV?=
 =?utf-8?B?RVhUcVFWYjVGQTlWdkJnY2xrd1BMaGtKRmZMVC9nbGVHRDlqL0dGa1ovaHFG?=
 =?utf-8?B?eFJJMWhDT3RrUCszUkhMaFczOTFZaGZzOXNTR1ZXMG9CQldrZWhMRWN1c0hF?=
 =?utf-8?B?WE1TUUVTMURnUktmcXZ2UzZBMXdoNmxBOUdicDFwVTZqKzVzUE0vT1hkaGN3?=
 =?utf-8?B?eU85d0l0TGlsQVk5aW1PTzRkaFlaZUkvbDR3dFBVdEh0RWdxSE5OQXd4MkJG?=
 =?utf-8?B?WTR2dWg5a2xnbU8rS3ZVYk14eklVdXJnUDZyQ09pNXBYNjFyMjIxcEdEb1dP?=
 =?utf-8?B?WHArYnRvR01oajJUZWEyUXRyS0dqZXU0TjVjUTkwNTZTV2QvNUJPemFkNXRo?=
 =?utf-8?Q?cCn/Q50FuaLPeTsLdXw2XrG9+nMo5n16RjBtiEw?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbecbcb0-b604-4143-fec0-08d8cc69f1a4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 19:44:27.4377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OF0Hubr0aTb30c7Nrk3DXKv9hV8bSaij04BHfhDmA8Y1D7aaMk50RK8YgAeau2b2q1zNbBPgohl7yH4flIN3GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5040
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/4/2021 1:10 PM, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/crypto/caam/caampkc.c:199: warning: expecting prototype for from a given scatterlist(). Prototype was for caam_rsa_count_leading_zeros() instead
> 
> Cc: "Horia Geantă" <horia.geanta@nxp.com>
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
