Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCA9C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 06:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60FD722E00
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 06:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbhAGGT7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 01:19:59 -0500
Received: from ZXSHCAS1.zhaoxin.com ([203.148.12.81]:52807 "EHLO
        ZXSHCAS1.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbhAGGT7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 01:19:59 -0500
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS1.zhaoxin.com
 (10.28.252.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 7 Jan 2021
 14:19:15 +0800
Received: from tony-HX002EA.zhaoxin.com (10.32.56.37) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 7 Jan 2021
 14:19:12 +0800
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>,
        <dave.hansen@intel.com>, <seanjc@google.com>,
        <fenghua.yu@intel.com>, <thomas.lendacky@amd.com>,
        <kyung.min.park@intel.com>, <kim.phillips@amd.com>,
        <mgross@linux.intel.com>, <peterz@infradead.org>,
        <krish.sadhukhan@oracle.com>, <liam.merwick@oracle.com>,
        <mlevitsk@redhat.com>, <reinette.chatre@intel.com>,
        <babu.moger@amd.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <TimGuo-oc@zhaoxin.com>, <CooperYan@zhaoxin.com>,
        <QiyuanWang@zhaoxin.com>, <HerryYang@zhaoxin.com>,
        <CobeChen@zhaoxin.com>, <SilviaZhao@zhaoxin.com>
Subject: [PATCH v1 0/3] crypto: x86/crc32c-intel - Exclude some Zhaoxin CPUs
Date:   Thu, 7 Jan 2021 14:19:05 +0800
Message-ID: <1610000348-17316-1-git-send-email-TonyWWang-oc@zhaoxin.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.32.56.37]
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver crc32c-intel match CPUs supporting X86_FEATURE_XMM4_2.
On platforms with Zhaoxin CPUs supporting this X86 feature, when
crc32c-intel and crc32c-generic are both registered, system will
use crc32c-intel because its .cra_priority is greater than
crc32c-generic.

When doing lmbench3 Create and Delete file test on partitions with
ext4 enabling metadata checksum, found using crc32c-generic driver
could get about 20% performance gain than using the driver crc32c-intel
on some Zhaoxin CPUs. Lower-level testing result is that with the same
input value the generic C implementation takes fewer time than the crc32c
instruction implementation on these CPUs. This case expect to use
crc32c-generic driver for these CPUs to get performance gain.

The presence of crc32c is enumerated by CPUID.01:ECX[SSE4.2] = 1, and
these CPUs other SSE4.2 instructions is ok.

Add a synthetic flag to indicates low performance CRC32C instruction
implementation, set this flag in Zhaoxin CPUs specific init phase,
and exclude CPUs which setting this flag from the driver crc32c-intel.

https://lkml.org/lkml/2020/12/21/789

Tony W Wang-oc (3):
  x86/cpufeatures: Add low performance CRC32C instruction CPU feature
  x86/cpu: Set low performance CRC32C flag on some Zhaoxin CPUs
  crypto: x86/crc32c-intel Exclude low performance CRC32C instruction
    CPUs

 arch/x86/crypto/crc32c-intel_glue.c | 5 +++++
 arch/x86/include/asm/cpufeatures.h  | 1 +
 arch/x86/kernel/cpu/centaur.c       | 7 +++++++
 arch/x86/kernel/cpu/cpuid-deps.c    | 1 +
 arch/x86/kernel/cpu/zhaoxin.c       | 6 ++++++
 5 files changed, 20 insertions(+)

-- 
2.7.4

