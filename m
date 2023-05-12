Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6064CC7EE2A
	for <linux-crypto@archiver.kernel.org>; Fri, 12 May 2023 11:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240994AbjELLJ4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 May 2023 07:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241040AbjELLJu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2023 07:09:50 -0400
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E817E4C1F;
        Fri, 12 May 2023 04:09:49 -0700 (PDT)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id C03E142529; Fri, 12 May 2023 12:00:03 +0100 (BST)
Date:   Fri, 12 May 2023 12:00:03 +0100
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Ross Philipson <ross.philipson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, linux-efi@vger.kernel.org,
        dpsmith@apertussolutions.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, ardb@kernel.org,
        James.Bottomley@hansenpartnership.com, luto@amacapital.net,
        nivedita@alum.mit.edu, kanth.ghatraju@oracle.com,
        trenchboot-devel@googlegroups.com
Subject: Re: [PATCH v6 05/14] x86: Secure Launch main header file
Message-ID: <20230512110003.GC14461@srcf.ucam.org>
References: <20230504145023.835096-1-ross.philipson@oracle.com>
 <20230504145023.835096-6-ross.philipson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504145023.835096-6-ross.philipson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 04, 2023 at 02:50:14PM +0000, Ross Philipson wrote:

> +static inline int tpm12_log_event(void *evtlog_base, u32 evtlog_size,
> +				  u32 event_size, void *event)
> +{
> +	struct tpm12_event_log_header *evtlog =
> +		(struct tpm12_event_log_header *)evtlog_base;
> +
> +	if (memcmp(evtlog->signature, TPM12_EVTLOG_SIGNATURE,
> +		   sizeof(TPM12_EVTLOG_SIGNATURE)))
> +		return -EINVAL;
> +
> +	if (evtlog->container_size > evtlog_size)
> +		return -EINVAL;
> +
> +	if (evtlog->next_event_offset + event_size > evtlog->container_size)
> +		return -E2BIG;
> +
> +	memcpy(evtlog_base + evtlog->next_event_offset, event, event_size);
> +	evtlog->next_event_offset += event_size;
> +
> +	return 0;
> +}
> +
> +static inline int tpm20_log_event(struct txt_heap_event_log_pointer2_1_element *elem,
> +				  void *evtlog_base, u32 evtlog_size,
> +				  u32 event_size, void *event)
> +{
> +	struct tcg_pcr_event *header =
> +		(struct tcg_pcr_event *)evtlog_base;
> +
> +	/* Has to be at least big enough for the signature */
> +	if (header->event_size < sizeof(TCG_SPECID_SIG))
> +		return -EINVAL;
> +
> +	if (memcmp((u8 *)header + sizeof(struct tcg_pcr_event),
> +		   TCG_SPECID_SIG, sizeof(TCG_SPECID_SIG)))
> +		return -EINVAL;
> +
> +	if (elem->allocated_event_container_size > evtlog_size)
> +		return -EINVAL;
> +
> +	if (elem->next_record_offset + event_size >
> +	    elem->allocated_event_container_size)
> +		return -E2BIG;
> +
> +	memcpy(evtlog_base + elem->next_record_offset, event, event_size);
> +	elem->next_record_offset += event_size;
> +
> +	return 0;
> +}
> +

These seem like they'd potentially be useful outside the context of SL, 
maybe put them in a more generic location? Very much a nice to have, not 
a blocker from my side.

> +/*
> + * External functions avalailable in mainline kernel.

Nit: "available"

