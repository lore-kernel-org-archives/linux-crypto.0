Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99B0C64ED9
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Feb 2023 19:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjBTT6T (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Feb 2023 14:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjBTT6S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2023 14:58:18 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D08D1C33A
        for <linux-crypto@vger.kernel.org>; Mon, 20 Feb 2023 11:58:12 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id l12so2552985qtr.0
        for <linux-crypto@vger.kernel.org>; Mon, 20 Feb 2023 11:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O7rkSAN5LAMQyeEaKY1rCygZe9FB1uxO0LO3uAv87QU=;
        b=hInwNusK1f2xWu38WC2TBIVbF8f2TO5jkZeMa3ENjF8+qZQNIQ1MTr6rSdq3y+Btjj
         6BIDSl7yj7uHqrzdyIoI/UMjBzPuslcrV+Q+GrjgBiWT7ywPd/P6BVOdzmIbFW4XirzN
         1GDvraFCY30SpfM/41Ra/eV1LxnCL5I0RalU3w7+qykDmmPnkBpbd2IUljWw+cw/LPp1
         2S1c8I9Tp2jZhgBraFlDDBdvp/sZMrxZalVFVA2qIdXMtkbA6E5Hen2YunYwcGVLmwbt
         w1U+aLxo8qFs9hnIoTnklHuBLNGbOiMibwiz17Hw2Y2Gdy/LSEkir86U3fL3Y0qWBBy5
         n8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O7rkSAN5LAMQyeEaKY1rCygZe9FB1uxO0LO3uAv87QU=;
        b=WKWe8hRcqQtiRWtkxYcmH1Xjsq0uxRpFiwqZAIRn1+sddxvgbfIEjz7PfEJjHFxz9A
         VYTTthKy9bVptzu3+WWxvPk9Tqhg7gvNWZ5K8B66u3cvlHxhupZ63Wf3Clmj18A1L4Ot
         Ws/cUNoIrRq5fI0Ux7srxS9IJKEAJq3/9kAkcwhOkAiWPrK+H60R0HQ+NAFzhwnMI5fR
         0ikEv60dmLumZkYnVRgCa/p3aqQlZZiD5b6F2AkSBR0PIRPHWr5cFOm/ij82Vj/OySzm
         eCHSTehG8lpGXpCpSUwQOPcMLfWoprzCHzO/u8Lac78UiBhwT4v3joAwSkbwxbfA1ZO2
         s4pQ==
X-Gm-Message-State: AO0yUKVjYPaMxJ2bT4TxBixk6+LP2HoAaPtR90/qm4Q9f05cOxCDkb2+
        HURmqXI0KL72WwS5ULvGGqgYBw==
X-Google-Smtp-Source: AK7set/sYxfkHmLO+xORTsRgDUCiomQwgSGXUzHB9SZzOE2YWrMYkjAsLwH9nBABUIsDsOgaxEchJw==
X-Received: by 2002:ac8:7c43:0:b0:3b8:340b:1aab with SMTP id o3-20020ac87c43000000b003b8340b1aabmr19284007qtv.25.1676923091286;
        Mon, 20 Feb 2023 11:58:11 -0800 (PST)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id q202-20020a3743d3000000b0073b341148b3sm9483000qka.121.2023.02.20.11.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 11:58:10 -0800 (PST)
Date:   Mon, 20 Feb 2023 11:57:59 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Michael Roth <michael.roth@amd.com>
cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH RFC v8 18/56] x86/fault: fix handle_split_page_fault()
 to work with memfd backed pages
In-Reply-To: <20230220183847.59159-19-michael.roth@amd.com>
Message-ID: <29e9ed33-52eb-fbb4-5358-76939df747a9@google.com>
References: <20230220183847.59159-1-michael.roth@amd.com> <20230220183847.59159-19-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 20 Feb 2023, Michael Roth wrote:

> From: Hugh Dickins <hughd@google.com>

No.

> 
> When the address is backed by a memfd, the code to split the page does
> nothing more than remove the PMD from the page tables. So immediately
> install a PTE to ensure that any other pages in that 2MB region are
> brought back as in 4K pages.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

No.  Suggested-by would be okay.

> Cc: Hugh Dickins <hughd@google.com>

Thanks.  I'm really sorry to be such a jobsworth,
and have nothing more constructive to say than I did before in
https://lore.kernel.org/linux-mm/7f2228c4-1586-2934-7b92-1a9d23b6046@google.com/
(please re-read), but adding a Signed-off-by where none was given is wrong;
and I'm not ever going to comprehend enough of the context to give it.

Best of luck for the series,
Hugh

> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  mm/memory.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index e68da7e403c6..33c9020ba1f8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4999,6 +4999,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  static int handle_split_page_fault(struct vm_fault *vmf)
>  {
>  	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
> +	/*
> +	 * Install a PTE immediately to ensure that any other pages in
> +	 * this 2MB region are brought back in as 4K pages.
> +	 */
> +	__pte_alloc(vmf->vma->vm_mm, vmf->pmd);
>  	return 0;
>  }
>  
> -- 
> 2.25.1
