Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F318BC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jan 2022 15:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379551AbiAaPaO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Jan 2022 10:30:14 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:23829 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235828AbiAaPaN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jan 2022 10:30:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1643643011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2O/gu1ZgGkEUL06mhaKOTJgAnLdtCjDIZhPKhSgLpu4=;
        b=RK+qL7sJN9ExrqnT2T1uJ4hshiU2IiIIep5QXMSI1UHY4iyvYeytjoN8BWjk6Ed20TzuF/
        EFvujTkwrOshkrhjql/gywGWup0RbcmDABk7yxhLH/2PZLZRXqfYTYzLhBJCPI9lF+Gjmn
        Fk39QGNZ3aCi/WXeEATqjAoyGhlSsPE=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2170.outbound.protection.outlook.com [104.47.17.170]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-12-F-YaXtGTPIKRmuu7a4EEnw-1; Mon, 31 Jan 2022 16:30:10 +0100
X-MC-Unique: F-YaXtGTPIKRmuu7a4EEnw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dST6BGT3nFAB8puRbKLfB+8jrDGVx2ByPEMFyOZJbwjNe66zkWRI28U8Voyc8iOzo1V7b6pjSNyB+0B8zFaY/wLmX3mjVS8Sv62s5KdKzdPAyympdttb53gPOHqyqCca0SI/SZaPnMFUKcANijufRMSkrAMt50u7Ip6Qgaoj3rIz81p6E6moXgsElkitQgx8P5GlC5qZlkczKuflpbNLY6MhvBVj6axw0c3slA1pwOkujDohEnXi6+aE58RdbW5bAtU0xloVStWDAbDOlvehy4/ptk5yliys4bcVldrFRseSI0knxLm6lYxqOrFrdtgA0Vednk0QglXKlqkDjiebUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2O/gu1ZgGkEUL06mhaKOTJgAnLdtCjDIZhPKhSgLpu4=;
 b=PRCdNy+L8AQc2f3nqR/FM5b6gx+QyhbKonHkb3OAsglSgxkaUQe/bbT0mAUAw4mAq00OrSs8G5QkyCz78F838IYcuzrB+y+/9fBB8HQ0JhC6pEU5UNOOArNqDqqhyRnaSILV7UFBWv1o8XTJaxxCksJZfn3ghwwQHqoWunFIw8MkDlT6ZPKFziLoGKb94o0ge3jRDEZoVwVSGaUu2e5MAJQHXPBZc9KH6KyXkfdTm9Ikns6LF04AaZqb+Y9acivIOVuU4EyEJugVf7h6DfEyKtGx7Qxcrcj3BG6lEegS70b8Ej5BqjZXa5BggheTqJQ5nSXiqlsIL2v0aMljKSnb/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by AM9PR04MB8273.eurprd04.prod.outlook.com (2603:10a6:20b:3e5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21; Mon, 31 Jan
 2022 15:30:09 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::7cc2:78a3:4d40:9d45]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::7cc2:78a3:4d40:9d45%6]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 15:30:09 +0000
