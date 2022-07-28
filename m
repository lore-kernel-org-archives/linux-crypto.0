Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD16C04A68
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jul 2022 10:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbiG1KaB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jul 2022 06:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbiG1KaA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jul 2022 06:30:00 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2082.outbound.protection.outlook.com [40.107.22.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7723550193
        for <linux-crypto@vger.kernel.org>; Thu, 28 Jul 2022 03:29:59 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=d3UblK3jFoD+c2XuIm7BLQtnPCZJnPrhsT62E4+fZPiQnxzXbW063mtKBnYOifoNeZQWX2KvmS1a4tcbfujYjUSUaber19BtuLO0rWdtCvLRyV3qHIc83uB+yJY7uebdSfvDiiu254Zx/m3otY4j1MYw8EXD4GcMj1cdGtYgwo5NDHFWp4u3NLT5CuuaHfqW6MKIV2oEVm3U87GEtCcRwEwIXtaUae7OKPPfPnIkHrussKPUW/FDsKi9ovNdCPSimSATB7WumPfpLTw6IMvEGA3b26KsfI9+3D8E50b+2UKJz5j6WQkgutV2Jg0jkH4+MWf61NhaTv70XOAvhTBHIw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4OrEKv3qWI2YbDZz6XeRrWYkCjGYkfNO7FrfrW3WMc=;
 b=lE3T2KF3KYtwgL3qyiMacshcW39g3/mTAeWzcWO7HrZoG0xo7DblXHvhIHkA8xEdkfGAfrisOl9/zdpyvk7hqiaRtJ19byY0tUMrP9c0e2xhBwA2n8MCb4GbQi+kmGfzGv0gQXk67tDzlokeF9Ll8v+bkmcRTG61Sr8+vTXe2H4MWLP/BxA2z5ESg+U2HMZS4ZzjK9phi+BwSpB01Xiwk5FS7z5WNuqdHgJsbkJ9ZDEU6QHuxjcMa7BZ91lnVSt2yrxsSWykpry3SJPebAHcxirdVWTQxdJ1fl7cpw19gQuSX/BMyvjzapEuonq4SxenGjjVZcdP5bPSW0lsVKmL1A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4OrEKv3qWI2YbDZz6XeRrWYkCjGYkfNO7FrfrW3WMc=;
 b=u3qFYRzUP48AuOHA0UBXJ7qa3ZwYFY6PlrdzXJJs2gXYFcIOLtk6DByShnTdtJ+yZy1x1PTYV8HeJkgNTP735IrIJUDKkKJZ/KAw3uMG3FO0/txU9DJ0zp1nWaihA+G1Y4vH0VrjXTzv90sg4nLzvUiH+ujnF7qoFeyIg7/sNZI=
Received: from DB3PR08CA0022.eurprd08.prod.outlook.com (2603:10a6:8::35) by
 VI1PR08MB4189.eurprd08.prod.outlook.com (2603:10a6:803:e7::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.24; Thu, 28 Jul 2022 10:29:54 +0000
Received: from DBAEUR03FT020.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:8:0:cafe::5c) by DB3PR08CA0022.outlook.office365.com
 (2603:10a6:8::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10 via Frontend
 Transport; Thu, 28 Jul 2022 10:29:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT020.mail.protection.outlook.com (100.127.143.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.12 via Frontend Transport; Thu, 28 Jul 2022 10:29:53 +0000
Received: ("Tessian outbound 63c09d5d38ac:v123"); Thu, 28 Jul 2022 10:29:53 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 1312df54fcc20e4a
X-CR-MTA-TID: 64aa7808
Received: from 02a9e35fa645.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 52054CF8-B435-464A-92E0-EE42D829CD5F.1;
        Thu, 28 Jul 2022 10:29:46 +0000
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 02a9e35fa645.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 28 Jul 2022 10:29:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWQivCAjkJXbEELZxqakjvbRhfeIDZe3ThDCs79iC2C8CQyDhjG2j10gcb1p9Ve8/fkBqRaIAhQpCiX9bY105EhACxLghB79TZIXXiuhnzn5ejLWYtbe2qPd0YmvVlNMJ1mFI3NUComLHyEkIfOOYbDpxTzP51E3B1MVep8Zy4rAE/UVD7JBHmTEPvUiT+ef94ji6dmlAC0jaX5VN0pkmt+otTt2oWGFyQScc8Sf9hHw0poDnm53xSySpj6iFIhAkorQSgnx32E6Myh19XdfIDSjBMgQwA5MJFUKjmjQ+/jD14QWU6GMUVklToUAEf/nOW+yHz9CoghmUBSXuyiP+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4OrEKv3qWI2YbDZz6XeRrWYkCjGYkfNO7FrfrW3WMc=;
 b=Iauzxrd2W8triFZbEHWQ12Utdhvxo1jH85nFQS9C5RF6dU5HUfZS7CVwegjNqsus+dllYTAaVNK7sZoEcnNuJCEl1IGWL7oRbYXiI9IE7QDbV15aGuisaKS8sxzoiQndApj4lS7DEvAIRGr5yrwjLmMkAfE49JDQ2Ms4TEIDx67ilDcmkxSJ+Fg8KHeYG1mTGyf6Q/ABkrpX6ySW0cVoEGZTkHCyRPLRsKYsNk/m1on4w2V+Mioqy5T1vT1B1iy/lD46IMccDoK+eSYPtru8BeLzXrNBt4zlL7d/3j6PJAmvfNLPUwXaMq/CsHtZkYbNN4aQCR320B9hFHkdZUf1/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4OrEKv3qWI2YbDZz6XeRrWYkCjGYkfNO7FrfrW3WMc=;
 b=u3qFYRzUP48AuOHA0UBXJ7qa3ZwYFY6PlrdzXJJs2gXYFcIOLtk6DByShnTdtJ+yZy1x1PTYV8HeJkgNTP735IrIJUDKkKJZ/KAw3uMG3FO0/txU9DJ0zp1nWaihA+G1Y4vH0VrjXTzv90sg4nLzvUiH+ujnF7qoFeyIg7/sNZI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by AM9PR08MB6292.eurprd08.prod.outlook.com (2603:10a6:20b:2d8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 10:29:44 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7920:5d4b:d11d:d5e4]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::7920:5d4b:d11d:d5e4%3]) with mapi id 15.20.5458.025; Thu, 28 Jul 2022
 10:29:44 +0000
Date:   Thu, 28 Jul 2022 11:29:30 +0100
From:   Szabolcs Nagy <szabolcs.nagy@arm.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     libc-alpha@sourceware.org, adhemerval.zanella@linaro.org,
        Florian Weimer <fweimer@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v6] arc4random: simplify design for better safety
