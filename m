Return-Path: <SRS0=i+zF=BU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCD1C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Aug 2020 15:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A330422BF3
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Aug 2020 15:24:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="B7xtyZiB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgHJPYu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Aug 2020 11:24:50 -0400
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:7046
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728448AbgHJPYs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Aug 2020 11:24:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kURN34cZDQ5gRmK5iNgmEgo9HD2p8CqiXTDrYP4M9fA7jr+Dt+xH1b/A2Hu5JjP5jxcDxm5PdWYD56YbRsf9ImH0CjUsI6tVAAgl8WNtoGl9wxSsxK5i9N+HK7ZesS34KokVsd5WQHRa6zRbj96611dmv21L/RSFFM4vd04JSrNcuR75uwMRXKSP66blojRvTj9o/0AaiB12BmL9TWXUf5z04t8FqaS/EGF45AZs2mvUuWp6xKk1ug2IezQRugjjkukqZSV3mPXbkAZ3ZXCXoOopWPmrfjXSgzN0q4HXC3PXVxJbGeIUrLD1k1An9lCCc+vqgaD7oLXx7pyG/LssHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HvzZxaOGst5M4V8elg7uJ9zdqMATdgA16fbwdtCMhU=;
 b=QJkgr+fLiHZJ6hPI3z3qmDbgAEVpXvT04FKHKRoLerouhiErt7nlRbXrn3IsQCzgufwR7oCPp9fGDUBSj0zcjOfQvbM54q+JUg7RXXK18SyPiL1Ban9UmcmvjmqnvccqWe92w0QOc4z84JqkQoH/oYnvm+F8PYoQzCLQZRBXjkV5vm7la9sS2602QU2S0rshwVhXsiSB/2qPLJAygyAdmBU2gE6lnWANhURLcx7J9Baij3W979Y6jAH27t4imYbF4IFegxYXxkXZ30Ty6zxLSjQswaspyEIabOmGADKEt0ywUmd6Ugh0F5S+VYgX2e24yuDW8L+5ytrwjeFC1/fayA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HvzZxaOGst5M4V8elg7uJ9zdqMATdgA16fbwdtCMhU=;
 b=B7xtyZiBEtHX19mQgbTVfR1/ykcVx08OQQ8pkBjxiEHlikVKVxG3d7fvHgGxro0Z1EHexXmaj2WAcT0nbt89wR3UzJ/WvhfBtVHQEstUWL+Rr2HOtcGSvToGuhWrtwLymkcpnenZ97PUsIB3C27lsCHCb7EHK6q6nQLFNcad8vg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5710.eurprd04.prod.outlook.com (2603:10a6:803:df::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15; Mon, 10 Aug
 2020 15:24:44 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3261.024; Mon, 10 Aug 2020
 15:24:44 +0000
Subject: Re: [v3 PATCH 16/31] crypto: caam/qi2 - Set final_chunksize on chacha
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <20200728071746.GA22352@gondor.apana.org.au>
 <E1k0JtK-0006QL-VA@fornost.hmeau.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <787cfba6-e979-437b-d9b6-0afb6e6af1e1@nxp.com>
Date:   Mon, 10 Aug 2020 18:24:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <E1k0JtK-0006QL-VA@fornost.hmeau.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0020.eurprd03.prod.outlook.com
 (2603:10a6:208:14::33) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR03CA0020.eurprd03.prod.outlook.com (2603:10a6:208:14::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Mon, 10 Aug 2020 15:24:43 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8bf3e9c5-be86-4c58-9508-08d83d41826a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5710:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5710161039B792EF9733E05498440@VI1PR04MB5710.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6vAC9KFoxXXGHQdyzh8y7ZlMg4CXVf5lyk2m7NvH8nH7u5GKqFhPj1trN3GSMbwjHQAM1tKwG8UGRoUaJoxGPHu02n0KSZEVmnKuituVil7fp9zKd98nRziijrYwOOHtCXca0hIpAdvnQbGfMHFeziwzZxndA4a95oIb/AxDXBpEXmGk7XLKYSs/+m1pMlDApAiWl6CoLv8AFego4oDEtI/odSTY/EN62Ydpy0OTr8yAqCyTf+fxPuSQr0Nq35hJ6t3N5eLIZo3vD2cO33zlirWvqAzb2WPITqDD+uJxOcwllKRcZv4J2vj3MvOZR9ZZAuTjFrDEVOcR+ebvJAk3/wjn9G4sdxlPgkebuELvzHhh7VpE4qp62XLrwnvVhPmN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(8936002)(4744005)(31696002)(66946007)(8676002)(36756003)(66556008)(66476007)(31686004)(26005)(186003)(53546011)(5660300002)(16526019)(956004)(2616005)(52116002)(478600001)(2906002)(6486002)(110136005)(316002)(83380400001)(16576012)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZRq3e17+ZMtKlyEQR3AEJh74KY1Ea8R8gCW++1Dj6Uw+pw8b+bsCI0wARwbrSf4tVW1+IXw3G3TBobBR0d96Hx25urAygqXN0r2Gm1R2b/ffWR08jLoqdllX4gwt2n2h7smWpjSZdpTbAChaOzVTb4vBvyXPDsr2VO5adX5ZevQulJ6c5uBck/NfuzFxBooKm1I/03qKO8BrovP4uzgW0IeazPZuRbgMKUPEhO+yJFmV6PwMO8wjjtJzE8R070QjZGhRvzxNFQZZEcZ6iMQUVesOyqf/VEfteTnP1oYluuHh7xGrWeM0SDOxyWD5dAc5ZlJIavhyfFyHq+E+UywJ/XW8YH8EH7rIBLrRyjElYlMMzz3gUJPJRLxUFqftGExp3j3maY7ZO4k6QLp0C+6m8iH39ooFwm2Ys5BIdDJniqn4QCO4OnCEM/jsZ28GetjRvifgCX+hFtTR0KIPP+8gdAH99GuUXkS99HfVRbEBkQ12MQDlexZrLUpZ74DMtoSby7xAqJaszbK4DNtTd/+oFQr9oUtNSuy+opyWmF905qI9b/IIU8jD2Z3qoSwJ/s45Rsrw12vlMeokvvmwzXCOIyEFNCIW1yonR7lliZ4n4wLylZwYPp0j5fttQV75oyDCLRu7j9FPthPbLssVpFvaCg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf3e9c5-be86-4c58-9508-08d83d41826a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2020 15:24:44.6175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oj0XfNg3b7H9XK2RZy7yNbZccNfNPR2BKGTyVHzpDsHc+2o9R+srVvMMK1RiTwYTHym10zDaGiByNCBSFdMYOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5710
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/28/2020 10:19 AM, Herbert Xu wrote:
> The chacha implementation in caam/qi2 does not support partial
> operation and therefore this patch sets its final_chunksize to -1
> to mark this fact.
> 
> This patch also sets the chunksize to the chacha block size.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