Message-ID: <83208d0b-cbe0-8ca9-195c-ee1673f08573@suse.com>
Date:   Mon, 31 Jan 2022 16:30:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
From:   Jan Beulich <jbeulich@suse.com>
Subject: your patch "crypto: api - Fix built-in testing dependency failures"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR01CA0069.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::46) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0892df4-f280-444b-fd61-08d9e4ce906b
X-MS-TrafficTypeDiagnostic: AM9PR04MB8273:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB827330D9F42DBFD3E8D0CD46B3259@AM9PR04MB8273.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kzIJIRqaMvfLIG5RWvlzvxsLMj084g/bvKPIJU8NJc6zcEFPMlQuslaNx3Nt8h0M5c1to2YZPKoV7RcWfmgO/z6TByC9UGgL52QqsPferfqpXAlsrG2DyJK2aacafdx3ucmBKDOEV5gbHCej7VCk+tThgKrYbYGpPMe4BrNCh6fxYT85ZgkwEv2On/QzCo67BstpGjyF2pEPpBV2SoEv2r/bT/y+W8jh4HS9PVaEgGyVtob4IM4cFXmLF4GcB0Fn33GISuAkYnYtjgxqE8MQ1vB4bFWXoP+JH8f84ChGl9qZ3KBZ8Drot5TH8ljgwCHprLVQPvFbdn+NfRs++fYm8HP7wKJI3p9Q9l5YlIRNvspFc6XDu+WtHDg2c08y8TjswPJIP/PH/3gnJmIb/JBD9pOww2RSdx5VQA6uoQcp+3OBuV6drYpu52KhncA74TnbAfddUHYkt8bhZgLGn1FELkjKCyc4mvoA14Vby0iqzeTme+C0HqNrRZ2+d4PZAT5Fu1/dHkII0lUPwY5ehAD2p+mfV4KgOV7W7GQDd9YSCZX8EDrX4gRe9fBYm/1F2doYKsKgNGrR4ec68aQJH6eIsLBruHcDlSzlBC37sJwEaj9WwxSu/gyyTEnlsctqFxyYimKgNd0u40MyP8hJ3K52nHRtJDIXvTOFVOPJDTcY7YspsKrT71w1tyXmXNXbQ6B8aRo1PdkVCIHDhiX0AR7C/v82VCwfUBnkesp1BzMdlc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4744005)(86362001)(83380400001)(8676002)(36756003)(5660300002)(66946007)(2616005)(316002)(31686004)(2906002)(66556008)(6916009)(4326008)(8936002)(66476007)(6512007)(31696002)(6506007)(6666004)(6486002)(38100700002)(26005)(186003)(508600001)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXNYVWNFVm9uU09sYXBMUlBCSEMrZzlldzRPejdPVlNnRnNycWpxRWR4WUUr?=
 =?utf-8?B?QzZhN3ROSVExMng0VUhVZHBuSG5DR3AvbzF3TUc5d3VzWXkwbXVQK2pQNERk?=
 =?utf-8?B?VjZGdWFnWnB0V3k3TE1jSWU5TXNLcnRtRVkwTVpDc2d0U04yK1VIT1NsdWNT?=
 =?utf-8?B?Q1BMQ0VURy9BNmRyS09hazJMMjdVSjlsRm9uU3oyWlJVYzJRQ0xTczI0S3ZD?=
 =?utf-8?B?WGlUUHpQZFNtZDJyZnlPbnh6cjFvVVhoaTc0WEM2RStjd2h3TU05aHQyNDBn?=
 =?utf-8?B?RTlBdDNrZldqa0RidHoydUdRbXd6djI1TTBnUkdNMGZKRXBSRWZWVjFCbGVX?=
 =?utf-8?B?MVNKSkJXWU5PUGlOMGl4Y244ZllTcDkwMGdaM05JYkZRTjFWM2cxTkpWU2Qv?=
 =?utf-8?B?T3JmUWMyWTNQa3ZESlpSZlVYZnJ4K0VUTzU1VUJxTXk1eEo5U1VIemxmOHR5?=
 =?utf-8?B?UmFKbEhZUnFoblljRmpVTTkwcFNBVWRjVFhKVEVmM1dmN0czWHJTbVBEa1hk?=
 =?utf-8?B?bWZ2MlBIbmxYMVVqNVNvRWNXMlh3N0s3K1loenN5c05taHc0bURueE1DaEtH?=
 =?utf-8?B?THFIVXE4K3ByNnNtaC9heGpxYUdkS3hMZ1cvb0Jhb0hya1RjVmhqQUd1SWlD?=
 =?utf-8?B?MVc1Z0lRNUs3WkRSVFd0NkxLRmF1Rjh6Sm1pWktab3hZejhIRUhTR0RJWGkz?=
 =?utf-8?B?TkZpZS9lMjNZUFRpRUlUR3RmYktaOE5XaTRpYnBDbFJ5NUFybW13S3lzWC92?=
 =?utf-8?B?aWZzUXhpL3RZclMvTUxOMlVqQzJNbXFXa1RmeWI3ZHpnYXMzcE01a1QzT2E4?=
 =?utf-8?B?RUd5YlBWOVB2aWZlNXdIOXpNZGxpMXV3aXRoTzZQbkdlUWtsRU4xNjllNC9E?=
 =?utf-8?B?VVFIbkRsakw1NUZJOUxKcDZnT25yL2ROMjV5eUJ0cUtQcGpWYjBjSS9tWGZK?=
 =?utf-8?B?NnAyeTQ0clc4VkIrNWFyY1BmU01RTUZpSVU5SFB1UWZwNGx5Q01qSy9hNTR4?=
 =?utf-8?B?SzEzalJ2MlFGOEc5ZXFFeW81Q2ZSQXNOc2RJZ0EzakpkMGtCUXdDZjZ6dXlX?=
 =?utf-8?B?b053cmZRbWVKU1RkVS9OTFc4aFBUWnVDRDFVRkNsQ2pmK3pKRUM4WEpPU1lU?=
 =?utf-8?B?L2dNc0NFMjg4NFRhSDJxalBDWmVQVHBkM2xEN1prdmFnSjZEK3dmNWxtZlpv?=
 =?utf-8?B?aWZHb0hjeDBvNzh2N1pKTGlxakV5R3ZNQkgrbGlGMnVVSjgxMEJGWGtoV1p6?=
 =?utf-8?B?M2U3elRXVnBJcFkvczR3ZG9xSGFsVkorTGorOHZPTFJtSGZhWmtTMENtTUts?=
 =?utf-8?B?bTlqYUVJU2VIYTgreVlaZFZjUld5SWNhUHNNb3VaUUFtV2FZL1Q5QUFpQUZP?=
 =?utf-8?B?cWl5MlJFeWtQUDVJcXBhVmpkc05zb3J1SlEwd0k1dlRTcjZYYXpycVJoQjJB?=
 =?utf-8?B?ZVNxYSs1UEtNZ0l1ZTVPUEswU0ZFVzlaY1k0RjFtT3ArbzdGSnVXSkVjeFFn?=
 =?utf-8?B?bjc4MGNDWWw4MHdFV3hXdS9ZT3VHZkpJblB5VDU1STFwTUdmdWU5M0pQaDVG?=
 =?utf-8?B?N0VqRzcvUTVxb2xqMVNLeTY5V0tyMjFFQnhRZW1kT0pVcTkxVWlmRkVzUWhp?=
 =?utf-8?B?elRJYThFczJiMG1XbGFsQy9jdUI2bWIxbXFlUlJ0ZUlySU1BMy9DbnRQRWNv?=
 =?utf-8?B?SVVQT2c5ZG9sL2x4b3JESDFzTytDWkFoNVdienV0eDB0Qk5WRXN4WlFkaHZw?=
 =?utf-8?B?cUpWOWZ4ZU92a3BZUmhkY1JrZEZnRDJVaG1zVkROWWhJRCsxMW5TUW9icEpC?=
 =?utf-8?B?TzZXa0hocGVYa0s5S1RNem9QYklLUzdpNDVxMVVJbjJuY3ZWd21VNGhydUNQ?=
 =?utf-8?B?bmkvQnU0OHlHS29zK25KdWFxcTlxLzF2KzBVcWlxdGwvMmRiY1hyZWVPTmdF?=
 =?utf-8?B?Q01YaHl3Slo2bGlEZWdKbmFxam9ReHAxdS9YMjYxakU3TnN5NkUzNk1Sdkwv?=
 =?utf-8?B?RytOcXAxYjRZS2xCYXM3aWhmUmZUYUx2TUpMOVk0MHRkREJJUHBtMEQrREdK?=
 =?utf-8?B?eFUzZk5leFJXS3haWkc0ekYyekpQanJwem5MMnc1L1RHVkZkNHl0ejJVTkw4?=
 =?utf-8?B?Slh4SVF1TXgwRnllc1YvaVduWGUvalBVOXA4MmpSR0U2Y0lrR0JkakNtQjN4?=
 =?utf-8?Q?Ll9lZwuSW2Yi6M4cHN1jXck=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0892df4-f280-444b-fd61-08d9e4ce906b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 15:30:08.9996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z0BbZ82ILYKaFuNf/ZGF1szVNhqHsI6W0HIyYK3PD7I08PQLZ6Y/jN6FYarmgQBDXMWbqMUVz9NMIlEnAunlXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8273
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

unexpectedly after updating to 5.16 on one of my systems (the 1st one
I tried) btrfs.ko would not load anymore. Since this did happen before,
I inspected module dependencies, but they were all fine. Nevertheless
it was libcrc32c.ko which actually failed to load, but the error
("Accessing a corrupted shared library") wasn't very helpful. Until I
spotted crypto_alg_lookup(), and "only" a few steps I found this commit
of yours. The problem, ultimately, is that all of the sudden
cryptomgr.ko needs to be available in initrd. Without any module having
a dependency on it, it wouldn't get pulled in automatically. And there
was no need for it before (until later in the boot process, when / was
already mounted).

Can this be addressed in some way, i.e. is there a way to re-work your
change to remove the dependency again?

Thanks, Jan