Message-ID: <YuJlCijOtAXOco6h@arm.com>
References: <20220726190830.1189339-1-Jason@zx2c4.com>
 <20220726195822.1223048-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220726195822.1223048-1-Jason@zx2c4.com>
X-ClientProxiedBy: LO4P265CA0107.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::12) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: c2c2b2f2-dfe3-4a17-09e4-08da70841c2d
X-MS-TrafficTypeDiagnostic: AM9PR08MB6292:EE_|DBAEUR03FT020:EE_|VI1PR08MB4189:EE_
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: nRHL+yu2mrba/skE3P3f9liJxqJkdWMWxYPCRpY5mnxZi4uR4B1aStxnyfSJu+wWAtooXl8E1NSu5DQTsmSBaPWdmoAGO3wnIK7wob+6pMsjxYwcacg+aLeu1xeaa0AvI1bwTQMb9LZpmfr6OlEsqcEEZ8f0SEyLM3wd1qqKK/VEZyeTYEQra75/Ed1bXBx1LOkE9ygqwzW3OjxQyH+Ju5blILMkgq3NBzl6/rj5gUQW0MB+UoXT7aw+po3Q2KPMSRci6B9D8o0sXWXqUKZzA60Ec9ZuVIxAlT2gvTcbjqKuBCtmwwWgO3COZk3GM14Cbv3FZliObOK1Cu3fyjOyhbajMc4Kk/Ufct9zkGF0cBmpu4b/BtyKkjK6R8MRLKg8achMp6UW1cvu0mUwqi76rE1tVm3dGuSCUL6W7PhYLsWc01mjYepLq4XyTXdUntHL6aDN3hFstG4jke8z2Mo40Weq5U5XqgeBfF6qA/7GOTjnMYgLQk4BifQVrYgozQ8p0kWYd0b7Ld2PxygqQxo2stqMetcAyRBEBp4MGKfhmuw4HmKgLXa0W5LVoiwizd8Vu14wZxY/iK9TedvD6CW+d1t6HdEYhfkKnDvF2B4pwHitzn22zYXjemavszTZB9qeCB/WlfnFx5xBRuX3rZXzRT1NHHRYFMMJqiEyP1Wzz1XvLMokSzIRsLsQvVxn1Hfb5o9eXmQX+UitrVCBHA+Twvjj+C49pUjGxLiIYcGgPXjFSqwQa10uEEIJqkbabzdAkdnLxjRIjvdXoe6rPhHayatzIR7eJyl2d/jTcE7FIXk=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB7179.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(36756003)(5660300002)(66556008)(66476007)(6486002)(4326008)(66946007)(186003)(44832011)(86362001)(8936002)(6512007)(54906003)(41300700001)(38100700002)(8676002)(6506007)(2616005)(6916009)(478600001)(83380400001)(6666004)(2906002)(66574015)(316002)(26005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6292
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 747baaac-3248-4974-554f-08da70841646
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LSq1AT6pu3C/nizX/bh+kn/3nG48GkvPpeN+IcjQOy0nWRLGb5mR0gS3D+TgQ0tzqOr6esiVnNs1KItk6MTjjUZml0hkzq8cm5iybYfUt60GLEXU8Vjhg3R8I3b42fw6CcToF/rtWuh/RHEY19ArQ2BB8uJZ/gnSZ7KKbZDjp+JIIGAXTRxuc+eazbP6hWZBMa5hFVnbf1YSDsWakGuhsJB+eQJzM+sGjemHwhRtvNgpd/pTFlwCrIErWPSLQs+IAQf2I9jCna6H1pjvGb6IVZqh23Y0KgP9nOyd8wl+XfyilrbWzKRRDuWrPnhjZWwj/WYgFgzrwuleCbPO+ObJfGBGxw3vnfHvExeY36RBp8Ky31Hx0TfgLf+dHR6MRtHVcW1A41fZxvPacBMM0sHyLzdyOep3yw8C2etpDMaj6Arn8WGxFF/Z6YMdCD1pKec3BU7ss9IM+wU8pPUptgE9vExY0D8fbaVMswKtx0Fho0mOKEMmNiec7P95TP2jntqt2mNwgk0tkyVfnPFVShmqp7HBlFopzrSjyalfha4tbaVWmcmoHdJ6gIyApr24Sao7PyT8yaPB+k4BtOa9nnkTF+kM+iM4yuz5xwvfiwZCLwRJln7yYpK8OrRXZgf0fldsSiV92G47Pk0MNAo5k4pU1ojfsxKUMDNotkPpUVa3k9kxyWGjJBF/eRpSwzsVUQvRJBzhs8p/4mrT8r5PXZFrkBV6Oyv+xDGCf4ZK5e4WwB+Ooc+agmsAtZpt8+fyXjn3vLxzHArQlGiAAv+0Er5fI4Mo1ysOellPzFfFCv9FIYVKLckx3A1LWpaQdJbzVutRmAWK+3UFchfVYyx+scG5cg==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(376002)(136003)(40470700004)(36840700001)(46966006)(6862004)(8936002)(5660300002)(2906002)(8676002)(47076005)(316002)(86362001)(40480700001)(36756003)(70206006)(40460700003)(82310400005)(70586007)(54906003)(4326008)(356005)(6506007)(82740400003)(6666004)(6512007)(6486002)(26005)(2616005)(44832011)(66574015)(83380400001)(41300700001)(336012)(36860700001)(81166007)(186003)(478600001)(32563001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 10:29:53.6897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c2b2f2-dfe3-4a17-09e4-08da70841c2d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4189
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The 07/26/2022 21:58, Jason A. Donenfeld via Libc-alpha wrote:
> Rather than buffering 16 MiB of entropy in userspace (by way of
> chacha20), simply call getrandom() every time.
> 
> This approach is doubtlessly slower, for now, but trying to prematurely
> optimize arc4random appears to be leading toward all sorts of nasty
> properties and gotchas. Instead, this patch takes a much more
> conservative approach. The interface is added as a basic loop wrapper
> around getrandom(), and then later, the kernel and libc together can
> work together on optimizing that.
> 
> This prevents numerous issues in which userspace is unaware of when it
> really must throw away its buffer, since we avoid buffering all
> together. Future improvements may include userspace learning more from
> the kernel about when to do that, which might make these sorts of
> chacha20-based optimizations more possible. The current heuristic of 16
> MiB is meaningless garbage that doesn't correspond to anything the
> kernel might know about. So for now, let's just do something
> conservative that we know is correct and won't lead to cryptographic
> issues for users of this function.
> 
> This patch might be considered along the lines of, "optimization is the
> root of all evil," in that the much more complex implementation it
> replaces moves too fast without considering security implications,
> whereas the incremental approach done here is a much safer way of going
> about things. Once this lands, we can take our time in optimizing this
> properly using new interplay between the kernel and userspace.
> 
> getrandom(0) is used, since that's the one that ensures the bytes
> returned are cryptographically secure. But on systems without it, we
> fallback to using /dev/urandom. This is unfortunate because it means
> opening a file descriptor, but there's not much of a choice. Secondly,
> as part of the fallback, in order to get more or less the same
> properties of getrandom(0), we poll on /dev/random, and if the poll
> succeeds at least once, then we assume the RNG is initialized. This is a
> rough approximation, as the ancient "non-blocking pool" initialized
> after the "blocking pool", not before, and it may not port back to all
> ancient kernels, though it does to all kernels supported by glibc
> (≥3.2), so generally it's the best approximation we can do.
> 
> The motivation for including arc4random, in the first place, is to have
> source-level compatibility with existing code. That means this patch
> doesn't attempt to litigate the interface itself. It does, however,
> choose a conservative approach for implementing it.
> 
> Cc: Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
> Cc: Florian Weimer <fweimer@redhat.com>
> Cc: Cristian Rodríguez <crrodriguez@opensuse.org>
> Cc: Paul Eggert <eggert@cs.ucla.edu>
> Cc: Mark Harris <mark.hsj@gmail.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

fyi, after this patch i see

FAIL: stdlib/tst-arc4random-thread

with

$ cat stdlib/tst-arc4random-thread.out
info: arc4random: minimum of 1750000 blob results expected
info: arc4random: 1750777 blob results observed
info: arc4random_buf: minimum of 1750000 blob results expected
info: arc4random_buf: 1750000 blob results observed
info: arc4random_uniform: minimum of 1750000 blob results expected
Timed out: killed the child process
Termination time: 2022-07-27T14:41:33.766791947
Last write to standard output: 2022-07-27T14:41:22.522497854

on an arm and aarch64 builder.

running it manually it takes >30s to complete.

> ---
>  LICENSES                                      |  23 -
>  NEWS                                          |   4 +-
>  include/stdlib.h                              |   3 -
>  manual/math.texi                              |  13 +-
>  stdlib/Makefile                               |   2 -
>  stdlib/arc4random.c                           | 196 ++----
>  stdlib/arc4random.h                           |  48 --
>  stdlib/chacha20.c                             | 191 ------
>  stdlib/tst-arc4random-chacha20.c              | 167 -----
>  sysdeps/aarch64/Makefile                      |   4 -
>  sysdeps/aarch64/chacha20-aarch64.S            | 314 ----------
>  sysdeps/aarch64/chacha20_arch.h               |  40 --
>  sysdeps/generic/chacha20_arch.h               |  24 -
>  sysdeps/generic/not-cancel.h                  |   3 +
>  sysdeps/generic/tls-internal-struct.h         |   1 -
>  sysdeps/generic/tls-internal.c                |  10 -
>  sysdeps/mach/hurd/_Fork.c                     |   2 -
>  sysdeps/mach/hurd/not-cancel.h                |   4 +
>  sysdeps/nptl/_Fork.c                          |   2 -
>  .../powerpc/powerpc64/be/multiarch/Makefile   |   4 -
>  .../powerpc64/be/multiarch/chacha20-ppc.c     |   1 -
>  .../powerpc64/be/multiarch/chacha20_arch.h    |  42 --
>  sysdeps/powerpc/powerpc64/power8/Makefile     |   5 -
>  .../powerpc/powerpc64/power8/chacha20-ppc.c   | 256 --------
>  .../powerpc/powerpc64/power8/chacha20_arch.h  |  37 --
>  sysdeps/s390/s390-64/Makefile                 |   6 -
>  sysdeps/s390/s390-64/chacha20-s390x.S         | 573 ------------------
>  sysdeps/s390/s390-64/chacha20_arch.h          |  45 --
>  sysdeps/unix/sysv/linux/not-cancel.h          |   8 +-
>  sysdeps/unix/sysv/linux/tls-internal.c        |  10 -
>  sysdeps/unix/sysv/linux/tls-internal.h        |   1 -
>  sysdeps/x86_64/Makefile                       |   7 -
>  sysdeps/x86_64/chacha20-amd64-avx2.S          | 328 ----------
>  sysdeps/x86_64/chacha20-amd64-sse2.S          | 311 ----------
>  sysdeps/x86_64/chacha20_arch.h                |  55 --
>  35 files changed, 64 insertions(+), 2676 deletions(-)
>  delete mode 100644 stdlib/arc4random.h
>  delete mode 100644 stdlib/chacha20.c
>  delete mode 100644 stdlib/tst-arc4random-chacha20.c
>  delete mode 100644 sysdeps/aarch64/chacha20-aarch64.S
>  delete mode 100644 sysdeps/aarch64/chacha20_arch.h
>  delete mode 100644 sysdeps/generic/chacha20_arch.h
>  delete mode 100644 sysdeps/powerpc/powerpc64/be/multiarch/Makefile
>  delete mode 100644 sysdeps/powerpc/powerpc64/be/multiarch/chacha20-ppc.c
>  delete mode 100644 sysdeps/powerpc/powerpc64/be/multiarch/chacha20_arch.h
>  delete mode 100644 sysdeps/powerpc/powerpc64/power8/chacha20-ppc.c
>  delete mode 100644 sysdeps/powerpc/powerpc64/power8/chacha20_arch.h
>  delete mode 100644 sysdeps/s390/s390-64/chacha20-s390x.S
>  delete mode 100644 sysdeps/s390/s390-64/chacha20_arch.h
>  delete mode 100644 sysdeps/x86_64/chacha20-amd64-avx2.S
>  delete mode 100644 sysdeps/x86_64/chacha20-amd64-sse2.S
>  delete mode 100644 sysdeps/x86_64/chacha20_arch.h
