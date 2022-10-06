Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1274C433FE
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Oct 2022 11:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJFLu3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Oct 2022 07:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiJFLu1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Oct 2022 07:50:27 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC431FCDA
        for <linux-crypto@vger.kernel.org>; Thu,  6 Oct 2022 04:50:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FLSXSTI9V2OGa6ynCbG48cx/oD6GA+z/o6f0pYW0sfrZV6lI0RWRfTmfBoNJutwzymUdPbY94kFku6SItyMXzjrP8sPYQ7JUhleqfzpGwXclTRTlXIlGa/lnz2poy4CplzySwksMyQ1vMRbiqLz6/SIgefRhHeltg4daM/bCgrtRJa7F1e3soHOvw+ZSfWKRgeDKhufQ1VXmb5ugdUFEpYgNdbhXo4gM+9dljsGY3BE1rHObWOHk3cy+SF4lMGUaCqB9PHvuJybveU7EeSW6Zo0WeJNBh3QPHwsLKXAVnNnbQdlQLJH5l2qfNkq+VShlFgO9mk1lGCjw86fVEVK6NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJv+auXzciQDSN6yi4/Yt4CMZW7vVJE/yJX/gBX08bM=;
 b=becSln8DNyQ/jyU8hj1UqMXBlbjVZNDJX2ONwtCT+nZnx3oJiA3/K78LlsX6EiltezVUzhJ8pwKzpmbdLcv8cTogLfNVsElwpicJkIDneR/xtPOJujaHr9Dw0rtcqbgpyOKqB9Q+K1n6Ec9C0LxYiNnK7nVFJU41HDh2+wrjq4MgnrCP89nG8f3ghR4IEImOKrNTMqxJWyV1f/dVnBtcZG6J9RIPdPN2Z2ZOhQxtUr0BPPot3rIF6UEk7HjGfo7/1Eq2JPONbS9/dkyyKq4fipkpexXV6IjFKlrI8En7ljJRSsa5CySiAtVo7ihWlqraOye6HicdYtuffgKMD75w8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJv+auXzciQDSN6yi4/Yt4CMZW7vVJE/yJX/gBX08bM=;
 b=BnJ3NXIEpKHfMBh85UaVzxKWrwtRb1IW517hsUTkqe99q1cGio07c7oNQOqR0mc0zUruLzeFXIFU0nNIJamJCnIAPfczSL7OIam3eI7wt8OAW2jiABWOV6x3MWvQVoNrMapgnySxwJf/e/96l/57f5gQUBgrPd73Ic9pvs3GI3M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ0PR12MB6927.namprd12.prod.outlook.com (2603:10b6:a03:483::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 11:50:23 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::e0fb:6f05:f125:c002]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::e0fb:6f05:f125:c002%3]) with mapi id 15.20.5676.028; Thu, 6 Oct 2022
 11:50:23 +0000
Message-ID: <c71529ed-5937-b50f-4804-566b03748fac@amd.com>
Date:   Thu, 6 Oct 2022 17:20:13 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Early init for few crypto modules for Secure Guests
Content-Language: en-US
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>, ketanch@iitk.ac.in
References: <c6fb9b25-a4b6-2e4a-2dd1-63adda055a49@amd.com>
 <CAMj1kXF2sfsXhE9dq5b77nnzHEZHkMa+b2VUCCw7gtRL6mEwEw@mail.gmail.com>
 <CAMj1kXGzKO8=F2RzFBObPYb7J-hSj-esHJ8oCC-1fsV-B028EQ@mail.gmail.com>
 <a9ea7eac-0fa4-63dd-42ad-87109c8fe0e4@amd.com>
 <CAMj1kXHDbnNWb23eXMie1hQaDmX3nR2261eKXbMPW-c9sWRSsg@mail.gmail.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAMj1kXHDbnNWb23eXMie1hQaDmX3nR2261eKXbMPW-c9sWRSsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0207.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::18) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ0PR12MB6927:EE_
