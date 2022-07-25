Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666BDC43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbiGYOcT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235549AbiGYOcQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:32:16 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F88A167C2;
        Mon, 25 Jul 2022 07:32:13 -0700 (PDT)
Received: from zn.tnic (p200300ea972976f8329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9729:76f8:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DA9011EC0554;
        Mon, 25 Jul 2022 16:32:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1658759527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=eFkyFfYwzdjMe2TFbK6JN+UuA/fBO6Fgi7kfcYlY0nc=;
        b=RxNdjRWIDGQmYeYuo2H9YlPOtj+XPvvNc9IkCJlRaohNd1UK1e+L6ZmctWEneBEvOBjGn4
        M8/4UarWyUZRy359qf45+k4Q2Vubx9mXD/e3xYgsKBfpWybZWR1/FofQAFJO8sfT3+ZeWZ
        P33CncvQHT0Y4iyE2NZLgmcUsCCrjG4=
Date:   Mon, 25 Jul 2022 16:32:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Message-ID: <Yt6pYu1D28DPatcK@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 20, 2022 at 11:02:33PM +0000, Ashish Kalra wrote:
> +/*
> + * The RMP entry format is not architectural. The format is defined in PPR
> + * Family 19h Model 01h, Rev B1 processor.
> + */
> +struct __packed rmpentry {

That __packed goes...

> +	union {
> +		struct {
> +			u64	assigned	: 1,
> +				pagesize	: 1,
> +				immutable	: 1,
> +				rsvd1		: 9,
> +				gpa		: 39,
> +				asid		: 10,
> +				vmsa		: 1,
> +				validated	: 1,
> +				rsvd2		: 1;
> +		} info;
> +		u64 low;
> +	};
> +	u64 high;
> +};

... here, at the end.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
