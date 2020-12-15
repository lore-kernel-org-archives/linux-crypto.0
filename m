Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF71C2BB9A
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Dec 2020 08:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC4512222A
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Dec 2020 08:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgLOI7Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 03:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgLOI7T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 03:59:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7726C0617A6;
        Tue, 15 Dec 2020 00:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AKm4eJHa0x7jzyMwctEebqE5zykXwFHnRzlnlcFMVho=; b=NgHRH8X+2NtNssI6RUv7NlxmWx
        xce2nCced5yWEbsjfNHzsgUH2BPLDgAuslXtubwogm+lWxJCBVsh6EWvlqRESsWSV56mSTwelxAQd
        hjSLxc2rpQqwvANXLLP0EQsiW3lf4D9mdSrNFriG3vgE3VOxZ9sWnOqMUKZlk7I745kusquQMx+AX
        1SWL+BfGyZ1mNPu/JqmwaSyZbhHNkC7uYVPOAIVZK6h/aI3FVQLaPmqOyjgSpuefT+ldunvusWmUC
        PzAcuMmkv//VTgx9IFhWD5+HfXoxiN0uyxwIEyDbDPhbgp79C2i6OQtgnxXXkVlwIsl1xvg7dSVx1
        nb5uMg/g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kp6A1-00051s-ID; Tue, 15 Dec 2020 08:58:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3429D300446;
        Tue, 15 Dec 2020 09:58:19 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 142CE2C787A47; Tue, 15 Dec 2020 09:58:19 +0100 (CET)
Date:   Tue, 15 Dec 2020 09:58:19 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, TimGuo-oc@zhaoxin.com,
        CooperYan@zhaoxin.com, QiyuanWang@zhaoxin.com,
        HerryYang@zhaoxin.com, CobeChen@zhaoxin.com, SilviaZhao@zhaoxin.com
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
Message-ID: <20201215085819.GE3040@hirez.programming.kicks-ass.net>
References: <1607918392-19171-1-git-send-email-TonyWWang-oc@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607918392-19171-1-git-send-email-TonyWWang-oc@zhaoxin.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 14, 2020 at 11:59:52AM +0800, Tony W Wang-oc wrote:

Didn't I mention something about a comment?

>  static const struct x86_cpu_id crc32c_cpu_id[] = {
> +	X86_MATCH_VENDOR_FAM_FEATURE(ZHAOXIN, 0x6, X86_FEATURE_XMM4_2, 1),
> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(ZHAOXIN, 0x7, 0x1b, X86_FEATURE_XMM4_2, 1),
> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(ZHAOXIN, 0x7, 0x3b, X86_FEATURE_XMM4_2, 1),
> +	X86_MATCH_VENDOR_FAM_FEATURE(CENTAUR, 0x6, X86_FEATURE_XMM4_2, 1),
> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(CENTAUR, 0x7, 0x1b, X86_FEATURE_XMM4_2, 1),
> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(CENTAUR, 0x7, 0x3b, X86_FEATURE_XMM4_2, 1),
>  	X86_MATCH_FEATURE(X86_FEATURE_XMM4_2, NULL),
>  	{}

Also, the above is weird in that is has the negative entries marked
positive, and 1/NULL are inconsistent.

Something like so then?

---

diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
index feccb5254c7e..f6e6669a5102 100644
--- a/arch/x86/crypto/crc32c-intel_glue.c
+++ b/arch/x86/crypto/crc32c-intel_glue.c
@@ -215,14 +215,31 @@ static struct shash_alg alg = {
 };
 
 static const struct x86_cpu_id crc32c_cpu_id[] = {
-	X86_MATCH_FEATURE(X86_FEATURE_XMM4_2, NULL),
+	/*
+	 * Negative entries; exclude these chips from using this driver.
+	 * They match the positive rule below, but their CRC32 instruction
+	 * implementation is so slow, it doesn't merrit use.
+	 */
+	X86_MATCH_VENDOR_FAM_FEATURE(ZHAOXIN, 0x6, X86_FEATURE_XMM4_2, false),
+	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(ZHAOXIN, 0x7, 0x1b, X86_FEATURE_XMM4_2, false),
+	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(ZHAOXIN, 0x7, 0x3b, X86_FEATURE_XMM4_2, false),
+	X86_MATCH_VENDOR_FAM_FEATURE(CENTAUR, 0x6, X86_FEATURE_XMM4_2, false),
+	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(CENTAUR, 0x7, 0x1b, X86_FEATURE_XMM4_2, false),
+	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(CENTAUR, 0x7, 0x3b, X86_FEATURE_XMM4_2, false),
+	/*
+	 * Positive entry; SSE-4.2 instructions include special purpose CRC32
+	 * instructions.
+	 */
+	X86_MATCH_FEATURE(X86_FEATURE_XMM4_2, true),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, crc32c_cpu_id);
 
 static int __init crc32c_intel_mod_init(void)
 {
-	if (!x86_match_cpu(crc32c_cpu_id))
+	const struct x86_cpu_id *m = x86_match_cpu(crc32c_cpu_id);
+
+	if (!m || !m->driver_data)
 		return -ENODEV;
 #ifdef CONFIG_X86_64
 	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ)) {