X-MS-Office365-Filtering-Correlation-Id: d34e353a-e7f7-4e83-e856-08daa790f37a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rjZpUGtRI+eIsnMYOGOtwYcDJoTTPHxUK1TZCxHLqEaa4CGbaums1jmkBnMmKTgZaCym8Ut4Hp7YQpB7tKoH0gFPn56UshUmh+diKlDd2M/znR8ZxCM0aZ0hUb41cB07n7pwjsB/oG39bIqRM+/xsLI86+i+d3v+5WIiEmfTUzcs9X1rOtHVpHggZli9ht/EOWyAaqlVFsTpdyJkIArzAIebdRGo85+5LmQdiFyowFab80vKsGkCR5ZXe078Kds3rZFd1c3km9pauwEt/E8iaSwufo2EpI5hn9kpy8f9viMF8Hzz4FNmBKCryRhMz/Gggxq3rQZESv5nlAYhxt3ERgOgulvUdEavKiQSaBHwLVOxG2W5VDTQ/TvwHt+X9qmrSLJJUpFgL5xX1Gt7RAgA04Ll8v3RiogTm/6tIuw7Ff9DKpeMMHEcouq7+kpx+yy6VzbnKR8nTJPyJf572nInWxETDvS58UfdDLmKtZn1VvitcZoFuTz1JGGx9V82RDAJYiQJmHmwLHmxKOd682goC9rO3pjExF1hAcBkFJZv6ho+S2yfoFBkTgw3bbYVUxqXonz1tUMh7JzSX7CxfzCIIlYSin6KK7tOniREQzlYQSrcL78vyx2R7UrX7ta/MsIZE8FWWduDPrkL2Pb7C5mEcuC6Ktf1UNySlODO5k26BcQvmRsXXOX1iCxHLuVL5SZTuuRrnx0gSX9KgoS+VbumQP8Zz51O2sJqelMjSF4OoFG1pSdFQlArToYwlTcvz7UMpQiYVCWoU444Jk48UsQX8Mn0j3pIEQsgdQiqcd1umvGt2ZhAec03S7vLZbqAWmPmNLSU7hUTEFm+aaRjLvzKXF+/aqkCUBLoJJJvGpktdsM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199015)(36756003)(41300700001)(31686004)(2616005)(186003)(8936002)(6512007)(31696002)(53546011)(26005)(8676002)(4326008)(5660300002)(6666004)(6506007)(38100700002)(2906002)(83380400001)(6916009)(66556008)(478600001)(66476007)(966005)(316002)(6486002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDU2U3RmR0pRTjAwWEJ1eW9Wa0hTa3lvb0tFTHBpQUdmenB5Z1A1aTJ4Rm5L?=
 =?utf-8?B?VFYyMzZhbGdyaW5GbTlHK3ZVMHFTeXlMTGpGT1p0OExtQUdZRmJvSWFVYU9T?=
 =?utf-8?B?NldCL2ttelRQMTNsdUx3ampzK2M2Q2ZkS29BY0Y5dkJjTDJuQTZIOFRHYVFL?=
 =?utf-8?B?dlFkMEZ2TUNjUzJDMGJXR1J0NnQ3OVdlcnJuMzhGNnRydVhicUlXQllMbDVx?=
 =?utf-8?B?MXg5aWFWdlN6cjNBaVlIQkpXcWNYa21VT28zSGdJZ05CenNHNE1ZWDF0VDh2?=
 =?utf-8?B?RXJ0N0pwTm5XOC9zeEQxNEpCNmd3MkhaVXF0VTgxZ0pIZTZ5TnZ0NmRDRW5p?=
 =?utf-8?B?VWo4UUpnck1TWEtDZUJ2ME1GOU9KRWRNQTVQNXREejAzM2ltY3k2dm1YNEtr?=
 =?utf-8?B?TTU2MjVUbGpPcDB6MHIxa1ZSN3RaMk45REk3YjlLb3cxcG1BT2g2YVdFWnRo?=
 =?utf-8?B?VHlxS0lpUEEyWHU0Yzd2SC9ZVXZ2MkpLc3pLT1Nha3EvdUltNEJlWVNkTVpD?=
 =?utf-8?B?Zm94a0hVbkhJMElCT1VjN0dFQUJ2SWw1NWFSV2FnSUYvZFptSGlrdDI1d3ZY?=
 =?utf-8?B?T0h6TzhUYk1KQWZURHZOSThzRGg2clU2Y1EvdlNqSmZEUVIwV21DL1J6aCs3?=
 =?utf-8?B?NWgySGdMSGI0NXZXWDMwWU9jZGJaRlJYb1VVMEExMk5WT011SGloYWZGRFRT?=
 =?utf-8?B?TnliaUNkWk1LUmRUS2VLUlk1cWFqT0w5UXBjVzNTN2VFaXJtY05uU3c5UE1h?=
 =?utf-8?B?MGNHSE9uaER3WjRTSGxQNzlFRFJGdXJnbVNzeitVVkhId0V0UUNwUXM5WVF4?=
 =?utf-8?B?R2xhK3Avbk5YdThLaVo5dWtkeVh1WTd0cFM3UWFCNDk3T2J1TmZRRmtpaGVN?=
 =?utf-8?B?MHh5UGxxdE5LdTFpUVZ1UDlQeVR3OGE2RmN5dFZCQVlGMlA4cDB6N3Z0SzFj?=
 =?utf-8?B?ZlovZjhTcHBWZHBOK3BONWNVMjJaN2ZTbUtCbUh3K045d0Qxa3dSTjcvbGkr?=
 =?utf-8?B?VVlwS0VEWEw4K2hlei9SUGxoazlSYlAvRWZKNDBRNVlpZHZXRkJJVWlZdzF4?=
 =?utf-8?B?WWU3YUNpWDBSM3BmODYxZ2F5YTFuaERFSFhmeXdtWFlLdXpueTZ5Z2Nla1ZW?=
 =?utf-8?B?anllLzJwbmVMbERUaGJhdDB5OW45dFdSUzY2bjFNVjJ1RTltYk9OdVNXa2Q3?=
 =?utf-8?B?Um1tNitOakZzZTBGQ3FFZ0JudE9ZNXM2c0FrQlNGTHovaGduR3lWQlhXd2ZT?=
 =?utf-8?B?MkZvdEZlbFZCMzQ0Rk01NzQrY3hhYmtOdTBjRWRsaFFZQkJpcHBOdWtOK0Jj?=
 =?utf-8?B?aDJXakRDTXhDalpZdk4vT3JyUE5SVVRZRSswdlE1T1UrZTJueVdjZEsyZGF6?=
 =?utf-8?B?R2xBN283aHNaMnB2a0w4RXdvZVg4WTlCYVV1UDc2cFVkMmtyU2tUOVJuK1RF?=
 =?utf-8?B?RDVPQU1ONURkMENwbVEwaXkzTWxOd3BlRTV4SVJ5VTlrZ1FsY3JNc1h6Mncy?=
 =?utf-8?B?ZWMvelp4cXdKbFBxWUhBclR2VnlnUXJ6V1gzQXpha25nb3pmc0piMnp5b3lT?=
 =?utf-8?B?dkUwdjE4OWhNZW5xVzVVRmthYzlHYXZtMDMvQ2JJRHdKK3IzdjhSVkhhakc1?=
 =?utf-8?B?Uy9ZUHRWUWh0S0hrRFI4a3lKb3d1SGNCMFh4NE80dmRTeFd3b3hKV2ZiNjdy?=
 =?utf-8?B?VG5vNUpVaCtMVVJQL0YzK2tHaEtOQmQvQkNxei9wRUFuTmNCRGdMZVU1U0c0?=
 =?utf-8?B?NXNkb3laNllMRytXY3lwZ0pkNTdDL2dMRGdMZUI4bXptYzBQaTZ2b0piQ2lZ?=
 =?utf-8?B?OFdkQXc0UFVjLzkwN2IwUXBVQzFaWW1YQkR3LzZNZDVIbzFnQ3NIaEw1ZXJ3?=
 =?utf-8?B?YTdpVlJiVVFSV0QvclZNUmd4WkpKYXQ1US9VR0hhZDdPZlpDZjRFSVFjZHlO?=
 =?utf-8?B?T1laTC9TQ3VzTHJzb3FIcjl3STlyMWQ1U3IwaHF1TUswdURiRlR4RFFjampL?=
 =?utf-8?B?d1hnS1BTRkpUUVEraGlPbkg1N2tSWnZxVTA4NTd0NC83bVBhNzl2NVBwY2Jx?=
 =?utf-8?B?V2d2ZlV0OG8vY08rbldBS2RHcFNjRTJKWGptSjZuTE5qNUdnV05TN1hhcGVM?=
 =?utf-8?Q?pyrFsy+IWz542drxQrZrhWBh/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d34e353a-e7f7-4e83-e856-08daa790f37a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 11:50:22.9956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfY5ycrHpoG4AFBs4cYUdq2VCg1o5BbQ43MD0Wx4shcdkGs4tsvYk7SW0POtThzetbC52wPeCmc4m7lAryQH1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6927
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 04/10/22 22:47, Ard Biesheuvel wrote:
> On Tue, 4 Oct 2022 at 11:51, Nikunj A. Dadhania <nikunj@amd.com> wrote:
>>
>>> AES in GCM mode seems like a
>>> thing that we might be able to add to the crypto library API without
>>> much hassle (which already has a minimal implementation of AES)
>>
>> That will be great !
>>
> 
> Try this branch and see if it works for you
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=libgcm

Thanks Ard, I had to make few changes to the api to get it working for my usecase.
The ghash is store/retrieved from the AUTHTAG field of message header as per 
"Table 97. Message Header Format" in the SNP ABI document: 
https://www.amd.com/system/files/TechDocs/56860.pdf

Below are the changes I had made in my tree.

---

diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h
index bab85df6df7a..838d1b4e25c3 100644
--- a/include/crypto/gcm.h
+++ b/include/crypto/gcm.h
@@ -74,9 +74,11 @@ int gcm_setkey(struct gcm_ctx *ctx, const u8 *key,
               unsigned int keysize, unsigned int authsize);
 
 void gcm_encrypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
-                int src_len, const u8 *assoc, int assoc_len, const u8 *iv);
+                int src_len, const u8 *assoc, int assoc_len, const u8 *iv,
+                u8 *authtag);
 
 int gcm_decrypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
