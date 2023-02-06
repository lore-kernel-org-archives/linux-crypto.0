Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB21C61DA4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Feb 2023 03:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjBFDYe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Feb 2023 22:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBFDYd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Feb 2023 22:24:33 -0500
Received: from aib29gb122.yyz1.oracleemaildelivery.com (aib29gb122.yyz1.oracleemaildelivery.com [192.29.72.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468C013D41
        for <linux-crypto@vger.kernel.org>; Sun,  5 Feb 2023 19:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hikEbvdhBM/uA7Vw7FYuXgpKwmQoM8LjtV7ww72bjJE=;
 b=Y4JuvUIdV+BY/doZwWSuuMqTT1AITrsWQSRMNe8BDfhrSmd+VO5p/Gam4iZ6VzhnCd1ya4GxNmcQ
   9X9ogOjjZ+QQQeUvFg0osVHHN4WCsVxUiYVPHdAfPKi9zBKFAbPCptktJhZNqHRpcp+jJJOO1r3h
   FTDjNugltem4oEy776YcfqSWy78deDVlnE9+AtE0XjYKUjBrmBrakD5R9B1JUriuRAXOzFnvJwXM
   ONiuNncY+egyuhtkKv7u8IH16bFKQsErwY9VOFlcA1aECkj0S5tl1YvWjTxlZUC+jk2qZBvJF3u5
   ghMiajnbI49hnue40SbZbWUTfqTV7JVyFt6bQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hikEbvdhBM/uA7Vw7FYuXgpKwmQoM8LjtV7ww72bjJE=;
 b=KVB2TBzFj6zkSDjvwy8nuXvJFxxs15pOU3L696tOaj6MXy+kne7XWVkpYiIOhRq6BxBF6wtZW6l7
   D1bnwl+yH7wWRJq54swIemlh2fm9E/86d0PG0MsF2edLn8zKVfvaeAAg8aALQ2z9516nK8+iTT++
   94l0FnB6m03P0T7DV41Ql1LwuThnGAuwuAzVQ97Q4tnmtkoj7tR+XA6f9HKZJzqQ3JrlfWVFnt7P
   q8q3i9nD2DmQjJMfSBUEDqtSQqYkTu0kxR2Bdq4WMKYC8Yx2mNABHrcRjxPu8ycOr7PSVb7aTbJt
   wgmkK0hu9cSOypLbRtXyu2yNXZRHhduk8nP9ng==
Received: by omta-ad1-fd1-101-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230123 64bit (built Jan 23
 2023))
 with ESMTPS id <0RPN00LVR2SVJPA0@omta-ad1-fd1-101-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 linux-crypto@vger.kernel.org; Mon, 06 Feb 2023 03:24:31 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Lafreniere <peter@n8pjl.ca>, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: [PATCH 0/3] crypto: x86/twofish-3way - Cleanup and optimize asm
Date:   Sun,  5 Feb 2023 22:24:16 -0500
Message-id: <cover.1675653010.git.peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAFF1LFDwh9WytZ70YqVtgZ2LqgAqUKTOVWAp+kY9s51Y4EYZI2i8F606VwFJx8a
 W8RlOs8oU1JhUSKYdTFZ94J7/A8CgRpC+mbgyR/FXawPNEcuTONxOP6nEcvl6Ntv
 xBmB++GflFqHljBaIqHKajpOhmVmlNZXi91JVHtcLIpwTEPTVZ6VSwr/iZVCfGCm
 h+HrGUtoU/beB1haMAPFdk20HwomGQ/kHjxRFD9bZTpWhRyuSbrUSu+F45TqcWci
 Tmm7B2Bce5K+5dClYNgcZIjFvInO85wlPVPodkgpgUu972Y8o8rMXJtYCkFELGs9
 BoW4qxDbFzOQRKf6jqKLxtdorxBQBj0/7kPXsAYU6593tqUg3RZYEYz0q/3Lsajw
 XbU23GQCs+E2vlWswytkcLKFRJMpNFing9X7/WAYWtufw4O/1cbpVF44fhjxaOZN
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1/3 removes the unused xor argument to encode functions. This argument
is deadweight and its removal shaves off a both a few cycles per call as
well as a small amount of lines.

2/3 moves handling for cbc mode decryption to assembly in order to
remove overhead, yielding a ~6% speedup on AMD Zen1.

3/3 makes a minor readability change that doesn't fit well into 2/3.

Peter Lafreniere (3):
  crypto: x86/twofish-3way - Remove unused encode parameter
  crypto: x86/twofish-3way - Perform cbc xor in assembly
  crypto: x86/twofish-3way - Remove unused macro argument

 arch/x86/crypto/twofish-x86_64-asm_64-3way.S | 71 ++++++++++++--------
 arch/x86/crypto/twofish.h                    | 19 ++++--
 arch/x86/crypto/twofish_avx_glue.c           |  5 --
 arch/x86/crypto/twofish_glue_3way.c          | 22 +-----
 4 files changed, 59 insertions(+), 58 deletions(-)

-- 
2.39.1

