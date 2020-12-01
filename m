Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D276C64E7A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14498207FF
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:17:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="34VLVb1U";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="iLQAOSIq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbgLAORS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 09:17:18 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55812 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbgLAORS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 09:17:18 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606832197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=97Qp08Mksru0av9OuaDYt+uZ/R1iR7sbIBO2KnJ9JEk=;
        b=34VLVb1U05aHZb+j3fzZStYevSh7fu2wzl9HIWUupC2pZwfyEsHqDRhVkX/kknkGR3xvNY
        GIUzDTt1/pAfotc7FnK47ak0v10YrwBeeZgQsKD8OYOIqsKDyDRynaW1zW0yFAmLbS0/n+
        s+hvOGFHac9P26Pfw02ButsUsovqXvXx3FgEvNsIGAA2WsAPsQ5hBA0Wr9OzKWOp861/lP
        JJsP3T2T/YgmGkvuJ8ORNVEvB30vq2w7CeAvrSzzWvk/W3dyglzigVUqyivZF2rQQ+uNVD
        dPUlZGAzJ8QkjUeOiceW00qT6WLuHan/islq1zdZ7s6rJDk+OiuoQxNAB8LV8Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606832197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=97Qp08Mksru0av9OuaDYt+uZ/R1iR7sbIBO2KnJ9JEk=;
        b=iLQAOSIqwknMG/7WA/ENJ02FcUWTLFUtv0LRt5HoBWRruKQ20wbFsUBeaAXIL5s2MiMzjL
        RrjubIkV+DHXAaBQ==
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: crypto: sun4i-ss: error with kmap
In-Reply-To: <20201201135252.GA9584@Red>
References: <20201201130102.GA23461@Red> <87ft4phcyx.fsf@nanos.tec.linutronix.de> <20201201135252.GA9584@Red>
Date:   Tue, 01 Dec 2020 15:16:36 +0100
Message-ID: <87y2ihfw6z.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 01 2020 at 14:52, Corentin Labbe wrote:
> On Tue, Dec 01, 2020 at 02:28:54PM +0100, Thomas Gleixner wrote:
> The patch made the board too busy logging and fail to boot until the test.

Stupid me. Of course this wants to be conditional.

Thanks,

        tglx
---        
diff --git a/mm/highmem.c b/mm/highmem.c
index b49364a306b8..178b126ab4f6 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -571,8 +571,10 @@ void kunmap_local_indexed(void *vaddr)
 		 * PAGE_OFFSET. Warn for all other addresses which are in
 		 * the user space part of the virtual address space.
 		 */
-		if (!kmap_high_unmap_local(addr))
-			WARN_ON_ONCE(addr < PAGE_OFFSET);
+		if (!kmap_high_unmap_local(addr)) {
+			if (WARN_ON_ONCE(addr < PAGE_OFFSET))
+				pr_err("kunmap_local: vaddr %lx\n", (unsigned long) vaddr);
+		}
 		return;
 	}
 