-               int src_len, const u8 *assoc, int assoc_len, const u8 *iv);
+               int src_len, const u8 *assoc, int assoc_len, const u8 *iv,
+               u8 *authtag);
 
 #endif
diff --git a/lib/crypto/gcm.c b/lib/crypto/gcm.c
index d80e430505ee..34c86b2ea2aa 100644
--- a/lib/crypto/gcm.c
+++ b/lib/crypto/gcm.c
@@ -30,7 +30,7 @@ int gcm_setkey(struct gcm_ctx *ctx, const u8 *key,
 
 static int gcm_crypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
                     int crypt_len, const u8 *assoc, int assoc_len,
-                    const u8 *iv, bool encrypt)
+                    const u8 *iv, bool encrypt, u8 *authtag)
 {
        be128 tail = { cpu_to_be64(assoc_len * 8), cpu_to_be64(crypt_len * 8) };
        u8 ctr[AES_BLOCK_SIZE], buf[AES_BLOCK_SIZE];
@@ -76,8 +76,8 @@ static int gcm_crypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
        put_unaligned_be32(1, ctr + GCM_AES_IV_SIZE);
        aes_encrypt(&ctx->aes_ctx, buf, ctr);
 
-       crypto_xor_cpy(encrypt ? dst : buf, buf, (u8 *)&ghash, ctx->authsize);
-       if (!encrypt && crypto_memneq(src, buf, ctx->authsize))
+       crypto_xor_cpy(encrypt ? authtag : buf, buf, (u8 *)&ghash, ctx->authsize);
+       if (!encrypt && crypto_memneq(authtag, buf, ctx->authsize))
                ret = -EBADMSG;
 
        memzero_explicit(&ghash, sizeof(ghash));
@@ -87,16 +87,18 @@ static int gcm_crypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
 }
 
 void gcm_encrypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
-                int src_len, const u8 *assoc, int assoc_len, const u8 *iv)
+                int src_len, const u8 *assoc, int assoc_len, const u8 *iv,
+                u8 *authtag)
 {
-       gcm_crypt(ctx, dst, src, src_len, assoc, assoc_len, iv, true);
+       gcm_crypt(ctx, dst, src, src_len, assoc, assoc_len, iv, true, authtag);
 }
 
 int gcm_decrypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
-               int src_len, const u8 *assoc, int assoc_len, const u8 *iv)
+               int src_len, const u8 *assoc, int assoc_len, const u8 *iv,
+               u8 *authtag)
 {
        return gcm_crypt(ctx, dst, src, src_len - ctx->authsize, assoc,
-                        assoc_len, iv, false);
+                        assoc_len, iv, false, authtag);
 }

